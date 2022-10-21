# How to Recover Data from Damaged Drives
## Using `safecopy`
Safecopy is a data recovery tool similar to ddrescue. While ddrescue seems to be more widely used, safecopy has its own usecases wherein it shines.
According to the project's official site (https://safecopy.sourceforge.net/), it is:
> _...a data recovery tool which tries to extract as much data as possible from a problematic (i.e. damaged sectors) source - like floppy drives, hard disk partitions, CDs, tape devices, ..., where other tools like dd would fail due to I/O errors..._

In my personal experience, safecopy is ideal simply for its ease of use.

Safecopy has a variety of complex and detailed commands that can work for advanced users, but using the defaults has worked well for me. The preset mode consists of three stages, each extracting progressively more data from the damaged drive. If the drive isn't damaged, safecopy can be used to make a clone of the drive in a single pass (i.e., by only running stage 1). If one desires to use stage 3 to extract data, stages 1 and 2 must have first been executed.

### _Basic Drive Recovery to Clone_
To perform the full three-stage recoverery of **UNMOUNTED** damaged drive (in this example at `/dev/sdb`) to a bare drive of a larger size (lets say at `/dev/sdc`), the code would be as follows:
```bash
safecopy /dev/sdb /dev/sdc --stage1 && safecopy /dev/sdb /dev/sdc --stage2 && safecopy /dev/sdb /dev/sdc --stage3
```
The double ampersands above are to chain three successive commands together. Optionally, you could perform `--stage1`, shut down the computer, and come back later to perform `--stage2` and `--stage3`. 

### _Basic Drive Recovery to an Image_
This time, we'll copy/recover an unmounted damaged drive (located at `/dev/sdb`) to a `.iso` file located in a storage drive at `/dev/sdc/images`
```bash
safecopy /dev/sdb /dev/sdc/images/myRecoveredImage.iso --stage1 && 
safecopy /dev/sdb /dev/sdc/images/myRecoveredImage.iso --stage2 && 
safecopy /dev/sdb /dev/sdc/images/myRecoveredImage.iso --stage3
```
Making an iso as shown above _does_ work, but it doesn't product an iso that is mountable with Windows Explorer in Win10 (i.e., it's not in ISO 9660 format). 

Make sure [`genisoimage` package] is installed (`sudo apt install genisoimage`). This gives you access to the [`isoinfo`] commands. You can then check info on your iso by:
```bash
isoinfo -J -l -i myRecoveredImage.iso
```
[Gist Tutorial to Edit and Repack an ISO]

Safecopy is a project by [corvuscorax] on SOURCEFORGE. While he is still active as a user, the [safecopy project] hasn't been updated since 2013.

[corvuscorax]: <https://sourceforge.net/u/corvuscorax/profile/>
[safecopy project]: <https://sourceforge.net/projects/safecopy/>
[`genisoimage` package]: <https://packages.debian.org/bullseye/genisoimage>
[`isoinfo`]: <https://manpages.debian.org/bullseye/genisoimage/isoinfo.1.en.html>
[Gist Tutorial to Edit and Repack an ISO]: <https://gist.github.com/AkdM/2cd3766236582ed0263920d42c359e0f>
