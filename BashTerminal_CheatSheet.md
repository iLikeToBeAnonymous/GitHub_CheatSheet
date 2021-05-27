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
A more flexible alternative seems to be offered by the **perl** interpreter in bash. In the following, the two `cut` commands have been replaced by a single perl command, the results of which are then appended to a file named `results.txt`. 
```bash
url="https://www.microcenter.com/search/search_results.aspx?N=&cat=&Ntt="
upc="195553093934"
echo \"${upc}\"','\"$(curl ${url}${upc} | grep "\<span\sitemprop\=\"price\"" | perl -wlne 'print $1 if /(\d+\.\d+)/')\" >> results.txt
```
