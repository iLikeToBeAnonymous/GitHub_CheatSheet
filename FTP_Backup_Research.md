___
# Premise
**FTP Backups of a folder (in zip format) operates via four broad steps:**
1) Copy a folder into a backup location
2) Create a `.zip` of the backed-up folder (overwriting an existing one if necessary)
3) Establish (passive) connection with FTP server
4) Upload zipped backup to the FTP server


# Zipping the backup folder
PowerShell can be used to create and compress an archive by using the following commands:

The simple way (to understand how the command works):

```PowerShell
Compress-Archive -Path "C:\Users\Somebody\myBackupFolder\*" -DestinationPath "C:\Users\Somebody\myBackup.zip"
```

The more verbose way (using variables):

```PowerShell
# Variable Declaration:
$desiredZipName = "myBackup"
$folderToBackup = "C:\Users\Somebody\myBackupFolder\*"
$destinationOfZip = "C:\Users\Somebody\$desiredZipName.zip"
# Now to actually make the zip file...
Compress-Archive -Path $folderToBackup -DestinationPath $destinationOfZip
```
