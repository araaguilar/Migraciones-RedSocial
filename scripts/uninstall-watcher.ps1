$startupPath = [Environment]::GetFolderPath("Startup")
$launcherPath = Join-Path $startupPath "moment-migraciones-auto-push.cmd"

if (Test-Path -LiteralPath $launcherPath) {
    Remove-Item -LiteralPath $launcherPath -Force
    Write-Host "Inicio automatico eliminado: $launcherPath"
}
else {
    Write-Host "No existe el inicio automatico: $launcherPath"
}
