Get-ChildItem "*Invoice*.pdf" | ForEach-Object {
    $_.Name -match "(Invoice.*)--(\d{4}-\d{2}-\d{2}-\d{4})\.pdf";
    $datePortion = $Matches[2];
    $invName = $Matches[1];
    $_ | Rename-Item -NewName {"$datePortion--$invName"+$_.Extension} -Path $Matches[0] -Verbose
}

[System.GC]::Collect() # Garbage collection.