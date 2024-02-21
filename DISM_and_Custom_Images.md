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

To delete a partition on a drive that already has Windows installed:
```cmd
@REM within DiskPart select the partition to delete, then...
del part override
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
### _Repairing a Win Install via `.wim` File_

[Windows Central](https://www.windowscentral.com/how-use-dism-command-line-utility-repair-windows-10-image)
[Some fancy DISM Repairs](https://www.wintips.org/fix-dism-0x800f081f-error-in-windows-10-8/)

- [Analyze Component Store](https://win10.guru/dism-analyzecomponentstore-and-startcomponentcleanup/)
  - If the `/Cleanup-Image` and `/RestoreHealth` flags are used with DISM, the component store is automatically analyzed and cleaned. <br>
- [How DISM Cleanup-Image and RestoreHealth Affect Current Configuration](https://superuser.com/questions/1330365/how-will-dism-online-cleanup-image-restorehealth-affect-my-current-configurat)
  - `SFC` assumes the Component Store is **not** corrupted.
  - `sfc /verifyonly` will scan for problems without performing any action, allowing the operator to make that decision.
- [How to Run SFC from WinPE](https://www.wintips.org/how-to-run-sfc-offline-system-file-checker-tool/)
  - `sfc /ScanNow /OffBootDir=C:\ /OffWinDir=C:\Windows`


From an Administrator PowerShell instance:
```PowerShell
# Check the component store for broken or corrupted hard links
DISM /Online /Cleanup-Image /AnalyzeComponentStore

# Clean broken hard links from the component store (WinSxS cleanup)
DISM /Online /Cleanup-Image /StartComponentCleanup # "Source" CANNOT be specified with this command

# Now you can begin restoring from a wim image...
$wimFilePath = 'J:\Win10Pro-21H2-HMIvs.wim'
# "Source CAN be specified with "RestoreHealth"
# Additionally, note that the index is specified AND that "WIM" is specified after "Source" and before the path.
DISM /Online /Cleanup-Image /RestoreHealth /Source:WIM:J:\Win10Pro-21H2-HMIvs.wim:1
```
### _Repairing from within WinPE/BootPE_
Alternatively, `DISM` can be run from Boot PE via the `/Image` flag instead of the `/Online` flag.

```PowerShell
DISM /Image:C:\ /Cleanup-Image /RestoreHealth
```
However, running the above by itself typically results in the warning "_The scratch directory size might be insufficient to perform this operation_." 
In this case, you will manually need to specify a scratch directory ([_source_)](https://www.wintips.org/fix-dism-error-the-scratch-directory-size-might-be-insufficient-to-perform-this-operation/)). 
What seems to work for me is to modify the above code to the following:

```PowerShell
mkdir C:\Scratch # Assuming that directory doesn't already exist
# then...
DISM /Image:C:\ /Cleanup-Image /RestoreHealth /ScratchDir:C:\Scratch
```
Some manufacturers customize their Windows installations and have a dedicated recovery partition or drive. Clues to this can be found by:

```PowerShell
DiskPart
# then after you've entered the DiskPart utility...
list volume
# This lists drive letters and volume labels
```
For this example, let's assume that `DiskPart` confirmed `C` as the "OS" volume and `F` as the "Image" volume.  
The PowerShell DISM command would then be:

```PowerShell
DISM /Image:C:\ /Cleanup-Image /RestoreHealth /Source:F:\ /ScratchDir:C:\Scratch
```

### _Additional Notes_

It is worth noting that occasionally, `DISM` will fail due to "pending operations." While I personally have not had luck with either of these commands, 
there are two commands intended to fix this issue:

```PowerShell
# To view pending actions that may be causing issues
DISM /Image:C:\ /Get-PendingActions

# To clear pending actions
DISM /Image:C:\ /Cleanup-Image /RevertPendingActions
```

According to [answer by JW0914](https://superuser.com/questions/1330365/how-will-dism-online-cleanup-image-restorehealth-affect-my-current-configurat),
only **AFTER** `Dism` has successfully run should `SFC /ScanNow` be run. This post is exceptional and should be read in more detail. The claims by user JW0914
are explicitly in this quote from [Microsoft Support](https://web.archive.org/web/20220217043413/https://support.microsoft.com/en-us/topic/use-the-system-file-checker-tool-to-repair-missing-or-corrupted-system-files-79aa86cb-ca52-166a-92a3-966e85d4094e):
> _If you are running Windows 10, Windows 8.1 or Windows 8, first run the inbox Deployment Image Servicing and Management (DISM) tool 
> **prior** to running the System File Checker (SFC)._ 

### _Repairing from within a Windows Instance_
As a side note, if you're already in a Windows installation (_i.e._, an "Online" instance), the following is a one-liner that does all of the following (although not necessarily as thoroughly as performing this while referencing a source `.wim`.

```PowerShell
DISM /Online /Cleanup-Image /RestoreHealth; SFC /ScanNow;
# OR IF YOU KNOW THE COMPONENT STORE NEEDS CLEANUP:
DISM /Online /Cleanup-Image /StartComponentCleanup; DISM /Online /Cleanup-Image /RestoreHealth; SFC /ScanNow;
```

---
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
