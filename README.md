# GitHub_CheatSheet
Just a GitHub cheat-sheet because I'm forgetful (or sometimes very tired) when I'm working.

[Great Github workflow example](https://www.atlassian.com/git/tutorials/comparing-workflows/feature-branch-workflow)

[Good github quick reference](https://rogerdudler.github.io/git-guide/)

[Using syntax highlighting in markdown syntax](https://github.com/github/linguist/blob/master/lib/linguist/languages.yml)  


If you need to create a local copy of a project from Github, all you need to do is open bash in the desired target folder, then type:

  ```gitattributes
  git clone the_url_of_the_repository
  ```
  
If instead of a remote URL, you wish to clone from one local repo to a new local location, you can open a terminal in the new target
and use the source repo's local path instead of a URL. In the example below, the local source is on my `f` drive in my `Projects` folder.
This command was executed in WSL, but if should work the same in Linux if you remove the `/mnt` part.

```gitattributes
git clone '/mnt/f/Projects/<repo_name>/.git'
```

If you were working on a branch from a different machine and need to make sure you're up-to-date with the version in the repository:

```gitattributes
git checkout nameOfTheBranch
```
Or if you already know you're on the correct branch:
```gitattributes
git checkout
```

- If you already have a project downloaded and want to make a new branch, first make sure your local version matches the master branch. If you're not already on the main branch, it'll switch to the main when you do this.

  ```gitattributes
  git checkout master
  git fetch origin
  git reset --hard origin/master
  ```
  - Alternatively:
  - `git fetch --all` lets your local copy know the changes done in the remote repo of the branch you're on.
  - `git branch -r` shows all remote branches instead of just the branches on your local machine.
  - `git status` lets you know if you're up-to-date or ahead of the remote repo
  - You can then use `git pull` to update the local copy to match the remote repo

- Now make a new (local) branch. You don't have to create a branch ahead of time on Github.

  ```gitattributes
  git checkout -b new-feature
  ```
- Once you've made changes and want to push them to the branch on Github, you must first prep for the push.

  ```gitattributes
  git status
  git add <some-file>
  git commit
  ```
  
  <dl>
    <dt>At this stage, you'll be prompted to enter a description for the changes you've made. Type your description, then</dt>
      <dd>"Ctrl+O" to say it's finalized</dd>
      <dd>"Enter"</dd>
      <dd>"Ctrl+X" to exit the shell text editor and continue on your merry way</dd>
  </dl>

- Once your changes have been committed, push those changes to a branch on Github.

  ```gitattributes
  git push -u origin new-feature
  ```
  
If you already have a multi-branch local repository and want to push all of its changes at once to GitHub, you can easily do so via:

```gitattributes
git push --all origin
```
___

### Using `commit --amend`
If you accidentally left off a minor change or detail in your commit and don't want to make an entirely new commit for something like a line comment or
a extra note in the commit message, you can simply amend the commit. First, make sure that you're still on the correct branch, then stage the changes
and type:

```gitattributes
git commit --amend
```

If you've already pushed the commit to your upstream repo, you will have to force the amendment. However, doing so requires extreme caution! This article on [Atlassian](https://www.atlassian.com/git/tutorials/rewriting-history) says it best:
> _Amended commits are actually entirely new commits and the previous commit will no longer be on your current branch. This has the same consequences as resetting a public snapshot. Avoid amending a commit that other developers have based their work on. This is a confusing situation for developers to be in and it’s complicated to recover from._

If you're sure you _DO_ want to force-push the amend commit, make sure you specify the branch name in the push command:
```gitattributes
git push -f origin YourBranchNameHere
```
___

## Git Prune and Cleaning Up
Read up on this more to figure out exactly what it does and why you want to do it.
Use of `git prune` should only be used within the context of `git gc` [Atlassian — Git prune](https://www.atlassian.com/git/tutorials/git-prune).  
Info on `git gc`: [Atlassian — Git gc](https://www.atlassian.com/git/tutorials/git-gc)
An emdash: &emdash;

```gitattributes
git prune remote origin
```

___

### Undoing Changes
If you want to undo the changes to a specific file:
```gitattributes
git restore myfile.name
```

On the other hand, if you want a "nuke 'em all" solution to revert to the last commit:
```gitattributes
git reset HEAD --hard #HEAD is optional
```
Alternatively, you just want to overwrite a specific branch with the upstream version you can do so. Be advised that the commands WILL IGNORE untracked files
in your local copy. As a precaution, the first command you should enter is a `checkout` to ensure you're actually on the branch you want to overwrite with the origin version. The command sequence is as follows:
```gitattributes
git checkout branchName_to_overwrite
git fetch -u origin
git reset --hard origin/branchName_to_overwrite
```

Afterwards, if you want to further clean things up by removing files not under version control (probably a good idea), git has a command for this, but **use it with caution!**

The `git clean` command removes files not under version control, and only those that are "seen" by git. In other words, new files that show up as "untracked files" under `git status` would get removed, but files specified in the `.gitignore` file would be left ontouched. Before doing any form of `git clean`, you should do a dry run:

```gitattributes
git clean --dry-run
```

If the only files that show up there are the ones you want removed, the go ahead and re-run the command, omitting the `--dry-run` part.
> Further reading: [git-clean documentation](https://git-scm.com/docs/git-clean)

>If you need more control over how git-clean works, you can always use the `-i` suffix, which is an interactive mode. You can read about it on [Atlassian's page](https://www.atlassian.com/git/tutorials/undoing-changes/git-clean)
___

### Renaming Files (the Right Way)
If you rename a file via the file gui, Git doesn't seem to recognize it as a "rename" action, instead attributing it as a deletion of a file and the creation of a new one.

For Git to record the action as a rename, you must rename the file via the terminal. In bash, type the following, being sure to include the file extensions if present:

```gitattributes
git mv old_filename.js new_filename.js
```

If you have complicated file names (or filenames with spaces, which you shouldn't have anyway), you can copy the file names from the file explorer and assign them to variables if you'd prefer (although you could also just copy them and paste them into the terminal)

```gitattributes
old_filename="current_filename_to_change.py"
new_filename="better_filename.py"
git mv $old_filename $new_filename
```
