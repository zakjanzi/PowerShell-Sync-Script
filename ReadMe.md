# PowerShell Synchronization Script

Usage: 

`.\OneWaySync.ps1 -sourceFolder "C:\path\" -destinationFolder "C:\path"` 


Pseudocode:

- Setup the parameters:
    - sourcePath
    - destinationPath
    - logFilePath

- Setup LogMessage function
    - takes 1 param: message

- Get files from provided source folder path.
- Iterate over them to check if they exist in destination folder.
- Add files to destination folder if they don't exist and log action.
- Check for files that exist in destination folder but not in source.
    - If any, delete them from destination and log action.
- Log success message or error object upon completion.
