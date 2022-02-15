# Writing All Streams of a Script to a Log File

In the following example, note three key points:
1) The use of the PowerShell inherent variable `$ErrorActionPreference` to prompt the person running the script to choose what action to take in the event of an error.
2) The use of `&{ function calls go here } *>> logfilename.log` to write ALL streams to a log file. The `>>` APPENDS to the log file, while a single `>` overwrites
   the run log on each run of the script.

```PowerShell
# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_redirection?view=powershell-7.2#examples
# $ErrorActionPreference is a PowerShell variable that affects what gets written to the Error stream.
# It's great for debugging!
$ErrorActionPreference = 'Inquire' # Other valid values are 'Continue', 'SilentlyContinue', 'Stop', and 'Ignore'
Function Test-UserName {
    param(
        [Parameter(Mandatory=$True)][string]$TargetUserName
    )
    try{$targetUserObj = Get-LocalUser -Name $TargetUserName -ErrorAction Stop | Select-Object * }catch{
        Write-Host "`nCOULD NOT FIND USER $TargetUserName`!`nChecking if NTUSERDAT exists for user`: $TargetUserName" -ForegroundColor Red -BackgroundColor Yellow
        if(Test-Path "$env:SystemDrive`\Users`\$TargetUserName"){
            Write-Host "Found profile path for user`: $TargetUserName" -ForegroundColor Cyan -BackgroundColor Black
            $targetUserObj = @{'SID' = @{'Value' = $TargetUserName}}
        }else{
            # https://4sysops.com/archives/stop-or-exit-a-powershell-script-when-it-errors/
            # Write-Error("Username `'$TargetUserName`' is invalid!")
            throw "TERMINATING ERROR! Username `'$TargetUserName`' is invalid!"
            $targetUserObj = $null
        }
    }
    # Return $targetUserObj# Returns back to the main script.
    Write-Output('UserObj Val for: ' + "$TargetUserName")
    Write-Output('User SID: ' + $targetUserObj.SID.Value)
    [gc]::collect()
};

# The function calls are wrapped in braces, preceeded by an ampersand, and then followed
# by an asterisk and the double arrows directing the stream to a log file.
# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_redirection?view=powershell-7.2#example-4-redirect-all-streams-to-a-file
&{

    Write-Output("`n" + 'Running function for user named "Default"')
    Test-UserName -TargetUserName 'Default'
    
    Write-Output("`n" + 'Running function for user named "Administrator"')
    Test-UserName -TargetUserName 'Administrator'
    
    Write-Output("`n" + 'Running function for user named "Defacto"')
    Test-UserName -TargetUserName 'Defacto'
    
    [gc]::collect()
} *>> SCRATCHPAPER.txt
```
