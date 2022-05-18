## Export All Drivers to a Folder
According to post on [tenforums.com] by user _hsehestedt_:
> The following code exports all the drivers from your system to the folder `C:\MyDrivers`. <br>
> **You can use another location if you like**. 

```PowerShell
pnputil /export-driver * C:\MyDrivers
```

User _hsehestedt_ goes on to explain how to subsequently reinstall all of those drivers (such as in the event you've had to do a clean Windows installation)
> ...NOTE: This command is assuming that the thumb drive is `D:` and that the drivers are in the folder called `MyDrivers`. <br>
> Change the drive letter and path if you need to do so. <br>
> Code:

```Powershell
pnputil /add-driver D:\MyDrivers\*.inf /subdirs /install
```
---
## Export Drivers for a Specific Device
### _THIS SECTION IS A FRAGMENT, AND DOES NOT SHOW THE FULL PROCESS!_
The PowerShell native [`Get-PnpDevice`] command can be used to quickly retrieve information for Plug-n-Play devices by their friendly name. For example:

```PowerShell
Get-PnpDevice -FriendlyName 'WD SES Device' | Select-Object *
```

This can then be paired with `pnputil`'s ability to export a specified driver as follows:
J:\Drivers_for_Server
```PowerShell
pnputil /enum-devices /instanceid "$((Get-PnpDevice -FriendlyName 'WD SES Device').InstanceId)"
# which yields...
Microsoft PnP Utility

Instance ID:                USBSTOR\Other&Ven_WD&Prod_SES_Device&Rev_4005\57583431444338394B324A30&1
Device Description:         WD SES Device
Class Name:                 WDC_SAM
Class GUID:                 {8496e87e-c0a1-4102-9d8d-bd9a9b8b07a9}
Manufacturer Name:          Western Digital Technologies
Status:                     Started
Driver Name:                oem5.inf

# The Driver Name from above can then be used to look up more details
Get-WindowsDriver -Online -Driver oem5.inf

# Or used directly to export the drivers:
pnputil /export-driver oem5.inf  'E:\My_Driver_Backup'
```

---
## Further Reading
https://docs.microsoft.com/en-us/powershell/module/dism/get-windowsdriver?view=windowsserver2022-ps


[//]: # (Copied from "untitled Document.md" from dillinger.io:
         > These are reference links used in the body of this note and get stripped out when the markdown processor does its job. 
         > There is no need to format nicely because it shouldn't be seen. 
         > Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)

[tenforums.com]: <https://www.tenforums.com/windows-updates-activation/181971-last-product-key-id-xxxxx-xxxxx-xxxxx-aaoem-you-entered-cant-2.html?s=87ac7c435d88a546bf3cd30bcb8c4d25>   

[`Get-PnpDevice`]: <https://docs.microsoft.com/en-us/powershell/module/pnpdevice/get-pnpdevice?view=windowsserver2022-ps>
