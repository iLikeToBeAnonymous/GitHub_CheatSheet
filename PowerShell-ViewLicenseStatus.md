# Viewing Windows License Info

## Raw Licensing Info
_From [IDERA community blog](https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/check-windows-license-status)_

A bunch of somewhat obtuse info can be viewed by:
```PowerShell
Get-WmiObject SoftwareLicensingService
```
A fancier table view can be accessed with:
```PowerShell
Get-WmiObject SoftwareLicensingProduct | Select-Object -Property Description, LicenseStatus | Out-GridView
```

After some fiddling, I found that the thing that gives more useful information is actually the [SoftwareLicensingProduct class](https://docs.microsoft.com/en-us/previous-versions/windows/desktop/sppwmi/softwarelicensingproduct), which can be accessed in raw form simply with `Get-WmiObject SoftwareLicensingProduct`. However, this takes quite a while and involves much scrolling... I recycled the `Out-GridView` from earlier and came up with the following (be warned, PowerShell will appear to freeze for a few seconds before any info appears):

```PowerShell
 Get-WmiObject SoftwareLicensingProduct | Select-Object -Property ID, Name,  Description | Out-GridView
```

## Viewing AzureAD Device ID
_From [post](https://superuser.com/questions/1212477/determine-azure-ad-device-id) by user Alkum_
As a script:
```PowerShell
$DsregCmdStatus = dsregcmd /status
if($DsregCmdStatus -match "DeviceId")
{
$DeviceId = $DsregCmdStatus -match "DeviceID"
$DeviceId = ($DeviceId.Split(":").trim())
$DeviceId = $DeviceId[1]
}
```
Or hypothetically as a one-liner:
```PowerShell
$DsregCmdStatus = dsregcmd /status | -match "DeviceID"
```
