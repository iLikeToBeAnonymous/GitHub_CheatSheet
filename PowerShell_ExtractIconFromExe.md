# Extract an Icon from an Executable via PowerShell
The following script is actually a custom PowerShell Module, which needs to be "installed" for it to work correctly (to my understanding). 

It was copied from a [blog post](https://jdhitsolutions.com/blog/powershell/7931/extracting-icons-with-powershell/) by "The Lonely Administrator."

I have not been able to get this to work outside of installing it, and I haven't yet attempted to install it. More research is required on my part.

Alternatively, I might try to convert it into a function. The inspiration for the aforementioned blog post (which was cited therein) can be 
found [Spiceworks post](https://community.spiceworks.com/topic/592770-extract-icon-from-exe-powershell) by user [Duffney](https://community.spiceworks.com/people/duffney), who created it as a function.

```PowerShell
# Extract-Icon.ps1
# requires -version 5.1

# inspired by https://community.spiceworks.com/topic/592770-extract-icon-from-exe-powershell

[CmdletBinding(SupportsShouldProcess)]
Param(
    [Parameter(Position = 0, Mandatory,HelpMessage = "Specify the path to the file.")]
    [ValidateScript({Test-Path $_})]
    [string]$Path,

    [Parameter(HelpMessage = "Specify the folder to save the file.")]
    [ValidateScript({Test-Path $_})]
    [string]$Destination = ".",

    [parameter(HelpMessage = "Specify an alternate base name for the new image file. Otherwise, the source name will be used.")]
    [ValidateNotNullOrEmpty()]
    [string]$Name,

    [Parameter(HelpMessage = "What format do you want to use? The default is png.")]
    [ValidateSet("ico","bmp","png","jpg","gif")]
    [string]$Format = "png"
    )

    Write-Verbose "Starting $($MyInvocation.MyCommand)"

    Try {
        Add-Type -AssemblyName System.Drawing -ErrorAction Stop
    }
    Catch {
        Write-Warning "Failed to import System.Drawing"
        Throw $_
    }

    Switch ($format) {
        "ico" {$ImageFormat = "icon"}
        "bmp" {$ImageFormat = "Bmp"}
        "png" {$ImageFormat = "Png"}
        "jpg" {$ImageFormat = "Jpeg"}
        "gif" {$ImageFormat = "Gif"}
    }

    $file = Get-Item $path
    Write-Verbose "Processing $($file.fullname)"
    #convert destination to file system path
    $Destination = Convert-Path -path $Destination

    if ($Name) {
        $base = $Name
    }
    else {
        $base = $file.BaseName
    }

    #construct the image file name
    $out = Join-Path -Path $Destination -ChildPath "$base.$format"

    Write-Verbose "Extracting $ImageFormat image to $out"
    $ico =  [System.Drawing.Icon]::ExtractAssociatedIcon($file.FullName)

    if ($ico) {
        #WhatIf (target, action)
        if ($PSCmdlet.ShouldProcess($out, "Extract icon")) {
            $ico.ToBitmap().Save($Out,$Imageformat)
            Get-Item -path $out
        }
    }
    else {
        #this should probably never get called
        Write-Warning "No associated icon image found in $($file.fullname)"
    }

    Write-Verbose "Ending $($MyInvocation.MyCommand)"
```
