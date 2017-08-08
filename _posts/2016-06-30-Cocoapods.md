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

* 注 - CocoaPods版本设置

```objective-c
pod 'AFNetworking'      //不显式指定依赖库版本，表示每次都获取最新版本  
pod 'AFNetworking', '2.0'     //只使用2.0版本  
pod 'AFNetworking', '> 2.0'     //使用高于2.0的版本  
pod 'AFNetworking', '>= 2.0'     //使用大于或等于2.0的版本  
pod 'AFNetworking', '< 2.0'     //使用小于2.0的版本  
pod 'AFNetworking', '<= 2.0'     //使用小于或等于2.0的版本  
pod 'AFNetworking', '~> 0.1.2'     //使用大于等于0.1.2但小于0.2的版本  
pod 'AFNetworking', '~>0.1'     //使用大于等于0.1但小于1.0的版本  
pod 'AFNetworking', '~>0'     //高于0的版本，写这个限制和什么都不写是一个效果，都表示使用最新版本
```


## 四、建立自己的Podspec


* 流程
* 1.创建并设置一个私有的Spec Repo。
* 2.创建Pod的所需要的项目工程文件，并且有可访问的项目版本控制地址。
* 3.创建Pod所对应的podspec文件。
* 4.本地测试配置好的podspec文件是否可用。
* 5.向私有的Spec Repo中提交podspec。
* 6.在个人项目中的Podfile中增加刚刚制作的好的Pod并使用。
* 7.更新维护podspec。


注：
在这一系列的步骤中需要创建两个Git仓库，分别是第一步和第二步（第二步不一定非要是Git仓库，只要是可以获取到相关代码文件就可以，也可以是SVN的，也可以说zip包，区别就是在podspec中的source项填写的内容不同），并且第一步只是在初次创建私有podspec时才需要，之后在创建其他的只需要从第二步开始就可以。


### 1.创建`Spec Repo`流程


* `Github`创建远程仓库`ZYP_HomeController`


* 本地`Cocoapods`创建私有化`Spec Repo`


```
~ cd ~/.cocoapods/repos
➜  repos ls
master
➜  repos pod repo add ZYP_HomeController https://github.com/SilverBulletZyp/ZYP_HomeController.git
Cloning spec repo `ZYP_HomeController` from `https://github.com/SilverBulletZyp/ZYP_HomeController.git`
➜  repos ls
ZYP_HomeController master
```


* 查看创建好的仓库


```
➜  repos tree -L 2
.
├── ZYP_HomeController
│   ├── LICENSE
│   └── README.md
└── master
    ├── CocoaPods-version.yml
    ├── README.md
    └── Specs
```


### 2.创建pod项目工程文件



* 进入本地项目目录创建`podTestLibrary`


```
➜  Desktop ls
ZYP_HomeViewController
➜  Desktop cd ZYP_HomeViewController
➜  ZYP_HomeViewController ls
ZYP_HomeViewController           ZYP_HomeViewController.xcodeproj
➜  ZYP_HomeViewController pod lib create podTestLibrary
Cloning `https://github.com/CocoaPods/pod-template.git` into `podTestLibrary`.
Configuring podTestLibrary template.

------------------------------
```


* 之后需要填写几个问题


```
What language do you want to use?? [ Swift / ObjC ]
 > ObjC
Would you like to include a demo application with your library? [ Yes / No ]
 > Yes
Which testing frameworks will you use? [ Specta / Kiwi / None ]
 > Specta
Would you like to do view based testing? [ Yes / No ]
 > Yes
What is your class prefix?
 > ZYP
```

* 随后自动执行`pod install`并创建`pod`依赖(此处我省略了项目内文件内容的打印)


```
➜  ZYP_HomeViewController tree -L 2
.
├── ZYP_HomeViewController
│   ├── ...
├── ZYP_HomeViewController.xcodeproj
│   ├── project.pbxproj
│   ├── project.xcworkspace
│   └── xcuserdata
└── podTestLibrary
    ├── Example
    ├── LICENSE
    ├── README.md
    ├── _Pods.xcodeproj -> Example/Pods/Pods.xcodeproj
    ├── podTestLibrary
    └── podTestLibrary.podspec
```



### 3.完善项目文件


* 我们可以查看项目目录下`podTestLibrary`内容


```
➜  ZYP_HomeViewController cd podTestLibrary
➜  podTestLibrary git:(master) ✗ tree -L 2
.
├── Example
│   ├── Podfile
│   ├── Podfile.lock
│   ├── Pods
│   ├── Tests
│   ├── podTestLibrary
│   ├── podTestLibrary.xcodeproj
│   └── podTestLibrary.xcworkspace
├── LICENSE
├── README.md
├── _Pods.xcodeproj -> Example/Pods/Pods.xcodeproj
├── podTestLibrary
│   ├── Assets
│   └── Classes
└── podTestLibrary.podspec
```

此时能看到该项目已由非git仓库自动生成为git类型仓库，并有`commit`的`log`


* 添加需要替换的文件


```
// 可以看到在这个目录下有个 ReplaceMe.m 的文件，将需要提交的class替换即可
ZYP_HomeViewController/podTestLibrary/podTestLibrary/Classes
```

于是我替换了目录下文件后为:


```
➜  podTestLibrary git:(master) ✗ tree -A
.
├── Assets
└── Classes
    ├── ZYPBaseViewController.h
    ├── ZYPBaseViewController.m
    ├── ZYPNavigationController.h
    ├── ZYPNavigationController.m
    ├── ZYPViewController.h
    └── ZYPViewController.m
```


此时远端还没有改仓库，我们在github上创建该仓库后推送至远端


* 创建好仓库后，`pod`目录下git推送


```
➜  podTestLibrary git:(master) ✗ git add -A
➜  podTestLibrary git:(master) ✗ git commit -m 'init pod'
➜  podTestLibrary git:(master) git remote add origin https://github.com/SilverBulletZyp/ZYP_HomeViewController.git
➜  podTestLibrary git:(master) git push origin master
// 推送不上去时可以试试强制推送
// git push -f origin master
// git push -u origin master
// 之后可以查看仓库状态
➜  podTestLibrary git:(master) git remote -v
origin	https://github.com/SilverBulletZyp/ZYP_HomeViewController.git (fetch)
origin	https://github.com/SilverBulletZyp/ZYP_HomeViewController.git (push)
```

注：每当你向Pod中添加了新的文件或者以后更新了podspec的版本都需要重新执行一遍pod update命令。


* 增加`tag`并推送(`podspec`文件中获取`Git`版本控制的项目)


```
➜  podTestLibrary git:(master) git tag 1.0.0
➜  podTestLibrary git:(master) git push --tags
```


### 4.修改项目`podspec`文件


* cd到根目录创建`.podspec`


```
➜  ZYP_HomeViewController pod spec create ZYP_HomeViewController
```


* 配置`.podspec`的必要信息

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


* 验证`.podspec`

```
/*pod lib lint                    //不予许警告和错误
pod lib lint --allow-warnings   //允许警告*/
pod spec lint ZYP_HomeViewController.podspec --allow-warnings
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
