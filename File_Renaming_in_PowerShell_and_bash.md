___
## File Rename Automation in PowerShell
## Appending a suffix
To append a timestamp to a filename (NOTE: this format below inserts periods between `HH.mm.ss`):
```PowerShell
get-item filepath | Rename-Item -NewName {$_.BaseName+(Get-Date $_.CreationTime -Format "yyyy-MM-dd HH.mm.ss" )+$_.Extension}
```

To change the name of a folder named "screenshots" you'd paste type the code (as it appears below) into PowerShell:
```PowerShell
# Declare your variables
$folderWithPictures = C:/users/yourNameHere/onedrive/pictures/screenshots
$somePrefix = "_vs_"


# Preview changes only (NOTE: $_.BaseName is a system var)
ls $folderWithPictures | foreach-object {$_.BaseName+$somePrefix+(Get-Date $_.CreationTime -Format "yyyy-MM-dd-HHmm" )+$_.Extension}

# Actually execute the changes
get-item $folderWithPictures | rename-item -newname {$_.BaseName + $somePrefix + (Get-Date $_.CreationTime -Format "yyyy-MM-dd-HHmm") + $_.Extension}
```

If the PowerShell instance is already open within the target folder, the `$folderWithPictures` variable isn't needed, and the code to execute the changes can be simplified to:
```PowerShell
# Note that the var $somePrefix is inlined as a string in the code below
# Preview
ls | foreach-object {$_.BaseName+"_vs_"+(Get-Date $_.CreationTime -Format "yyyy-MM-dd-HHmm" )+$_.Extension}

# Execute the changes
Dir | Rename-Item -NewName {$_.BaseName+"_vs_"+(Get-Date $_.CreationTime -Format "yyyy-MM-dd-HHmm" )+$_.Extension}
```

To append just a simple suffix, use the same code as above, but replace the `(Get-Date....)` code section with your desired string.
```PowerShell
Dir | Rename-Item -NewName {$_.BaseName+"—foobar"+$_.Extension}
```

### PowerShell Rename with Find and Replace

#### First, some notes: 
- The property `$_.name` indicates the entire file name, **including the extension**.
- The property `$_.BaseName` seems to indicate **only** the file name, but does **NOT include the extension**.
- The property `$_.Extension` is the existing file extension on each file.

#### Simple Rename and Replace
The following assumes you already have PowerShell open in the directory in which you want the renaming to take place.
In the current dir, all file names containing the partial string targeted for replacement will have that partial string value replaced with the new value, leaving the rest of the file name alone.
```PowerShell
Dir | Rename-Item -NewName {$_.name -replace "old_filename_part","new_filename_part"}
```
Because the above version leverages `$_.name` property, it is possible the file extension could also be renamed. This potential issue is circumvented by using the `$_BaseName` prop instead.
```PowerShell
Dir | Rename-Item -NewName {($_.BaseName -replace "old_filename_part","new_filename_part")+$_.Extension}
```

Of course, if you DO wish to change the file extension, you could restructure the above code in two ways. 
- Using the `$_.name` prop (which in the example below would only change files ending in `.jpeg` to `.jpg`):
```PowerShell
Dir | Rename-Item -NewName {$_.name -replace "_.jpeg",".jpg"}
```
- Using the `$_.BaseName` prop (which would blindly change ALL file extensions in the dir to `.jpg`.:
```PowerShell
Dir | Rename-Item -NewName {$_.BaseName +".jpg"}
```

___
## Renaming in Bash
### Simple Rename
To just rename a file in bash (without moving it) you'd still use the "mv" command. Note that there are no spaces, and the file names include their extensions. 
```bash
mv 'oldFileName.pdf' 'newFileName.pdf'
```
### File Rename with Regex Match and Replace
A more robust way is to use the bash `rename` command
_Sourced from: https://www.howtogeek.com/423214/how-to-use-the-rename-command-on-linux/_
The "rename" command is not part of a the standard Linux distro, so you must install it:
```bash
sudo apt-get install rename
```
Then you can use a rename using a regular expression (assuming you've navigated to the correct directory beforehand):
```bash
find -regextype posix-extended -regex '^.*test\.log\.[0-9]{4}-[0-9]{2}-[0-9]{2}\.*'
```
