---
layout: post
title: "cocoaPods（三）：私有库创建"
date: 2019-02-03
description: ""
tag: CocoaPods
---





## 目录
* [私有pod库创建](#content1)
* [私有pod库索引库创建](#content2)
* [私有库使用](#content3)
* [私有库更新](#content4)
* [spec文件](#content5)





## <a id="content1">私有pod库创建</a>

#### 一、创建流程   

```
#1 github 或者 gitlab 等 创建一个仓库 用来存储工程文件
https://github.com/JiangHuHiKe/XYUIKit.git


#2 创建pod私有库的项目工程      
在合适的目录下执行 pod lib create 命令 按提示输入需要的内容
创建名字叫XYUIKit的私有库项目
pod lib create XYUIKit   


#3 添加文件并更新   
在目录 ../XYUIKit/XYUIKit/Classes下 删除"ReplaceMe.m"文件
在目录 ../XYUIKit/XYUIKit/Classes下 添加LCCategory文件夹，内包含UIColor+Category.h UIColor+Category.m文件
在目录 ../XYUIKit/Example下执行 pod install  更新Example项目中的pod 出现提示成功字样 该步完成


#4 修改podspec文件并验证   
找到XYUIKit.podspec文件 进行修改   
在XYUIKit.podspec所在目录下执行 
pod lib lint 
进行验证 出现成功字样 该步完成



    
#5 将本地项目文件上传到远程私有库中 并 校验spec
在XYUIKit工程目录下执行：
$ git remote add origin https://github.com/JiangHuHiKe/XYUIKit.git
$ git add .
$ git commit -m "Initial XYUIKit"
$ git push -u origin master
$ git tag 0.1.0     //tag 值要和podspec中的version一致
$ git push --tags   //推送tag到服务器上

在XYUIKit.podspec所在目录下执行    
pod spec lint 
校验spec 出现成功提示该步完成，出现错误重新执行该步骤
```

#### 二、验证介绍

**1、pod lib lint 验证什么**     

**本地验证：**            
它会在本地新建一个临时工程，把你写的 .podspec 文件引入进去，然后尝试编译。    

**检查点：**    
.podspec 格式是否合法（字段齐全，类型正确）。    
.source_files 指向的文件是否存在。    
Swift/OC 混编是否能编译通过。    
是否能在不同平台（iOS/macOS 等）编译通过（取决于你 s.platform 设置）。    
是否需要 use_frameworks!/static_framework 等特殊配置。    

**⚠️ 注意：**     
pod lib lint 不会拉取远程仓库，它只依赖你当前目录下的源码。        
这意味着即使 .source 写的 Git 地址不可访问，它也能通过。       


**2、pod spec lint 验证什么**     

**远程验证：**     
它会去 .podspec 的 s.source 指定的 Git 地址，拉取对应 tag 的代码，并做和 pod lib lint 类似的编译检查。    

**因此必须保证：**        
仓库可访问（公开或私有仓库 + 认证成功）。     
tag 存在并和版本号对应。    


**3、总结**     

本地开发阶段 → 用 pod lib lint，快速验证 podspec 正确性和能否编译。     
准备发布到私有/公共仓库 → 用 pod spec lint，确保远程源码也能被别人 clone 并正常编译     



## <a id="content2">私有pod库索引库创建</a> 


```
#1 github创建一个仓库 用来作为索引库
这个仓库存放了我们创建的组件的XYUIKit.podspec文件    
https://github.com/JiangHuHiKe/XYAppMobileSpec.git


#2 将索引仓库克隆到 ~/.cocoaPods/repos目录下
XYAppMobileSpec 指定索引库在本地的名字，在~/.cocoaPods/repos下就可以看到
pod repo add XYAppMobileSpec https://github.com/JiangHuHiKe/XYAppMobileSpec.git


#3 建立关联
将XYUIKit.podspec添加到~/.cocoaPods/repos/XYAppMobileSpec目录下，并推送到远程     
在目录XYUIKit.podspec所在目录下执行：
pod repo push XYAppMobileSpec XYUIKit.podspec 

```



## <a id="content3">私有库使用</a> 


```
#1 开始集成前可先搜索
pod search XYUIKit


#2 更新索引库
pod repo update XYAppMobileSpec


#3 新建工程的根目录下执行
pod init


#4 修改Podfile文件如下
source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/JiangHuHiKe/XYAppMobileSpec.git'
target 'podUsageTest' do
#use_frameworks!
platform :ios, '9.0'
pod 'MJExtension'
pod 'XYUIKit'
end


#5 集成
pod install
当我们执行pod install的时候就会先在本地的~/.cocoaPods/repos/XYAppMobileSpec中查找
如果没有就会去索引库更新到本地     
```



<!-- ************************************************ -->
## <a id="content4">私有库更新</a> 



```
#1 添加文件并更新
添加完成后
在目录 ../XYUIKit/Example下执行 pod install  更新Example项目中的pod 出现提示成功字样 该步完成

    
#2 修改 XYUIKit.podspec文件
找到XYUIKit.podspec文件 进行修改 s.version的值
在目录 ../XYUIKit下执行pod lib lint 进行验证 出现成功字样 该步完成


#3 推送到远程并更新tag
git add .
git commit -m "your message"
git push
git tag 0.1.1   //tag值要与s.version一致
git push --tags //

在目录../XYUIKit下执行：
pod spec lint //有警告的话可以加上 --allow-warnings 来忽略警告
校验spec 出现成功提示该步完成，出现错误重新执行该步骤


#4 更新本地索引库
pod repo push XYAppMobileSpec XYUIKit.podspec

```



<!-- ************************************************ -->
## <a id="content5">spec文件</a> 

**一、文件说明**

- [参考文章：podspec文件介绍](https://www.jianshu.com/p/a23397065e40)

```
name：框架名
version：当前版本（注意，是当前版本，假如你后续更新了新版本，需要修改此处）
summary：简要描述，在pod search ZCPKit的时候会显示该信息。
description：详细描述
homepage：页面链接
license：开源协议
author：作者
source：源码git地址
platform：支持最低ios版本
source_files：源文件（可以包含.h和.m）
public_header_files：头文件(.h文件)
resources：资源文件（配置的文件都会被放到mainBundle中）
resource_bundles：资源文件（配置的文件会放到你自己指定的bundle中）
frameworks：依赖的系统框架
vendored_frameworks：依赖的非系统框架
libraries：依赖的系统库
vendored_libraries：依赖的非系统的静态库
dependency：依赖的三方库
```


**二、子模块**

- [参考文章：https://www.jianshu.com/p/6bb4980a8af6](https://www.jianshu.com/p/6bb4980a8af6)
- [参考文章：https://www.jianshu.com/p/e990bce53431](https://www.jianshu.com/p/e990bce53431)
- [参考文章：http://blog.wtlucky.com/blog/2015/02/26/create-private-podspec/](http://blog.wtlucky.com/blog/2015/02/26/create-private-podspec/)

```
#该行会影响子目录的文档结构 要与subspec配合使用
s.source_files = 'XYUIKit/Classes/**/*'

s.subspec 'TestC' do |testc|
testc.source_files = 'Test/TestC/*.{h,m}'
end

s.subspec '目录名字' do |别名-小写字母|
别名.source_files = '文件路径'
end
```


注意点
```
1、如果搜索某个仓库找不到或没有反应
    移除~/.cocoapods/repos/trunk文件夹后尝试
    
    如不行更新本地索引库
    pod repo update
 
    如果还是失败 移除以下文件
    rm ~/Library/Caches/CocoaPods/search_index.json 
    参考文章：
    https://blog.csdn.net/conglin1991/article/details/55096422?utm_source=blogxgwz9
    https://www.jianshu.com/p/9add72f11df6
    
2、理解CocoaPods的Pod Lib Create
    https://www.jianshu.com/p/4685af9dd219
    
3、pod lib lint出错
    https://www.jianshu.com/p/6bc293da596c
    https://blog.csdn.net/adadadadadadad40/article/details/87805144

4、私有库xxx.podspec文件相关
    https://juejin.im/post/5b04e26bf265da0b83371a9c
    
5、执行指定的
    pod 'lklZFWxSDK', :path => '../'
```







----------
>  行者常至，为者常成！



