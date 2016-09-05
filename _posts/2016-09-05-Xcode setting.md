---
layout: post
title: Xcode常用配置
category: iOS
tags: [iOS]

---


> 总结Xcode常用目录与文件设置


## Xcode目录配置

* Provisioning Profile 目录位置

```
/Users/XXX/Library/MobileDevice/Provisioning\ Profiles/
```


## Plist文件配置


* 修改iOS 9和OS X v10.11 HTTP请求限制

http超文本传输协议采用明文传输，https则使用SSL加密传输协议进行传输，因此添加规则限制

1.默认允许任意HTTP请求

```
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
</dict>
```

2.添加键值限制

由于第三方SDK与合作伙伴接入多为HTTP，因此常用方法1，该情况下虽然解决了网络访问的问题，但是苹果提供的安全保障也被关闭了。

如果你的App没有受到这些原因的限制，还是更建议你增加HTTPS支持，而不是关闭限制。


```xml
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSExceptionDomains</key>
  <dict>
    <key>域名.com</key>
    <dict>
      <!--允许子域名:subdomains-->
      <key>NSIncludesSubdomains</key>
      <true/>
      <!--允许App进行不安全的HTTP请求-->
      <key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
      <true/>
      <!--在这里声明所支持的 TLS 最低版本-->
      <key>NSTemporaryExceptionMinimumTLSVersion</key>
      <string>TLSv1.1</string>
    </dict>
  </dict>
</dict>
```

例如

```XML
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSExceptionDomains</key>
    <dict>
		<key>qq.com</key>
       	<dict>
           	<key>NSIncludesSubdomains</key>
          	 <true/>
   	    </dict>
     	  <key>sina.com.cn</key>
     	  <dict>
          <key>NSIncludesSubdomains</key>
          <true/>
       	</dict>
	</dict>
</dict>
```

当然, 以上方法都是建立在所访问的请求是HTTP类型的基础上, 一劳永逸的方法就是让服务端升级使用TLS 1.2 SSL加密请求的HTTPS协议。

服务器已支持TLS 1.2 SSL ，但iOS9上还是不行，还要进行链接里的适配操作。那是因为：ATS只信任知名CA颁发的证书，小公司所使用的 self signed certificate，还是会被ATS拦截。对此，建议使用链接中给出的NSExceptionDomains，并将你们公司的域名挂在下面。


