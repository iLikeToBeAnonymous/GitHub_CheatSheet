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
