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

## _Ping Failing_
Typically, when a machine is rejecting ping requests, it is due to firewall rules. 
Interestingly enough, a machine can still respond to a ping request if the firewall rules `Core Networking Diagnostics - ICMP Echo Request (ICMPv6-In)` are both disabled. 

The critical firewall rule can be found and fixed as follows:
1) Open _Windows Defender Firewall with Advanced Security_
2) Go to "Inbound Rules" and sort by the "Protocol" column, then scroll down to the group of rules that start with `ICMP`.
3) In the "Actions/Filter by Group" (vertical menu at right side), choose "File and Printer Sharing" (yes, that's the correct group for this)
4) Click the "Name" column to sort by name.
5) Because the non-responsive computer was on a domain and the network only utilized IPv4, I looked for and found the rule named
   `File and Printer Sharing (Echo Request - ICMPv4-In)` and switched it to "Enabled."
6) That's it!

That was all that I needed to do to enable pinging on the computer.

References:
- Answer by user "Run5k" at [superuser.com](https://superuser.com/questions/1137912/ping-to-windows-10-not-working-if-file-and-printer-sharing-is-turned-off)
- This article is useful for command-line methods of enabling this: [How to Allow Pings (ICMP Echo Requests) Through Your Windows Firewall](https://www.howtogeek.com/howto/windows-vista/allow-pings-icmp-echo-request-through-your-windows-vista-firewall/)

## _Further Reading_
- https://devblogs.microsoft.com/scripting/powertip-use-powershell-to-find-mac-address/
