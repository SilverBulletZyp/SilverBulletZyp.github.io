---
layout: post
title: iOS Attributes文本属性解析
category: iOS
tags: [iOS]

---

> 关于UI控件的Attributes文本属性，学习了一部分整理下来


## **一.示例部分**

![AttributesDemo](http://img.blog.csdn.net/20151019151640317)

测试代码

```objc
/** label1 */
UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(30, 60, 500, 40)];
NSDictionary * attributes = @{NSForegroundColorAttributeName:[UIColor redColor],
                              NSBackgroundColorAttributeName:[UIColor greenColor],
                                         NSFontAttributeName:[UIFont fontWithName:@"TimesNewRomanPS-BoldItalicMT" size:19.0],
                                         NSKernAttributeName:@1.0};
NSString * string = @"This is an attributes string";
NSAttributedString * attributeText = [[NSAttributedString alloc]initWithString:string attributes:attributes];
[label1 setAttributedText:attributeText];
[self.view addSubview:label1];

/** label2 */
UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(30, 100, 300, 40)];
NSDictionary * attributes2 = @{NSBackgroundColorAttributeName:[UIColor orangeColor],
                                          NSFontAttributeName:[UIFont fontWithName:@"ArialUnicodeMS" size:19.0],
                                          NSKernAttributeName:@5.0};
NSString * string2 = @"Orange Background";
NSAttributedString * attributeText2 = [[NSAttributedString alloc]initWithString:string2 attributes:attributes2];
[label2 setAttributedText:attributeText2];
[self.view addSubview:label2];
```


---


## **二.Attributes属性**

进入`UIKit`的`NSAttributedString.h`看`Attributes`属性

```objc
/** 系统提供了这么多 */
NSFontAttributeName                   // 设置字体
NSParagraphStyleAttributeName         // 设置段落风格
NSForegroundColorAttributeName        // 设置文字颜色
NSBackgroundColorAttributeName        // 设置背景颜色
NSLigatureAttributeName               // 设置连体属性
NSKernAttributeName                   // 设置字符间距
NSStrikethroughStyleAttributeName     // 添加删除线
NSUnderlineStyleAttributeName         // 添加下划线
NSStrokeColorAttributeName            // 设置文字描边颜色
NSStrokeWidthAttributeName            // 设置文字描边宽度
NSShadowAttributeName                 // 设置阴影
NSTextEffectAttributeName             // 设置文本特殊效果
NSAttachmentAttributeName             // 设置文本附件
NSLinkAttributeName                   // 设置链接属性
NSBaselineOffsetAttributeName         // 设置基线偏移量
NSUnderlineColorAttributeName         // 添加下划线颜色
NSStrikethroughColorAttributeName     // 添加删除线颜色
NSObliquenessAttributeName            // 设置字体倾斜
NSExpansionAttributeName              // 设置文本扁平
NSWritingDirectionAttributeName       // 设置文字书写方向
NSVerticalGlyphFormAttributeName      // 设置文本段落排版格式
```

我们常把需要的属性放在字典中添加给字符串，使用方法看范例代码
下面我们看看这些属性都干了什么，常用的有：

---

### **1.设置字体** 
* NSFontAttributeName

```objc
NSFontAttributeName:[UIFont systemFontOfSize:(CGFloat)] // 字体大小
NSFontAttributeName:[UIFont fontWithName:(nonnull NSString *) size:(CGFloat)] // 字体名称，字体大小
```


### **2.设置段落风格**
* NSParagraphStyleAttributeName


### **3.设置字体和背景颜色**
* NSForegroundColorAttributeName、NSBackgroundColorAttributeName

```objc
NSForegroundColorAttributeName:[UIColor redColor]
NSBackgroundColorAttributeName:[UIColor greenColor]
```


### **4.设置字符间距** 
* NSKernAttributeName
* 正值间距加宽，负值间距变窄

```objc
NSKernAttributeName:@-1.0
```


### **5.添加删除线和下划线**
* NSStrikethroughStyleAttributeName、NSUnderlineStyleAttributeName

```objc
NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)
NSStrikethroughColorAttributeName:[UIColor redColor]
NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)
NSUnderlineColorAttributeName:[UIColor redColor]
```


### **6.设置文字描边颜色和宽度** 
* NSStrokeColorAttributeName、NSStrokeWidthAttributeName

```objc
/** 单独设置颜色无效果，需和描边宽度同时设置 */
NSStrokeColorAttributeName:[UIColor redColor]
NSStrokeWidthAttributeName:@3
```


### **7.设置阴影**
* NSShadowAttributeName
* 官方文档说明`NSShadowAttributeName`默认为空，需要一个`NSShadow`实例对象。

```objc
NSShadow * shadow = [[NSShadow alloc]init];
shadow.shadowBlurRadius = 5; // 模糊度
shadow.shadowColor = [UIColor grayColor];
shadow.shadowOffset = CGSizeMake(1, 3);
/** 使用时 */
NSShadowAttributeName:shadow
```

效果
![NSShadow](http://img.blog.csdn.net/20151019162331353)
`NSShadowAttributeName`也常和`NSVerticalGlyphFormAttributeName`、`NSObliquenessAttributeName`或`NSExpansionAttributeName`结合使用



### **8.绘制文本、设置字体倾斜、设置文本横向拉伸压缩属性**
* NSVerticalGlyphFormAttributeName、NSObliquenessAttributeName、NSExpansionAttributeName
* 对于`NSVerticalGlyphFormAttributeName`设置文本排版格式，0 表示横排文本。1 表示竖排文本。在 iOS 中，总是使用横排文本，0 以外的值都未定义。

```objc
NSVerticalGlyphFormAttributeName:@(0)
NSObliquenessAttributeName:@1
NSExpansionAttributeName:@1
```


### **9.设置连体属性** 
* NSLigatureAttributeName
* 0 表示没有连体字符，1 表示使用默认的连体字符，2 表示使用所有连体符号，默认值为 1（iOS 不支持 2）

Zapfino字体下：

```objc
NSLigatureAttributeName:@0,
NSLigatureAttributeName:@1,
```

对比一下：
![NSLigatureAttributeName1](http://img.blog.csdn.net/20151019172735196)
![NSLigatureAttributeName2](http://img.blog.csdn.net/20151019172758652)



### **10.设置文本特殊效果** 
* NSTextEffectAttributeName
* 取值为 NSString 对象，目前只有图版印刷效果可用

```objc
NSTextEffectAttributeName: NSTextEffectLetterpressStyle
```

上面是添加属性的label，下面是未添加属性的label
![NSTextEffectAttributeName](http://img.blog.csdn.net/20151019214153975)



### **11.设置链接属性**
* NSLinkAttributeName
* 点击后调用浏览器打开指定URL地址

```objc
NSLinkAttributeName:[NSURL URLWithString:@"http://www.baidu.com"]
```


### **12.设置基线偏移量** 
* NSBaselineOffsetAttributeName
* 正值上偏，负值下偏

```objc
NSBaselineOffsetAttributeName:@3
```


### **13.设置文本附件**
* NSAttachmentAttributeName
* 取值为NSTextAttachment对象,常用于文字图片混排

```objc
NSAttachmentAttributeName:id
```


### **14.设置文字书写方向** 
* NSWritingDirectionAttributeName
* 从左向右书写或者从右向左书写，取值：

```objc
@[@(NSWritingDirectionLeftToRight | NSTextWritingDirectionEmbedding)]
@[@(NSWritingDirectionLeftToRight | NSTextWritingDirectionOverride)]
@[@(NSWritingDirectionRightToLeft | NSTextWritingDirectionEmbedding)]
@[@(NSWritingDirectionRightToLeft | NSTextWritingDirectionOverride)]
```

使用：

```objc
NSWritingDirectionAttributeName:@[@(NSWritingDirectionRightToLeft|NSWritingDirectionOverride)]
```

![NSWritingDirectionAttributeName](http://img.blog.csdn.net/20151019221353739)



---


## **三.UIFont字体选择**
创建并且返回一个指定字体类型和大小的字体对象，fontName指定字体集的名字和风格（例如宋体，楷书等这一类型的），fontsize设置字体的大小。

```objc
+ (nullable UIFont *)fontWithName:(NSString *)fontName size:(CGFloat)fontSize;  
```

字体参考详见[字体](http://www.tuicool.com/articles/yQVVru)

