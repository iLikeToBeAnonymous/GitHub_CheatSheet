[System.GC]::Collect() # Lead with manual garbage collection for debugging purposes.
Clear-Host;
# Remove-TypeData;
Update-TypeData;

<#
    .SOURCES
        https://stackoverflow.com/questions/24868273/run-a-c-sharp-cs-file-from-a-powershell-script
        Author: "Knuckle-Dragger"
        Editor: "Lews Therin"

    .DESCRIPTION
        Loads a C# (C Sharp) class from an external .cs file, making it accessible to PowerShell.

    .NOTES
        According to
            https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/add-type?view=powershell-7.2
            "Beginning in PowerShell 7, Add-Type does not compile a type if a type with the same name already exists. Also, 
            Add-Type looks for assemblies in a ref folder under the folder that contains pwsh.dll."
        According to
            https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/add-type?view=powershell-7.2
            Under the "Parameters" entry for "-Name"
            "The type name and namespace must be unique within a session. You can't unload a type or change it. 
            To change the code for a type, you must change the name or start a new PowerShell session. Otherwise, the command fails."
#>



$source = Get-Content -Path "$PSScriptRoot`\CSharp_ExternalClass.cs" -Verbose
# Write-Host $source -ForegroundColor Black -BackgroundColor Green
# $myTypeData = Add-Type -TypeDefinition "$source" -Language CSharp -Verbose
# Add-Type -TypeDefinition "$source" -Language CSharp -Verbose -PassThru > $myTypeData
Add-Type -TypeDefinition "$source" -Verbose # -PassThru | Set-Variable -name 'myTypeData'

# Write-Output($myTypeData)
# Add-Type -TypeDefinition "$source" -Verbose #-Language CSharp -Verbose
[myCSharpDemo] | Get-Member


# Call a static method
[myCSharpDemo.BasicTest]::Add(4, 3)

# Attempt at my own static method...
[myCSharpDemo.BasicTest]::TemplateDemo("Gracie-Lou Freebush")

# Create an instance and call an instance method
$basicTestObject = New-Object myCSharpDemo.BasicTest
$basicTestObject.Multiply(5, 2)


#Get-TypeData
# <#-------------------------------------------#>
# <#                  CLEANUP                  #>
# <#-------------------------------------------#>
[System.GC]::Collect()
# Remove-TypeData -TypeData $myTypeData
Remove-Variable -Name 'source' -Force -Verbose
Write-Output($source) # 
pause