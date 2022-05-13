## _Retrieving Network Info from a PC_

The easiest option to remember is the classic `ipconfig /all`, but this has the drawback of producing results that aren't formatted as an object. 
PowerShell of course has some alternative means of doing the same thing, all of which result in a proper object.

This produces quite a few results, and is relatively easy to remember. However, the number of results it produces can be dizzying.
```PowerShell
Get-NetIPAddress
```

Different Options:

```PowerShell
# Look up by name
Get-CimInstance win32_networkadapterconfiguration | Select-Object * | Where-Object Description -like "Realtek*"

# Look up by name, specifying which columns you want
Get-CimInstance win32_networkadapterconfiguration | Select-Object DNSHostName, Caption, Description, MACAddress | Where-Object Description -like "Realtek*"

# Look up all where DNSHostName isn't empty
Get-CimInstance win32_networkadapterconfiguration | Select-Object DNSHostName, Caption, Description, MACAddress | Where-Object DNSHostName -match "\w.*"

# Look up all where MACAddress isn't empty
Get-CimInstance win32_networkadapterconfiguration | Select-Object DNSHostName, Caption, Description, MACAddress | Where-Object MACAddress -match "\w.*"
```

Alternatively, you can use `Get-WmiObject` to retrieve similar results:

```PowerShell
Get-WmiObject win32_networkadapterconfiguration
```

## _Further Reading_
- https://devblogs.microsoft.com/scripting/powertip-use-powershell-to-find-mac-address/
