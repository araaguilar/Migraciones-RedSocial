$ErrorActionPreference = "Stop"

$repoPath = (Resolve-Path "$PSScriptRoot\..").Path
$watcherPath = Join-Path $PSScriptRoot "watch-migraciones.ps1"
$startupPath = [Environment]::GetFolderPath("Startup")
$launcherPath = Join-Path $startupPath "moment-migraciones-auto-push.cmd"

$launcher = @"
@echo off
start "Moment Migraciones Auto Push" /min powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$watcherPath" -RepoPath "$repoPath"
"@

Set-Content -LiteralPath $launcherPath -Value $launcher -Encoding ASCII
Start-Process -WindowStyle Hidden -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$watcherPath`" -RepoPath `"$repoPath`""

Write-Host "Watcher instalado en Inicio de Windows: $launcherPath"
