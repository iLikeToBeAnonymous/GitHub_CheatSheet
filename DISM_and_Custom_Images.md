## Craft Computing's [Windows Deployment Services Tutorial](https://www.youtube.com/watch?v=ARDjb2UV3Nw)

#### _Timestamps_

- [Pulling `.wim`'s from the iso file](https://youtu.be/ARDjb2UV3Nw?t=437)
- [`Boot.wim` vs `Installer.wim` Explained](https://youtu.be/ARDjb2UV3Nw?t=526)

----
## Installing Windows via Custom Image [(trishtech.com)](https://www.trishtech.com/2021/10/how-to-clean-install-windows-11-using-dism-on-any-hdd-ssd/) <br>
Finding the index of your install version within the `.wim` file:

```PowerShell
$wimFilePath = 'Win10_21H1_install.wim'
DISM /Get-ImageInfo /ImageFile:$wimFilePath # Note the index number of the edition you want to install
```

```cmd
DISM /apply-image /imagefile:D:\Win10Pro-21H2-HMIvs_2022-01-10-1457.wim /index:1 /Unattend:D:\unattend.xml /applydir:C: 
```

https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/capture-and-apply-windows-using-a-single-wim?view=windows-11
https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/deploy-a-custom-image?view=windows-11

----
## Editing a `.wim` File after Creation
It seems that a .wim file can only be "mounted" to edit it. This is **NOT** equivalent to mounting an .iso file in that the .wim
is essentially extracted to an _empty_ folder you've specified. 
Consider the following:

```PowerShell
$wimFilePath = 'J:\Win10Pro-21H2-HMIvs.wim'
$mountDir = 'F:\WinImages\mount' # MUST BE AN EMPTY DIRECTORY!
DISM /Mount-Wim /wimfile:$wimFilePath /Index:1 /MountDir:$mountDir
<#  DO NOT CLOSE THIS WINDOW UNTIL YOU'VE UNMOUNTED THE WIM FILE!!!  #>
```
All of the files from the wim will be extracted to the empty directory. You may then add or remove files from it.
Once you've completed your edits, you can either `/Commit` or `/Discard` your edits.

```PowerShell
DISM /Unmount-Wim /MountDir:$mountDir /Commit # To save your changes
# OR...
DISM /Unmount-Wim /MountDir:$mountDir /Discard # To discard your changes
```

If `/Commit` is selected, the unpacked directory will be repacked into the .wim file.

----
## Repairing a Win Install via `.wim` File

[Windows Central](https://www.windowscentral.com/how-use-dism-command-line-utility-repair-windows-10-image)
[Some fancy DISM Repairs](https://www.wintips.org/fix-dism-0x800f081f-error-in-windows-10-8/)

If the `/Cleanup-Image` and `/RestoreHealth` flags are used with DISM, the component store is automatically analyzed and cleaned.

From an Administrator PowerShell instance:
```PowerShell
# Check the component store for broken or corrupted hard links
DISM /Online /Cleanup-Image /AnalyzeComponentStore

# Clean broken hard links from the component store (WinSxS cleanup)
Dism /Online /Cleanup-Image /StartComponentCleanup # "Source" CANNOT be specified with this command

# Now you can begin restoring from a wim image...
$wimFilePath = 'J:\Win10Pro-21H2-HMIvs.wim'
# "Source CAN be specified with "RestoreHealth"
# Additionally, note that the index is specified AND that "WIM" is specified after "Source" and before the path.
DISM /Online /Cleanup-Image /RestoreHealth /Source:WIM:J:\Win10Pro-21H2-HMIvs.wim:1
```

According to [answer by JW0914](https://superuser.com/questions/1330365/how-will-dism-online-cleanup-image-restorehealth-affect-my-current-configurat),
only **AFTER** `Dism` has successfully run should `SFC /ScanNow` be run. This post is exceptional and should be read in more detail. The claims by user JW0914
are explicitly in this quote from [Microsoft Support](https://web.archive.org/web/20220217043413/https://support.microsoft.com/en-us/topic/use-the-system-file-checker-tool-to-repair-missing-or-corrupted-system-files-79aa86cb-ca52-166a-92a3-966e85d4094e):
> _If you are running Windows 10, Windows 8.1 or Windows 8, first run the inbox Deployment Image Servicing and Management (DISM) tool 
> **prior** to running the System File Checker (SFC)._ 

### _More about How DISM was Used_
- [Analyze Component Store](https://win10.guru/dism-analyzecomponentstore-and-startcomponentcleanup/)

## Making an Image

```PowerShell
PS C:\WINDOWS\system32> cd 'F:\CloneZilla_Images'
PS F:\CloneZilla_Images> ls


    Directory: F:\CloneZilla_Images


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
da----        2022-01-10     09:12                2022-01-10-14-img
da----        2021-08-04     04:47                HMI_GENERIC_IMAGE--2021-08-04-0840


PS F:\CloneZilla_Images> dism /Capture-Image /ImageFile:Win10-Pro-21H1-HMIvs_2022-01-10-1457.wim /CaptureDir:E:\ /Name:'Win 10 Pro 21H1 HMIvs 2022-01-10-1502'

Deployment Image Servicing and Management tool
Version: 10.0.19041.844

Saving image
[==========================100.0%==========================]
The operation completed successfully.
```
