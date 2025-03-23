---
layout: post
title: "12 flutter engine"
date: 2022-02-12
tag: Flutter
---

[参考:Flutter混合栈管理方案对比](https://blog.csdn.net/holyli1134516796/article/details/136434006)


## 目录
- [介绍](#content1) 
- [depot_tools](#content2) 
- [引擎复用](#content3) 




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

## <a id="content3">引擎复用</a>

在 iOS 与 Flutter 的混合工程中，每次 push 一个新的 Flutter 页面可能导致内存泄漏的问题在早期版本中确实存在。   
这些内存泄漏主要源于每次创建新的 FlutterEngine 实例，导致内存占用逐渐增加。  

为了解决这些问题，业界提出了多种引擎复用方案，以下是其中两种主要方案的详细流程：    

#### **一、多引擎实例方案**   

Flutter 2.0 引入了 FlutterEngineGroup，允许创建多个共享资源的引擎实例，以减少内存占用。

```objc
#import "FlutterEngineManager.h"

@interface FlutterEngineManager()
@property (nonatomic, strong) FlutterEngineGroup *engineGroup;
@end



@implementation FlutterEngineManager
// 静态变量，保存单例实例
static FlutterEngineManager *_sharedInstance = nil;

// 单例的共享实例方法
+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}


// 重写 init 方法，确保外部不能直接调用 init 创建实例
- (instancetype)init {
    self = [super init];
    if (self) {
        // 初始化私有变量
        self.engineGroup = [[FlutterEngineGroup alloc] initWithName:@"engine_group" project:nil];
    }
    return self;
}


-(FlutterEngine*)makeEngineWithEntrypoint:(NSString*)entrypoint initialRoute:(NSString*)initialRoute{
    // 使用引擎组
    FlutterEngine *engine = [self.engineGroup makeEngineWithEntrypoint:entrypoint
                                                            libraryURI:nil //
                                                          initialRoute:initialRoute];
    [engine run];
    
    //
//    FlutterEngine *engine = [[FlutterEngine alloc] initWithName:entrypoint];
//    [engine runWithEntrypoint:entrypoint libraryURI:nil initialRoute:initialRoute];
    
    return engine;
}
@end
```
使用创建的引擎
```objc
+ (instancetype)viewControllerWithRouterName:(NSString *)routerName params:(nullable NSDictionary *)params {
    FlutterEngine *flutterEngine = [[FlutterEngineManager shared] makeEngineWithEntrypoint:@"main" initialRoute:routerName];
    TestFlutterViewController *viewController = [[self alloc] initWithEngine:flutterEngine nibName:nil bundle:nil];
    [GeneratedPluginRegistrant registerWithRegistry:viewController];
    return viewController;
}
```

**优点：**     
多个引擎实例共享资源，减少内存占用。

**Flutter Framework 代码（Dart 代码的 JIT/AOT 代码）**    
多个 FlutterEngine 可以共享同一份已编译的 Flutter Framework 代码（Dart 代码已编译成机器码），避免<span style="color:red;">重复加载多份</span>。   

**Flutter 插件的 Native 代码**   
例如 iOS 上的 Objective-C/Swift 插件代码，在多个 FlutterEngine 间是共享的，不会<span style="color:red;">重复加载多份</span>。    

**Dart VM（虚拟机）**    
所有 FlutterEngine 共享同一个 Dart 虚拟机（Dart VM），避免每次创建新引擎时<span style="color:red;">重复初始化</span> Dart VM，从而降低内存消耗。    

**图片缓存**     
Flutter 的 ImageCache 可能会在多个 FlutterEngine 之间共享相同的缓存，从而减少重复加载相同的图片资源。    



**缺点：**    
每个引擎实例仍有独立的 Dart Isolate，数据不共享，可能增加开发复杂度。   


**二、单引擎复用方案**   

<span style="color:red;">单引擎复用方案先做了解</span>

在该方案中，整个应用只创建一个全局共享的 FlutterEngine 实例，所有的 Flutter 页面都复用这个引擎，以减少内存开销。

**实现步骤**      
1、初始化一个全局的 FlutterEngine 实例并运行。        
2、创建 FlutterViewController： 在需要展示 Flutter 页面时，使用全局的 FlutterEngine 实例创建 FlutterViewController。    

**优点：**     
减少内存占用，避免每次创建新引擎导致的内存增长。

**缺点：**    
需要确保在适当的时机清理资源，避免内存泄漏。   


----------
>  行者常至，为者常成！


