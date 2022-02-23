# Arrays vs ArrayLists
PowerShell arrays are quick and easy to implement (e.g., `$myArray = 'alpha', 2, 'beta', 'gamma'`) and are able to store multiple data types. However, 
they suffer the significant drawback of not being able to directly be expanded, instead require being copied to a new list with the any new members added at 
the end or the beginning (e.g., `$myArray = $myArray + 'delta'` sticks the string "delta" at the end of `$myArray`, but does so be completely overwriting the original array.

By contrast, an _ArrayList_ is directly extensible via the `$myArrayList.Add('yourValueHere')`. However, declaring it is slightly more complicated:
```PowerShell
$myArrayList = New-Object -TypeName 'System.Collections.ArrayList'
# or
$myArrayList = [System.Collections.ArrayList]::new()
```

## _ArrayList Example Use_
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

## _Further Reading on ArrayLists:_
- https://www.spguides.com/powershell-arraylist/
