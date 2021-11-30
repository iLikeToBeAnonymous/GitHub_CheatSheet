

# Miscellaneous
## Basic Mapping with `Net Use`
A user's Nextcloud files can be accessed as a mapped network drive: 
[Nextcloud User Manual, Release latest][NxtcldUsrMan], pg 27 (pdf pg 23)

```PowerShell
net use N: 'https://yourBaseNextcloudURL/remote.php/dav/files/yourUserName/' /user:yourUserName yourPassword
```

If you perform this mapping from an Admin PowerShell instance, the mapped drive will be invisible to users.
_Answer by user Denis Cooper on forum post [here][DENISCOOPER]._

As a side-note, a drive with a mapped letter (such as described above) can be removed/unmapped by:
_Source: Codrut Neagu on [digitalcitizen.life][codrut]_
```PowerShell
net use N: /delete
```

After a drive is mapped, files can be successfully copied to the Nextcloud instance via the PowerShell `Copy-Item` command:

```PowerShell
$copyFrom = 'C:\Documents\'
$copyTo = 'N:\Documents\' # "N" is the drive letter used earlier when mapping Nextcloud
$myFileName = 'some_filename_here.txt'
Copy-Item ($copyFrom +"\" + $myFileName) -Destination $copyTo
```
You can even perform rename operations on this invisible mapped drive, such as the example below wherein the file extension is changed to `.ps1`.

```PowerShell
Get-Item ($copyTo +"\" + $myFileName) | Rename-Item -NewName {$_.BaseName + '.ps1'}
```

___
## The `New-PSDrive` Command

_[Official Microsoft Documentation][NewPSDrive]_
The following code assumes that you have already stored the appropriate info in the variables `$yourNxtCldBaseAddr` and `$yourUserName`...
```PowerShell
#Below line prompts for password entry, which gets stored in a SecureString
$cred = Get-Credential -Credential $yourUserName
$cloudAddress = "https://$yourNxtCldBaseAddr/remote.php/dav/files/$yourUserName/"
# Next line is to verify that everything works
(Invoke-WebRequest $cloudAddress -Method Options -Credential $cred).Headers.DAV

# Below doesn't work :-(
$cloudUncFormat = "\\$yourNxtCldBaseAddr@ssl\nextcloud\remote.php\dav"
New-PSDrive -Name "MyCloudBkp" -Root $cloudUncFormat -PSProvider 'FileSystem' -Credential $cred
```

___

## Windows Credential Security and Encryption
According to this informative article on [Jaap Brasser's blog][jaapGetCred], PowerShell scripts can leverage the `Get-Credential` command to prompt the user to enter a password and store it in a SecureString variable.
```PowerShell
$cred = Get-Credential -Credential $myUserName
```

If desired, this variable can be exported to an encrypted file readable only by the Windows user who created it. **NOTE: THIS EXPORTS A PLAIN-TEXT FILE**
```PowerShell
$cred | Export-CliXml -Path "${env:\userprofile}\$WinUserName.xml"
```
...which in turn can later be retrieved for reuse in a later PowerShell instance:
```PowerShell
$Credential = Import-CliXml -Path "${env:\userprofile}\$WinUserName.xml"
Invoke-Command -Computername 'Server01' -Credential $Credential {whoami}
```
The author goes on to say:
>...The file itself is not encrypted... user name will be in plain text and the password will be stored as a secure string which is encrypted. It is... fully reversible by the user, but that is also the purpose of storing credentials for later use.
>For Enterprise environments I would look into Protect-CMSMessage, which allows you to use certificates to secure your sensitive data.

Further Reading:
> - https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/get-credential?view=powershell-7.2
> - https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/protect-cmsmessage?view=powershell-7.2
> - https://docs.microsoft.com/en-us/dotnet/api/system.management.automation.pscredential?view=powershellsdk-7.0.0
___

foo <sup>1</sup>

bar^2^

[//]: # (REFERENCES)
[//]: # (This is an example of the most platform-independent comment format)
[NxtcldUsrMan]: <https://social.technet.microsoft.com/Forums/lync/en-US/a2137d76-e00b-4047-85cc-cfea96040609/drive-mapping-not-showing-up-in-explorer-drive-listing?forum=winserver8gen>
[DENISCOOPER]: <https://social.technet.microsoft.com/Forums/lync/en-US/a2137d76-e00b-4047-85cc-cfea96040609/drive-mapping-not-showing-up-in-explorer-drive-listing?forum=winserver8gen>
[codrut]: <https://www.digitalcitizen.life/how-delete-mapped-drives-windows-7/>
[NewPSDrive]: <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/new-psdrive?view=powershell-7.2>
[jaapGetCred]: <https://www.jaapbrasser.com/quickly-and-securely-storing-your-credentials-powershell/>
