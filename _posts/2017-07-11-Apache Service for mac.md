---
layout: post
title: 启用Apache进行本地测试
category: Tool
tags: [Tool]

---

> mac环境下启用本地已搭建的apache服务器进行测试


## 启动Apache

```
sudo apachectl -k start
```

* 在浏览器中输入`localhost`或`127.0.0.1`或本机实际ip地址

* 返回`It works!`时说明启动成功


## 相关配置

### 1.配置目录

```
cd /etc/apache2
```

### 2.修改默认配置

原默认配置为`httpd.conf`文件

```
sudo vim httpd.conf
```

vim状态下查看当前默认文件根目录

```
/DocumentRoot
```

* 原始默认路径为`/Library/WebServer/Documents`可将其重新修改，配置文件内路径位置有两处，修改完后`:wq`保存即可

### 3.重启使用

回到主窗口后重启apache

```
sudo apachectl -k restart
```


> 编辑模式:i
> 命令模式:esc

注：所有修改目录在编辑模式下进行,其他搜索字符串或保存退出在命令行模式下进行

* 进入本地配置目录下创建`test.html`，例

```html
<html>
  <head>
    <title>My Apache</title>
  </head>
  <body>
    <h1>This is my Apache</h1>
  </body>
<html>
```

* 进入浏览器`http://localhost/text.html`查看


## 部分命令


* 启动

```
sudo apachectl start
```

* 停止

```
sudo apachectl stop
```


* 重启

```
sudo apachectl restart
```

* 查看

```
Apache 版本 httpd -v
```


* 错误日志目录

```
ErrorLog "/private/var/log/apache2/..."
```


## 添加PHP脚本支持

* 在`httpd.conf`搜索`/php`，查找到以下部分删除`#`并保存

```
#LoadModule php5_module libexec/apache2/libphp5.so
```

* 进入当前目录修改，将`php.ini.default`文件复制为`php.ini`

```
cd /etc/
sudo cp php.ini.default php.ini
```

* 重启服务器，在文件目录路径下新建`info.php`，测试目录路径是否支持

```php
<html>
  <body><?php phpinfo(); ?>
  </body>
<html>
```


* 进入浏览器`http://localhost/info.php`查看`php`是否支持


> 注：
> 静态页面:htm、html
> 动态页面:asp、aspx、jsp、PHP


