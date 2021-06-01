## Viewing All Local Users

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
