---
layout: post
title: "Flutter"
date: 2023-02-17
tag: Overview
---





## 目录


- [Flutter 与 跨平台](#content1)   
- [三棵树](#content2)   


## <a id="content1">Flutter 与 跨平台</a>

#### **一、Flutter 介绍**     

**Flutter 是 Dart 语言书写的跨平台框架**    

<img src="/images/flutter/flutter2.png" style="width:66%;">

**主要分为三层**       
1、Framework 框架层         
程序员编写的dart代码，通过构建widget来创建UI，在iOS中dart代码编译后就是App.framework。    

2、Engine 引擎层    
Dart运行时 + 绘制渲染 + 平台通道 + 事件处理(比如触摸)。

3、Embedder 嵌入层      
Flutter 最终渲染、交互是要依赖其所在平台的操作系统 API，嵌入层主要是将 Flutter 引擎 ”安装“ 到特定平台上。    


#### **二、跨平台总结**    

**1、H5**   
优点：web技术栈社区资源丰富 + 动态化。        
缺点：对于复杂界面和动画性能一般 + 系统能力需要借助JSBridge。   

**为什么H5的性能一般？**           
WebView 拥有独立的浏览器内核(webkit)。     
页面渲染需要通过WebCore对HTML/CSS进行解析，形成DOM树 - 渲染树 - 图层合成 - 叠加到原生窗口。    
JS需要通过JSCore进行解释执行(词法分析 - 语法分析 - 语义分析 - AST - 编译 等)     
所以H5得渲染链路极长，开销巨大。  
<span style="color:red;">H5的瓶颈在WebView</span>      

**2、JS + 原生渲染(Weex/RN)**     
优点：采用web技术栈 + 动态化较好 + 原生渲染(性能比H5好点)          
缺点：依赖原生控件外观可能不一致，不同平台的控件需要单独维护，并且当系统更新时，社区控件可能会滞后 + 频繁拖动会卡顿(js通讯压力大)。    

**Weex原理**    
(1) 开发者写：Vue/JS/CSS 代码。               
(2) Weex 内部的 JS Framework，将 代码转化为中间代码，类似JSON。               
(3) JSBridge 通知 Native。          
(4) Native创建原生控件，完成渲染。                
<span style="color:red;">Weex的瓶颈在JS通讯<span>            

**3、自绘UI + 原生(Flutter)**    
优点：自会引擎性能高 + 外观一致 + 生态越来越成熟             
缺点：动态化不足        


## <a id="content2">三棵树</a>

在Flutter渲染的流程中，有三棵重要的树，Widget树，Element树，Render树    

**Widget树(Widget对象)**     
UI描述，定义了UI的结构和配置。轻量级，每次build都会创建新的。              
<span style="color:gray;font-size:12px;">
自身不变化使用StatelessWidget。比如 Text，用来展示文字，自身没有状态。      
自身变化使用StatefulWidget。比如 Image,需要展示未加载，加载中，加载失败，自身有状态需要自更新。          
</span>

**Element树(Element对象)**      
Element对象是widget对象和renderObject对象之间的桥梁。     
widget对象和element对象是一一对应的(element对象持有 widget/state 对象)。         
当重新build，widget对象发生变化时，Element树会比较新旧Widget，决定是更新还是重建。并通知Render树做相应绘制。       

**Render树(Render对象)**    
直接与底层渲染引擎（如Skia）交互。                   
负责处理布局（Layout）、绘制（Paint）和命中测试（Hit Testing）。  
<span style="color:gray;font-size:12px;">
RenderImage绘制图片到屏幕上。    
RenderParagraph绘制文本到屏幕上。    
RenderBox绘制矩形到屏幕上。      
⚠️ 注意：不是每个 Widget 都有 RenderObject。     
</span>    








----------
>  行者常至，为者常成！


