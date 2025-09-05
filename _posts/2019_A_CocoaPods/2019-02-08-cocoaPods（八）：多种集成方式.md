---
layout: post
title: "cocoaPods（八）：多种集成方式"
date: 2019-02-08
description: ""
tag: CocoaPods
---






## 目录
* [集成方式](#content1)


## <a id="content1">集成方式</a> 

#### **一、版本集成**     

```ruby
pod 'AFNetworking'                     # 最新版本
pod 'AFNetworking', '~> 4.0'           # 兼容 4.x 最新版本
pod 'AFNetworking', '4.0.1'            # 指定具体版本
pod 'XYUIKit', '~> 0.2.0'
```

#### **二、从 Git 仓库地址 集成**

```ruby
最新主分支
pod 'AFNetworking', :git => 'https://github.com/AFNetworking/AFNetworking.git'

指定分支
pod 'AFNetworking', :git => 'https://github.com/AFNetworking/AFNetworking.git', :branch => 'develop'

指定tag
pod 'AFNetworking', :git => 'https://github.com/AFNetworking/AFNetworking.git', :tag => '4.0.1'

指定commit
pod 'AFNetworking', :git => 'https://github.com/AFNetworking/AFNetworking.git', :commit => '1a2b3c4d'

```

#### **三、从本地集成**    
```ruby
从 本地路径 集成
pod 'XYUIKit', :path => '../XYUIKit'

从 本地 .podspec 文件 集成
pod 'XYUIKit', :podspec => '../XYUIKit/XYUIKit.podspec'

```

#### **四、从 二进制 Framework/xcframework 集成**   
```ruby
如果三方库已经提供编译好的二进制：
pod 'Alamofire', :binary => true


通过 pod-binary 插件
plugin 'cocoapods-binary'
pod 'XYUIKit', :path => '../XYUIKit', :binary => true
```

#### **五、指定平台/配置/子模块**    
```ruby
指定某个 target：
target 'MyApp' do
  pod 'AFNetworking'
end


指定配置环境（只在 Debug 下安装）：
pod 'FLEX', :configurations => ['Debug']


子模块（subspec）：
pod 'AFNetworking/Serialization'

```

✅ 总结一下：     

**官方源** → pod 'xxx'    
**私有源** → 同上，只要先 pod repo add     
**Git** → :git + :branch|:tag|:commit    
**本地** → :path 或 :podspec    
**二进制** → :binary => true    


----------
>  行者常至，为者常成！



