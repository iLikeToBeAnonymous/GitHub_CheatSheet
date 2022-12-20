<#
 .NOTES
 .ALTERNATIVES
 https://products.aspose.com/words/python-net/merge/
#>




function Get-HtmlBody {
    param(
        [Parameter(Mandatory=$True)]$htmlFile,
        [Parameter(Mandatory=$True)]$outfile,
        [Parameter(Mandatory=$True)][bool]$writeHead,
        [Parameter(Mandatory=$True)][bool]$writeFoot
        )
        
        $openingTagFound = $false; $closingTagFound = $false;
        
        Get-Content -Path $htmlFile -Encoding UTF8 | ForEach-Object {
            # encounter with opening body tag
            if((!$openingTagFound) -and ($_ -match "(?<linePrefix>.*)<body>(?<lineSuffix>.*)")){
                if(!$writeHead){Write-Output($Matches.lineSuffix) >> $outfile;}
                else{Write-Output($_ >> $outfile)}
            $openingTagFound = $true;
            }
            # encounter with closing body tag
            elseif(($_ -match "(?<linePrefix>.*)</body>.*")){
                $closingTagFound = $true; 
                if(!$writeFoot){Write-Output($Matches.linePrefix) >> $outfile;}
                else {Write-Output($_ >> $outfile)}
            }
            # opening tag has already been found, but not closing tag, so write all lines
            elseif(($openingTagFound) -and (!$closingTagFound)){
                Write-Output($_) >> $outfile;
            }
            # body tag not yet found and $writeHead is true
            elseif((!$openingTagFound) -and ($writeHead)){
                Write-Output($_) >> $outfile;
            }
            #
            elseif(($closingTagFound) -and ($writeFoot)){
                Write-Output($_) >> $outfile;
            }
    };
};

<########## END FUNCTIONS ############>

<# BEGIN MAIN SCRIPT #>
$outputFileName = 'allCombined.html';

# CHECK IF THE OUTFILE EXISTS. IF NOT, CREATE IT.
if(!(Test-Path -path $outputFileName)){New-Item -name $outputFileName};
# new-item -name $outputFileName;

$outfile = Get-ItemPropertyValue -path $outputFileName -name 'fullname';

$rootFolder = (Get-Location).Path;

$fileList = Get-ChildItem -Path $rootFolder | Where-Object {$_.Name -match "\d{20}-.*stage\d\.html"};
$iterationLimit = $fileList.Count -1;
$loopCount = 0;

# Get-ChildItem -Path $rootFolder | ForEach-Object {
#     if($_.Name -match "\d{20}-.*stage\d\.html"){
#         Get-HtmlBody -htmlFile $_.FullName -outfile $outfile -writeHead $false -writeFoot $false
#     }
# };
$fileList | ForEach-Object {
    $donorFile = $_.FullName;
    switch ($loopCount) {
        (0) { Get-HtmlBody -htmlFile $donorFile -outfile $outfile -writeHead $true -writeFoot $false }
        ($iterationLimit) { Get-HtmlBody -htmlFile $donorFile -outfile $outfile -writeHead $false -writeFoot $true }
        Default {Get-HtmlBody -htmlFile $donorFile -outfile $outfile -writeHead $false -writeFoot $false}
    }
    $loopCount = $loopCount + 1;
};

<# END MAIN SCRIPT #>
