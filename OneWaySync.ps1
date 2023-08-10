# parameters for the source, destination and log file paths.
param (
    [string]$sourcePath,
    [string]$destinationPath,
    [string]$logFilePath
)

# logging function
function LogMessage {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp - $message"
    Write-Output $logEntry
    $logEntry | Out-File -Append -FilePath $logFilePath
}

try {

    LogMessage "Starting synchronization from '$sourcePath' to '$destinationPath'."

    # Create destination folder if it doesn't exist
    if (!(Test-Path -Path $destinationPath -PathType Container)) {
        New-Item -Path $destinationPath -ItemType Directory | Out-Null
        LogMessage "Created destination folder '$destinationPath'."
    }

    # Get files in source folder
    $sourceFiles = Get-ChildItem -Path $sourcePath -File -Recurse

    # Synchronize the files
    foreach ($file in $sourceFiles) {
        $relativePath = $file.FullName.Replace($sourcePath, "")
        $destinationFilePath = Join-Path -Path $destinationPath -ChildPath $relativePath

        if (!(Test-Path -Path $destinationFilePath)) {
            Copy-Item -Path $file.FullName -Destination $destinationFilePath
            LogMessage "Copied file '$relativePath' to destination folder."
        }
    }

    # Remove files from destination folder that do not exist in source folder
    $destinationFiles = Get-ChildItem -Path $destinationPath -File -Recurse
    foreach ($destinationFile in $destinationFiles) {
        $relativePath = $destinationFile.FullName.Replace($destinationPath, "")
        $sourceFilePath = Join-Path -Path $sourcePath -ChildPath $relativePath

        if (!(Test-Path -Path $sourceFilePath)) {
            Remove-Item -Path $destinationFile.FullName -Force
            LogMessage "Removed file '$relativePath' from destination folder."
        }
    }

    LogMessage "Synchronization completed successfully."
}
catch {
    LogMessage "Error occurred: $_"
}
