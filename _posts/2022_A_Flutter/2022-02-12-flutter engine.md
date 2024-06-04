---
layout: post
title: "12 flutter engine"
date: 2022-02-12
tag: Flutter
---


## 目录
- [介绍](#content1) 
- [depot_tools](#content2) 




<!-- ************************************************ -->
## <a id="content1">介绍</a>

**一、介绍** 

app.framework 就是dart代码

Flutter.framework 就是引擎，很多大公司的二开比如热更新，就是在这个framework的基础上进行的  

引擎在flutter sdk中的位置    
/opt/flutter/bin/cache/artifacts/engine/ios/Flutter.xcframework/ios-arm64/Flutter.framewor 

查看当前的engine的版本    
/opt/flutter/bin/internal/engine.version    

**二、编译流程**   

1、下载代码引擎源码：使用.gclient进行管理         

2、构建xcode工程：使用gn构建         

3、编译xcode工程产生引擎产物：使用ninjia编译(首次耗时，后续编译是增量编译)

4、配置项目代码：找到Generated.xcconfig文件   
FLUTTER_ENGINE=你存放引擎代码的路径/engine/src    
#使用的引擎对应版本（这里是iOS-debug模式下-模拟器的版本）    
LOCAL_ENGINE=ios_debug_sim_unopt    


编译好之后的源码：    
<img src='/images/flutter/flutter4.png' style="width:600px;">
<img src='/images/flutter/flutter3.png' style="width:600px;">


引擎挂载不成功原因？    
观察工程配置项文件内的文件路径是否正确      
如果不正确，可以使用Androidstudio重新操作一遍    




<!-- ************************************************ -->
## <a id="content2">depot_tools</a>


**一、depot_tools 是做什么用的？**   

是一组由 Google 提供的工具，用于管理和构建大型、多仓库代码库。    
它包括多个脚本和工具，帮助开发者在处理复杂的依赖关系、版本控制和代码同步时更为高效。     
以下是 depot_tools 的一些主要功能和组件：

1、gclient：    
gclient 是 depot_tools 中的一个核心工具，用于管理多仓库项目的依赖和同步。   
它解析包含项目依赖配置的文件（如 solutions 列表），并自动克隆或更新指定的仓库。   
gclient 还处理 DEPS 文件中的依赖项，使得项目的依赖关系清晰且易于管理。    

创建一个.gclient文件，文件内容如下
```json
solutions = [
    {
        "managed": False,
        "name": "src/flutter",
        "url": "git@github.com:flutter/engine.git@6bc433c6b6b5b98dcf4cc11aff31cdee90849f32",
        "custom_deps": {},
        "deps_file": "DEPS",
        "safesync_url": "",
    },
]
```
在.gclient目录下，执行 gclient sync  就会clone 仓库 fluter/engine,并fetch项目flutter/engin下的DEPS文件内的所有依赖

2、gn (Generate Ninja)：   
gn 是一个生成构建文件的工具，用于将项目的构建描述转换为 Ninja 构建系统使用的文件。    
它比传统的 gyp 构建系统更快、更灵活，适合大型项目的需求。    

3、ninja：     
虽然 Ninja 本身不是 depot_tools 的一部分，但它与 gn 配合使用。    
Ninja 是一个关注速度的小型构建系统，特别适用于大型项目的快速增量构建。    

除了以上还有其它工具和组件      




----------
>  行者常至，为者常成！


