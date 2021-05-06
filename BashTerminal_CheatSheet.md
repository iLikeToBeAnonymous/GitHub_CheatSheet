# The Basics

- `sudo apt-get update` 
  - >downloads up-to-date package info from all configured sources and updates the package index.
- `sudo apt-get upgrade` 
  - >installs available upgrades of all packages currently installed on the system. 
  - >installs new packages if required to satisfy dependencies, but existing packages will never be removed.
- Commands can be chained together: `sudo apt-get update && sudo apt-get upgrade`
- After installing software or updates, run `sudo apt-get autoremove` to remove packages that were installed automatically as dependencies but now are no longer needed. This is sort of the inverse of how `apt-get upgrade` auto-installs dependencies.
- `sudo apt-get clean`
  - this cleans the download cache after new packages have been installed.


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

# Using `curl` and `grep` to pull prices from Microcenter.com
```javascript
//Refresher course from:
//https://medium.com/@LiliSousa/web-scraping-with-bash-690e4ee7f98d
//(Meant to be run in bash)

myUrl="https://www.microcenter.com/search/search_results.aspx?N=&cat=&Ntt="
myUpc="195553093934"
curl ${myUrl}${myUpc} > tmp_file
cat tmp_file | grep "\<span\sitemprop\=\"price\"" | cut -d'>' -f4 | cut -d'<' -f1


//Or instead of piping to a tmp_file and then reading it...
myUrl="https://www.microcenter.com/search/search_results.aspx?N=&cat=&Ntt="
myUpc="195553093934"
curl ${myUrl}${myUpc} | grep "\<span\sitemprop\=\"price\"" | cut -d'>' -f4 | cut -d'<' -f1
```
