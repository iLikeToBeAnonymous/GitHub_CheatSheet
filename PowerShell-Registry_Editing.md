# Registry Editing via PowerShell

## Introduction

According to Microsoft:
> _The registry is a hierarchical database... The data is structured in a tree format. Each node in the tree is called a key. 
> Each key can contain both subkeys and data entries called values. Sometimes, the presence of a key is all the data that an 
> application requires; other times, an application opens a key and uses the values associated with the key..._ <br>
> A registry tree can be 512 levels deep. You can create up to 32 levels at a time through a single registry API call.... <br>
> &emsp;&mdash; docs.microsoft.com, ["Structure of the Registry"](https://docs.microsoft.com/en-us/windows/win32/sysinfo/structure-of-the-registry)

The "data entries" mentioned above can be though of as being the "file" within a "folder." According to further Microsoft documentation:
> _...The actual data is stored in the registry entries, the lowest level element in the registry. The entries are like files... <br>
> Each entry consists of the entry name, its Data Types in the Registry, ...and a field known as the value of the registry entry._ <br>
> &emsp;&mdash; docs.microsoft.com, ["Overview of the Windows Registry"](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2003/cc781906(v=ws.10))

The above reference is highly-recommended further reading, giving a distinct explanation of the registry hierarchy of the sub*tree*, key, sub*key*, entry structure.

----
----

## Adding a New Registry Entry

The following examples will be using these declared variables:

```PowerShell
$regKeyPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\Nla\Cache\Intranet\myDemoKey'
$regEntryName = 'someRegItem'
$regEntryVal = 777
```

### _New-Item and New-ItemProperty_
The `New-Item` command is able to do more than create new files and folders. It is also able to create new subkeys ("folders") in Windows Registry.
A registry entry (an "item" within a registry "folder") can subsequently be created via the `New-ItemProperty` command.

```PowerShell
# Create a registry subkey within the "Intranet" subkey
New-Item -Path $regKeyPath

# Now add a new registry entry (a named registry "item") to that key
New-ItemProperty -Path $regKeyPath -Name $regEntryName -Value $regEntryVal
```

**NOTE:** If the second command were to be executed by itself, the new registry value would not be created because the key to contain it does not already exist.

Further Reading:
 - _Microsoft.PowerShell.Management_, ["New-Item"](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/new-item?view=powershell-7.2) 
 - _Microsoft.PowerShell.Management_, ["New-ItemProperty"](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/new-itemproperty?view=powershell-7.2)
 - _Microsoft.PowerShell.Management_, ["Set-Item"](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/set-item?view=powershell-7.2)
 - _Microsoft.PowerShell.Management_, ["Set-ItemProperty"](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/set-itemproperty?view=powershell-7.2)

---

### [_Reg Add_](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/reg-add)

In the example below, `$regKeyPath` needed to be changed because the key `HKLM` is **NOT** followed by a colon, unlike in the `New-Item`/`New-ItemProperty` example. <br>
Additionally, note that the subkey does not need to be created prior to creating the registry entry item.
```PowerShell
$regKeyPath = 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\Nla\Cache\Intranet\myDemoKey'
Reg Add $regKeyPath /v $regEntryName /d $regEntryVal /f # The "/f" flag adds to registry without prompt for confirmation
```

### _[Registry.SetValue Method](https://docs.microsoft.com/en-us/dotnet/api/microsoft.win32.registry.setvalue?view=net-6.0)_

In the example below, `$regKeyPath` requires that the "HKEY_LOCAL_MACHINE" be written out instead of abbreviated to "HKLM"
```PowerShell
$regKeyPath = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\Nla\Cache\Intranet\myDemoKey'
$regEntryName = 'someRegItem'
$regEntryVal = 777
[Microsoft.Win32.Registry]::SetValue($regKeyPath,$regEntryName,$regEntryVal)
```

----
----

## Checking if a Registry Entry Exists

### _[Registry.GetValue Method](https://docs.microsoft.com/en-us/dotnet/api/microsoft.win32.registry.getvalue?view=net-6.0)_
Note: ALL THREE PARAMETERS MUST BE PROVIDED FOR THIS TO NOT THROW ERRORS!

```PowerShell
$defaultMsg = "If a registry entry doesn't exist, this gets returned."
[Microsoft.Win32.Registry]::GetValue('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon','AutoRestartShell',$defaultMsg)
```

----
----

## Accessing the Registry Directly
Native [Microsoft.Win32.Registry](https://docs.microsoft.com/en-us/dotnet/api/microsoft.win32.registrykey?view=net-6.0#methods)
See also: https://docs.microsoft.com/en-us/dotnet/api/microsoft.win32.registrykey.openbasekey?view=net-6.0
```PowerShell
Import-Module -Name .\LIB\GPRegistryPolicy\GPRegistryPolicyParser.psm1 -Verbose

##################################################
reg load 'HKLM\loadedUser' 'C:\Users\Default\NTUSER.DAT'

$Hive = [Microsoft.Win32.Registry]::LocalMachine
<# https://docs.microsoft.com/en-us/dotnet/api/microsoft.win32.registry?view=net-6.0#examples
REGARDING THE ABOVE LINE (WHEREIN THE HIVE IS SPECIFIED AS "LocalMachine"), other acceptable values are:
    CurrentUser
    LocalMachine
    ClassesRoot
    Users
    PerformanceData
    CurrentConfig
    DynData
#>
# $Hive = [Microsoft.Win32.Registry]::CurrentUser
$regSubPath = 'loadedUser\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize'
#$regSubPath = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer'
$targetValueName = 'EnableTransparency'

$RegKey = $Hive.OpenSubKey($regSubPath)
Write-Output("Key:`n`t" + $RegKey.ToString())

$Vals = $RegKey.GetValueNames()
Write-Output('Value Names:')
# Write-Output($RegKey.GetValueNames())
$Vals | ForEach-Object {Write-Output("`t$_")}

$Data = $RegKey.GetValue($targetValueName)
$Size = $Data.Length

Write-Output("Info for $targetValueName`: ")
Write-Output("`tData Value`: $Data")
Write-Output("`tData Size`: $Size")
##################################################

# https://docs.microsoft.com/en-us/dotnet/api/microsoft.win32.registrykey?view=net-6.0#methods
# $RegKey.Flush() # Writes all the attributes of the specified open registry key into the registry
$RegKey.Close() # Closes the key and flushes it (writes it) to disk if its contents have been modified.
$RegKey.Dispose() # Releases all resources used by the current instance of the RegistryKey class.

reg unload 'HKLM\loadedUser'
[System.GC]::Collect() # Standard garbage collection invocation
```
