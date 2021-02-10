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
