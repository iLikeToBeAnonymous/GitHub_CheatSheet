___
## File Rename Automation in PowerShell

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
___
## Renaming in bash
To just rename a file in bash (without moving it) you'd still use the "mv" command. Note that there are no spaces, and the file names include their extensions. 
```bash
mv 'oldFileName.pdf' 'newFileName.pdf'
```
A more robust way is to use the bash `rename` command.
_Sourced from: https://www.howtogeek.com/423214/how-to-use-the-rename-command-on-linux/_
The "rename" command is not part of a the standard Linux distro, so you must install it:
```bash
sudo apt-get install rename
```
Then you can use a rename using a regular expression (assuming you've navigated to the correct directory beforehand):
```bash
find -regextype posix-extended -regex '^.*test\.log\.[0-9]{4}-[0-9]{2}-[0-9]{2}\.*'
```
