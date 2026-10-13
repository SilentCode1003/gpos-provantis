@echo off
rem Lets you type these from ANY folder, in cmd or PowerShell:
rem   gpos-provantis            (Android + Windows)
rem   gpos-provantis android
rem   gpos-provantis windows
rem Extra options pass straight through, e.g.  gpos-provantis android -SplitPerAbi
rem
rem -ExecutionPolicy Bypass applies to this one run only, so you don't have to
rem change your PowerShell settings.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0build.ps1" %*
exit /b %ERRORLEVEL%
