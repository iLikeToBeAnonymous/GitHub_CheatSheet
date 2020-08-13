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
  - `git fetch` lets your local copy know the changes done in the remote repo of the branch you're on.
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

# NPM Cheat-Sheet

- To initiate a new project with npm:

	```npm
	npm init
	```

- To install a package and save it as a dependency in the package.json file:
  ```npm
  npm install <pkg> --save
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
