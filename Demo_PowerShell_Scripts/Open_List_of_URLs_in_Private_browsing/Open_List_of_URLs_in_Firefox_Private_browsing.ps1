<#
    .DESCRIPTION
        Opens an array of URLs in an incognito Firefox window. If a private browsing window is not already open, one is opened.
        Each url is opened as a new tab within the private browsing window.
    .NOTES
        Further Reading:
            https://www.openallurls.com/
            https://superuser.com/questions/1576302/start-chrome-with-a-url-with-options-incognito-mode-and-maximized-tab-in-batch
            https://stackoverflow.com/questions/57027695/open-multiple-urls-with-firefox-in-private-mode-using-powershell
            Validating a URL:
                https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/validating-a-url
        
        Needed to do:
            I would like to turn this into a function and have the function check if the variable passed is an array or a delimted string
            to parse into an array.
)
#>
<# 
$urlList1 = @(
    'https://www.google.com/search?q=make+windows+deployment+image+from+existing+installation',
    'https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/deploy-a-custom-image?view=windows-11',
    'https://www.google.com/search?q=sysprep+a+wim',
    'https://askme4tech.com/sysprep-and-capture-windows-10-dism',
    'https://community.spiceworks.com/topic/2224394-sysprep-win-pe',
    'https://thesolving.com/server-room/when-and-how-to-use-sysprep/',
    'https://www.youtube.com/watch?v=Bl1gNZCek4c',
    'https://answers.microsoft.com/en-us/windows/forum/all/i-can-not-activate-windows-10-after-installing-a/345b2095-0d83-4450-bf49-b8476794028c',
    'https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/deploy-a-custom-image?view=windows-11',
    'https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/dism-image-management-command-line-options-s14?view=windows-11#capture-customimage',
    'https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/dism-configuration-list-and-wimscriptini-files-winnext?view=windows-11',
    'https://docs.microsoft.com/en-us/windows/deployment/planning/windows-10-deprecated-features',
    'https://github.com/FOGProject/fog-client/blob/master/Modules/HostnameChanger/Windows/WinActivation.cs',
    'https://en.wikipedia.org/wiki/Installation_(computer_programs)'
)

$urlList2 = @(
    'https://adamtheautomator.com/powershell-get-computer-name/',
    'https://git-scm.com/book/en/v2/Git-Tools-Submodules',
    'https://github.com/PowerShell/GPRegistryPolicy',
    'https://www.atlassian.com/git/tutorials/git-submodule',
    'https://stackoverflow.com/questions/1260748/how-do-i-remove-a-submodule',
    'https://stackoverflow.com/questions/1260748/how-do-i-remove-a-submodule/36593218#36593218',
    'https://stackoverflow.com/questions/4089430/how-can-i-determine-the-url-that-a-local-git-repository-was-originally-cloned-fr',
    'https://git-scm.com/docs/git-mv',
    'https://git-scm.com/docs/gitignore'
)
$myText = '####### List for First Window #######'
$urlList1 | ForEach-Object {$myText += ("`n" + $_)}
$myText += ("`n`n" + '####### List for Second Window #######')
$urlList2 | ForEach-Object {$myText += ("`n" + $_)}

Set-Content -Path 'urlList.txt' -Value $myText 
#>
$filePath = $PSScriptRoot + '\' + 'urlList.txt'
$rawFileContent = Get-Content $filePath


# $sysPath = $env:Path.Split(',')
# Start-Process firefox -ArgumentList @('-private-window' , 'https://youtube.com/')
$rawFileContent | ForEach-Object{
    # Verify that the url is valid. This also weeds out empty lines and comments.
    # https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/validating-a-url
    $validated = $_ -as [System.URI]
    # ($_ -as [System.URI]).AbsoluteURI -ne $null
    if($validated.AbsoluteURI -ne $null){

        Start-Process firefox -ArgumentList @('-private-window' , $validated.AbsoluteURI)
        Start-Sleep -Milliseconds 250 # Just to make things a little smoother
    }
    # Start-Process firefox -ArgumentList @('-private-window' , $_)
}
