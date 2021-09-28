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
$DeviceId = ($DeviceId.Split(":").trim()) # splits the resulting string into two lines
$DeviceId = $DeviceId[1] # print the second line (which contains the info you're looking for)
}
```
NOTE: Sometimes, it's just DeviceID, other times, it's WorkplaceDeviceID

The above can be distilled into a slightly messy one-liner:
```PowerShell
DsRegCmd /status | Where-Object {$_ -match ".*DeviceID\b"}
```
...which could also be written as:
```PowerShell
DsRegCmd /status | select-string -pattern ".*DeviceID\b"
```
