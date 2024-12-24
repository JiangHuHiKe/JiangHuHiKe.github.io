---
layout: post
title: "Mac 中 Flutter环境配置"
date: 2012-02-13
tag: 其它
---

## 目录
- [环境配置流程](#content1) 
- [遇到的问题](#content66) 



## <a id="content1">环境配置流程</a>



在配置flutter环境之前，先配置好xcode环境 和 Android Studio环境，这两个配置好之后flutter的环境配置会顺利很多。    

**下载flutter SDK**    

```text
//将仓库克隆到合适的目录下
git clone https://github.com/flutter/flutter.git
```
**切分支**   

切换分支到 stable,这是最新的稳定版本。       
如果想使用特定版本，请将 stable 分支 reset 到指定的tag处即可。    
<span style="color:gray;font-size:12;font-style:italic;">注意：不要直接选中tag，然后checkout，这样后面在flutter doctor时会有警告提示，未在官方channel上</span>    

**设置环境变量**     

```text
#Dart配置
export PATH=$PATH:/Users/lixiaoyi/FlutterSDK/flutter_flutter/bin/cache/dart-sdk/bin


# Flutter 国内镜像
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn


# Flutter 拉取下来的flutter_flutter/bin目录
export FLUTTER=/Users/lixiaoyi/FlutterSDK/flutter/bin
#export FLUTTER=/Users/lixiaoyi/FlutterSDK/flutter_flutter/bin
export PATH=$FLUTTER:$PATH


# Flutter 相关Url配置
export FLUTTER_GIT_URL=https://github.com/flutter/flutter.git
#export FLUTTER_GIT_URL=https://gitee.com/openharmony-sig/flutter_flutter.git
```

**检查是否配置成功**   

```text
// 查看flutter 版本
flutter --version

// 环境诊断,如果有问题请根据提示进行修复    
flutter doctor 
flutter doctor -v  
```


## <a id="content66">遇到的问题</a>

**Xcode配置引起的问题**    

执行flutter doctor时，报 xcrun:error 是因为xcode得命令行工具找不到。指定下位置即可。     
```text
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer/
```

**Android Studio配置引起的问题**    

执行flutter doctor时，报红提示找不到 java runtime ,并且 Android Studio 报错 Unable to find bundled Java version.

```text
╰─ flutter doctor   
Doctor summary (to see all details, run flutter doctor -v):
The operation couldn’t be completed. Unable to locate a Java Runtime.
Please visit http://www.java.com for information on installing Java.
The operation couldn’t be completed. Unable to locate a Java Runtime.
Please visit http://www.java.com for information on installing Java.
[✓] Flutter (Channel stable, 3.7.12, on macOS 15.2 24C101 darwin-arm64, locale zh-Hans-CN)
The operation couldn’t be completed. Unable to locate a Java Runtime.
Please visit http://www.java.com for information on installing Java.
[✓] Android toolchain - develop for Android devices (Android SDK version 34.0.0)
[✓] Xcode - develop for iOS and macOS (Xcode 16.2)
[✓] Chrome - develop for the web
[!] Android Studio (version 2024.2)
    ✗ Unable to find bundled Java version.
[✓] Connected device (2 available)
[✓] HTTP Host Availability

! Doctor found issues in 1 category.
```

搜索资料后发现没有配置 JAVA_HOME 环境变量，配置了 JAVA_HOME 环境变量后执行 flutter doctor  
<span style="color:gray;font-size:12;font-style:italic;">注意：.zshrc文件内配置了下面两项时 echo $JAVA_HOME 无法输出内容</span>    
```text
export PATH="$HOME/.jenv/bin:$PATH"

// 注释掉该行，echo $JAVA_HOME 才生效
# eval "$(jenv init -)"
```

但注释之后运行flutter doctor，只是少了 找不到 java runtime 的错误提示，但 Android Studio 仍然报错     
```text
╰─ flutter doctor 
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.7.12, on macOS 15.2 24C101 darwin-arm64, locale zh-Hans-CN)
[✓] Android toolchain - develop for Android devices (Android SDK version 34.0.0)
[✓] Xcode - develop for iOS and macOS (Xcode 16.2)
[✓] Chrome - develop for the web
[!] Android Studio (version 2024.2)
    ✗ Unable to find bundled Java version.
[✓] Connected device (2 available)
[✓] HTTP Host Availability

! Doctor found issues in 1 category.
```

将flutter sdk 切换到最新版本flutter doctor就不会报错，所以怀疑是不是 最新下载的Android Studio 和 老版本的flutter sdk不兼容。     
后来搜索资料，发现一篇文章下面的评论内提到一个方法尝试了下解决了。     

在应用程序内找到 Android Studio 右键打开包内容      
在content目录下 创建一个jre文件夹       
将jbr目录下的所有内容拷贝一份到jre文件夹内       
重启终端执行 flutter doctor 然后就成功了。     

<img src="/images/Other/3.png">

<span style="color:red;font-weight:bold;">后续研究研究这两个文件夹的作用。</span>



----------
>  行者常至，为者常成！


