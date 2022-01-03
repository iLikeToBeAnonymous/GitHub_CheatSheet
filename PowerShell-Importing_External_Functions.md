## _Importing Functions via Dot Notation_

Consider two files: `MyFunctions.ps1` and `Main.ps1`. <br>
Contents of `MyFunctions.ps1`:
```PowerShell
Function Get-SomeText {
    param
    (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$someText
    )

    return "$someText`nPlus this"
 }
```
**Contents of `Main.ps1`:**
```PowerShell
# Note: using dot source notation requires putting the full path of the script being referenced.
# This can be made dynamic by using the $PSScriptRoot PowerShell variable.
. "$PSScriptRoot`\MyFunctions.ps1"
# All functions of the above file are now able to be called from within this script
Write-Output(Get-SomeText -someText 'This is some text')
```
In the above example, note that `Get-SomeText` is a function located in `MyFunctions.ps1` and that `-someText` is 
the parameter of the function as declared in that function.

## _Using the Import-Module Commandlet_
Alternatively, PowerShell's `Import-Module` commandlet is a bit more transparent when reviewing code. However, it
seems to still use the same dot notation on the back end of things.
Just like with dot notation, the file containing the functions you are importing must be referenced with a full
path, so again, this can by made dynamic by use of the `$PSScriptRoot` native variable. <br><br>
**Contents of `Main.ps1` if `Import-Module` is used instead:**
```PowerShell
Import-Module -Name "$PSScriptRoot`\MyFunctions.ps1" -Verbose
Write-Output(Get-SomeText -someText 'This is some text')
```

## _Retrieving Info about a Currently-Loaded Module_
Continuing with the example from above (notice that wildcards are allowed):
```PowerShell
Write-Output('Module Name: ' + (Get-Module "*functions*").Name)
```

## _Unloading a Currently-Loaded Module_
Once you're done using the `MyFunctions` module, you can unload it from the session like so:
```PowerShell
Remove-Module -Name "MyFunctions" -Verbose
```

References:
- https://mcpmag.com/articles/2017/02/02/exploring-dot-sourcing-in-powershell.aspx
- https://www.techtarget.com/searchwindowsserver/tutorial/Learn-to-use-a-PowerShell-call-function-from-another-script
- https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/import-module?view=powershell-7.2#examples
