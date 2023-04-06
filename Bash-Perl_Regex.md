## Perl regex and capture groups

The following examples will utilize the bash command `lsb_release -d` to produce the input string `Description:    Ubuntu 20.04.6 LTS`. The goal of the subsequent exercises will be to extract the numbers `20.04.6` in one form or another.  
Additionally, please note that the perl flags can all be specified separately (_e.g._, `-n -l -e`) but will be grouped together where possible in the following examples (_e.g._, `-nle`).

You can extract three numbers separated by periods using capture groups in a bash perl command:
```bash
lsb_release -d | perl -nle 'print "$1 $2 $3" if /(\d+)\.(\d+)\.(\d+)/'
```
This will output: 
```bash
20 04 6
```  
The `-e` flag seems to allow the perl line to execute from the shell interpreter rather than having to be run by executing a program, the `-n` flag to run the code against each line of input from STDIN, and the `-l` flag to ensure line ending processing is handled correctly where applicable.

To print each capture group one at a time, you can use the following command:
```bash
lsb_release -d | perl -nle 'print "$_" for /(\d+)\.(\d+)\.(\d+)/g'
```
This will output: 
```bash
20
04
6
```
The `/g` flag at the end of the regular expression tells perl to match all occurrences of the pattern.

Capture groups can also be specifically referenced. For example, you can modify the previous command to only print the second capture group:
```bash
lsb_release -d | perl -nle 'print "$2" if /(\d+)\.(\d+)\.(\d+)/'
```
This will output: `04`. That is because the `$2` variable contains the second capture group.

For even more uses of capture groups, you can save each capture group to a different variable like this:
```bash
lsb_release -d | perl -nle '($a,$b,$c) = /(\d+)\.(\d+)\.(\d+)/; print "$a $b $c"'
```
The `($a,$b,$c)` syntax creates three variables named `$a`, `$b`, and `$c`, and assigns them the values of the first, second, and third capture groups, respectively. They can then be used later on if desired.

## Overview of Perl flags in bash
Per [stackoverflow.com answer](https://stackoverflow.com/a/6302045) by user [paxdiablo](https://stackoverflow.com/users/14860/paxdiablo)
 - `-p`: _Places a printing loop around your command so that it acts on each line of standard input. Used mostly so Perl can beat the pants off Awk in terms of power AND simplicity :-)_
 - `-n`: _Places a non-printing loop around your command._
 - `-e`: _Allows you to provide the program as an argument rather than in a file. You don't want to have to create a script file for _every little Perl one-liner._
 - `-i`: _Modifies your input file in-place (making a backup of the original). Handy to modify files without the {copy, delete-original, rename} process._
 - `-w`: _Activates some warnings. Any good Perl coder will use this._
 - `-d`: _Runs under the Perl debugger. For debugging your Perl code, obviously._
 - `-t`: _Treats certain "tainted" (dubious) code as warnings (proper taint mode will error on this dubious code). Used to beef up Perl security, especially when running code for other users, such as setuid scripts or web stuff._


### Further Reading
- [Understanding perl one-line with p, i, and e switches](https://stackoverflow.com/a/46349069) — answer by user [DavidO](https://stackoverflow.com/users/716443/davido)
- [Perl 5 git repo](https://github.com/Perl/perl5)
- [Perl101.org Command Line Switches](https://perl101.org/command-line-switches.html)

