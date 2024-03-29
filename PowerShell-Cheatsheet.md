## Coding Loops with and without Line Breaks

Code can be written cleanly with nesting and line breaks such as below:

```PowerShell
$myIndx = 0 # Declare a variable to keep track of an array index
$myTxtAry | ForEach-Object { # An array gets piped into a ForEach-Object loop
  Write-Output("Index: $myIndx Value $_") <# The "$_" is the native way of
                                             representing the contents of a 
                                             particular object in this loop. #>
  $myIndx++ # Increment the index before the next turn of the loop.
}
```

...Or more compactly with the use of semicolons:

```PowerShell
$myIndx = 0; $myTxtAry | ForEach-Object {Write-Output("Index: $myIndx Value $_"); $myIndx++}
```

It is possible to shorten this even further by the use of [script blocks](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_script_blocks?view=powershell-7.2):

```PowerShell
$myTxtAry | % {$myIndx=0} {"Value:$_ Index:$myIndx"; $myIndx++}
```

----

## Working with Variables and Garbage Collection

### The [`New-Variable` Command](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/new-variable?view=powershell-7.2)
Creates a new variable in PowerShell. It can simply be declared, or can be declared with a value. In this case, it's declared as ReadOnly, has a value, and includes a description.

```PowerShell
New-Variable -Name 'myTargetFilePath' -Value 'C:\Windows\System32' -Description 'An example variable' -Option ReadOnly
```

### The [`Get-Variable` Command](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-variable?view=powershell-7.2)
To retrieve details about a specifically-named variable.  In this example, the variable is `$myTargetFilePath` from before. <br>
Note that the "Description" field is populated with the text from the previous step.

```PowerShell
Get-Variable -Name 'myTargetFilePath' | Select-Object *
# OR...
Get-Variable | Select-Object * | Where-Object {$_.Name -like "myTargetFilePath"}
```

### The [`Set-Variable` Command](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/set-variable?view=powershell-7.2)
Similar to the `New-Variable` command, but useable for updating the value and other parameters of an already-existing variable. 
If you want to use this command on a ReadOnly variable, you'll have to include the `-Force` flag as shown below. The example below not only changes
the value of the variable, it also removes the ReadOnly option.

```PowerShell
Set-Variable -Name 'myTargetFilePath' -Value 'C:\Windows\addins' -Option None -Force
```

### The [`Clear-Variable` Command](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/clear-variable?view=powershell-7.2)
Clears the value of a variable, but does not clear other parameters (such as the description)
```PowerShell
Clear-Variable -Name 'myTargetFilePath'
```

### The [`Remove-Variable` Command](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/remove-variable?view=powershell-7.2)
Deletes a variable and its value. Has multiple parameters useful for performing bulk operations, including 
an allowance to specify the scope of the variables to delete.

```PowerShell
Remove-Variable 'myTargetFilePath'
```

This can be implemented in a more elegant solution such as below.

```PowerShell
$myVarList = '$myTargetFilePath', 'currentFileContent','myVarList'
<#  In the try statement below, if -ErrorAction is not specified, the catch block won't be triggered.
    In the catch statement below, the $_ is framed in quotes so it will only write-out the string part of the error message. #>
$myVarList | ForEach-Object {try{Remove-Variable -Name $_ -ErrorAction Stop}catch{Write-Output("$_")}}

[System.GC]::Collect() # Garbage collection.
```

___

## Checking if a file exists <sup>[adamtheautomator.com](https://adamtheautomator.com/powershell-check-if-file-exists/)</sup>

If checking for a specific file (and not a folder), use the following:
```PowerShell
Test-Path -Path 'C:\temp\important_file.txt' -PathType Leaf
```
> Note that the -PathType Leaf part tells the cmdlet to check for a file and not a directory explicitly.

___

## Viewing an object's properties by name
PowerShell objects are similar to objects in many other programming languages, but are more finicky. If you think of JavaScript objects being in key/value pairs, PowerShell objects contain data in what they call Property/PropertyValue pairs.

For this exercise, consider how to get the properties of a file, `nsis-3.06.1-setup.exe`. If you type the following, you'll get a variety of details about the file:

```PowerShell
# Pretend that you opened a PowerShell instance within the containing folder for the file.
$myFileName = 'nsis-3.06.1-setup.exe'
Get-Item -Path $myFileName | Select-Object *
```
<details><summary>Expand to show results of above code</summary>

  ```PowerShell
  PSPath            : Microsoft.PowerShell.Core\FileSystem::F:\Downloads\nsis-3.06.1-setup.exe
  PSParentPath      : Microsoft.PowerShell.Core\FileSystem::F:\Downloads
  PSChildName       : nsis-3.06.1-setup.exe
  PSDrive           : F
  PSProvider        : Microsoft.PowerShell.Core\FileSystem
  PSIsContainer     : False
  Mode              : -a----
  VersionInfo       : File:             F:\Downloads\nsis-3.06.1-setup.exe
                      InternalName:
                      OriginalFilename:
                      FileVersion:      3.06.1
                      FileDescription:  NSIS Setup
                      Product:
                      ProductVersion:
                      Debug:            False
                      Patched:          False
                      PreRelease:       False
                      PrivateBuild:     False
                      SpecialBuild:     False
                      Language:         English (United States)

  BaseName          : nsis-3.06.1-setup
  Target            : {}
  LinkType          :
  Name              : nsis-3.06.1-setup.exe
  Length            : 1538352
  DirectoryName     : F:\Downloads
  Directory         : F:\Downloads
  IsReadOnly        : False
  Exists            : True
  FullName          : F:\Downloads\nsis-3.06.1-setup.exe
  Extension         : .exe
  CreationTime      : 2021-05-03 12:58:30
  CreationTimeUtc   : 2021-05-03 16:58:30
  LastAccessTime    : 2021-12-08 09:07:36
  LastAccessTimeUtc : 2021-12-08 14:07:36
  LastWriteTime     : 2021-05-03 12:58:40
  LastWriteTimeUtc  : 2021-05-03 16:58:40
  Attributes        : Archive
  ```
  
</details>

Notice that some properties (such as `Extension`) are top-level and can be accessed directly via the [`Get-ItemProperty` ](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-itemproperty?view=powershell-7.2)
command:

```PowerShell
Get-ItemProperty -Path $myFileName -Name 'Extension'
```

The above command actually retrieves the object that is that property. What you actually want is to return the _value_ of the property named "Extension," so you instead need to use the [`Get-ItemPropertyValue`](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-itempropertyvalue?view=powershell-7.2)
command:

```PowerShell
Get-ItemPropertyValue -Path $myFileName -Name 'Extension'
# Gives desired result of ".exe"
```

If we try this same command on a multi-level property (such as the `VersionInfo` demonstrated in the original console output above), we once again get a sub-object with multiple nested values:
<details><summary>Expand to show results of above code</summary>

  ```PowerShell
  PS F:\Downloads> Get-ItemPropertyValue -Path $myFileName -Name 'VersionInfo'

  ProductVersion   FileVersion      FileName
  --------------   -----------      --------
                   3.06.1           F:\Downloads\nsis-3.06.1-setup.exe
  ```
  
</details>

Ultimately, the easiest way of retrieving the value is this:
```PowerShell
(Get-Item -Path $myFileName).VersionInfo.FileVersion
# Above code reveals just the detail we want: "3.06.1"
```

___
## Filtering Results

### _A Basic Example with Timezones_
All available timezones available to the system can be viewed via `tzutil /l`. However, this yields an exceedingly verbose response. If, for example, you only want to see results for "Alaska," you could...

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

---
### _A Slightly More Complicated Example_
Let's try filtering out details from scheduled tasks in Task Scheduler. If we simply run the following:

```PowerShell
Get-ScheduledTask -TaskName "Microsoft*" | Select-Object "*"
```
...the results are detailed and difficult to read (just trust me on this, or run the command yourself to see the results).
For this example, we'll be trimming down those results just so we can see the author name. The following three lines all yield the same output, just via slightly different routes:

```PowerShell
# For-loop
(Get-ScheduledTask -TaskName "Microsoft*" | Select-Object "*").CimInstanceProperties | ForEach-Object {if($_.Name -eq 'Author'){Write-Output($_)}}

# A Where-Object with braced query
(Get-ScheduledTask -TaskName "Microsoft*" | Select-Object "*").CimInstanceProperties | Where-Object {$_.Name -like 'Author'}; Write-Output($_)

# A Where-Object with a naked property filter
(Get-ScheduledTask -TaskName "Microsoft*" | Select-Object "*").CimInstanceProperties | Where-Object -Property Name -like 'Author'; Write-Output($_);
```
I want to reiterate that each of the above three lines produce identical results, so I only included the results once below to save space. (Note: on my computer, each line produced three objects)
<details><summary><em>Click to expland the console results for the above three commands.</em></summary>

```PowerShell
  Name            : Author
  Value           : $(@%SystemRoot%\system32\compattelrunner.exe,-501)
  CimType         : String
  Flags           : Property, NotModified
  IsValueModified : False

  Name            : Author
  Value           : Microsoft Corporation
  CimType         : String
  Flags           : Property, NotModified
  IsValueModified : False

  Name            : Author
  Value           : Microsoft Corporation
  CimType         : String
  Flags           : Property, NotModified
  IsValueModified : False
```
  
</details>

---

### _Filtering with Not Like_

Say you have multiple network adapters on a PC, many of which are virtual adapters. You know that all virtual adapters contain the "virtual" somewhere in the name. <br>
You could use a `-NotLike` to filter these out:

```PowerShell
Get-NetAdapter | Where-Object {$_.InterfaceDescription -NotLike "*virtual*"}
```

----
----
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

## Using `netstat`
### _View all open/listening ports_
The following is copied from [gist:2558512](https://gist.github.com/steelcm/2558512) by member [Chris Steel (steelcm)](https://github.com/steelcm)

```powershell
PS C:\> netstat -an | select-string -pattern "listening"
```

Because `netstat` returns a string list, string filtering techniques must be used. In the example above, notice that the `Select-String` commandlet with a `-pattern` flag was used. (_**Remember!** the `pattern` flag accepts regular expressions_)

### _Filtering by port number_
Continuing from the previous example, the giant string is arranged in lines, and therefore can be iterated using the `ForEach-Object` commandlet. 
```PowerShell
# Make a RegEx to find instances of port 4443
$myRegEx = ".*\:443\b.*"
netstat -an | ForEach-Object {if($_ -match $myRegEx){Write-Output($_)}}
```

For more information about extracting network info via PowerShell, see [PowerShell-NetworkInfo.md](https://github.com/iLikeToBeAnonymous/GitHub_CheatSheet/blob/master/PowerShell-NetworkInfo.md).

---


## Copying Folders and Files
Personally, the two most-useful methods of copying are the [`copy-item`](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/copy-item?view=powershell-7.1) and [`robocopy`](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/robocopy) commands. The `copy-item` command is nice for copying a single file, but `robocopy` seems to still be the star when it comes to copying directories.

### _Robocopy_
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

### _[`Copy-Item` Commandlet](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/copy-item?view=powershell-7.2)_

NOTE: the `Copy-Item` commandlet requires that the destination folder already exist. Mutiple levels of a folder path can be created at once via the `New-Item` commandlet.

<details><summary>Expand to show example of creating multiple levels of folders...</summary>

  ```PowerShell
  New-Item -Path 'C:\Some_Folder\Some_Subfolder' -ItemType 'directory'
  ```
  
</details>

To copy a single file:

```PowerShell
Copy-Item -Path 'C:\Original_Folder\My_file.txt' -Destination 'C:\Some_other_folder\My_copied_file.txt'
```

Using `Copy-Item` to copy folders and their contents is a little bit trickier than using `robocopy`, but it is still relatively straightforward. <br>
In the following example, the `\*` part of the path indicates that all the contents of the original folder are copied to the new destination, but not the folder itself. <br>
In the example below, all the files WITHIN the "Pictures" folder are copied to the "Graphics" folder. (_Note the use of double quotes to facilitate the use of the wildcard character_)

```PowerShell
Copy-Item -Path "C:\Pictures\*" -Destination 'C:\Graphics' -Recurse
```

The next example omits the `\*`, and in the result, a copy of the "Pictures" folder is a child of the "Graphics" folder (all the contents of the "Pictures" folder are copied over as well).

```PowerShell
Copy-Item -Path 'C:\Pictures' -Destination 'C:\Graphics' -Recurse
```



___
### References:
<a id="1">[1]</a> 
Mohamed Jawad, [https://serverfault.com/questions/120229/adding-a-user-to-the-local-administrator-group-using-powershell](https://serverfault.com/questions/120229/adding-a-user-to-the-local-administrator-group-using-powershell), Accessed 2021-02-17

<a id="2">[2]</a>
Sergey Tkachenko, [https://winaero.com/save-list-services-file-windows-10/](https://winaero.com/save-list-services-file-windows-10/), Accessed 2021-04-06
