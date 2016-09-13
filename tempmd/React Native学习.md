# React Native学习


## 基础与使用工具

**nvm** 是node版本管理工具。

**node.js** 是运行在服务端的JavaScript。

**npm** 是node包管理器，用于安装、卸载、更新、查看、搜索、发布等。

**watchman** facebook开源项目，用来监视文件并且记录文件的改动情况。

**git-flow** 是使用Git进行源代码管理时的一套行为规范和简化部分Git操作的工具。


## 安装node.js

如果之前通过brew安装过node，则移除node后安装nvm，通过nvm管理不同版本node

```
// 移除已安装好的node(若存在)
brew remove --force node
sudo rm -r /usr/local/lib/node_modules
brew prune
sudo rm -r /usr/local/include/node
// 检查brew是否正常
brew doctor
```

安装nvm

```
brew install nvm
```

其次需要在shell的配置文件(~/.bashrc,~/.profile,和~/.zshrc)中添加

```
# For NVM
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh
```

注意配置顺序，以防开启新终端，node出现找不到的情况

重启终端，nvm安装不同版本的node

```
nvm install v4.5.0
```

* 查看本地版本和远程版本

```
nvm ls
nvm ls-remote 
```

* npm安装react-native-cli的命令行工具

```
// 权限不够则使用sudo
npm install -g react-native-cli
```

* 使用react创建项目

```
react-native init XXX
```


