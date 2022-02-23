[System.GC]::Collect() # I lead with this just to make sure any changes are cleaned up before running this again.
<#
    .SOURCES
        https://dandraka.com/2018/11/12/powershell-how-do-you-add-inline-c/
    .DESCRIPTION
        Example of in-lined C# (C-Sharp)
        Author: Jim Andrakakis, November 2018
    .NOTES
        DOES NOT WORK IN POWERSHELL 5.1 ("Desktop") !!!
        Works fine in PowerShell 7.1 core
#>

#
# Here goes the C# code:
Add-Type -Language CSharp @"
using System; 
namespace MyInlineCSharp {
    public static class Magician 
    {
        private static string spell = ""; 
        public static void DoMagic(string magicSpell) 
        {
            spell = magicSpell; 
        }
        public static string GetMagicSpells() 
        {
            return "Wingardium Leviosa..." + spell; 
        }
        public static string WriteHello(string aFriend)
        {   
            // This seems to work in PowerShell 7.2.1, but not in 5.1
            return ($"Hello {aFriend}");
        }
    }
}
"@;



 
# And here's how to call it:
[MyInlineCSharp.Magician]::DoMagic("Expelliarmus") # Passes a string value to the "DoMagic" method, which is in turn assigned to a private variable for the class.
$spell = [MyInlineCSharp.Magician]::GetMagicSpells() # Returns a modified string containing the string passed to the class in the above line.
[MyInlineCSharp.Magician]::DoMagic("Expel your arms") # Changes the value of the internal "spell" variable.
$spell2 = [MyInlineCSharp.Magician]::GetMagicSpells() # Retrieves the "spell" again to show that it is changed.

$myMessage = [MyInlineCSharp.Magician]::WriteHello("Jimbo") # Passes a string to a method, which incorporates it in a template string and returns the completed string.
 
Write-Output($spell);
Write-Output($spell2);
Write-Output($myMessage)


# <#-------------------------------------------#>
# <#                  CLEANUP                  #>
# <#-------------------------------------------#>
[System.GC]::Collect()