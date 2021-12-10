## Reading .ini and Parsing Contents

Below code is a simple function that:
1) ...accepts a path to a source .ini file (as the `$srcFile` variable)
2) ...loads the plain-text contents of that file into memory via the `Get-Content` command
3) ...uses a switch statement to automatically traverse the individual lines of the loaded file, checking each to see if it matches one of the 
    corresponding regular expressions
4) ...then lastly extracts sub matches and neatly prints them to the screen.

If a line of the loaded text file matches one of the regular expressions of the switch statement, the `matches` variable is automatically 
created by PowerShell. This variable is actually an array of strings, the first index of which (index 0) is actually the entirety of the matching string.
The second index (index 1) is the match for the first capturing group, index 2 is the second capturing group, etc.

Considering the explanation thus far, look at the regular expression `"(.+?)\s*=\s*(.*)"` (used in the first switch option below). If it were fed the matching string
"_UserName = John Doe_" (standard _.ini_ format):
 - `$matches[0]` would be the complete string "_UserName = John Doe_"
 - `$matches[1]` would be the first capturing group (the `(.+?)`), and would equal "_UserName_"
 - `$matches[2]` would be the second capturing group (the `(.*)`), and would equal "_John Doe_"

```PowerShell
function Parse-myIni{
    Param([parameter(Mandatory=$true)]$srcFile)

    Get-Content $srcFile | ForEach-Object {
        # declare a switch statement that uses a regex matching technique
        switch -Regex ($_){
            "(.+?)\s*=\s*(.*)"{ # Match an ini key
                Write-Output("`tKey: $($matches[1])`tValue: $($matches[2])`tZeroth ele: $($matches[0])")
            }
            "^\[(.+)\]"{ # Match an ini section 
                Write-Output('Section: ' + $matches[1])
            }
            "^(;.*)$"{ # Match an ini comment
                Write-Output("`tComment: " + $matches[1])
            }
        }
    }
}
```

___
## Links for Further Reading

 - [_Microsoft Docs PowerShell Scripting_, "about_Switch"](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_switch?view=powershell-7.2)
 - [_Adam the Automator_, "Understanding the PowerShell Switch Statement"](https://adamtheautomator.com/powershell-switch/#Using_the_-RegEx_Parameter)
 - [_ArcaneCode.com_, "Fun with the PowerShell Switch Parameter"](https://arcanecode.com/2021/09/20/fun-with-the-powershell-switch-parameter/)
 
