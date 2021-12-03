## Coding Loops with and without Line Breaks

Code can be written cleanly with nesting and line breaks such as below:

```PowerShell
$myIndx = 0 # Declare a variable to keep track of an array index
$myTxtAry | ForEach-Object { # An array gets piped into a ForEach-Object loop
  Write-Output("Index: $myIndx Value $_") # The "$_" is the native way of representing the contents of a particular object in this loop
  $myIndx++ # Increment the index before the next turn of the loop.
}
```

...Or the more compactly with the use of semicolons:

```PowerShell
$myIndx = 0; $myTxtAry | ForEach-Object {Write-Output("Index: $myIndx Value $_"); $myIndx++}
```

It is possible to shorten this even further by the use of [script blocks](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_script_blocks?view=powershell-7.2):

```PowerShell
$myTxtAry | % {$myIndx=0} {"Value:$_ Index:$myIndx"; $myIndx++}
```

___

## Checking if a file exists <sup>[adamtheautomator.com](https://adamtheautomator.com/powershell-check-if-file-exists/)</sup>

If checking for a specific file (and not a folder), use the following:
```PowerShell
Test-Path -Path 'C:\temp\important_file.txt' -PathType Leaf
```
> Note that the -PathType Leaf part tells the cmdlet to check for a file and not a directory explicitly.

## Filtering Results

All available timezones available to the systme can be viewed via `tzutil /l`. However, this yields an exceedingly verbose response. If, for example, you only want to see results for "Alaska," you could...

```Powershell
> tzutil /l | Where-Object {$_ -match ".*laska.*"}
> echo "This yields following two lines:"
> (UTC-9:00) Alaska
> Alaskan Standard Time
```

The `$_` above basically says that any property can match the regular expression. However, if you're searching for something which has property names, you can follow the underscore with a period and the property name, _then_ match to your regular expression. 

```Powershell
Get-TimeZone -ListAvailable | Where-Object {$_.BaseUtcOffset -match ".*-09:00.*"}
```

___
## How to Save a List of a Folder's Contents to a .txt File

The following command will send the top-level view of the current directory's list of files and folders to a .txt file. If the file already exists, its contents will be overwritten.

```powershell
ls > myFileName.txt
```

However, you can add a second arrow to **append** to a file instead. If the file doesn't already exist, it will be created. 

```powershell
ls >> myFileName.txt
```

NOTE: the `>` and `>>` both send a specified stream to an output file you've defined. It is not limited to just use with the `ls` command. You can also do something like:

```powershell
"Hello World!" > myFileName.txt
```
Further reading can be found [here](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_redirection?view=powershell-7.1).
___
## File Rename Automation
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
## Symlinks (fancy shortcuts)
Below only works in cmd, not powershell
`mklink /J "C:\Link To Folder" "C:\Users\Name\Original Folder"`

Powershell vs:

_Disclaimer_: If you want to make a symlink to a network location, you probably won't be able to use it.
Run the following to check what's enabled or not:
```Powershell
fsutil behavior query symlinkevaluation
```

You can pick which one you need to enable and then run the follow (Remote to remote is used below):
```Powershell
fsutil behavior set symlinkevaluation R2L:1
```

See article [here](http://www.virtualizetheworld.com/2014/07/the-symbolic-link-cannot-be-followed.html) for more details

```Powershell
$myAliasPath = "C:\Link To Folder"
$myActualPath = "C:\Users\Name\Original Folder"
New-Item -ItemType SymbolicLink -Path $myAliasPath -Target $myActualPath
```

If you need to update the target of the SymbolicLink later, just repeat the declaration of the variables, the 
follow the `New-Item` line with `-Force`.

```Powershell
New-Item -ItemType SymbolicLink -Path $myAliasPath -Target $myActualPath -Force
```
___
## Powershell Scripting Basics

### How to execute a powershell script 
(if you get the `... someScriptName.ps1 cannot be loaded because running scripts is disabled on this system` error).
- Open an instance of Powershell in the script location. It doesn't SEEM to have to be opened as admin for this to work...
- Then the cannon-to-kill-a-mosquito solution is to run your script by typing the following:

``` powershell
  powershell -executionpolicy bypass -File .\yourScriptNameHere.ps1
```
- Alternatively, this roundabout trick to get your script to execute seems to work as well:

``` powershell
  Get-Content .\yourScriptNameHere.ps1 | Invoke-Expression
```  

- Another option is to create a shortcut to the script which automatically runs the script with those options embedded. To accomplish this:
  1. Right-click your .ps1 file and select "_Create Shortcut_"
  2. Next, right-click the shortcut you just created and go into the "Target" field.
  3. Once you cursor is blinking within the field, hit "_HOME_" on your keyboard and paste the following:
`%windir%\system32\WindowsPowerShell\v1.0\powershell.exe -noexit -executionpolicy bypass -File `<br>
    The `-noexit` keeps the terminal window from auto-closing after execution, and the `-executionpolicy bypass` will do what was explained above.
  4. Click "_Apply_" followed by "_OK_"

### Run script silently and/or run with elevation
According to this [post by user SilverAzide](https://forum.rainmeter.net/viewtopic.php?t=27632):
>The trick is the **-NonInteractive** switch; e.g., `powershell -NonInteractive -Command "... your PS command..."`

>Another super handy feature of powershell is that you can get it to prompt for elevation, something you can't do with a command prompt (a command prompt has to be launched as an Admin, but a PS command can elevate a process as needed using the -Verb switch).

>Here is a powershell command that will launch DOS-type batch file in an elevated hidden window (yes, you can launch a hidden powershell window that launches a hidden window). All you will see is a prompt for elevation.
>
```powershell
powershell -NonInteractive -Command "Start-Process 'my_batch_file.cmd' [color=#FF0000]-Verb runAs[/color] -WindowStyle Hidden"
```

Alternatively, you can simply enable running scripts via PowerShell, which you probably want to do if you're using it as a development environment.
```powershell
Set-ExecutionPolicy RemoteSigned
```

This will enable any local scripts to run and only allow signed remote scripts to run. It's not ideal, but it's safer the changing the execution policy to `Unrestricted` instead. 

If you need to disable running scripts again for security purposes, type:
```powershell
Set-ExecutionPolicy Restricted
```

The Set-ExecutionPolicy options are:
- `Restricted` – No scripts can be run.
- `AllSigned` – Only scripts signed by a trusted publisher can be run.
- `RemoteSigned` – Downloaded scripts must be signed by a trusted publisher.
- `Unrestricted` – All Windows PowerShell scripts can be run.

## Running a _.bat_ File from a Network Path
If you attempt to run a _.bat_ file (that does things within the network folder), you'll get an error message like below...
```CMD
cd \\myServerName\someNetworkFolder
@REM running the above line yields the following error:
CMD does not support UNC paths as current directories.
```
The ideal way of bypassing this is to map the network folder as a network drive. However, that isn't always an option. A solution utilizes the `pushd` and `popd` commands.
This was extrapolated by reading posts found [here](https://superuser.com/questions/282963/browse-an-unc-path-using-windows-cmd-without-mapping-it-to-a-network-drive)
```bat
@REM Save the network path from which the script is running as a variable.
set currentDir=%~dp0

@REM The strange syntax below says: 
@REM "starting from the 0 position of the %currentDir% string, extract the first two 
@REM  chars as a substring."
set firstTwoChars=%currentDir:~0,2%

@REM If the string val of %firstTwoChars% is two back strokes (indicating a UNC path), 
@REM make a temp drive map using the pushd command.
if "%firstTwoChars%"=="\\" pushd %currentDir%

@REM Do the rest of your commands in here, such as bypassing a restricted execution policy on a PowerShell script.
PowerShell.exe -Command "powershell -executionpolicy bypass -File .\myScriptName.ps1"

@REM Do the check again, and use the popd command to release the temp mapped drive.
if "%firstTwoChars%"=="\\" popd
```

## Simple Step to add a domain user to the Administrators group:[<sup>1</sup>](#1)

In PowerShell...

```powershell
Add-LocalGroupMember -Group Administrators -Member $env:USERDOMAIN\<username>
```

Note: Make sure you run PowerShell "As Administrator".

## Write out list of currently running services[<sup>2</sup>](#2)

```powershell
Get-Service | Where-Object {$_.Status -eq "Running"} > myRunningServices.txt
```

## View all open/listening ports
The following is copied from [gist:2558512](https://gist.github.com/steelcm/2558512) by member [Chris Steel (steelcm)](https://github.com/steelcm)

```powershell
PS C:\> netstat -an | select-string -pattern "listening"
```

## Copying Folders and Files
Personally, the two most-useful methods of copying are the [`copy-item`](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/copy-item?view=powershell-7.1) and [`robocopy`](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/robocopy) commands. The `copy-item` command is nice for copying a single file, but `robocopy` seems to still be the star when it comes to copying directories.

### Robocopy
To copy a folder and ALL its contents:

```PowerShell
$copyFrom = "C:\myOriginal"
$copyTo = "D:\myFolderClone"
robocopy $copyFrom $copyTo /mt /zb /e /is
```
Some common robocopy flags (including those used above) are:
- `/mt`     enables multithreading
- `/z`      enables robocopy to resume if interrupted
- `/b`      backup mode, overriding file and folder permission settings for files you might otherwise not have access to
- `/zb`     copies files in restartable mode. If access is denied, switches to backup mode.
- `/e`      copies subdirectories, including empty ones.
- `/is`     ignores if an existing file in the target is identical to a file in the source. Normally, robocopy only overwrites files that are different.
- `/purge`  deletes destination files and directories that no longer exist in the source.

You can also choose to copy a single file, but the command is a bit confusing. In the command below, notice that the filename comes after both the "from" and "to" directories.

```PowerShell
$copyFrom = "C:\myOriginal"
$copyTo = "D:\myFolderClone"
$someFile = myFileName.txt
robocopy $copyFrom $copyTo $someFile /mt /zb /e /is
```
___
### References:
<a id="1">[1]</a> 
Mohamed Jawad, [https://serverfault.com/questions/120229/adding-a-user-to-the-local-administrator-group-using-powershell](https://serverfault.com/questions/120229/adding-a-user-to-the-local-administrator-group-using-powershell), Accessed 2021-02-17

<a id="2">[2]</a>
Sergey Tkachenko, [https://winaero.com/save-list-services-file-windows-10/](https://winaero.com/save-list-services-file-windows-10/), Accessed 2021-04-06
