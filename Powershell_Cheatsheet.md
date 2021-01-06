### Powershell basic stuff

___

#### How to execute a powershell script (if you get the `... someScriptName.ps1 cannot be loaded because running scripts is disabled on this system` error).
- Open an instance of Powershell in the script location. It doesn't SEEM to have to be opened as admin for this to work...
- In that instance, run your script by typing the following:

``` powershell
  powershell -executionpolicy bypass -File .\yourScriptNameHere.ps1
```
