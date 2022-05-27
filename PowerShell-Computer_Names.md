A computer can have many names, all of which have their own significance and generally seem like some variation of the others.

FQDN = "**F**ully **Q**ualified **D**omain **N**ame"

Below code shows several options by which to programmatically acquire the names of the PC on which this code is run.

```PowerShell
$env:COMPUTERNAME
hostname
Get-WmiObject Win32_ComputerSystem # | Select-Object -ExpandProperty name
(Get-CIMInstance CIM_ComputerSystem).Name
[system.environment]::MachineName
[System.Net.Dns]::GetHostName()
[System.Net.Dns]::GetHostByName($env:COMPUTERNAME).HostName # This is the FQDN -- "Fully Qualified Domain Name"
$myFQDN=(Get-WmiObject win32_computersystem).DNSHostName+"."+(Get-WmiObject win32_computersystem).Domain; Write-Host $myFQDN
(Get-WmiObject win32_computersystem).DNSHostName+"."+(Get-WmiObject win32_computersystem).Domain
Get-CimInstance win32_computersystem | % { $_.Name + '.' + $_.Domain }
netdom computername ($env:COMPUTERNAME) /enumerate # Has the benefit of showing all names if the computer has aliases.
```
