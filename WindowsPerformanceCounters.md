# Rebuilding Windows Performance Counters

I have successfully used the following code on both Windows 10 Pro 21H2 and on Windows Server 2016 v1607.

Source: https://learn.microsoft.com/en-us/troubleshoot/windows-server/performance/manually-rebuild-performance-counters
It is strongly recommended to read the above link _IN DETAIL_ if the below steps don't work.

In PowerShell admin instance:

```PowerShell
# If perf counters are in error state, the following line throws an error
# When done on the server, this completed successfully the first time.
Set-Location 'C:\Windows\System32'; lodctr /R;

# After running the following line, the counters can be rebuilt successfully
# in the System32 folder.
Set-Location 'C:\Windows\SysWOW64'; lodctr /R;

# Resync the counters with Windows Management Instrumentation (WMI)
WINMGMT.EXE /RESYNCPERF

# Stop and restart the Performance Logs and Alerts service.
Get-Service -Name "pla" | Restart-Service -Verbose

# Stop and restart the Windows Management Instrumentation service.
# This may take a few minutes to complete if done on a server.
Get-Service -Name "winmgmt" | Restart-Service -Force -Verbose
```
