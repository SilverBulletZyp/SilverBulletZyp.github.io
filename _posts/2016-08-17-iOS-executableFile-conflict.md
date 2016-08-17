---
layout: post
title: iOS 可执行文件冲突解决方案
category: Category
tags: [iOS]

---

> 解决iOS中静态库与第三方开源库冲突问题


最近接入第三方厂商提供的.a静态库，在编译时出现了.o可执行文件冲突的问题。大致情况就是本地项目使用了一个名为'GTMBase64'的加密开源库，恰好第三方厂商的静态库也对其进行了封装，于是程序编译造成冲突。

## 解决方案

两种思路：

* 如果本地开源库文件极小，则单独提出修改本地开源库文件名及内部引用名。(缺点为无法对大型文件修改)
* 如果开源库不便于修改，则将静态库拆包后单独提出.o可执行文件，重新打包后使用。(缺点为无法使用cocoapods对其静态库长期在线更新)


由于两种思路都有弊端，因此更希望如若不涉及软著或是核心技术的源码，开源更为有益。此外，本文详述第二种方案的实施步骤。


## 拷贝静态库

创建文件夹拷贝静态库

```
cd Desktop/ 
mkdir testDir
cd testDir
cp /Users/XXX/Desktop/xxx.a libx.a
```

## 查看包信息

```
lipo -info libx.a
```

如果提示fat file，那么代表这个包是支持多平台的，例如armv7，armv7s，i386等，这需要我们逐一做解包重打包操作

## 解包与打包

以下仅提供示例

### 1.创建存放.o文件的文件夹

```
mkdir armv7
```

### 2.取出armv7平台的包

```
lipo libx.a -thin armv7 -output armv7/libx-armv7.a
```

### 3.查看库中所包含的文件列表

```
ar -t armv7/libx-armv7.a
```

### 4.解压出object file(即.o后缀文件)


```
cd armv7 && ar xv libx-armv7.a
```

### 5.删除冲突的包

```
rm GTMBase64.o
```

### 6.重新打包object file

```
cd .. && ar rcs libx-armv7.a armv7/*.o
```
其他平台操作步骤相同

### 7.将.o文件合并为fat file的.a文件

```
lipo -create libx-armv7.a libx-armv7s.a libx-i386.a -output libx-new.a
```
最后拷贝覆盖原文件即可



## 重要概念

平时项目开发中，可能使用第三方提供的静态库.a，如果.a提供方技术不成熟，使用的时候就会出现问题，例如：

在真机上编译报错：No architectures to compile for (ONLY_ACTIVE_ARCH=YES, active arch=x86_64, VALID_ARCHS=i386).

在模拟器上编译报错：No architectures to compile for (ONLY_ACTIVE_ARCH=YES, active arch=armv7s, VALID_ARCHS=armv7 armv6).

要解决以上问题，就要了解一下Apple移动设备处理器指令集相关的一些细节知识。


### 1.ARM

ARM处理器，特点是体积小、低功耗、低成本、高性能，所以几乎所有手机处理器都基于ARM，在嵌入式系统中应用广泛。

### 2.ARM处理器指令集
armv6｜armv7｜armv7s｜arm64都是ARM处理器的指令集，这些指令集都是向下兼容的，例如armv7指令集兼容armv6，只是使用armv6的时候无法发挥出其性能，无法使用armv7的新特性，从而会导致程序执行效率没那么高。

还有两个我们也很熟悉的指令集：i386｜x86_64 是Mac处理器的指令集，i386是针对intel通用微处理器32架构的。x86_64是针对x86架构的64位处理器。所以当使用iOS模拟器的时候会遇到i386｜x86_64，iOS模拟器没有arm指令集。

### 3.目前iOS移动设备指令集

* arm64：iPhone5S｜ iPad Air｜ iPad mini2(iPad mini with Retina Display)

* armv7s：iPhone5｜iPhone5C｜iPad4(iPad with Retina Display)

* armv7：iPhone3GS｜iPhone4｜iPhone4S｜iPad｜iPad2｜iPad3(The New iPad)｜iPad mini｜iPod Touch 3G｜iPod Touch4

* armv6：iPhone, iPhone2, iPhone3G, 第一代、第二代 iPod Touch（一般不需要去支持）


### 4.Xcode中指令集相关选项（Build Setting中）

* Architectures

指定工程被编译成可支持哪些指令集类型，而支持的指令集越多，就会编译出包含多个指令集代码的数据包，对应生成二进制包就越大，也就是ipa包会变大。

* Valid Architectures 

限制可能被支持的指令集的范围，也就是Xcode编译出来的二进制包类型最终从这些类型产生，而编译出哪种指令集的包，将由Architectures与Valid Architectures（因此这个不能为空）的交集来确定，例如：
比如，你的Valid Architectures设置的支持arm指令集版本有：armv7/armv7s/arm64，对应的Architectures设置的支持arm指令集版本有：armv7s，这时Xcode只会生成一个armv7s指令集的二进制包。

再比如：将Architectures支持arm指令集设置为：armv7,armv7s，对应的Valid Architectures的支持的指令集设置为：armv7s,arm64，那么此时，XCode生成二进制包所支持的指令集只有armv7s

在Xcode6.1.1里的 Valid Architectures  设置里，默认为 Standard architectures(armv7,arm64),如果你想改的话，自己在other中更改。

原因解释如下： 
使用 standard architectures (including 64-bit)(armv7,arm64) 参数，则打的包里面有32位、64位两份代码，在iPhone5s（ iPhone5s的cpu是64位的 ）下，会首选运行64位代码包， 其余的iPhone（ 其余iPhone都是32位的,iPhone5c也是32位 ），只能运行32位包，但是包含两种架构的代码包，只有运行在ios6，ios7系统上。 
这也就是说，这种打包方式，对手机几乎没要求，但是对系统有要求，即ios6以上。 
而使用 standard architectures (armv7,armv7s) 参数， 则打的包里只有32位代码， iPhone5s的cpu是64位，但是可以兼容32位代码，即可以运行32位代码。但是这会降低iPhone5s的性能。 其余的iPhone对32位代码包更没问题， 而32位代码包，对系统也几乎也没什么限制。 

所以总结如下：  

要发挥iPhone5s的64位性能，就要包含64位包，那么系统最低要求为ios6。 如果要兼容ios5以及更低的系统，只能打32位的包，系统都能通用，但是会丧失iPhone5s的性能。

* Build Active Architecture Only

指定是否只对当前连接设备所支持的指令集编译

当其值设置为YES，这个属性设置为yes，是为了debug的时候编译速度更快，它只编译当前的architecture版本，而设置为no时，会编译所有的版本。 编译出的版本是向下兼容的，连接的设备的指令集匹配是由高到低（arm64 > armv7s > armv7）依次匹配的。比如你设置此值为yes，用iphone4编译出来的是armv7版本的，iphone5也可以运行，但是armv6的设备就不能运行。  所以，一般debug的时候可以选择设置为yes，release的时候要改为no，以适应不同设备。 

<1>
Architectures:  armv7, armv7s, arm64
ValidArchitectures:  armv6, armv7s, arm64
生成二进制包支持的指令集： arm64

<2>
Architectures: armv6, armv7, armv7s
Valid Architectures:  armv6, armv7s, arm64
生成二进制包支持的指令集： armv7s 

<3>
Architectures: armv7, armv7s, arm64
Valid Architectures: armv7，armv7s

这种情况是报错的，因为允许使用指令集中没有arm64。

注：如果你对ipa安装包大小有要求，可以减少安装包的指令集的数量，这样就可以尽可能的减少包的大小。当然这样做会使部分设备出现性能损失，当然在普通应用中这点体现几乎感觉不到，至少不会威胁到用户体检。


### 5.制作静态库.a是指令集选择

现在回归到正题，如何制作一个“没有问题”的.a静态库，通过以上信息了解到，当我们做App的时候，为了追求高效率，并且减小包的大小，Build Active Architecture Only设置成YES，Architectures按Xcode默认配置就可以，因为arm64向前兼容。但制作.a静态库就不同了，因为要保证兼容性，包括不同iOS设备以及模拟器运行不出错，所以结合当前行业情况，要做到最大的兼容性。

ValidArchitectures设置为:armv7｜armv7s｜arm64｜i386｜x86_64 

Architectures设置不变(或根据你需要):armv7｜arm64

然后分别选择iOS设备和模拟器进行编译，最后找到相关的.a进行合包
