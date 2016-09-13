
> 错误日志解析与性能优化


## dSYM文件

dSYM 是保存16进制函数地址映射信息的中转文件，我们调试的symbols都会包含在这个文件中，并且每次编译项目的时候都会生成一个新的dSYM文件，当我们的软件release模式打包或上线后，不会像我们在 Xcode 中那样直观的看到用崩溃的错误，这个时候我们就需要分析crash report文件了，iOS设备中会有日志文件保存我们每个应用出错的函数内存地址，通过Xcode的Organizer可以将iOS 设备中的DeviceLog导出成crash文件，这个时候我们就可以通过出错的函数地址去查询dSYM文件中程序对应的函数名和文件名。


* 开发环境路径

```
/Users/XXX/Library/Developer/Xcode/DerivedData/app名称/Build/Products/Debug-iphoneos/
```

* 生产环境路径

```
/Users/XXX/Library/Developer/Xcode/Archives
```

因此，对于每一个发布版本我们都很有必要保存对应的Archives文件。


## 常用操作

* 输出UUID及所在平台 [关于平台-ARM重要概念](http://silverbulletzyp.github.io//ios/2016/08/17/iOS-executableFile-conflict.html)

```
dwarfdump --uuid xx.app/xx     // 查看xx.app的UUID
dwarfdump --uuid xx.app.dSYM   // 查看xx.app.dSYM的UUID
```


```
dwarfdump --lookup 0x9d70 -arch armv7 xx.app.dSYM  使错误的日志能看懂，把相应的内存地址对应到正确的地方。
```