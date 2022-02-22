$ErrorActionPreference = 'Inquire' # Other valid values are 'Continue', 'SilentlyContinue', 'Stop', and 'Ignore'

<#
    .NOTES
        The two text files used by this script were generated via the following two lines of code on two different PC's:
            Set-Location C:\Users\Owner\Downloads
            reg query 'hklm' /v "*InduSoft*" /s > RegQuery_Indusoft.txt
#>
<#-------------------------------------------#>
<#           CREATING VARIABLES              #>
<#-------------------------------------------#>
Clear-Host # Just clear the console of anything previous...
# Create a variable list
New-Variable -Name 'myVarList' -Scope Script -Verbose

# Populate it with an array of variable names
$myVarList = 'line', 'myHash', 'firstFilePath', 'secondFilePath'
# Traverse the array, creating each item into a variable
$myVarList | ForEach-Object {New-Variable -Name $_ -Scope Script -Verbose}

<# # DEBUGGING: Show details about $myVarList
Get-Variable -Name 'myVarList' | Select-Object * -Verbose #>
# MAKE AN EMPTY HASH TABLE
$myHash = @{}

$firstFilePath = 'F:\HMI_Utilities\Indusoft_Config\RegQuery_Indusoft_INTERIM-IMAGE.txt'
$secondFilePath = 'F:\HMI_Utilities\Indusoft_Config\RegQuery_Indusoft.txt'

function Format-Json {
    <#
    .SYNOPSIS
        Prettifies JSON output.
    .DESCRIPTION
        Reformats a JSON string so the output looks better than what ConvertTo-Json outputs.
        Post/Answer by user "Theo" at https://stackoverflow.com/questions/56322993/proper-formating-of-json-using-powershell
    .PARAMETER Json
        Required: [string] The JSON text to prettify.
    .PARAMETER Minify
        Optional: Returns the json string compressed.
    .PARAMETER Indentation
        Optional: The number of spaces (1..1024) to use for indentation. Defaults to 4.
    .PARAMETER AsArray
        Optional: If set, the output will be in the form of a string array, otherwise a single string is output.
    .EXAMPLE
        $json | ConvertTo-Json  | Format-Json -Indentation 2
    #>
    [CmdletBinding(DefaultParameterSetName = 'Prettify')]
    Param(
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]$Json,

        [Parameter(ParameterSetName = 'Minify')]
        [switch]$Minify,

        [Parameter(ParameterSetName = 'Prettify')]
        [ValidateRange(1, 1024)]
        [int]$Indentation = 4,

        [Parameter(ParameterSetName = 'Prettify')]
        [switch]$AsArray
    )

    if ($PSCmdlet.ParameterSetName -eq 'Minify') {
        return ($Json | ConvertFrom-Json) | ConvertTo-Json -Depth 100 -Compress
    }

    # If the input JSON text has been created with ConvertTo-Json -Compress
    # then we first need to reconvert it without compression
    if ($Json -notmatch '\r?\n') {
        $Json = ($Json | ConvertFrom-Json) | ConvertTo-Json -Depth 100
    }

    $indent = 0
    $regexUnlessQuoted = '(?=([^"]*"[^"]*")*[^"]*$)'

    $result = $Json -split '\r?\n' |
        ForEach-Object {
            # If the line contains a ] or } character, 
            # we need to decrement the indentation level unless it is inside quotes.
            if ($_ -match "[}\]]$regexUnlessQuoted") {
                $indent = [Math]::Max($indent - $Indentation, 0)
            }

            # Replace all colon-space combinations by ": " unless it is inside quotes.
            $line = (' ' * $indent) + ($_.TrimStart() -replace ":\s+$regexUnlessQuoted", ': ')

            # If the line contains a [ or { character, 
            # we need to increment the indentation level unless it is inside quotes.
            if ($_ -match "[\{\[]$regexUnlessQuoted") {
                $indent += $Indentation
            }

            $line
        }

    if ($AsArray) { return $result }
    return $result -Join [Environment]::NewLine
}

Function CompareFiles{
    Param( 
        [Parameter(Mandatory)][string]$filePath,
        [Parameter(Mandatory = $false,HelpMessage = 'Incumbent delimiter for data within each line.')][string]$intralinearDelim
     )
    $rawFileContent = Get-Content $filePath #-Verbose} # LOAD FILE CONTENTS
    $fileName = ($filePath.Split('\'))[-1] # The -1 returns the last item of the array, which still works if only a filename is provided.
    $fileName -match  "(\.[A-Z0-9]{3,4}$)" # Retrieves the file extension from the filename
    $Extension = $Matches[1]
    $fileName = $fileName.Replace($Extension,'').Trim()

    # Parse each line
    # $LineNmbr = 0; $rawFileContent | ForEach-Object {Write-Output('Line ' + "$LineNmbr".PadLeft(3,'0') + ' ==> ' + $_); $LineNmbr++}
    $LineNmbr = 0; $rawFileContent | ForEach-Object {
        # if($_ -like "HKEY*"){
        #   # Make new registry parent
        #}
        if($_.Length -gt 0){ # Make sure the line isn't blank
            $line = $_.Replace('    ',"`t") # Swap the quad-spaces for a tab char
            $line = $line.Split("`t") # Split the string into an array delimited by tabs
            # # # Write-Output("$LineNmbr".PadLeft(3,'0') + ' ==> ' + $line[0] + "`n`tLine Length `: $($line.Length)")
            # # # Write-Output("$LineNmbr".PadLeft(3,'0') + ' ==> ' + $line[0] + "`n`tObj Length `: $($_.Length)")
            $lineKey = $line[0]
            $LineNmbrKey = "$($fileName)_LnNmbr"
            $LineValsKey = "$($fileName)_Vals"
            if(-not($myHash.ContainsKey($lineKey))){ # If the first term of the line doesn't already exist, create a new key
                # # # $myHash.Add($lineKey,@{'Ctr' = 1; 'ArrayLen' = $line.Length; 'ArrayVals_1' = $line[1..$line.Count]})
                # # $myHash.Add($lineKey,@{'Ctr' = 1; 'ArrayLen' = $line.Length; 'ArrayVals_1' = (($line[1..$line.Count]) -join ', ')})
                # # In the line below, remember that the terminal val of an array is index -1.
                # $myHash.Add($lineKey,@{'Ctr' = 1; $LineNmbrKey = "$LineNmbr"; $LineValsKey = (($line[1..-1]) -join ', ')})
                $myHash.Add($lineKey, @{
                    'Ctr' = 1; 
                    $fileName = @{
                        'LineNmbr' = "$LineNmbr"; 
                        'LineValue' = ($line[1..($line.Count - 1)]) -join ', '
                    }
                })
            }else{
                $myHash[$lineKey].Ctr = $myHash[$lineKey].Ctr + 1 # Increments Ctr by 1
                # $myHash[$lineKey].Add("Len$($myHash[$lineKey].Ctr)", $line.Length) # Adds a new length key for the new instance Ctr
                # # $myHash[$lineKey].Add("ArrayVals_$($myHash[$lineKey].Ctr)", $line[1..$line.Count])
                # $myHash[$lineKey].Add("ArrayVals_$($myHash[$lineKey].Ctr)", (($line[1..$line.Count]) -join ', '))
                if($myHash.$lineKey.ContainsKey($LineNmbrKey)){
                    $myHash.$lineKey.$LineNmbrKey = $myHash.$lineKey.$LineNmbrKey + ", $LineNmbr"
                }else{
                    $myHash.$lineKey.Add($LineNmbrKey, "$LineNmbr")
                }

                if($myHash.$lineKey.ContainsKey($fileName)){
                    $myHash.$lineKey.$fileName.LineNmbr += ", $LineNmbr"
                }else{
                    $myHash.$lineKey.Add($fileName, @{
                        'LineNmbr' = "$LineNmbr"; 
                        'LineValue' = ($line[1..($line.Count - 1)]) -join ', '
                    })
                }
            }
        }
        $LineNmbr++
    }
}

# Write-Output('Val of $myCtr after the function is complete: '+"$myCtr")
CompareFiles -filePath $firstFilePath
CompareFiles -filePath $secondFilePath


# $myHash | ForEach-Object {if($_.Value -gt 1){Write-Output("Val: $($_.Value)`t$($_.Name)")}}
# $myHash | Format-Table -AutoSize
# $myHash | ConvertTo-Json -Depth 7 | Format-Json |  Set-Content "$PSScriptRoot\Output.json" -Encoding utf8
$filtered = @{} # Generate a new empty hashtable into which the matching entries from $myHash get stored
$myHash.Keys | ForEach-Object {
    if($myHash["$_"]['Ctr'] -lt 2){$filtered.Add("$_",$myHash["$_"])}
}
$filtered | ConvertTo-Json -Depth 7 | Format-Json |  Set-Content "$PSScriptRoot\OutputLessThan2.json" -Encoding utf8
<# $myHash.Keys | ForEach-Object {
    if($myHash[$_].Ctr -gt 1){
        # Write-Output("$_")
        # Write-Output($myHash[$_])
        Write-Output("Ctr: $($myHash.$_.Ctr)`tArrayVals_1: $($myHash.$_.ArrayVals_1)`tValue: $_")
    }
} #>
<#-------------------------------------------#>
<#                  CLEANUP                  #>
<#-------------------------------------------#>
# Traverse the array of variable names, deleting each
$myVarList | ForEach-Object {Remove-Variable -Name $_ -Scope Script -Force -Verbose}
# Delete the variable name array itself.
Remove-Variable -Name 'myVarList' -Scope Script -Force -Verbose
# Trigger garbage cleanup.
[System.GC]::Collect()
