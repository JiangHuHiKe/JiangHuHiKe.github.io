---
layout: post
title: "Flutter"
date: 2023-02-17
tag: Overview
---





## 目录


- [Flutter 与 跨平台](#content1)   
- [三棵树](#content2)   
- [重要方法](#content3)   
- [key](#content4)   
- [状态管理](#content5)   



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


## <a id="content2">三棵树及和渲染原理</a>


#### **一、三棵树**    

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
当重新build，widget对象发生变化时，Element树会比较新旧Widget，决定是更新还是重建。并通知Render树只做必要更新。       

**Render树(Render对象)**    
直接与底层渲染引擎（如Skia）交互。                   
负责处理布局（Layout）、绘制（Paint）和命中测试（Hit Testing）。  
<span style="color:gray;font-size:12px;">
RenderImage绘制图片到屏幕上。    
RenderParagraph绘制文本到屏幕上。    
RenderBox绘制矩形到屏幕上。      
⚠️ 注意：不是每个 Widget 都有 RenderObject。     
</span>    


#### **二、渲染原理**      

**iOS 原生的流程（UIKit + CALayer）**

```text
[Object-C 代码]
↓
UIKit 生成 UIView Tree 【CPU】
↓
UIKit 创建并执行布局 (layoutSubviews) & 绘制 (drawRect) → CALayer Tree【CPU】
↓
UIKit（Core Animation） 收集 Layer Tree 快照，准备合成信息【CPU】
↓
UIKit（Core Animation） 将快照提交给系统的 Render Server（backboardd）【CPU】
↓
Render Server 利用 Metal 对Layer Tree进行图层合成 & 光栅化，将图像写入 CAMetalLayer 的 Framebuffer【GPU】
↓
VSync 到来时提交 Framebuffer 到 Display Controller
↓
屏幕刷新
```

**Flutter 的流程（FlutterView + CAMetalLayer）**

```text
[Dart 代码]
↓
Flutter Framework 构建 Widget Tree → Element Tree → RenderObject Tree 【CPU】
↓
Flutter Framework 的 RenderObject 执行布局 (layout) & 绘制 (paint) → Layer Tree 【CPU】
↓
Layer Tree 提交给 Flutter Engine（C++）【CPU → GPU】
↓
Flutter Engine 调用 Skia，光栅化 Layer Tree，渲染到 offscreen surface / framebuffer（离屏缓冲）【GPU】
↓
Flutter Engine 收到 VSync 信号将离屏内容提交给 FlutterView 的 CAMetalLayer 的 Framebuffer【GPU】
↓
VSync 到来时提交 Framebuffer 到 Display Controller
↓
屏幕刷新
```

## <a id="content3">重要方法</a>

**一、canUpdate**    
两个widget运行时类型相同 && key相同。    
返回ture，element树复用element节点(state也会复用)。   
返回false时，element树创建新的element节点替换旧的(state也会重新创建)。        

**二、didUpdateWidget**    
使用场景          
<span style="color:red;">父组件传入参数变化</span>，需要同步内部状态。     
<span style="color:gray;font-size:12px;">
比如：从父组件传入的参数发生变化，重新初始化数据(不能使用initState,只调用一次，element复用不会再次调用)。          
比如：从父组件传入的参数发生变化，重新请求数据。    
</span>

触发条件     
<span style="color:gray;font-size:12px;">
1、父 widget 触发 rebuild       
2、Flutter 复用旧 Element    
3、新 widget != old widget（配置发生变化）     
</span>

为什么不能用build？   
<span style="color:gray;font-size:12px;">
首先build的主要作用是重绘UI。另外build是是高频调用。        
更新时触发顺序：先调用didUpdateWidget 再调用 build。       
</span>


**三、didChangeDependencies**     
使用场景   
<span style="color:gray;font-size:12px;">
主题变化、字体变化、屏幕旋转。     
</span>

调用时机     
<span style="color:gray;font-size:12px;">
1、state第一次初始化时会调用。          
调用顺序：createState -> initState -> didChangeDependencies -> build     
2、当依赖的 Theme / MediaQuery / Locale / Provider发生变化时会调用。     
调用顺序：didChangeDependencies -> build     
</span>


## <a id="content4">key</a>

#### **一、LocalKey**    
<span style="color:gray;font-size:12px;">
在实际开发中，大部分不会传入key，是因为页面结构稳定。     
当页面结构稳定的时候，传入key会增加diff成本，比如需要创建映射的map。     
当页面结构不稳定的时候，需要传入key，否则会引起页面错乱。    
比如在index=0位置插入或删除widget，或者交换两个widget。所以动态列表一般要传入key。         
</span>

<span style="color:red;font-size:12px;">
Localkey的两个主要作用：        
canUpdate 方法中使用。     
按 key 创建 Map。    
</span>

#### **二、GlobalKey**    
<span style="color:red;font-size:12px;">
Globalkey的两个主要作用：        
跨层级获取state，比如在父widget中手动更新子widget(调用子widget中的state的方法)。     
获取widget的位置和大小。    
</span>


## <a id="content5">状态管理</a>

#### **一、InheritedWidget**    

ShareDataWidget extends InheritedWidget     
在页面最外层使用ShareDataWidget，整棵子树共享数据           
在子组件ShareDataChildWidget使用共享数据：ShareDataWidget.of(context)!.data        

<span style="color:gray;font-size:12px;">
传入context后，会沿着element树向上寻找ShareDataWidget     
然后建立 ShareDataWidget  和 ShareDataChildWidget 的映射关系    
当data发生变化时，会调用 ShareDataChildWidget 的 didChangeDependencies -> build 更新数据   
</span>












----------
>  行者常至，为者常成！


