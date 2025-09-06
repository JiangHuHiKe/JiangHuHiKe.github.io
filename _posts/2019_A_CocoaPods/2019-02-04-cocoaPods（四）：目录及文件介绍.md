---
layout: post
title: "cocoaPods（四）：目录及文件介绍"
date: 2019-02-04
description: ""
tag: CocoaPods
---



## 目录
* [master与trunk](#content1)
* [podfile文件](#content2)
* [podspec文件](#content3)


## <a id="content1">master与trunk</a>

#### **一、master 与 trunk 的区别**   


#### **二、repos目录介绍**

repos目录位于~/.cocoapods/repos下

存放了各个三方库的源仓库，其中trunk是官方的源仓库，其它的是私有源仓库

```shell
$ ls ~/.cocoapods/repos

XYAppMobileSpec                    trunk
```



#### **三、trunk目录介绍**

trunk目录内的文件和文件夹

**all_pods.txt 文件**：这个文件列出了所有可用库的名称。它通常包含了所有库的清单，供CocoaPods使用。

**Specs 目录**：这个目录下存放了所有三方库的podspec文件,<span style="color:red;font-weight:bold">存放规则是按三方库名称的md5值进行排列的</span>

```shell
# -n 是一个选项参数，表示在输出时不添加换行符
$ echo -n "AFNetworking" | md5

a75d452377f3996bdc4b623a5df25820
```
在目录trunk/a/7/5 目录下就会找到AFNetworking这个三方库的podspec文件


## <a id="content1">podfile文件</a>

#### **一、文件示例**

```
# 这行代码使用 Ruby 的 require 语句来引入一个名为 "fzmultidev.rb" 的 Ruby 文件
# require 用于将其他 Ruby 文件引入当前文件，以实现代码复用、模块化、分离关注点和更好地组织代码。
# 这是 Ruby 中组织和管理代码的常见实践。
#require File.join(File.dirname(__FILE__),"fzmultidev.rb")
#require File.join(File.dirname(__FILE__),"update_flutter.rb")

# 这行代码指定了一个 CocoaPods 源，用于获取第三方库的依赖
# CocoaPods 使用这些源来查找和下载指定的第三方库。
#source 'git@gitlab-ce.emas-poc.com:EMAS-iOS/emas-specs-thirdpart.git'
#source 'git@gitlab-ce.emas-poc.com:EMAS-iOS/emas-specs.git'
#source 'ssh://git@ssh.gitlab.fzzqft.com:13122/xf2-app-libs/Specs.git'


# platform 是 CocoaPods 的 DSL 中的指令，不是 Ruby 的标准构建块。
# :ios 是 Ruby 中的 Symbol 数据类型，表示 iOS 平台。
# CocoaPods 的 Podfile 结合了 Ruby 语法和特定于 CocoaPods 的指令，用于配置 iOS 项目的依赖库和其他选项。
# 指定了你的 iOS 项目的目标平台和最低支持的 iOS 版本
platform :ios, '13.0'


# 这是一个用于开启 CocoaPods 使用动态库（frameworks）而不是静态库（libraries）的选项。
# 使用 CocoaPods 创建动态库可以减小最终应用的二进制大小，但有时可能会引入一些不兼容问题。
# 在需要时，你可以取消注释这行代码以启用动态库支持。
use_frameworks!


# 禁止 CocoaPods 输出警告信息
#inhibit_all_warnings!

# 返回当前目录的路径
#currentPath = Dir.pwd

# 如果不包含 "/DevelopmentPod" 则执行里边的代码
#unless currentPath.include? "/DevelopmentPod"
#  flutter_application_path = load_flutter_pod
#end


# 完整写法：install!('cocoapods', {:disable_input_output_paths => true, :deterministic_uuids => false})
# 哈希参数被传递给 install! 方法，用于配置 CocoaPods 安装选项。 Ruby 的语法允许最后一个参数是hash时可以省略花括号，
# 告诉 CocoaPods 使用名为 "cocoapods" 的插件
# :disable_input_output_paths => true：这是一个选项，它将 CocoaPods 安装时的输入输出路径禁用（true 表示启用这个选项）。这可能会对某些情况下的构建产生影响，通常是为了确保构建的一致性。
# :deterministic_uuids => false：这是另一个选项，用于控制生成的 UUID 是否是确定性的。如果设置为 false，则生成的 UUID 可能是不确定性的，否则（true）则生成的 UUID 是确定性的。这也是为了确保构建的一致性
#install! 'cocoapods', :disable_input_output_paths => true, :deterministic_uuids=>false

# AppIcon for iOS 11


# target 不是一个方法，而是 CocoaPods 的 DSL（领域特定语言）中的一个关键字
target 'LCClientDemo' do
    puts "lxy:target LCClientDemo do  end 执行了"
    # Comment the next line if you don't want to use dynamic frameworks
    use_frameworks!
    
    # 在 CocoaPods 中，pod 不是一个方法，而是一个命令，用于声明和指定要安装的依赖库。这是 CocoaPods 的 DSL（领域特定语言）的一部分，用于管理依赖关系。
    # pod '依赖库名称', '版本号'
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'KakaJSON'
    pod 'Alamofire',"4.9.1"
    pod 'SwiftyJSON'
    pod 'Kingfisher'
    pod 'MJRefresh'
end


# pre_install 回调方法
pre_install do |installer|
  # 执行一些自定义操作
  puts "lxy:pre_install do |installer|  end 执行了"
end




# post_install 回调方法
# 运行 pod install 或 pod update 命令来安装或更新项目的依赖库时，post_install 回调方法会在 CocoaPods 完成依赖库的下载和安装后被执行。
post_install do |installer|
    puts "lxy:post_install do |installer|  end 执行了"
    
    # Only allow NSLog in DEBUG build, for all Pods
    # Referenced from https://gist.github.com/krzyzanowskim/7690635
    # Pods-environment.h is no longer supported
    # 遍历了 CocoaPods 安装目录中的所有 .pch 文件，并在这些文件中添加了一些宏定义，以在非 DEBUG 构建（即发布构建）中禁用日志输出
    Dir.glob("#{installer.sandbox.target_support_files_root}/**/*.pch") do |item|
      #puts "lxy:item = #{item}"
      # 模式 "a" 表示以追加方式打开文件
      open(item, "a") do |file|
        # 向文件中添加多行文本
        file.puts <<~EOF
        // Disable logs
        #ifndef DEBUG
          #define NSLog(...)
        #endif
        EOF
      end
    end

    
    
    # 通过 installer 对象访问 CocoaPods 项目（.xcodeproj 文件）中的构建目标（target），然后对每个目标执行自定义操作
    installer.pods_project.targets.each do |target|
        
        puts "lxy:target = #{target.name}"
        
        
        # 禁用项目中 bundle 类型的构建目标的代码签名
        if target.respond_to?(:product_type) and target.product_type == "com.apple.product-type.bundle"
             target.build_configurations.each do |config|
               config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
             end
        end

        
        
        # build_configurations 构建配置项
        target.build_configurations.each do |config|
            
            
            #判断scheme
            if config.name.include?("Debug")
              config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)']
              #指定scheme的调试模式可见变量
              #不需要启用优化，以便进行更容易的调试
              config.build_settings['GCC_OPTIMIZATION_LEVEL'] = '0'
              #某些情况由于编译器不支持无法debug（可选）
              #构建仅针对当前活动的架构进行构建
              config.build_settings['ONLY_ACTIVE_ARCH'] = 'YES'
              config.build_settings['APPLICATION_EXTENSION_API_ONLY'] = 'NO'
            end

            
            
            
            # 升级xcode14后报错问题：https://developer.apple.com/forums/thread/728021
            # 错误：error in Xcode File not found: /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/arc/libarclite_iphonesimulator.a
            # 将每个target的最低版本设置为11.0
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
            

        end
        
    end
end
```


#### **二、属性解释**

```ruby
**use_frameworks!**    
使用framework 替代 static libraries    
使用时需要指定：:linkage，取值为 :static 或者 :dynamic`


target 'MyApp' do
  use_frameworks!
  pod 'AFNetworking', '~> 1.0'
end
      
      
target 'MyApp' do
  use_frameworks! :linkage => :dynamic
  pod 'AFNetworking', '~> 1.0'
end

target 'ZipApp' do
  use_frameworks! :linkage => :static
  pod 'SSZipArchive'
end
```



## <a id="content1">podspec文件</a>


#### **一、文件示例**

```ruby
Pod::Spec.new do |s|
  s.name             = 'XYUIKit'
  s.version          = '0.1.1'
  s.summary          = 'A Base UIKit of XYApp.'
  s.ios.deployment_target = '13.0'
end
```

#### **二、属性解释**


```ruby
**homepage**    
该pod的主页url
spec.homepage = 'http://www.example.com'
```


```ruby
**authors**   
代码库的作者们
spec.author = 'Darth Vader'

spec.authors = 'Darth Vader', 'Wookiee'

spec.authors = { 'Darth Vader' => 'darthvader@darkside.com',
                  'Wookiee'     => 'wookiee@aggrrttaaggrrt.com' 
               }
```


```ruby
**source**    
指定源代码的检索方式

spec.source = { :git => 'https://github.com/AFNetworking/AFNetworking.git',
                :tag => spec.version.to_s 
              }

spec.source = { :http => 'http://dev.wechatapp.com/download/sdk/WeChat_SDK_iOS_en.zip' }


# Using HTTP to download a file using a hash to verify the download. It supports sha1 and sha256.
spec.source = { :http => 'http://dev.wechatapp.com/download/sdk/WeChat_SDK_iOS_en.zip',
                :sha1 => '7e21857fe11a511f472cfd7cfa2d979bd7ab7d96' 
              }

```


```ruby
**platform**    
支持的平台，如果不写代表支持所有平台。    
当支持多个平台时，应在下面使用 deployment_target


spec.platform = :osx, '10.8'
spec.platform = :ios
```



```ruby
**deployment_target**     
为每个平台指定最小部署目标比如：

spec.ios.deployment_target = '6.0'
spec.osx.deployment_target = '10.8'
```


```ruby
**source_files**   
指定Pod的源代码文件


spec.source_files = 'Classes/**/*.{h,m}'

spec.source_files = 'Classes/**/*.{h,m}', 'More_Classes/**/*.{h,m}'

spec.ios.source_files = 'Classes/ios/**/*.{h,m}'

spec.osx.source_files = 'Classes/osx/**/*.{h,m}'
```


```ruby
**public_header_files**       
指定公共头文件,build setting - headers - public下   
并且会在生成的framwork内创建一个headers目录存在公共头文件           
如果未指定公共头文件，则 source_files 中的所有标头都被视为公共标头。


spec.public_header_files = 'Headers/Public/*.h'
```


```ruby
**exclude_files**   
不要包括指定的源码文件


spec.ios.exclude_files = 'Classes/osx'

spec.exclude_files = 'Classes/**/unused.{h,m}'
```


```ruby

**resource_bundles**    
用于指定一个或多个资源束（Resource Bundles）通常用于存储图片、xib 文件、本地化字符串等非代码文件。


spec.ios.resource_bundle = { 'MapBox' => 'MapView/Map/Resources/*.png' }

spec.resource_bundles = {
  # 生成一个MapBox的bundle
  'MapBox' => ['MapView/Map/Resources/*.png'],
   # 生成一个MapBoxOtherResources的bundle
  'MapBoxOtherResources' => ['MapView/Map/OtherResources/*.png']
}
```    

```ruby
**resource**    
指定的资源会被直接copy到client target下，xcode也不会对这些资源文件优化   
因此cocoapods官方建议使用resource_bundles



spec.resource = 'Resources/HockeySDK.bundle'

spec.resources = ['Images/*.png', 'Sounds/*']
```


```ruby
**frameworks**   
需要依赖的系统库



spec.ios.framework = 'CFNetwork'

spec.frameworks = 'QuartzCore', 'CoreData'
```

```ruby
**dependency**   
需要依赖的三方库    
官方建议使用~>来指定版本，提高Pod的兼容性    
:configurations => ['Debug'] 这是一个配置选项，表示该依赖关系仅在 Debug 模式下生效。



spec.dependency 'AFNetworking', '~> 1.0'

spec.dependency 'AFNetworking', '~> 1.0', :configurations => ['Debug']

spec.dependency 'AFNetworking', '~> 1.0', :configurations => :debug

spec.dependency 'RestKit/CoreData', '~> 0.20.0'

spec.ios.dependency 'MBProgressHUD', '~> 0.5'
```

```ruby
**static_framework**   
如果指定了使用use_frameworks!     
那么通过指定static_framework来使用静态framework



spec.static_framework = true
```






#### **三、其它**

```ruby
Pod::Spec 代表pod模块下的Spec类
初始化一个Spec的实例对象



Spec.new do |s| 

end
```

我们可以通过ruby代码把文件内容转为一个Spec的实例对象
```ruby
# 将podspec文件转为对象 Pod::Specification
def getPodSpec(podspecPath)
    # 读取 podspec 文件的内容
    podspecContent = File.read podspecPath        

    # 将 podspec 文件的内容解析为对象
    podspec = eval podspecContent

    # 如果解析后的对象是哈希类型，则转换为 Pod::Specification 对象
    if podspec.class == Hash
        podspec = Pod::Specification.from_json(podspecContent)
    end
    # 返回 podspec 对象
    return podspec
end


spec = getgetPodSpec(path)
name = spec.name
puts "name = #{name}"
```






----------
>  行者常至，为者常成！



