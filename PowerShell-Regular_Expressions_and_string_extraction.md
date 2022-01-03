# Subtext Extraction via RegEx in PowerShell

**Note:** The best explanation of Regular Expressions in PowerShell can be found on [this blog post](https://powershellexplained.com/2017-07-31-Powershell-regex-regular-expression/#matches)
by Kevin Marquette

Keep in mind that if you're trying to use regex to extract from an existing string, it is probably wise to attempt to use an "if" statement to avoid errors. <br>
In the following example, the version number without any additional info will be extracted from the string `$vsNmbrFull`:
```PowerShell
$vsNmbrFull = 'v2.34.1.windows.1'

if($vsNmbrFull -match "v(\d+\.\d+\.\d+)\.(.*)"){
    $vsNmbrOnly = $Matches[1]
    $vsSuffix = $Matches[2]
}

Write-Output('$Matches[0]: ' + $Matches[0]) # Yields "$Matches[0]: v2.34.1.windows.1"
Write-Output('$Matches[1]: ' + $Matches[1]) # Yields "$Matches[1]: 2.34.1"
Write-Output('$vsNmbrOnly: ' + $vsNmbrOnly) # Yields "$vsNmbrOnly: 2.34.1"
Write-Output('$vsSuffix: ' + $vsSuffix)     # Yields "$vsSuffix: windows.1"
```

Alternatively, you can assign names to matches by preceeding the parenthetical match with a question mark and a name framed in arrows:
```PowerShell
$vsNmbrFull = 'v2.34.1.windows.1'

if($vsNmbrFull -match "v(?<baseVsNo>\d+\.\d+\.\d+)(?<vsSuffix>.*)"){
    Write-Output("Base vs No: $($Matches.baseVsNo)`nSuffix: $($Matches.vsSuffix)")    
}
```
