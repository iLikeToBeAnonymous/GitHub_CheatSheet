## Simple Switch with Multiple Matching Conditions
See StackOverflow question [What's the Powershell syntax for multiple values in a switch statement?](https://stackoverflow.com/questions/3493731/whats-the-powershell-syntax-for-multiple-values-in-a-switch-statement)

In my testing, I've noticed the following:
1) It seems very important to always wrap a single condition in parentheses.
2) Following a case with a `break` sometimes makes things work more smoothly, but isn't always necessary.

In the example below, notice that because some cases can be triggered by several values, those values are stored as an array, and the `-contains` flag checks the 
value against them.

```PowerShell
$foo = '1','a','2','b','c','d','5','e','f','g','y','h'
$foo | ForEach-Object {
    switch ($_) {
        ('y') {Write-Output("$_ is sometimes considered a vowel"); break;}
        {@('a','e','i','o','u') -contains $_} {Write-Output("$_ is a vowel"); break;}
        {@('1','2','3','4','5','6','7','8','9','0') -contains $_}{Write-Output("$_ is a number"); break;}
        Default {Write-Output("$_ is a consonant"); break;}
    }
}
```

Notice in the example below that the first case has two acceptable values.

```PowerShell
$foo = (('Yes HUZZAH niet. Nope No Y') -split ' ').trim()
$foo | ForEach-Object {
    switch ($_.ToLower()) {
        {'y', 'yes' -eq $_} {Write-Output("($_)`t" + 'You entered "Yes"')}
        ('huzzah') {Write-Output("($_)`t" + 'Calm down...')}
        ("no") {Write-Output("($_)`t" + 'You entered "No"')}
        default {Write-Output("($_)`t" + "What part of `"Yes or No`" don't you understand?")}
    }
}
```

This example uses a wildcard so anything that starts with the letters "no" triggers the case.
```PowerShell
$foo = (('Yes HUZZAH niet. Nope No Y') -split ' ').trim()
$foo | ForEach-Object {
    switch -wildcard ($_.ToLower()) {
        {'y', 'yes' -eq $_} {Write-Output("($_)`t" + 'You entered "Yes"')}
        ("no*") {Write-Output("($_)`t" + 'You entered "No"')}
        default {Write-Output("($_)`t" + "What part of `"Yes or No`" don't you understand?")}
    }
}
```

----
----

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
 
