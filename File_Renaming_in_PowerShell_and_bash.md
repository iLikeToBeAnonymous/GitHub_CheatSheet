# File Rename Automation in PowerShell
## _Appending a Suffix_
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
Of course, you could also use this to prepend a prefix as well:
```PowerShell
Dir | Rename-Item -NewName {"Some_Prefix_Here_"+$_.BaseName+$_.Extension}
```
----
----
## _PowerShell Rename with Find and Replace_

### First, some notes: 
- The property `$_.name` indicates the entire file name, **including the extension**.
- The property `$_.BaseName` seems to indicate **only** the file name, but does **NOT include the extension**.
- The property `$_.Extension` is the existing file extension on each file.

### Simple Rename and Replace
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

### Filtering before Renaming
The previous renaming examples attempt to make changes to all files in a directory, but a more graceful approach utilizes the `Get-ChildItem` command. 

For example, lets say you have a list of files with a date suffix formatted `yyyy-mm-dd-HHmm` as used in the examples earlier. Within that list of files, you only want to perform a renaming action on the files have suffix for the year 2021, the month 09, and between 07:30 and 07:39, you could do the following (_note the use of **single quotes** in the `Get-ChildItem` statement_)
```PowerShell
Get-ChildItem *'2021-09-2'*'073'* | Rename-Item -NewName {$_.name -replace "old_filename_part","new_filename_part"}
```
**Note:** in the `-replace` expressions above, regular expressions can be used if the double quotes shown are replaced with single quotes. (This doesn't seem to work in the `Get-ChildItem` part of the filter).

If, for example, you wished to replace all white-spaces directly with underscores:
```PowerShell
Get-ChildItem *' '* | Rename-Item -NewName {($_.BaseName -replace '\s+','_')+$_.Extension}
``` 
----
----
## _Flip-flopping Parts of a File Name_

Consider you have the following files in a folder:

```
Invoice_E0200G90M8--2021-10-28-0007.pdf
Invoice_E0200GS2L3--2021-12-13-0228.pdf
Invoice_E0200I7B70--2022-04-13-0149.pdf
Invoice_E0200I7EAD--2022-04-13-0106.pdf
```

If you wanted to move the invoice name portion to the end and move the date portion to the beginning, you could do the following via RegEx:

```PowerShell
Get-ChildItem "*Invoice*.pdf" | ForEach-Object {
    $_.Name -match "(Invoice.*)--(\d{4}-\d{2}-\d{2}-\d{4})\.pdf";
    $datePortion = $Matches[2];
    $invName = $Matches[1];
    $_ | Rename-Item -NewName {"$datePortion--$invName"+$_.Extension} -Path $Matches[0] -Verbose
}
```

This would yield:

```
2021-10-28-0007--Invoice_E0200G90M8.pdf
2021-12-13-0228--Invoice_E0200GS2L3.pdf
2022-04-13-0106--Invoice_E0200I7EAD.pdf
2022-04-13-0149--Invoice_E0200I7B70.pdf
```
----
----
## _Further Reading_
- [PowerShell's "rename-item" command](https://www.pdq.com/powershell/rename-item/)
- [PowerShell's "move-item" command](https://www.pdq.com/powershell/move-item/)
----
----
## _Renaming in Bash_
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
### Simple Rename as One-Liner
If, for example, you have a sequence of screenshots in a folder, following the format of `SN-12-1` through `SN-12-1200`, you could correct the last number block by opening a terminal in the containing folder and running:
```bash
for file in SN-12-*; do mv "$file" "$(printf "SN-12-%05d.png" "${file##*-}")"; done
```
