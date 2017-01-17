---
layout: post
title: 解包app头文件
category: iOS
tags: [iOS]

---


## 使用class-dump解包出头文件

下载 [class-dump](http://stevenygard.com/projects/class-dump/)
运行dmg后需将`class-dump`拷贝进入`/usr/bin`

由于mac系统10.11之后无法直接写入，我们可以单独对某个目录添加环境变量并执行

ex:根目录

1.拷贝并添加权限

```
mkdir ~/bin
// 拷贝class-dump到 ~/bin
chmod +x ~/bin/class-dump
```

2.配置环境变量

```
vim ~/.bash_profile
// 添加 export PATH=$HOME/bin/:$PATH 保存
source ~/.bash_profile
```

3.解包目标文件生成头文件

```
class-dump -H file -o fileDir
// 即在fileDir下生成当前应用的头文件
```


## 其他常用工具

由于未开始研究逆向，因此只记录后续会使用到的工具以备用

* homebrew

* Hopper Disassembler — 反编译工具，根据可执行文件反编译出汇编码。

* Class-dump — 逆向工程的入门级工具，导出一个App的某些信息。

* otx — 国外某位大神的博客上用的一个工具。通过brew install --HEAD homebrew/head-only/otx命令安装。

* Hex friend — 二进制文件编辑器，要用这个修改原来的二进制文件。

* gdb — 调试器，用lldb也行。通过brew install gdb命令安装。

* AppCrackr


## 相关逆向文章参考

[移动App入侵与逆向破解技术](http://dev.qq.com/topic/577e0acc896e9ebb6865f321)

[破解Mac Paw](https://bestswifter.com/app-crack/)

[免越狱版iOS抢红包插件](http://www.swiftyper.com/2016/12/26/wechat-redenvelop-tweak-for-non-jailbroken-iphone/)

[APP逆向分析之钉钉抢红包插件的实现](https://yohunl.com/ding-ding-qiang-hong-bao-cha-jian-iospian/)
