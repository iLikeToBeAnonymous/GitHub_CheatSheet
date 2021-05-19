# GitHub_CheatSheet
Just a GitHub cheat-sheet because I'm forgetful (or sometimes very tired) when I'm working.

[Great Github workflow example](https://www.atlassian.com/git/tutorials/comparing-workflows/feature-branch-workflow)

[Good github quick reference](https://rogerdudler.github.io/git-guide/)

[Using syntax highlighting in markdown syntax](https://github.com/github/linguist/blob/master/lib/linguist/languages.yml)  


If you need to create a local copy of a project from Github, all you need to do is open bash in the desired target folder, then type:

  ```gitattributes
  git clone the_url_of_the_repository
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

# NPM Cheat-Sheet

- If you don't have nodejs installed yet, do it now with:

  ```
  sudo apt install nodejs
  ```

  - You can verify that it installed by typing `node --version`.
  - Next, make sure npm is installed by typing `sudo apt install npm`. This will take a bit to install. Afterwards, verify that it installed by typing `npm --version`.

- To initiate a new project with npm:

	```npm
	npm init
	```

- To install a package and save it as a dependency in the package.json file:
  ```npm
  npm install <pkg> --save
  ```
  
- To install a package as a _dev_ dependency (also saved in the package.json file):
  ```node
  npm install --save-dev <package_name>
  ```
  
- To [remove a package and its dependencies from a project](https://docs.npmjs.com/uninstalling-packages-and-dependencies) (and the package.json file):
  ```node
  npm uninstall --save <package_name>
  ```
  
  Or to uninstall a dev dependency:
  ```node
  npm uninstall -D <package_name>
  ```

## [Update Node.js via npm (and npm along with it)](https://davidwalsh.name/upgrade-nodejs)

- `n` is a package that serves as a helper in npm to update npm and Node.js (and do other things, possibly)
- 
	```gitattributes
	sudo apt-get update
	sudo npm cache clean -f
	sudo npm install -g n
	sudo n stable
    ```
    
- Make sure to restart your terminal afterwards!

If you've downloaded a package from GitHub and need to install it with npm, run `npm install` first, followed by `npm audit fix` to automatically fix any vulnerabilities. Afterwards, run `npm install` a second time to verify that there are no remaining vulnerabilities.
