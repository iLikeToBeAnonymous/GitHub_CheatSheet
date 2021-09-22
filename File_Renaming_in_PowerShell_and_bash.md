## Renaming in bash
To just rename a file in bash (without moving it) you'd still use the "mv" command. Note that there are no spaces, and the file names include their extensions. 
```bash
mv 'oldFileName.pdf' 'newFileName.pdf'
```
A more robust way is to use the bash `rename` command.
_Sourced from: https://www.howtogeek.com/423214/how-to-use-the-rename-command-on-linux/_
The "rename" command is not part of a the standard Linux distro, so you must install it:
```bash
sudo apt-get install rename
```
Then you can use a rename using a regular expression (assuming you've navigated to the correct directory beforehand):
```bash
find -regextype posix-extended -regex '^.*test\.log\.[0-9]{4}-[0-9]{2}-[0-9]{2}\.*'
```
