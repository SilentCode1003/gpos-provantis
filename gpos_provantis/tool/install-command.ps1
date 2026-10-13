<#
.SYNOPSIS
  One-time setup: lets you type `gpos-provantis` from any folder.

.DESCRIPTION
  Adds this tool\ folder to your USER PATH (no admin needed). Safe to run more
  than once. Open a NEW terminal afterwards so it picks up the change.

  Run it like this:
    powershell -ExecutionPolicy Bypass -File .\tool\install-command.ps1
#>
$ErrorActionPreference = 'Stop'

$toolDir = $PSScriptRoot
$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')

$entries = @()
if ($userPath) {
    $entries = @($userPath -split ';' | Where-Object { $_ })
}

if ($entries -contains $toolDir) {
    Write-Host "Already set up: $toolDir is on your PATH."
}
else {
    $newPath = (@($entries) + $toolDir) -join ';'
    [Environment]::SetEnvironmentVariable('Path', $newPath, 'User')
    Write-Host "Added to your PATH: $toolDir" -ForegroundColor Green
}

Write-Host ''
Write-Host 'Open a NEW terminal, then try:'
Write-Host '  gpos-provantis android'
Write-Host '  gpos-provantis windows'
Write-Host '  gpos-provantis'