---
layout: post
title: "cocoaPods（六）：遇到的问题建"
date: 2019-02-06
description: ""
tag: CocoaPods
---



## 目录
* [pod install 时报错](#content1)
* [私有库验证错误](#content2)
* [将公开库私有化](#content3)


## <a id="content1">pod install 时报错</a> 


#### **一、模拟器SDK引起的问题**

私有库添加CTMediator依赖后，报错   

```text
clang: error: SDK does not contain 'libarclite' at the path '.../libarclite_iphonesimulator.a'; 
try increasing the minimum deployment target
```

**问题原因**

CTMediator 是 Objective-C 库，使用 ARC，需要 libarclite 支持。

Xcode 14+ 模拟器 SDK 移动或优化了 libarclite 位置，低 Deployment Target（比如 iOS 8/9）会找不到它。

arm64 模拟器 上更严格，因为 M1/M2 Mac 模拟器默认使用 arm64，而 libarclite 不支持太低的 target。

总结：问题是最低 Deployment Target 太低导致模拟器 arm64 架构链接失败。

**解决办法**

提升并统一所有target的 Deployment Target 版本    

```Ruby
platform :ios, '11.0' # 所有 target 默认 iOS 11.0
use_frameworks!

target 'XYObject_Example' do
  pod 'XYObject', :path => '../'
  pod 'XYUIKit', :path => '../XYUIKit'
end

target 'AppTests' do
  inherit! :search_paths
end

# 如果 Podfile 中有很多 target，可以用 post_install 遍历修改 Deployment Target：
# 无论多少 target、Pod，都能统一 Deployment Target
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
    end
  end
end

```


#### **二、最低版本设置引起的问题**   

主工程最低支持版本 + pod工程最低支持版本 + podfile内指定的版本 要一致     
当编译不过去的时候可以检查下是否是版本问题    
可以在pofile文件中统一所有target的最低支持版本,然后pod install    

**解决方案**   
同上    




## <a id="content2">私有库验证错误</a>




[参考文章：CocoaPods 私有库 pod lib lint 踩坑](https://www.jianshu.com/p/71c701649df6)


#### **一、验证报错问题**

<span style="color:red;font-weight:bold">遇到xcode返回错误，可以使用--verbose 来查看验证的详细过程</span>
```shell
- ERROR | [iOS] xcodebuild: Returned an unsuccessful exit code. You can use `--verbose` for more information.

#查看报错的具体问题，进行修改
pod lib lint --verbose
```

#### **二、因为警告无法验证通过时**    

<span style="color:red;font-weight:bold">在验证之前先保证工程能正常的编译和启动起来这样会减少后续验证的错误</span>

<span style="color:red;font-weight:bold">在验证阶段会有很多警告导致验证失败，可以使用 --allow-warnings 忽略警告</span>
```shell
pod lib lint --allow-warnings
```

#### **三、因为未推送tag引起验证无法通过**   

<span style="color:red;font-weight:bold">未推送tag导致的错误</span><br>
在验证spec的时候xcode报找不到文件的错误，但实际工程中可以找到文件，并且工程可以跑起来。这个错报的莫名其妙。<br>
原因：podspec文件未打最新的tag并推送到远端，<span style="color:red;font-weight:bold">在验证spec的时候一定要先打tag并推送到远端后再验证</span><br>
否则会去找上一个版本进行spec lint导致莫名的错误
```
//在验证的时候一定要先打tag并推送到远端
pod spec lint 
```


#### **四、模拟器架构引起的问题**   

我有一个组件库XYUIKit，组件库依赖了CTMediator，我在 pod lib lint --allow-warnings 时报错

```text
The following build commands failed: Ld /Users/lixiaoyi/Library/Developer/Xcode/DerivedData/App-fobxblfxovnsfearudtzgekfdznk/Build/Intermediates.noindex/Pods.build/Release-iphonesimulator/CTMediator.build/Objects-normal/x86_64/Binary/CTMediator normal x86_64 (in target 'CTMediator' from project 'Pods') Building workspace App with scheme App and configuration Release
```


**问题原因分析**   

pod lib lint 的特点：

会用 Release 配置编译你的库，默认 模拟器 + x86_64 架构

如果依赖的 Pod（比如 CTMediator）没有完全支持模拟器 Release 架构，就会报 Ld x86_64 失败

lint 是临时工程，不会使用你的 Podfile 配置，所以 post_install 配置、EXCLUDED_ARCHS 等不会生效

所以你在本地项目能跑，但 pod lib lint 会失败。

**解决方案**   

```text
pod lib lint XYUIKit.podspec --allow-warnings --use-libraries --verbose --skip-tests
```

<span style="color:red;font-weight:bold">注意：pod lib lint 并不需要把组件在模拟器上完全能跑，只要能 解析 podspec、编译通过即可。</span>

**五、不确定，暂存**    

<span style="color:red;font-weight:bold">在私有库A依赖了私有库B，使用 --sources 来指定私有源</span>
```
 -> XYUIKit (0.1.0)
    - ERROR | [iOS] unknown: Encountered an unknown error (Unable to find a specification for `XYFoundation` depended upon by `XYUIKit`

You have either:
 * out-of-date source repos which you can update with `pod repo update` or with `pod install --repo-update`.
 * mistyped the name or version.
 * not added the source repo that hosts the Podspec to your Podfile.
) during validation.

# 解决办法
pod lib lint --allow-warnings --sources='https://e.coding.net/lxy911/xyappmobilespec/XYAppMobileSpec.git'
```


## <a id="content4">将公开库私有化</a> 

如果遇到公开库有问题，但是官方又没有发布新版本，这时我们自己可以将公开库私有化处理，然后自己维护一个修改后的版本等待官方更新       

一、以AFN为例，创建一个自己的AFNetworking仓库
```
https://e.coding.net/lxy911/xy-app-libs/AFNetworking.git
```

二、将官方的afn仓库同步到自己的仓库<br>
coding在仓库创建完成之后有对应的选项：从其它仓库同步    
若没有对应选项，可以在sourceTree 内直接替换远程仓库的地址     


三、编辑spec文件
将仓库切换到对应的tag
修改podspec文件的source选项为自己的git仓库地址

四、将spec文件推送到自己的索引仓库

五、在工程中使用私有化的afn<br>
在podfile文件中如果指定了私有源，则优先使用私有源中的afn<br>
如果存在多个私有源都存在afn，那么文件前面的私有源优先级高<br>

PS:<br>
<span style="color:red;font-weight:bold;">如果确定spec文件没问题，但执行pod repo push 总是不成功，可以将文件直接copy到私有仓库内直接推送到远端</span>

----------
>  行者常至，为者常成！



