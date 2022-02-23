# Arrays vs ArrayLists
PowerShell arrays are quick and easy to implement (e.g., `$myArray = 'alpha', 2, 'beta', 'gamma'`) and are able to store multiple data types. However, 
they suffer the significant drawback of not being able to directly be expanded, instead require being copied to a new list with the any new members added at 
the end or the beginning (e.g., `$myArray = $myArray + 'delta'` sticks the string "delta" at the end of `$myArray`, but does so be completely overwriting the original array.

By contrast, an _ArrayList_ is directly extensible via the `$myArrayList.Add('yourValueHere')`. However, declaring it is slightly more complicated:
```PowerShell
$myArrayList = New-Object -TypeName 'System.Collections.ArrayList'
# or the supposedly faster declaration...
$myArrayList = [System.Collections.ArrayList]::new() 
# or if ArrayLists are being declared in multiple places in the code, you can shorten them
# by using the namespace:
using namespace System.Collections # place at the top of your script
# ...then for each instanciation...
$myArrayList = [ArrayList]::new() 
```

## _ArrayList Example Use_
### Using the `New-Object` declaration
```PowerShell
# Instanciate an empty ArrayList
$myArrayList = New-Object -TypeName 'System.Collections.ArrayList'
# Then add some elements to it:
$myArrayList.Add('alpha'); $myArrayList.Add('beta'); $myArrayList.Add('gamma');
# You can then easily add additional members as shown above, or easily check for a value:
$myArrayList.Contains('beta') # Returns True
# But can't use regular fuzzy matches the way you'd expect:
$myArrayList.Contains("*eta*") # Returns False
```

### Using `C#` Notation
```PowerShell
using namespace System.Collections

$myArrayList = [ArrayList]::new() 
# Then add some elements to it:
$myArrayList.Add('alpha'); $myArrayList.Add('beta'); $myArrayList.Add('gamma');
# You can then easily add additional members as shown above, or easily check for a value:
$myArrayList.Contains('beta') # Returns True
# But can't use regular fuzzy matches the way you'd expect:
$myArrayList.Contains("*eta*") # Returns False

Write-Output($myArrayList)
```



## _Further Reading on ArrayLists:_
- https://www.spguides.com/powershell-arraylist/
- https://docs.microsoft.com/en-us/dotnet/api/system.collections.arraylist?view=net-6.0
- [Post by Reddit user Ta11ow](https://www.reddit.com/r/PowerShell/comments/9ldoi8/systemcollectionsgenericlistpsobject/)
