
# Where to look for log folders
$searchDirectory = "C:\intel"
$fileCountMinDefault = 2
$errors = @()

$logFolders = Get-ChildItem $searchDirectory

foreach ($logFolder in $logFolders) {

    $fileCountMin = $fileCountMinDefault

    #check for config file
    if (Get-ChildItem $searchDirectory\$logFolder -Filter "monitorConfig.xml") {
        $fileCountMin = ([xml](Get-Content $searchDirectory\$logFolder"\monitorConfig.xml")).Config.fileCountMin
    }
    $logFiles = Get-ChildItem $searchDirectory\$logFolder | Measure-Object #| Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-1) }
    $logFilesCount = $logFiles.Count
    if ($logFilesCount -lt $fileCountMin) {
        $errorMessage = "Number of log files lower than expected. Folder:$logFolder Files found: $logFilesCount Files expected:$fileCountMin"
        $errors += $errorMessage

    }

}

if ($errors.count -gt 0) {
    foreach ($errorItem in $errors) {
        Write-Host $errorItem
    }
}

