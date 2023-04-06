# The Basics

## Checking OS Version Info
```bash
# To find out kernel info: 
uname -sr

# For other OS info (such as which version of Ubuntu you're on): 
lsb_release -a
# If you only want just the release number (to store to a variable for later use or something)
lsb_release -r -s
# -r flag is "release" and -s is "short format". They can be chained as:
lsb_release -rs

# The more verbose, .ini-style option is: 
cat /etc/os-release
```
You can also try `hostnamectl`, which will reveal both the OS version and the kernel version, as well as info such as hardware vendor and model.  However, it doesn't work on WSL (in my experience).

If you want to see what the update-manager's settings are for performing a version upgrade, you can do so by...  
```bash
cat /etc/update-manager/release-upgrades
```

Much of the above info was found _[HERE](https://www.cyberciti.biz/faq/upgrade-ubuntu-20-04-lts-to-22-04-lts/)_.  
I recommend reading it. 

---

## Updating the System
### Regular Maintenance Updates ("_Upgrades_")
- `sudo apt-get update` 
  - >downloads up-to-date package info from all configured sources and updates the package index.
- `sudo apt-get upgrade` 
  - >installs available upgrades of all packages currently installed on the system. 
  - >installs new packages if required to satisfy dependencies, but existing packages will never be removed.
- After installing software or updates, run `sudo apt-get autoremove` to remove packages that were installed automatically as dependencies but now are no longer needed. This is sort of the inverse of how `apt-get upgrade` auto-installs dependencies.
- `sudo apt-get clean`
  - this cleans the download cache after new packages have been installed.

### Version Upgrades
If, instead of just doing security and maintenance updates, you want to do a full version upgrade, use the following code and follow the prompts. If you DO run the following command, you'll have the option to cancel before any changes are actually made.  
```bash
sudo do-release-upgrade
```

---

## Rebooting the System/Machine
The following info was taken in part from a [page on linuxopsys.com](https://linuxopsys.com/topics/reboot-command)...
If you're unconcerned with other users or any other currently running programs, the fast and effective way to reboot a machine is:
```console
sudo systemctl reboot
```

Alternatively, the Linux equivalent of the PowerShell `shutdown -r -f -t 0` command is as follows. However, use of `systemctl` seems to be more universally compatible in my experience.
```console
sudo shutdown -r now
```

---
---

## Creating and Adding a User to a Group
In Ubuntu 12.04 and later, to add to the sudo (_admin_) group:
```bash
sudo adduser <username> --ingroup sudo
```

---
---

## File and Folder Manipulation

### Make a Folder
To simply make one folder in the current directory
```bash
mkdir some_folder_name
```

The `mkdir` command accepts multiple entries at once, so if you want to create several files in the current directory:
```bash
mkdir folder_1 folder_2 folder_3
```

### Delete a File
```bash
rm file_to_delete
```

---
---

## Command Chaining
- Commands can be chained together: `sudo apt-get update && sudo apt-get upgrade`

## Lists and Simple `for` Loop
### _Space-delimited List_
- The following list of strings are space-delimited.
- It does not matter if it is a simple space or a new line, as long as the strings are framed within parentheses.
- Double quotes are optional, unless you want to include a space within a term in the list.

```sh
MyList=(
    word "another word" whatchamacallit
    "some thing" something foo "bar"
)
```

### _Incrementing a Counter_
Unfortunately, there doesn't seem to be an easy increment operator in Bash. Instead, it must be done by framing the expression in dual parentheses.

```sh
MyCounter=0
((MyCounter = MyCounter + 1)) # Increment the counter
```

### _Putting it all Together_

```sh
MyList=(
    word "another word" whatchamacallit
    "some thing" something foo "bar"
)
MyCounter=0
for i in "${MyList[@]}"
do
    echo "Index $MyCounter: $i"
    ((MyCounter = MyCounter + 1)) # Increment the counter
done
```

# Making a Script Exececutable
Making a `.sh` script executable isn't actually turning it into a compiled script. Rather, you're giving it permission to run. To do so, type:
```bash
chmod +x /path/to/yourscript.sh
```

To then execute the script from the directory where it is located, type:
```bash
./yourscript.sh
```


# Mapping a new Network Drive (Works in WSL)

Lets assume the NAS drive or server is named `server` and the folder you want mapped as a drive is `share`.

First, find the name of your network drive. It should be something like `\\server\share`.

Next, open WSL (or just bash if you're in Ubuntu). Make sure you're in root, if possible, and type the following:
  ```bash
  $ sudo mkdir /mnt/share
  $ sudo mount -t drvfs '\\server\share' /mnt/share
  ```
That's it! 

Above network drive mapping was taken from [this post](https://superuser.com/questions/1128634/how-to-access-mounted-network-drive-on-windows-linux-subsystem/1261563) by user _gman_ from the superuser.com forum. Accessed 2021-02-18.

# Mounting an External Drive (_i.e._, a USB Flash Drive)
Example from [SciVision](https://www.scivision.dev/mount-usb-drives-windows-subsystem-for-linux/)

```bash
echo 'Create a mount point for a flashdrive that in Windows is mounted at E:/'
mkdir /mnt/e

echo 'Now you can mount it'
mount -t drvfs e: /mnt/e

echo 'Now you can transfer a file you have mistakenly placed in your root folder...'
mv /root/myFile.txt /mnt/e/myFile.txt
```

# File Renaming
More of my personal notes can be found [here](https://github.com/iLikeToBeAnonymous/Site_Lookup_from_ID/blob/imgScrapingByURLWithFileName/Bash_download_File_from_URL_and_change_name_on_download.md). I plan on cleaning these up and merging them into this repo.

```bash
mv 'oldFileName.pdf' 'newFileName.pdf'
```

# Using `curl` and `grep` to pull prices from Microcenter.com
```bash
# Refresher course from:
# https://medium.com/@LiliSousa/web-scraping-with-bash-690e4ee7f98d

myUrl="https://www.microcenter.com/search/search_results.aspx?N=&cat=&Ntt="
myUpc="195553093934"
curl ${myUrl}${myUpc} > tmp_file
cat tmp_file | grep "\<span\sitemprop\=\"price\"" | cut -d'>' -f4 | cut -d'<' -f1
```

Or instead of piping to a tmp_file and then reading it, you could pipe the curl result directly to `grep` and `cut`.

```bash
myUrl="https://www.microcenter.com/search/search_results.aspx?N=&cat=&Ntt="
myUpc="195553093934"
curl ${myUrl}${myUpc} | grep "\<span\sitemprop\=\"price\"" | cut -d'>' -f4 | cut -d'<' -f1
```

However, using `cut` seems to require a foreknowledge of the length to cut or a foreknowledge of a consistent character which would serve as a delimiter. 
A more flexible alternative seems to be offered by the **perl** interpreter in bash. I'll pause here to briefly explain how to use perl to extract a match.  
Consider the output of the `lsb_release -ds` command, which results in `Ubuntu 22.04.2 LTS` in this example. If I wanted to just extract the `22.04.2` part, I would pipe the output of the command to the perl interpreter: 
```bash
lsb_release -ds | perl -ln -e "/\d+\.\d+\.\d+/ and print $&;"
```
In the above line, the code after the pipe means the following:
- `perl` — use the perl interpreter
- `-ln` — find matching lines
- `-e` — need to look up what this means, but the code fails without it
- `and print` — matching lines are to be printed. By contrast, to print lines that **DON'T** match, you'd use `or print`
- `$&` — special variable that holds the result of the latest match rather than the whole line.

The above example and explanation was derived from John D. Cook's blog post [Perl as a better grep](https://www.johndcook.com/blog/2018/06/12/perl-as-a-better-grep/).  
Now that we have a rudimentary understanding of regex in perl, let's return to our original exercise. In the following, the two `cut` commands have been replaced by a single perl command, the results of which are then appended to a file named `results.txt`. 
```bash
url="https://www.microcenter.com/search/search_results.aspx?N=&cat=&Ntt="
upc="195553093934"
echo \"${upc}\"','\"$(curl ${url}${upc} | grep "\<span\sitemprop\=\"price\"" | perl -wlne 'print $1 if /(\d+\.\d+)/')\" >> results.txt
```
