---
layout: post
title: "13 flutter channel"
date: 2022-02-13
tag: Flutter
---


## 目录
- [channel的创建](#content1) 
- [channel回调的实现](#content2) 
- [channel的codec](#content3) 





<!-- ************************************************ -->
## <a id="content1">channel的创建</a>

channel的创建需要两个参数    
name：channel的唯一标识    
binaryMessenger:消息信使，用于消息的接收和发送,可以传入FlutterViewController的实例        
```objc
+ (instancetype)methodChannelWithName:(NSString*)name
                      binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
```

调用到内部还有一个参数：codec    
<img src="/images/flutter/flutter5.png">


<!-- ************************************************ -->
## <a id="content2">channel回调的实现</a>

```objc
self.flutterInitChannel = [FlutterMethodChannel methodChannelWithName:@"syncData" binaryMessenger:self.engine.binaryMessenger];
[self.flutterInitChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
    __strong typeof(self) strongSelf = weakSelf;
    [[FZFlutterChannelManager sharedInstance] dispatchChannel:call result:result context:strongSelf];
}];
```

调用过程如下：   
<img src="/images/flutter/flutter6.png"><br>
<img src="/images/flutter/flutter9.png"><br>
<img src="/images/flutter/flutter8.png"><br>
<img src="/images/flutter/flutter7.png"><br>

本质是：   
name做为key,handler被包裹一层后做为value，存储在一个map里边。   
后续可以根据key获取到handler。      



<!-- ************************************************ -->
## <a id="content3">channel的codec</a>

**一、两种编解码器**             
FlutterMessageCodec       
二进制和oc对象的编解码       
<img src="/images/flutter/flutter10.png"><br>     

FlutterMethodCodec           
Methodcodec     
Call和二进制的编解码     
<img src="/images/flutter/flutter11.png"><br>     

**二、解码器的核心是读和写**   
<img src="/images/flutter/flutter12.png"><br>     
<img src="/images/flutter/flutter13.png"><br>     
跨平台的数据都要变成二进制    
写的时候先写标志位再写数据     
<img src="/images/flutter/flutter14.png"><br>     

读的时候先读标志位在读数据      
<img src="/images/flutter/flutter15.png"><br>     


----------
>  行者常至，为者常成！


