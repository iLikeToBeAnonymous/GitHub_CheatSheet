# Registry Editing via PowerShell

## Introduction

According to Microsoft:
> _The registry is a hierarchical database... The data is structured in a tree format. Each node in the tree is called a key. 
> Each key can contain both subkeys and data entries called values. Sometimes, the presence of a key is all the data that an 
> application requires; other times, an application opens a key and uses the values associated with the key..._ <br>
> A registry tree can be 512 levels deep. You can create up to 32 levels at a time through a single registry API call.... <br>
> &emsp;&mdash; docs.microsoft.com, ["Structure of the Registry"](https://docs.microsoft.com/en-us/windows/win32/sysinfo/structure-of-the-registry)

The "data entries" mentioned above can be though of as being the "file" within a "folder." According to further Microsoft documentation:
> _...The actual data is stored in the registry entries, the lowest level element in the registry. The entries are like files... <br>
> Each entry consists of the entry name, its Data Types in the Registry, ...and a field known as the value of the registry entry._ <br>
> &emsp;&mdash; docs.microsoft.com, ["Overview of the Windows Registry"](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2003/cc781906(v=ws.10))

The above reference is highly-recommended further reading, giving a distinct explanation of the registry hierarchy of the sub*tree*, key, sub*key*, entry structure.

----
----

## Adding a New Registry Entry

### _New-Item and New-ItemProperty_
The `New-Item` command is able to do more than create new files and folders. It is also able to create new subkeys ("folders") in Windows Registry.
A registry entry (an "item" within a registry "folder") can subsequently be created via the `New-ItemProperty` command.

```PowerShell
# Create a registry subkey within the "Intranet" subkey
New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\Nla\Cache\Intranet\myDemoKey'

# Now add a new registry entry (a named registry "item") to that key
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\Nla\Cache\Intranet\myDemoKey' -Name 'someRegItem' -Value 777
```

**NOTE:** If the second command were to be executed by itself, the new registry value would not be created because the key to contain it does not already exist.

---

## Checking if a Registry Entry Exists

