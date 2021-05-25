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
