---
layout: post
title: "cocoaPods（六）：遇到的问题"
date: 2019-02-06
description: ""
tag: CocoaPods
--- 




## 目录
* [pod 常用命令](#content1)
* [使用的经验](#content2)
* [Cocoapods 私有库搭建和使用](#content3)
* [将公开库私有化](#content4)




rvm(ruby管理器) -> ruby(ruby环境) -> gem(包管理器) -> cocoapods <br>
cocoapods 用哪个gem安装的,就要用哪个gem进行更新和卸载


<!-- ************************************************ -->
## <a id="content1"></a> pod 常用命令

1、安装完成后查看pod版本
```
pod --version
```

2、查看pod有哪些命令
```
pod 或者 pod --help
```

3、常用的命令
```
#init          Generate a Podfile for the current directory
pod init

# search        Search for pods
pod search AFN

# install       Install project dependencies according to versions from a Podfile.lock
pod install 

# update        Update outdated project dependencies and create new Podfile.lock
# 该指令会先更新本地的索引仓库
pod update

# setup         Set up the CocoaPods environment
pod setup

# repo          Manage spec-repositories
pod repo --help
```


<!-- ************************************************ -->
## <a id="content2"></a> 使用的经验


1、切换gem源
```
# 切换 Ruby Gem 源到 https://gems.ruby-china.com 主要是为了优化 Ruby Gem 工具和 Ruby 相关库的下载速度和稳定性，
# 对 CocoaPods 的影响非常有限
# https://rubygems.org/
# https://gems.ruby-china.com
gem sources --add https://gems.ruby-china.com
gem sources -r https://rubygems.org/
```

2、cocoapods的源
```
# CocoaPods 已不再推荐使用这个源 https://github.com/CocoaPods/Specs.git
# 推荐使用 https://cdn.cocoapods.org/ 不指定源的情况下,pod install 默认使用这个源
# pod repo 指令可以查看使用的所有的源
pod repo 
```


3、版本问题
```
#主工程最低支持版本 + pod工程最低支持版本 + podfile内指定的版本 要一致
#当编译不过去的时候可以检查下是否是版本问题
可以在pofile文件中统一所有target的最低支持版本,然后pod install
```


4、搜索一个三方库
```
在cocoapods的官网搜索:https://cocoapods.org/
pod search 搜索
```

<!-- ************************************************ -->
## <a id="content3"></a> Cocoapods 私有库搭建和使用



#### 一、原理
```
两个仓库:
一个三方仓库:存放podspec文件,这个文件用于描述三方库
一个三方库:源码仓库

三个文件
podspec
podfile
podfile.lock
```


#### 二、Cocoapods 私有库搭建
##### 1、创建索引仓库
```
    1.创建私有源仓库
        一个存放spec文件的git仓库，这个仓库可以存放多个pod的spec文件
        https://e.coding.net/lxy911/xyappmobilespec/XYAppMobileSpec.git

    2.将私有源仓库克隆到本地
        pod repo add XYAppMobileSpec https://e.coding.net/lxy911/xyappmobilespec/XYAppMobileSpec.git
        会在~/.cocoapods/repo目录下增加一个XYAppMobileSpec目录，
        存放的是各个pod的spec文件，spec文件是按tag整理的
        
    3.更新本地的源仓库
        pod repo update //更新所有的源仓库
        pod repo update XYAppMobileSpec // 更新特定的源仓库
```

##### 2、创建代码仓库
```
    1.创建一个新的pod组件
        pod lib create XYSRequest
        修改spec文件的基本信息
            说明配置，homepage配置，source配置
            组件版本配置
            在工程中将swift_version 设置成5,在podspec文件中也设置s.swift_version = '5'
            设置工程中的最低依赖版本

    2.代码仓库创建
        创建一个用于存放代码的仓库，关联本地仓库与远端仓库。注意:master分支和main分支的问题
        git remote add https://e.coding.net/lxy911/xysrequest/XYSRequest.git
        // 根据情况修改分支名
        git branch -M main
        git push -u origin main
        组件代码修改好后，提交到仓库

    3.打tag
        git tag '0.1.0' // tag一定要跟spec中指定的版本号一致
        git push --tags


    4.验证
        # 验证是否符合cocoapods规范
        pod lib lint
        验证完成之后会有提示:XYSRequest passed validation.

        # 验证文件podspec
        // 需要先推送tag才能验证过去，否则可能出现错误
        // 如果不先推送tag查找的是上个版本的spec文件
        pod spec lint   
        成功有提示:XYSRequest.podspec passed validation.


    5.推送到索引仓库
        # 将spec文件提交到远程索引仓库
        pod repo push XYAppMobileSpec XYSRequest.podspec

        # 成功后可以搜索下
        pod search XYSRequest
```


##### 3、验证报错问题

[参考文章：CocoaPods 私有库 pod lib lint 踩坑](https://www.jianshu.com/p/71c701649df6)


<span style="color:red;font-weight:bold">（1）在验证之前先保证工程能正常的编译和启动起来这样会减少后续验证的错误</span>

<span style="color:red;font-weight:bold">（2）在验证阶段会有很多警告导致验证失败，可以使用 --allow-warnings 忽略警告</span>
```shell
pod lib lint --allow-warnings
```

<span style="color:red;font-weight:bold">（3）在私有库A依赖了私有库B，使用 --sources 来指定私有源</span>
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

<span style="color:red;font-weight:bold">（4）遇到xcode返回错误，使用--verbose 来查看具体的问题</span>
```shell
- ERROR | [iOS] xcodebuild: Returned an unsuccessful exit code. You can use `--verbose` for more information.

#查看报错的具体问题，进行修改
pod lib lint --verbose
```

<span style="color:red;font-weight:bold">（5）未推送tag导致的错误</span><br>
在验证spec的时候xcode报找不到文件的错误，但实际工程中可以找到文件，并且工程可以跑起来。这个错报的莫名其妙。<br>
原因：podspec文件未打最新的tag并推送到远端，<span style="color:red;font-weight:bold">在验证spec的时候一定要先打tag并推送到远端后再验证</span><br>
否则会去找上一个版本进行spec lint导致莫名的错误
```
//在验证的时候一定要先打tag并推送到远端
pod spec lint 

```


#### 三、私有库的使用
在podfile文件中指定使用的版本，执行pod install 操作

会根据指定的版本找到索引仓库中对应的spec文件，根据spec文件的描述下载源码及其依赖库的源码




<!-- ************************************************ -->
## <a id="content4"></a> 将公开库私有化

一、以AFN为例，创建一个自己的AFNetworking仓库
```
https://e.coding.net/lxy911/xy-app-libs/AFNetworking.git
```

二、将官方的afn仓库同步到自己的仓库<br>
coding在仓库创建完成之后有对应的选项：从其它仓库同步


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



