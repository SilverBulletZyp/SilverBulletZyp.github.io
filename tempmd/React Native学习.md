# React Native学习


## 基础与使用工具

**nvm** 是`nodejs`版本管理工具,管理`nodejs`版本和`npm`版本。

**npm** 是node包管理器，管理`node.js`，用于安装、卸载、更新、查看、搜索、发布等。

**node.js** 是运行在服务端的`JavaScript`环境，同时也是`reactNative`开发过程中所需要的代码库。

**watchman** facebook开源项目，用来监视文件并且记录文件的改动情况。

**git-flow** 是使用Git进行源代码管理时的一套行为规范和简化部分Git操作的工具。




## nvm


### 1.homebrew安装

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

* 可能存在的问题[Github issues](https://github.com/creationix/nvm/issues/855)

### 2.nvm独立安装

* [Node Version Manager](https://github.com/creationix/nvm)


* 安装到`~/.nvm`

```bash
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash
```

* 配置环境变量路径

```vim
~/.zshrc // 优先配置
~/.bash_profile
~/.profile
~/.bashrc
```

* 修改环境变量

```vim
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
```

* 重启`zsh`

```
source ~/.zshrc
```


* 路径问题处理

```
// 若还无法使用，必须用nvm.sh。执行以下两行命令行即可
export NVM_DIR=~/.nvm
source ~/.nvm/nvm.sh
```



### 3.nvm命令


| 命令 | 描述 |
|:--- |:---|
| `command -v nvm`| 检查`nvm`是否安装成功 |
| `nvm ls-remote` | 查看`node`可安装版本 |
| `nvm install v4.1.0` | 安装对应`node`版本 |
| `nvm install node` | 安装最新`node`版本 |
| `ls -a ~/.nvm/versions/node` | 查看`node`安装目录 |
| `echo $PATH` | 打印`node`使用版本目录 |
| `nvm use v4.1.0` | 切换`node`版本 |
| `node -v` | 查看当前`node`版本 |
| `nvm alias default v4.1.0` | 指定默认版本(防止新开终端版本失效) |



## npm

### npm命令


* 安装命令


| 命令 | 描述 |
| :-- | :-- |
| `npm init` | 创建一个`package.json`文件 |
| `npm root` | 查看当前包的安装路径 |
| `npm install ModuleName` | 安装包 |
| `npm install ModuleName -g ` | 全局安装 |
| `npm install ModuleName --save` | 安装时写入信息到`package.json`中的`dependencies` |
| `npm install ModuleName --save-dev` | 安装时写入信息到`package.json`中的`devDependencies` |
| `npm set global=true` | 配置安装模式为全局 |
| `npm set global=false` | 配置安装模式为本地 |


* 查看命令

| 命令 | 描述 |
| :-- | :-- |
| `npm -v` | 查看`npm`版本 |
| `npm get global` | 查看当前安装模式 |
| `npm ls -g` | 查看所有全局安装的包 |
| `npm ls` | 查看本地项目中安装的包 |
| `npm view ModuleName` | 查看包的`pack.json`文件 |
| `npm view ModuleName dependencies` | 查看包的依赖关系 |
| `npm view ModuleName repository.url` | 查看包的源文件地址 |
| `npm view ModuleName engines` | 查看包所依赖的`node`版本 |
| `npm help folders` | 查看`npm`所使用的文件夹 |


* 更新命令


| 命令 | 描述 |
| :-- | :-- |
| `npm rebuild ModuleName` | 更改包内容后进行重建 |
| `npm outdated` | 检查包是否已经过时 |
| `npm update ModuleName` | 更新当前目录下`node_modules`子目录里的包 |
| `npm update ModuleName` | 全局更新 |
| `npm uninstall ModuleName` | 卸载包 |
| `npm help json` | 访问`npm`的`json`文件 |
| `npm search ModuleName` | 发布包时检验包名是否存在 |
| `npm cache clear` | 清空`npm`缓存 |
| `npm unpublish <package> <version>` | 撤销自己发布过的某个版本代码 |
| `npm install -g cnpm --registry=https://registry.npm.taobao.org` | 使用淘宝镜像 |



