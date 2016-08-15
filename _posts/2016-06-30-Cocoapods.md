---
layout:     post
title:      "cocoapods安装及使用教程"
<!--subtitle:   "rvm、ruby、gem、cocoapods安装及使用命令"
date:       2016-06-30
author:     "Zyp"-->
tags:[Tool]
<!--    - 工具控-->
---


* 利用rvm管理ruby版本,使用ruby环境下的gem安装cocoapods



### 1.安装rvm

安装rvm

```
$ curl -L get.rvm.io | bash -s stable
$ source ~/.bashrc
$ source ~/.bash_profile
```

如果网速较慢，修改rvm的ruby安装源镜像路径

```
$ sed -i -e 's/ftp\.ruby-lang\.org\/pub\/ruby/ruby\.taobao\.org\/mirrors\/ruby/g' ~/.rvm/config/db
```


### 2.安装ruby


列出已知的ruby版本

```
$ rvm list known
```

安装指定的ruby版本

```
$ rvm install 1.9.3
```

使用指定ruby版本

```
$ rvm use 1.9.3
```

将指定的ruby版本设为默认

```
$ rvm use 1.9.3 --default
```

查询已安装的ruby版本列表

```
$ rvm list
```

卸载指定的ruby版本

```
$ rvm remove 1.9.2
```

### 3.安装cocoapods

查看当前ruby版本

```
$ ruby -v
```

移除现有ruby默认源

```
$ gem sources --remove https://rubygems.org/
```


添加gem镜像源

```
$ gem sources -add https://ruby.taobao.org/
```

验证新源路径

```
$ gem sources -l
```

更新gem

```
$ sudo gem update --system
```

安装或升级cocoapods

```
// 原命令为
$ sudo gem install cocoapods
// OS X 系统升级后改为
$ sudo gem install -n /usr/local/bin cocoapods

$ pod setup
```

### 4.cocoapods使用

搜索第三方库

```
$ pod search XXX
```

cd到指定文件夹目录后创建Podfile文件

```
$ touch Podfile
```

使用vim编辑文件

```
$ vim Podfile
```

编写文件内容

```
// 指定路径
xcodeproj "/Users/XXX/XXX/XXX.xcodeproj"

// 所有的target使用相同的第三方依赖配置
link_with 'TargetName1', 'TargetName2'

// 指定iOS版本号
platform:ios, '8.0'
// 添加所需第三方库
pod 'AFNetworking', '~> 2.3.1'
// 退出vim时输入:wq
```

或

```
source 'https://github.com/CocoaPods/Specs.Git'
platform :ios, '6.1'
// 不同的target使用不同的第三方依赖配置 
target :TargetName1 do
    pod 'MKNetworkKit'
    pod 'MBProgressHUD'
    pod 'IQKeyboardManager'
    pod 'Toast'
end
```


安装pod导入第三方库

```
$ pod install
```

若只需更新则直接update

```
$ pod update
```

若存在警告则打开工程，为每个target的，build setting里的四个地方，增加$(inherited)。 

```
Other Link Flags 
Library search Paths
Header search Paths
Framework search Paths
```

### 5.其他

cocoapods帮助

```
$ pod -h
```

cocoapods安装路径

```
~/.cocoapods
```

查看目录下文件大小

```
$ du -sh *
```

