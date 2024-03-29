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

## Simple Step to add a domain user to the Administrators group:[<sup>1</sup>](#1)
Note: Make sure you run PowerShell "As Administrator".
In PowerShell...

```PowerShell
Add-LocalGroupMember -Group 'Administrators' -Member $env:USERDOMAIN\<username>
```

You can then verify that the user was added successfully by running `Get-LocalGroupMember -Group 'Administrators'` and confirming that the user has been added to the group.  

If only temporary access is needed, you may revoke the local admin status by simply reversing the command:

```PowerShell
Remove-LocalGroupMember -Group 'Administrators' -Member $env:USERDOMAIN\<username>
```

See also: PowerShell commandlet documentation for [`Add-LocalGroupMember`](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.localaccounts/add-localgroupmember), [`Get-LocalGroupMember`](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.localaccounts/get-localgroupmember), and [`Remove-LocalGroupMember`](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.localaccounts/remove-localgroupmember).  

---

## Changing Location of `NTUSER.DAT` for a User

```PowerShell
#Get-LocalUser | Select-Object Name, SID, Enabled | Where-Object Name -Match "Admin*|User" | Sort-Object SID
# HKey_Users only shows users that are actively logged onto the machine. To view all accounts, look at
#  the registry location specified by $profilePaths below:
$profilePaths = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\'
$userInfo = Get-LocalUser | Select-Object Name, SID, Enabled | Where-Object Name -Match "User"
$userInfo.Name
$userInfo.SID.Value
# Write-Output($('C:\Users\'+$userInfo.Name)) # debugging
# $userSID = (Get-LocalUser | Select-Object Name, SID, Enabled | Where-Object Name -Match "User*").SID.Value
<#
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList
#>
Set-ItemProperty -Path $($profilePaths + $userInfo.SID.Value) -Name 'ProfileImagePath' -Value $('C:\Users\'+$userInfo.Name)
<#
New-PSDrive -PSProvider Registry -Root 'HKEY_USERS' -Name 'HKU'

reg load HKU\UserHive 'C:\Users\User.DESKTOP-N5AA7K3\NTUSER.DAT'

reg unload HKU\UserHive

Remove-PSDrive -Name HKU
#>
```

## Changing a Local User Password
### _Secure Strings_
By Variable (less secure) <sup>[*](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/convertto-securestring?view=powershell-7.2#example-3--convert-a-plain-text-string-to-a-secure-string)</sup>:
```PowerShell
$myNewPassword = 'Password123'
get-localuser -name 'JohnSmith' | set-localuser -password (ConvertTo-SecureString -String $myNewPassword -AsPlainText -Force)
```

By User Input (better!) <sup>[*](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.localaccounts/set-localuser?view=powershell-5.1#examples)</sup>:
```PowerShell
# User types a password, which is obfuscated from view while typing
$myNewPassword = Read-Host -AsSecureString
$UserAccount = Get-LocalUser -Name "JohnSmith"
$UserAccount | Set-LocalUser -Password $myNewPassword
```

## Disabling a Local User <small><sup>[source](https://winaero.com/disable-enable-user-account-windows-10/)</sup></small>
(to enable, use "yes" instead of "no")
```PowerShell
net user "someUserName" /active:no
```

## Hiding Specific User Accounts from Login Screen <small><sup>[source](https://winaero.com/how-to-hide-user-accounts-from-the-login-screen-in-windows-10/)</sup></small>

___
### References:
<a id="1">[1]</a> 
Mohamed Jawad, [https://serverfault.com/questions/120229/adding-a-user-to-the-local-administrator-group-using-powershell](https://serverfault.com/questions/120229/adding-a-user-to-the-local-administrator-group-using-powershell), Accessed 2021-02-17
