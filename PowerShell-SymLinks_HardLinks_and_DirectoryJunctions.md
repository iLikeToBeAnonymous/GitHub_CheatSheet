# Symbolic Links
UNC paths (paths to network locations that start with `\\` such as `\\MyDomainShare\data\`) require *Symbolic Links*. Hard Links and Directory Junctions will not work with UNC paths.
However, symbolic links work just fine if the desired result is to have a shortcut to a location that makes it appear as if the target directory is actually located in the same spot as link location.
For example, imagine you have the long network share path: `\\MyDomainShare\data\MainFolder\SomeSubfolder\AnotherSubfolder\Folder_I_Use_Often\`. 
Now lets presume you would like to make *Folder_I_Use_Often* appear as if it is in your *Documents* folder. To do so, you could use the following PowerShell command:
```PowerShell
$whereIWantALink = 'C:\Users\YourUsername\Documents';
$nameForMyLink = 'IAmSymLink';
$realLocation = '\\MyDomainShare\data\MainFolder\SomeSubfolder\AnotherSubfolder\Folder_I_Use_Often\'
New-Item -ItemType SymbolicLink -Path "$whereIWantALink\$nameForMyLink" -Target $realLocation
```
Executing the above code (the variable names were just used because the paths are long) would result in a sym link named "IAmSymLink" appearing in your documents folder. Navigating inside that link
from within file explorer would reveal the contents of the folder at the UNC path defined for the variable `$realLocation`, but its path in your file explorer would show up as
the path `C:\Users\YourUsername\Documents\IAmSymLink`.  
As an additional note, opening a file via the folder in the sym link will make its path appear to the opening program as being via the sym link, NOT its real location.

**WARNING!!!** ATTEMPTING TO COPY/PASTE THE SYMLINK TO A DIFFERENT LOCATION WILL RESULT IN COPYING THE ENTIRE CONTENTS OF THE SYMLINK JUST LIKE A REGULAR FOLDER!

### Other Behavior:
Fortunately, *deleting* a symlink seems to merely delete the link, not delete the real folder or its contents.

# Further Reading
- [winaero.com]
- [Guide to Creating Symbolic Links (aka Symlinks) on Windows][howtogeek.com]
- [Distributed Link Tracking and Object Identifiers] *This may not be relevant as it seems to rely on some deep system and NTFS features*

---------------------------------------------------------------------------------------
[winaero.com]: <https://winaero.com/create-symbolic-link-windows-10-powershell/> 'Create Symbolic Link in Windows 10 with PowerShell'
[howtogeek.com]: <https://www.howtogeek.com/16226/complete-guide-to-symbolic-links-symlinks-on-windows-or-linux/> "The Complete Guide to Creating Symbolic Links (aka Symlinks) on Windows"
[Distributed Link Tracking and Object Identifiers]: <https://learn.microsoft.com/en-us/windows/win32/fileio/distributed-link-tracking-and-object-identifiers> 'Distributed Link Tracking and Object Identifiers'
