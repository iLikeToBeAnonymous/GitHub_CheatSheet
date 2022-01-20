# Viewing All Local Users

All local users on a machine can be viewed simply by the PowerShell command `Get-LocalUser`. However, this doesn't reveal all the information available from this command. 
To see all info available, type:

```PowerShell
Get-LocalUser | Select *
```

From this, you get a detailed list of info about all users. The list can be customized by again using the "select" statement to specify (as a comma-separated list) 
which fields you want to view. For example, if you want to view the username and SID of all users, type:

```PowerShell
Get-LocalUser | Select Name, SID
```


## Viewing All Enabled User Accounts

Building on this, if you want to filter to only view user accounts that are enabled, you would expand this command (via piping) to be:

```PowerShell
Get-LocalUser | Select Name, SID, Enabled | Where-Object {$_.Enabled -match "True"}
```

Or simply:

```PowerShell
Get-LocalUser | Select-Object * | Where-Object Enabled -eq $true
```

## Viewing Domain Users with Access to a PC
A more verbose version uses the `Get-WmiObject`, which is not limited to listing accounts on the system where the command is run (unlike the `Get-LocalUser` command).
This requires specifying the computer name, so I'll just substitute the environment variable `$env:ComputerName` for this. To replicate the command above, you would type

```PowerShell
Get-WmiObject -ComputerName $env:ComputerName -Class Win32_UserAccount -Filter "LocalAccount = True" | 
  Select Name, Sid, Disabled 
```

If you're having difficulty with some accounts and want to see some slightly different details, modify the above command with to the following.

```PowerShell
Get-WmiObject -ComputerName $env:ComputerName -Class Win32_UserAccount | 
  Select Name, PSComputerName, FullName, Disabled | Where-Object Disabled -eq $false
```

Another useful version is:
```PowerShell
Get-WmiObject -ComputerName $env:ComputerName -Class Win32_UserAccount | 
  Select PSComputerName, Caption, __SERVER, FullName
```

# Editing User Accounts via Admin PowerShell
## Disabling a Local User <small><sup>[source](https://winaero.com/disable-enable-user-account-windows-10/)</sup></small>
(to enable, use "yes" instead of "no")
```PowerShell
net user "someUserName" /active:no
```

## Hiding Specific User Accounts from Login Screen <small><sup>[source](https://winaero.com/how-to-hide-user-accounts-from-the-login-screen-in-windows-10/)</sup></small>
