# Using PowerShell to Delete Leftover Services

### _Verify the Service Name is Correct_
If you're querying with a valid service name, the following string should return useful results.
```PowerShell
sc.exe query "Sage 50 Smart Posting 2022
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
