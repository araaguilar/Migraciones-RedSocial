param(
    [string]$RepoPath = (Resolve-Path "$PSScriptRoot\..").Path,
    [int]$DebounceSeconds = 12
)

$ErrorActionPreference = "Stop"

function Invoke-GitSync {
    Push-Location $RepoPath
    try {
        $changes = git status --porcelain
        if (-not $changes) { return }

        git add -- .

        $staged = git diff --cached --name-only
        if (-not $staged) { return }

        $migrationFiles = @($staged | Where-Object { $_ -match '^\d{3}_.+\.sql$' })
        if ($migrationFiles.Count -gt 0) {
            $names = ($migrationFiles | ForEach-Object { [System.IO.Path]::GetFileNameWithoutExtension($_) }) -join ", "
            git commit -m "chore: agregar migracion $names"
        }
        else {
            $names = ($staged | ForEach-Object { [System.IO.Path]::GetFileName($_) }) -join ", "
            git commit -m "chore: actualizar migraciones $names"
        }

        git push
    }
    finally {
        Pop-Location
    }
}

$watcher = [System.IO.FileSystemWatcher]::new($RepoPath)
$watcher.IncludeSubdirectories = $false
$watcher.EnableRaisingEvents = $true
$watcher.NotifyFilter = [System.IO.NotifyFilters]'FileName, LastWrite, CreationTime'
$watcher.Filter = "*.*"

$lastChange = Get-Date "2000-01-01"
$pending = $false

$action = {
    $extension = [System.IO.Path]::GetExtension($Event.SourceEventArgs.FullPath)
    $name = [System.IO.Path]::GetFileName($Event.SourceEventArgs.FullPath)

    if ($extension -ne ".sql" -and $name -ne "README.md") { return }

    $script:lastChange = Get-Date
    $script:pending = $true
}

Register-ObjectEvent $watcher Created -Action $action | Out-Null
Register-ObjectEvent $watcher Changed -Action $action | Out-Null
Register-ObjectEvent $watcher Renamed -Action $action | Out-Null
Register-ObjectEvent $watcher Deleted -Action $action | Out-Null

Write-Host "Watcher activo para migraciones en: $RepoPath"

while ($true) {
    Start-Sleep -Seconds 2

    if (-not $pending) { continue }

    $elapsed = ((Get-Date) - $lastChange).TotalSeconds
    if ($elapsed -lt $DebounceSeconds) { continue }

    $pending = $false

    try {
        Invoke-GitSync
    }
    catch {
        Write-Error "No se pudo sincronizar migraciones: $($_.Exception.Message)"
    }
}
