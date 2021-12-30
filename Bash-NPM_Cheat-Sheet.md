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
