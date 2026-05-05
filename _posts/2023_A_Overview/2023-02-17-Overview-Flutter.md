---
layout: post
title: "Flutter"
date: 2023-02-17
tag: Overview
---





## 目录


- [Flutter 与 跨平台(#content1)   


## <a id="content1">Flutter 与 跨平台</a>

#### **一、Flutter 介绍**     

**Flutter 是 Dart 语言书写的跨平台框架**    

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

















----------
>  行者常至，为者常成！


