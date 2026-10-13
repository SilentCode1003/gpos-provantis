<#
.SYNOPSIS
  Builds gpos_provantis for Android and/or Windows.

.DESCRIPTION
  Reads the app name and version from pubspec.yaml, builds, and drops the
  finished files into <project>\dist:
    Android  -> an .apk
    Windows  -> a Setup .exe (built with Inno Setup)

.EXAMPLE
  gpos-provantis                 # Android + Windows
  gpos-provantis android
  gpos-provantis windows
  gpos-provantis android -SplitPerAbi
  gpos-provantis windows -SkipCodegen
#>
[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [ValidateSet('all', 'android', 'windows')]
    [string]$Target = 'all',

    # Skip `dart run build_runner` (faster, if generated files are up to date).
    [switch]$SkipCodegen,

    # Run `flutter clean` first.
    [switch]$Clean,

    # Android: one APK per CPU type (smaller) instead of a single universal APK.
    [switch]$SplitPerAbi
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
$global:LASTEXITCODE = 0

$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$distDir = Join-Path $projectRoot 'dist'
$issPath = Join-Path $projectRoot 'windows\installer.iss'
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
$artifacts = New-Object System.Collections.Generic.List[string]

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

# Runs a step and stops the whole build if the command inside it failed.
# (PowerShell does not stop on a failing .exe by itself, so we check.)
function Invoke-Step {
    param(
        [Parameter(Mandatory)] [string]$Title,
        [Parameter(Mandatory)] [scriptblock]$Action
    )
    Write-Host ''
    Write-Host "==> $Title" -ForegroundColor Cyan
    $global:LASTEXITCODE = 0
    & $Action
    if ($LASTEXITCODE -ne 0) {
        throw "Step failed: $Title (exit code $LASTEXITCODE)"
    }
}

function Find-Iscc {
    $onPath = Get-Command 'ISCC.exe' -ErrorAction SilentlyContinue
    if ($onPath) { return $onPath.Source }

    $candidates = @(
        (Join-Path ${env:ProgramFiles(x86)} 'Inno Setup 6\ISCC.exe'),
        (Join-Path $env:ProgramFiles 'Inno Setup 6\ISCC.exe'),
        (Join-Path $env:LOCALAPPDATA 'Programs\Inno Setup 6\ISCC.exe')
    )
    foreach ($candidate in $candidates) {
        if (Test-Path -LiteralPath $candidate) { return $candidate }
    }
    throw 'Inno Setup 6 (ISCC.exe) was not found. Install it from https://jrsoftware.org/isinfo.php'
}

# ---------------------------------------------------------------------------
# Read name + version from pubspec.yaml  ("version: 0.1.0+1" -> 0.1.0 / 1)
# ---------------------------------------------------------------------------

$pubspecPath = Join-Path $projectRoot 'pubspec.yaml'
if (-not (Test-Path -LiteralPath $pubspecPath)) {
    throw "pubspec.yaml not found at: $pubspecPath"
}
$pubspec = Get-Content -LiteralPath $pubspecPath -Raw

$nameMatch = [regex]::Match($pubspec, '(?m)^name:\s*([^\s#]+)')
if (-not $nameMatch.Success) { throw 'Could not find "name:" in pubspec.yaml.' }
$versionMatch = [regex]::Match($pubspec, '(?m)^version:\s*([^\s#]+)')
if (-not $versionMatch.Success) { throw 'Could not find "version:" in pubspec.yaml.' }

$appName = $nameMatch.Groups[1].Value.Trim('"', "'")
$versionRaw = $versionMatch.Groups[1].Value.Trim('"', "'")
$versionParts = $versionRaw -split '\+', 2
$appVersion = $versionParts[0]
$appBuild = '1'
if ($versionParts.Count -gt 1 -and $versionParts[1]) { $appBuild = $versionParts[1] }

Write-Host "Building $appName $appVersion (build $appBuild) -> target: $Target" -ForegroundColor Green

if (-not (Get-Command 'flutter' -ErrorAction SilentlyContinue)) {
    throw 'flutter was not found on PATH.'
}

Push-Location $projectRoot
try {
    New-Item -ItemType Directory -Force -Path $distDir | Out-Null

    # -----------------------------------------------------------------------
    # Shared prep
    # -----------------------------------------------------------------------
    if ($Clean) {
        Invoke-Step 'flutter clean' { & flutter clean }
    }

    Invoke-Step 'flutter pub get' { & flutter pub get }

    if (-not $SkipCodegen -and $pubspec -match 'build_runner') {
        Invoke-Step 'build_runner (generated code)' {
            & dart run build_runner build --delete-conflicting-outputs
        }
    }

    # -----------------------------------------------------------------------
    # Android
    # -----------------------------------------------------------------------
    if ($Target -eq 'all' -or $Target -eq 'android') {
        if (-not (Test-Path -LiteralPath (Join-Path $projectRoot 'android\key.properties'))) {
            Write-Warning ('android\key.properties not found: the APK will be signed with the ' +
                'debug key. Fine for installing on your own devices, not for the Play Store.')
        }

        $flutterArgs = @('build', 'apk', '--release')
        if ($SplitPerAbi) { $flutterArgs += '--split-per-abi' }
        Invoke-Step ('flutter ' + ($flutterArgs -join ' ')) { & flutter @flutterArgs }

        $apkDir = Join-Path $projectRoot 'build\app\outputs\flutter-apk'
        $prefix = "${appName}_v${appVersion}_b${appBuild}_android"

        if ($SplitPerAbi) {
            $apks = Get-ChildItem -LiteralPath $apkDir -Filter 'app-*-release.apk'
            if (-not $apks) { throw "No split APKs found in $apkDir" }
            foreach ($apk in $apks) {
                $abi = $apk.Name -replace '^app-(.+)-release\.apk$', '$1'
                $dest = Join-Path $distDir "${prefix}_${abi}.apk"
                Copy-Item -LiteralPath $apk.FullName -Destination $dest -Force
                $artifacts.Add($dest)
            }
        }
        else {
            $apk = Join-Path $apkDir 'app-release.apk'
            if (-not (Test-Path -LiteralPath $apk)) { throw "APK not found: $apk" }
            $dest = Join-Path $distDir "$prefix.apk"
            Copy-Item -LiteralPath $apk -Destination $dest -Force
            $artifacts.Add($dest)
        }
    }

    # -----------------------------------------------------------------------
    # Windows (Flutter build, then the Inno Setup installer)
    # -----------------------------------------------------------------------
    if ($Target -eq 'all' -or $Target -eq 'windows') {
        Invoke-Step 'flutter build windows --release' { & flutter build windows --release }

        $releaseDir = Join-Path $projectRoot 'build\windows\x64\runner\Release'
        $exePath = Join-Path $releaseDir "$appName.exe"
        if (-not (Test-Path -LiteralPath $exePath)) {
            throw ("Expected $exePath but it is not there. If the exe has a different name, " +
                'check BINARY_NAME in windows\CMakeLists.txt.')
        }
        if (-not (Test-Path -LiteralPath $issPath)) {
            throw "installer.iss not found at: $issPath"
        }

        $iscc = Find-Iscc
        Invoke-Step 'Inno Setup (installer)' {
            & $iscc "/DAppName=$appName" "/DAppVersion=$appVersion" "/DAppBuild=$appBuild" $issPath
        }

        $setupName = "${appName}_v${appVersion}_b${appBuild}_windows_Setup.exe"
        $setup = Join-Path $projectRoot "build\installer\$setupName"
        if (-not (Test-Path -LiteralPath $setup)) { throw "Installer not found: $setup" }
        $dest = Join-Path $distDir $setupName
        Copy-Item -LiteralPath $setup -Destination $dest -Force
        $artifacts.Add($dest)
    }
}
finally {
    Pop-Location
}

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
$stopwatch.Stop()
Write-Host ''
Write-Host ('Done in {0:mm\:ss}. Files are in: {1}' -f $stopwatch.Elapsed, $distDir) -ForegroundColor Green
foreach ($artifact in $artifacts) {
    $sizeMb = (Get-Item -LiteralPath $artifact).Length / 1MB
    Write-Host ('  {0}  ({1:N1} MB)' -f (Split-Path $artifact -Leaf), $sizeMb)
}
