
$TempFolder = ,@{Path = "E:\Temp\Emby"; limit = (Get-Date).AddHours(-5)}
$TempFolder += ,@{Path = "E:\Temp\Plex"; limit = (Get-Date).AddHours(-5)}
$TempFolder += ,@{Path = "E:\Emby\transcoding-temp"; limit = (Get-Date).AddHours(-5)}
$TempFolder += ,@{Path = "E:\Emby\Backup\db"; limit = (Get-Date).AddMonths(-6)}


foreach ($folder in $TempFolder)
{
    # Delete files older than the $limit.
    Get-ChildItem -Path $folder.Path -Recurse -Force | Where-Object { !$_.PSIsContainer -and ($_.CreationTime -lt $folder.limit) } | Remove-Item -Force
    If ($test.CreationTime -lt $folder.limit)
    { Write-Host ( "Deleting files older than " + $folder.limit + " from " + $folder.Path) }
    # Delete any empty directories left behind after deleting the old files.
    Get-ChildItem -Path $folder.Path -Recurse | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item  -Recurse
}