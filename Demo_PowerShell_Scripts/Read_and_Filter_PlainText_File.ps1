# Read and filter plain text from file

$sourceFilePath = 'demoPlainTextFile.csv'
# $targetWriteOutPath = 'demoPlainTextFile.csv' # Only used for sanitizing the demo csv.

# Store each line of the csv as an string in an array.
$textLines = Get-Content $sourceFilePath

# https://stackoverflow.com/questions/22846596/what-does-percent-do-in-powershell
    # The % starts script blocks after a pipeline
    # More about script blocks can be found here: 
    # https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_script_blocks?view=powershell-7.2
# $textLines | % {$myIndx=0} {"Value:$_ Index:$myIndx"; $myIndx++}

# below works too
#  $myIndx is declared, then $textLines gets piped into a ForEach-Object statement.
#  Note the use of semicolons in the place of line breaks.
# $myIndx = 0; $textLines | ForEach-Object {Write-Output("Index: $myIndx Value $_"); $myIndx++}

$myIndx = 0 # Declare a variable to keep track of an array index
$updateCount = 0 # To track how many matching lines were updated.
Write-Output("`n----------------------------------`n----------------------------------")
$textLines | ForEach-Object {
    if($_ -match ".*UPDATED\!.*"){
        Write-Output("Index: $myIndx Value $_")
        $updateCount++
    }
    $myIndx++ # Increment the index before the next turn of the loop.
}
Write-Output("Total of $updateCount lines showing as 'updated'")

### BELOW IS THE CODE I USED TO SANITIZE THE CSV FILE I USED FOR THIS DEMO ###
<#
$lineArray = ''; $cleanedLine = ''; $giantString = ''
$textLines | ForEach-Object {
    if($_ -match "\'SKIP\!.*|\'UPDATED\!.*"){
        $lineArray = $_.Split(",")
        $cleanedLine = $lineArray[0] + "," + $lineArray[1]
        # Write-Output("Index[$myIndx]: $cleanedLine")
        $myIndx++ # Index is incremented only if the desired line pattern is met.
        $giantString = $giantString + $cleanedLine + ",'ExampleFile" + "$myIndx".PadLeft(3,'0') + '.7z' + "'`n"
    }
    else {
        $giantString = $giantString + $_ + "`n"
    }
}
Write-Output("Total of $myIndx HMI(s) with new backups")
$giantString.Trim() > $targetWriteOutPath
#>
