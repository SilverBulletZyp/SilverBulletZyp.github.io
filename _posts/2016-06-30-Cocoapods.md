---
layout: post
title: Cocoapods安装及使用教程
category: Tool
tags: [Tool]

---


> 利用rvm管理ruby版本,使用ruby环境下的gem安装cocoapods



## 一、cocoapods安装

### 1.安装rvm

* 安装

```
curl -L get.rvm.io | bash -s stable
source ~/.bashrc
source ~/.bash_profile
```

* 如果网速较慢，修改rvm的ruby安装源镜像路径

```
sed -i -e 's/ftp\.ruby-lang\.org\/pub\/ruby/ruby\.taobao\.org\/mirrors\/ruby/g' ~/.rvm/config/db
```


### 2.安装ruby


* 列出已知的ruby版本

```
rvm list known
```

* 安装指定的ruby版本

```
rvm install 1.9.3
```

* 使用指定ruby版本

```
rvm use 1.9.3
```

* 将指定的ruby版本设为默认

```
rvm use 1.9.3 --default
```

* 查询已安装的ruby版本列表

```
rvm list
```

* 卸载指定的ruby版本

```
rvm remove 1.9.2
```

### 3.安装cocoapods

* 查看当前ruby版本

```
ruby -v
```

* 移除现有ruby默认源

```
gem sources --remove https://rubygems.org/
```


* 添加gem镜像源

```
gem sources -add https://ruby.taobao.org/
```

* 验证新源路径

```
gem sources -l
```

* 更新gem

```
sudo gem update --system
```

* 安装或升级cocoapods

```
// 原命令为
sudo gem install cocoapods
// OS X 系统升级后改为
sudo gem install -n /usr/local/bin cocoapods

pod setup
```


## 二、cocoapods使用

* 搜索第三方库

```
pod search XXX
```

* cd到指定文件夹目录后创建Podfile文件

```
touch Podfile
```

* 使用vim编辑文件

```
vim Podfile
```

* 编写文件内容

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


* 安装pod导入第三方库

```
pod install
```

若只需更新则直接update

```
pod update
```

若存在警告则打开工程，为每个target的，build setting里的四个地方，增加$(inherited)。 

```
Other Link Flags 
Library search Paths
Header search Paths
Framework search Paths
```

更新本地资源库
```
pod repo update 
```

## 三、常用命令及参考

* cocoapods帮助

```
pod -h
```

* cocoapods安装路径

```
~/.cocoapods
```

* 查看目录下文件大小

```
du -sh *
```

* 若网络条件较差，不更新资源库，则更新`podfile`时可使用：

```
pod install --verbose --no-repo-update
pod update --verbose --no-repo-update
```

* [解决CocoaPods慢的小技巧](http://www.cocoachina.com/ios/20170208/18645.html)


## 四、建立自己的Podspec

* 流程

创建`.podspec`，编辑`.podspec`的必要信息，提交到`Git`即可正常使用


### 1.创建及配置

* 创建

```
$ pod spec create XXX
```

* 配置

```
Pod::Spec.new do |s|

  s.name                 = "XXX"
  s.version              = "1.0.0"
  s.summary              = "integrate APNs rapidly"
  s.homepage             = "https://github.com/SilverBulletZyp/XXX"
  s.license              = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "zhaoyunpeng" => "807536782@qq.com" }
  s.social_media_url   = "Silverbulletzyp.github.io"
  s.platform             = :ios, "7.0"
  s.source               = { :git => "https://github.com/SilverBulletZyp/XXX", :tag => s.version }
  s.source_files          = "XXX/**/*.{h,m}"
  s.resources          = "XXX/Images/*.png"
  s.dependency             "BPushSDK", "1.4.1"
  s.requires_arc         = true

end

```

|名称|注释|
|:---|:---|
|s.name|名称，pod search 搜索的关键词|
|s.version|版本|
|s.summary|简介，pod search 搜索的关键词|
|s.homepage|主页地址，例如Github地址|
|s.license|许可证|
|s.author|作者|
|s.social_media_url|社交网址|
|s.platform|平台|
|s.source|Git仓库地址，例如在Github地址后边加上 .git 就是Git仓库地址，常见写法如下|
|s.source_files|需要包含的源文件，常见的写法如下|
|s.resources|需要包含的图片等资源文件|
|s.dependency|依赖库，不能依赖未发布的库|
|s.requires_arc|是否要求ARC|


* s.source_files 常见写法

```
"Directory1/*"
"Directory1/Directory2/*.{h,m}"
"Directory1/**/*.h"
// “*” 表示匹配所有文件
// “*.{h,m}” 表示匹配所有以.h和.m结尾的文件
// “**” 表示匹配所有子目录
```	
	
* s.source 常见写法

```
s.source = { :git => "https://github.com/SilverBulletZyp/XXX.git", :commit => "68defea" }
s.source = { :git => "https://github.com/SilverBulletZyp/XXX.git", :tag => 1.0.0 }
s.source = { :git => "https://github.com/SilverBulletZyp/XXX.git", :tag => s.version }
// commit => "68defea" 表示将这个Pod版本与Git仓库中某个commit绑定
// tag => 1.0.0 表示将这个Pod版本与Git仓库中某个版本的comit绑定
// tag => s.version 表示将这个Pod版本与Git仓库中相同版本的commit绑定
```


### 2.上传及验证

* 验证`.podspec`

```
$ pod spec lint XXX.podspec
```

* 验证过程中

```
 -> XXX
```
 
* 验证成功后

```
XXX.podspec passed validation.
```

* 验证失败后

```
[!] The spec did not pass validation, due to 1 error.
```

验证`.podspec`会先测试本地`.podspec`文件是否存在语法错误。测试成功再根据`.podspec`文件找到远端仓库对应的版本克隆到本地并进行配置。最后测试文件是否能够编译成功。


* 上传至`Github`

将包含配置好的`.podspec`的项目提交`Git`，并给这次提交打上`tag`，这时就可以在其他项目中使用 `CocoaPods`引入你配置好的`Pod`了。

```
pod 'XXX', :git => 'https://github.com/SilverBulletZyp/XXX.git', :tag => '1.0.0'
```

### 3.验证错误排查


* 语法错误 - 错误定位

```
[!] Invalid `LPPushService.podspec` file: no .<digit> floating literal anymore; put 0 before dot
  s.version      = “1.0.0”
                        ^
LPPushService.podspec:5: syntax error, unexpected tFLOAT, expecting '('
  s.version      = “1.0.0”
                        ^
```

> 上述错误是因为使用`“文本编辑”`进行编辑造成的。使用文本编辑有时候英文`""`引号会自动变成中文`“”`引号。
> [!] Your Podfile has had smart quotes sanitised. To avoid issues in the future, you should not use TextEdit for editing it. If you are not using TextEdit, you should turn off smart quotes in your editor of choice.
> 使用 vim 将其改为英文的""引号即可。


* 依赖错误 - `“--verbose”`

```
pod spec lint XXX.podspec --verbose
```

例：

```
 -> LPPushService (1.0.0)
    - ERROR | [iOS] Encountered an unknown error (The 'Pods' target has transitive dependencies that include static binaries: (/private/var/folders/jz/b_m3k7ln47524cm__h3__mk00000gn/T/CocoaPods/Lint/Pods/BPushSDK/LibBPush/libBPush.a)) during validation.
```
    
> 上述错误是因为依赖库`（s.dependency）`包含了`.a`静态库造成的。虽然这并不影响`Pod`的使用，但是验证是无法通过的。可以通过`--use-libraries`来让验证通过。
`pod spec lint XXX.podspec --verbose --use-libraries`
这种情况下使用`--use-libraries`虽然不会出现错误`（error）`，但是有时候会带来一些警告`（waring）`，警告同样是无法通过验证的。这时可以用`--allow-warnings`来允许警告。
`pod spec lint XXX.podspec --verbose --use-libraries --allow-warnings`


* 安装错误

`pod install`时，出现包含`“undefined method 'end_with?' for nil”`字样的报错

> 进入`“~/.cocoapods/repos”`目录，删除`“master”`，并将`master-1`改为`master`即可。
> 如果出现如下错误，而你的验证可以通过，那么一般更新下版本号就可以解决。
> [!] Unable to find a specification for 'XXX'.



### 4.发布到CocoaPods


你可以用 .podspec 文件来方便的管理内部代码，当然，也可以发布自己的 Pod 供其他开发者使用。
CocoaPods 0.33中加入了 Trunk 服务，使用 Trunk 服务可以方便的发布自己的Pod。虽然一开始使用 GitHub Pull Requests 来整理所有公共 pods 效果很好。但是，随着 Pod 数量的增加，这个工作对于 spec 维护人员 Keith Smiley 来说变得十分繁杂。甚至一些没有通过 $ pod lint 的 spec 也被提交上来，造成 repo 无法 build。CocoaPods Trunk 服务的引入，解决了很多类似的问题。每次使用 Trunk 服务发布 Pod 时都会通过 $ pod lint 验证 .podspec 是否有效。要想使用 Trunk 服务，首先需要使用如下命令注册自己的电脑。这很简单，只要你指明你的邮箱地址（spec文件中的）和名称即可。CocoaPods 会给你填写的邮箱发送验证邮件，点击邮件中的链接就可通过验证。


```
pod trunk register 807536782@qq.com "zhaoyunpeng"
```

然后就可以发布你的`Pod`了

```
pod trunk push XXX.podspec
```


发布时会验证 Pod 的有效性，如果你在手动验证`Pod`时使用了`--use-libraries`或`--allow-warnings`等修饰符，那么发布的时候也应该使用相同的字段修饰，否则出现相同的报错。

```
pod trunk push XXX.podspec --use-libraries --allow-warnings
```

发布成功后，就可以使用`pod search`搜索到你的`Pod`了

```
-> LPPushService (1.0.0)
   integrate APNs rapidly
   pod 'LPPushService', '~> 1.0.0'
   - Homepage: https://github.com/xiaofei86/LPPushService
   - Source:   https://github.com/xiaofei86/LPPushService.git
   - Versions: 1.0.0 [master repo]
```



### 5.CocoaPods版本升级


当需要更新`Pod`版本的时候，修改`.podspec`中的`s.version`为更高的版本号，并修改`s.source`中对应的`Git`版本。提交到`Git`，并打上对应`tag`。然后再次执行`pod trunk push XXX.podspec`将新的`.podspec`发布到`CocoaPods`。

* 附

为了更新更加方便，版本控制更加清晰，`s.source`建议采用如下写法

```
s.source = { :git => "https://github.com/SilverBulletZyp/XXX.git", :tag => s.version }
```

这样写将`Git`的版本与`CocoaPods`的版本进行了绑定。每次提交后再给本次提交打上`tag`就完成了更新。而且在`Git`中就可以清晰的看到哪次提交对应的哪个`CocoaPods`版本。如果与`commit`绑定，则要通过两次提交才能完成更新，第一次先提交修改代码，第二次将上一次`commit id`更新到`s.source`然后再次提交。如果直接与固定`tag`绑定，则每次还都要修改`s.source`。如果你的`Pod`是私有库，那么 `s.source`其实是无用的。因为在`Podfile`中已经指明了地址和版本（如下）。这时`s.source`可以随便填写，但最好还是按照上述规则以便以后发布。

```
pod 'XXX', :git => 'https://github.com/xiaofei86/LPPushService.git', :tag => 1.0.0
```


