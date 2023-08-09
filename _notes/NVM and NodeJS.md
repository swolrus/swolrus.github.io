---
title: NVM and NodeJS
---

> A quick intro to NodeJS including installation for those who were unsure.

## FAQ

> Come back here after following the install guide if you want more information or a question as it may be answered here.

### So what is yarn?

Yarn replaces NPM by interfacing with NPM. It's an abstraction layer that adds functionality and better dependency management.  In terms of your usage it "replaces" NPM. NPM will still be a dependency of your project, but yarn is not a dependency as it is just managing the correct versions of all the projects packages. As a dev you no longer use NPM you will interact with NPM via yarn.

### What are these words you're using?

| Term                       | Definition                                                   |
| -------------------------- | ------------------------------------------------------------ |
| NodeJS                     | A JavaScript runtime environment that allows for packages to be installed to provide functions to the environment. Think what virtualenv (venv) is for python. Example is installing react and using |
| Node Version Manager (NVM) | A program that is used to manage the version of Node is currently being used on a machine. |
| Node Package Manager (NPM) | The cli and host that actively allows for a developer/user of NodeJS to manage packages and run them within the environment. |
| {PROJECT}/package.json     | Dependency list providing minimum required package version to a package manager as well as other settings for NodeJS |
| {PROJECT}/package.lock     | Current installed versions of packages managed by node, generated when using `npm install` to install the dependencies in package.lock |
| {PROJECT}/yarn.lock        | Same as `package.lock` but generated when using the yarn package to manage a projects dependencies |

### Can I use NPM and yarn?

Only ever use one package manager - either yarn or NPM, if you don't you will most likely end up with conflicting packages and complaints from both about the file structure not following their schema.
For this project we are using Yarn, and generally I would suggest you always do, tends to have less bugs.

You are technically still using both NPM and yarn when you use yarn but NPM is working behind yarn. What you mustn't do is run both `yarn install` and `npm install` in the same directory.



## Installation

### 1. Install NodeJS

> Here are instructions for each OS, simply complete the appropriate section then continue to step 2.

#### 1.1 MAC OS

##### 1.1.1 Install Homebrew

This allows for packages to be installed and managed.
```zsh
# Download the hombrew installer into your path
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# Add the PATH to your .zshrc
echo "# Homebrew\nexport PATH=/opt/homebrew/bin:\$PATH" >> .zshrc
# load the homebrew profile so you don't have to restart terminal
source ~/.zshrc
```

##### 1.1.2 Install NVM

```zsh
# now brew is available, update the package lists
brew update
# and here we can install the Node Version Manager to manage our NodeJS install
brew install nvm
# make sure the dir NPM uses to store NodeJS versions exists
mkdir ~/.nvm
# Again add the nvm commands to PATH
echo "export NVM_DIR=~/.nvm\nsource \$(brew --prefix nvm)/nvm.sh" >> .zshrc
# and reload our profile so we can use NVM
source ~/.zshrc
```

#### 1.2 Windows

##### 1.2.1 Download the NVM Installer

Windows is a lot easier as there is a prebuild installer for x64 and x32 systems. You can download the installer (pick the latest release) here: [nvm-windows](https://github.com/coreybutler/nvm-windows).

##### 1.2.2 Install

Simply follow through the installer, the default values are sufficient unless you have other preferences.



#### 1.3 Linux (ubuntu)

##### 1.3.1 Download and run the NVM installer script.

```bash
sudo apt install curl 
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
```

##### 1.3.2 Load the environment profile which the script will of modified.

```bash
source ~/.bashrc
```

Alternatively you can login and logout again.



### 2. Install and select appropriate NodeJS (this project requires 16.19.1 or newer).

> Use `lts` instead of a version number to install latest version otherwise the version number. Each version remains available until uninstalled. This is good as if you develop using latest Node and then work on a project with an older Node dependency you won't have to uninstall and reinstall Node.

```bash
nvm install <version>
```
In our case the provided package.lock has the following requirement:
- `"npm": "^16.19"` 

We will install the correct version via the install argument.
```bash
nvm install 16.19.1
```

This command will list the available node versions, you should see Node 8.19.2 listed.
```bash
nvm ls
```

We can use the above ls argument to check if we are using the correct version, if not use the following command to set 16.19.1 as default.
```bash
nvm use 16.19.1
```



### 4. Clone the project repo

You should know how to do this.



### 5. Install the dependencies for the project.

> a) I recommend you go to step six to use yarn as an interface to NPM. It generally is a more robust package manager.
>
> b) Note we are no longer using the `nvm` command but instead `npm`. Little pesky 'v' to 'p' swap. Alternatively you can install yarn and use that to manage your dependencies.

If you've decided to use NPM, open a terminal window in the working directory of your cloned repo and install the dependencies. This will take a while.
```zsh
npm install
```



### 6. Alternatively install yarn package manager globally and then use that to install the dependencies.

Still open the terminal in the working directory of your cloned repo and run the following. The first command installs yarn, the `-g` option means it will be available globally allowing you to not have to install the manager for each project. This is ok to do for packages that don't have dependencies - yarn manages the packages but packes don't need a certain version to function.
```zsh
npm install -g yarn && yarn install
```



### 7. Serve the website

> This may be different depending on the scripts in your `package.json` but should apply for React and Next JavaScript projects.

**When using NPM**
```zsh
npm run start
```
**When using Yarn**

```zsh
# if using yarn then 
yarn run start
```
You're now serving the website over localhost and once there are some JS files they will update as changes are made.

For available scripts you should look in the package.json for a "scripts" key. This is used when setting up your project to automate aspects of the build for example linting or sass compiling. In the most basic case it will provide a development and live environment.
An example scripts setup with custom entries showing is here:

```json
"scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build ",
    "test": "react-scripts test",
    "eject": "react-scripts eject"
  },
```
