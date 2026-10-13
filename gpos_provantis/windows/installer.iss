; Windows installer for gpos_provantis. Needs Inno Setup 6.3 or newer.
;
; tool\build.ps1 passes AppName / AppVersion / AppBuild in with ISCC /D, taken
; straight from pubspec.yaml, so this file never has to be edited (or show up
; as "modified" in git) when the version changes. The defaults below only
; matter if you compile this file by hand.

#ifndef AppName
  #define AppName "gpos_provantis"
#endif
#ifndef AppVersion
  #define AppVersion "0.1.0"
#endif
#ifndef AppBuild
  #define AppBuild "1"
#endif
#define AppExe AppName + ".exe"

[Setup]
; Keep this GUID forever. It is how Windows recognizes "the same app", so new
; versions upgrade in place instead of installing next to the old one.
AppId={{68FE9BE4-8C14-438A-A2F3-439D9A461939}
AppName={#AppName}
AppVersion={#AppVersion}
VersionInfoVersion={#AppVersion}.{#AppBuild}
DefaultDirName={autopf}\{#AppName}
DefaultGroupName={#AppName}
; Without these two the 64-bit app lands in "Program Files (x86)".
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
OutputDir=..\build\installer
OutputBaseFilename={#AppName}_v{#AppVersion}_b{#AppBuild}_windows_Setup
Compression=lzma2/max
SolidCompression=yes
WizardStyle=modern
UninstallDisplayIcon={app}\{#AppExe}
; Updating a till that is still open: offer to close it and restart it.
CloseApplications=yes
RestartApplications=yes

[Tasks]
Name: "desktopicon"; Description: "Create a &desktop shortcut"; GroupDescription: "Additional shortcuts:"

[Files]
; Everything Flutter put in the Release folder (the exe is included here).
Source: "..\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; Fresh Windows machines can be missing the Visual C++ runtime that Flutter
; apps need. To bundle it: download vc_redist.x64.exe into this folder, then
; uncomment this line and the matching one in [Run].
; Source: "vc_redist.x64.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall

[Icons]
Name: "{autoprograms}\{#AppName}"; Filename: "{app}\{#AppExe}"
Name: "{autodesktop}\{#AppName}"; Filename: "{app}\{#AppExe}"; Tasks: desktopicon

[Run]
; Filename: "{tmp}\vc_redist.x64.exe"; Parameters: "/install /quiet /norestart"; StatusMsg: "Installing the Visual C++ runtime..."; Flags: waituntilterminated
Filename: "{app}\{#AppExe}"; Description: "Launch {#AppName}"; Flags: nowait postinstall skipifsilent
