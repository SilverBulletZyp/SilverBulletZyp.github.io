---
layout: post
title: iOS开发常用技巧
category: iOS
tags: [iOS]
---


> 收集iOS开发过程中的各种小技巧


## 1.HTML绘制Label

* 可新建本地测试`test.html`

```html
<html>
<head>
    <meta charset="UTF-8">
</head>
<body>
<p style="color: darkgreen;font-size: 23px">感谢<span style="color: red;font-size: 25px">A</span>送给<span style="color: cornflowerblue;font-size: 25px">B</span>鲜花</p>
</body>
</html>
```

* 本地读取

```objective-c
NSURL *str = [[NSBundle mainBundle]URLForResource:@"test.html" withExtension:nil];
NSAttributedString *attr = [[NSAttributedString alloc]initWithURL:str options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];

UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(50, 80, 240, 120)];
label.attributedText = attr;
[self.view addSubview:label];
```

* 效果如图

![HTML绘制Label效果图](http://silverbulletzyp.github.io/img/2017-08-18/html_draw_label.png)





