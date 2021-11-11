# Installing Python
## On Windows
### _Ninite_
Installing via Ninite is nice (and relatively quick), but it doesn't automatically add the Python folder or the Python Scripts folder to the system path (meaning the `Path` system environment variable if you are installing for all users).

However, this is relatively easily overcome by adding them manually.

### _Windows Store_
Supposedly adds to the path correctly on install, but there are quite of few posts from people stating this hasn't worked for them.

### _Chocolatey_
Arguably the best way to install Python on Windows. Automatically adds to the system path. Useful for maintaining and updating as well.
See this [post/answer](https://stackoverflow.com/questions/57421669/question-about-pip-using-python-from-windows-store) by stackoverflow user Weberth Lins for more details.


## Checking if Python is in your path
The system path is accessible in PowerShell via `$env:path`. However, this returns a single string in which all the values are separated with semicolons. To split this into a list, use the _.Split_ function with a semicolon as the delimeter: `$env:path.Split(";")`. However, the resulting array can be quite large, so to filter it down to only show entries for Python, you can use the following:
```PowerShell
$env:path.Split(";") | where {$_ -like '*Python*'} #(the "like" string is not case-sensitive)
```

Instead of a `-like` flag, you could use a `match` flag instead:
```PowerShell
$env:path.Split(";") | where {$_ -match '.*[P|p]ython.*'} #(Also not case-sensitive, so the [P|p] isn't necessary)
```

---

## Running Your File

### First, make sure that everything you need for compiling is already installed. If you follow the next steps, you'll be able to compile C and C++ code as well as others..

1) Make sure that g++/gcc compiler is installed on your system. If you're in WSL (Windows Subsystem for Linux), you'll probably need to run `sudo apt-get install g++` for this to work. 
2) The _slightly_ bloated solution is to instead run `sudo apt-get install build-essential`, which will install EVERYTHING, including the `make` command...

For further reading, try the link [here](https://linuxconfig.org/command-make-not-found-on-ubuntu-20-04-focal-fossa).

### Run a .py script without compiling
First, you must have a Python SDK installed on your machine. Some distros come with Python pre-installed, but you may need to upgrade.

Second, you must open a terminal/command line. The easiest way is to use the right-click/context menu to open PowerShell or WSL in the script's location.

For PowerShell, run the script by:

```PowerShell
python my_script.py
```

For WSL (on which I'm running Python 3.8.5 at the time of writing this):

```bash
python3 my_script.py
```

## Compiling into an Executable

### Easy Way — pyinstaller
See this great tutorial here: [How to Convert Python Files into Executables](https://www.thepythoncode.com/article/building-python-files-into-stand-alone-executables-using-pyinstaller)
