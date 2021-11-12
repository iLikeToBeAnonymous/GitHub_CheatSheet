# Export All Drivers to a Folder
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

[//]: # (Copied from "untitled Document.md" from dillinger.io:
         > These are reference links used in the body of this note and get stripped out when the markdown processor does its job. 
         > There is no need to format nicely because it shouldn't be seen. 
         > Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)

[tenforums.com]: <https://www.tenforums.com/windows-updates-activation/181971-last-product-key-id-xxxxx-xxxxx-xxxxx-aaoem-you-entered-cant-2.html?s=87ac7c435d88a546bf3cd30bcb8c4d25>   
