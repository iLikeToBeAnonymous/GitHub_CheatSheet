
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

### Simple Step to add a domain user to the Administrators group:[<sup>1</sup>](#1)

In PowerShell...

```powershell
Add-LocalGroupMember -Group Administrators -Member $env:USERDOMAIN\<username>
```

Note: Make sure you run PowerShell "As Administrator".

___
### References:
<a id="1">[1]</a> 
"Mohamed Jawad", [https://serverfault.com/questions/120229/adding-a-user-to-the-local-administrator-group-using-powershell](https://serverfault.com/questions/120229/adding-a-user-to-the-local-administrator-group-using-powershell), Accessed 2021-02-17
