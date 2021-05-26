# Updating Text within Existing Plaintext Files by PowerShell Script

## _Copied from tutorial by Joshua Stenhouse [here](https://virtuallysober.com/2020/08/04/how-to-update-powershell-scripts-using-powershell/)_

### Single-line Update Example

This works on a specific file.

```PowerShell
# Script to edit, change this to your script
$Script = "C:\Demo\DemoScript1.ps1"
# Loading the script content
$ScriptContent = Get-Content $Script
# Enter the line to update
$LineToUpdate = Read-Host "EnterLineToUpdate"
# Enter the new line 
$NewLine = Read-Host "EnterNewLine"
# Selecting the old string
$OldString = $ScriptContent |  Select-String -Pattern $LineToUpdate | Select -First 1
# Only progressing if string found, otherwise nothing to update
IF ($OldString -ne $null)
{
# Creating string required for new line
$NewString = "$NewLine"
# Updating the line
$ScriptModified = $ScriptContent.Replace("$OldString","$NewString") 
# Saving changes to the script
$ScriptModified | Set-Content -Path $Script
}
ELSE
{
"LineNotFound"
}
```

### All Scripts in a Folder Line Update Example

This checks all of a specified file type in a folder and changes each instance of a specified line.

```PowerShell
# Folder of scripts to edit
$ScriptFolder = "C:\Demo"
# Finding all scripts (add -Recurse to Get-ChildItem to get scripts in sub folders)
$Scripts = Get-ChildItem -Path $ScriptFolder | Where {$_.Name -match ".ps1"} | Select -ExpandProperty FullName
# Enter the line to update
$LineToUpdate = Read-Host "EnterLineToUpdate"
# Enter the new line 
$NewLine = Read-Host "EnterNewLine"
# For each script, updating
ForEach ($Script in $Scripts)
{
"Updating: $Script"
# Loading the script content
$ScriptContent = Get-Content $Script
# Selecting the old string
$OldString = $ScriptContent |  Select-String -Pattern $LineToUpdate | Select -First 1
# Only progressing if string found, otherwise nothing to update
IF ($OldString -ne $null)
{
# Creating string required for new line
$NewString = "$NewLine"
# Updating the line
$ScriptModified = $ScriptContent.Replace("$OldString","$NewString") 
# Saving changes to the script
$ScriptModified | Set-Content -Path $Script
}
ELSE
{
"LineNotFound"
}
}
```
