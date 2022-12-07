# Using PowerShell to Delete Leftover Services

### _Verify the Service Name is Correct_
If you're querying with a valid service name, the following string should return useful results.
```PowerShell
sc.exe query "Sage 50 Smart Posting 2022"
```

### _Delete the Service_
```PowerShell
sc.exe delete "Sage 50 Smart Posting 2020"
# OUTPUTS...
[SC] DeleteService SUCCESS
```
Alternatively, if you only know the display name of the service, you can get the necessary service name by the following:
```PowerShell
sc.exe delete "$((Get-Service -DisplayName "*Sage 50 Smart Posting 2020*").Name)"
```

## Further Reading
- [How to Delete a Service in Windows](https://www.ghacks.net/2011/03/12/how-to-remove-services-in-windows/) (_`ghacks.net`_)

# Using PowerShell to Change Service StartUp Type

## Simple Version

To simply change the startup type of the Sync Host (OneSyncSvc) which probably _isn't_ needed on a Windows PC...
In the command below, note that the param is actually `StartType`.
```PowerShell
Get-Service -Name 'OneSyncSvc'
```
If you want to change the param `StartType`, you the command is actually _used_ as `-StartupType` (see below).
```PowerShell
Get-Service -Name 'OneSyncSvc' | Set-Service -StartupType Disabled
```

## Fancy Version for Scripting
The below example shows how to kill some services (that should probably NOT ever be killed)

```PowerShell
<# For more details, see:
https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/set-service?view=powershell-7.2
#>
$serviceList = 'uhssvc', 'wuauserv', 'OneSyncSvc'
<# $serviceList | ForEach-Object {Get-Service -Name $_} # returns an object representing the service
$serviceList | ForEach-Object {Get-Service -Name $_ | Select-Object *} # returns a more detailed version of above #>
# Below line provides the most detail as well as gives error handling.
$serviceList | ForEach-Object {try{Get-Service -Name $_ -ErrorAction Stop | Select-Object *}catch{Write-Output("$_")}}

# You could also use something like below, but it only shows running services:
Get-Service -DisplayName "*Update" | Stop-Service -Force -Verbose # Note the use of the wildcard character.

# Below iterates through the array of service names to terminate, disabling each.
$serviceList | ForEach-Object {try{Stop-Service -Name $_ -Force -Verbose -ErrorAction Stop; Set-Service -Name $_ -StartupType Disabled -Verbose -ErrorAction Stop}catch{Write-Output("$_")}}

function DoesServiceExist {
    [Parameter(Mandatory=$true)]$mySrvcNm
    if(Get-Service -Name $mySrvcNm -ErrorAction SilentlyContinue -eq $null){return 'Service does not exist'}
    else{return 'Service found!'}
}

Remove-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate -Recurse

```
