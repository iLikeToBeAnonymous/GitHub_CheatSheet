Network drive paths can be viewed in several ways:

```powershell
NET USE
```

or

```powershell
Get-PSDrive

```

or

```powershell
Get-SMBMapping

```

or

```powershell
Get-WmiObject Win32_MappedLogicalDisk

```

or

```powershell
Get-WmiObject -Class Win32_MappedLogicalDisk | select Name, ProviderName

```

or

```powershell
Get-PSDrive -PSProvider FileSystem | Select-Object name, @{n="Root"; e={if ($_.DisplayRoot -eq $null) {$_.Root} else {$_.DisplayRoot}}}
```

