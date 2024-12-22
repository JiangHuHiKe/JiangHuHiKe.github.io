---
layout: post
title: "Mac 中 Android Studio 配置"
date: 2012-02-12
description: ""
tag: 其它
---




## 目录
- [介绍](#content1)   
- [Android SDK 的安装](#content2)   
- [Android Studio 使用技巧](#content66)   


## <a id="content1">介绍</a>

#### **Android SDK（Software Development Kit）**    

Android SDK 是为开发 Android 应用所提供的一套工具和库。它包含了用于开发、构建、调试、测试和部署 Android 应用所需的所有工具和 API。SDK 提供了多种工具，包括命令行工具、模拟器、平台库等。    

主要作用：        
构建和编译应用：包含构建工具（如 build-tools）用于打包和构建 APK。       
调试应用：提供工具（如 adb）来与设备或模拟器交互，进行调试。        
管理 Android 平台：支持多种 Android 系统版本，开发者可以选择特定版本进行开发。       
开发支持：包括工具、库和 API，帮助开发者高效地创建 Android 应用。       

<span style="color:red;font-weight:bold;">Android SDK 是完整的开发套件</span>


#### **Cmdline-tools（命令行工具）**    

Cmdline-tools 是 Android SDK 中的一部分，专门为开发者提供命令行工具，允许通过命令行管理 SDK 和执行常见任务。   

主要作用：    
管理 SDK 组件：使用 sdkmanager 安装、更新或删除 SDK 组件。   
创建和管理虚拟设备（AVD）：使用 avdmanager 创建 Android 模拟器。    
与设备交互：通过 adb （Android Debug Bridge）进行调试、安装应用、查看日志等。    

<span style="color:red;font-weight:bold;">Cmdline-tools 是 Android SDK 中的一部分</span>


#### **为什么我安装了Android Studio并下载好了Android SDK，在sdk目录下并没有找到cmdline-tools目录**    

这是正常的，因为默认情况下，Android Studio 不会自动安装命令行工具（cmdline-tools）文件夹。

**安装方式一：**       
<img src="/images/Other/2.png">

<span style="color:red;font-weight:bold;">从这里可以看出，这里列出的选项对应sdk目录下面的文件夹</span>

**安装方式二：**    
可以去官网手动下载它。

下载解压后会得到一个名 cmdline-tools 文件夹，在文件夹内创建一个latest目录，并将所有的内容拷贝进这个目录    
<span style="color:gray;font-size:12;font-style:italic;">提示：不这么做在bin目录下执行 ./sdkmanager 相关指令时会报根目录相关的错误。</span>

<img src="/images/Other/1.png">


## <a id="content2">Android SDK 的安装</a>

#### **通过 Android Studio 安装**   
最简单的方式是通过安装 Android Studio，它包含了 Android SDK 和其他开发工具。        
在首次启动时，Android Studio 会提示你安装 Android SDK。如果你选择默认选项，SDK 会自动安装。      
默认的安装目录是：/Users/your_username/Library/Android/sdk     


#### **通过 cmdline-tools 安装**   

下载 cmdline-tools 并按文章上面提到的方式创建latest目录。    
手动创建目录:/Users/your_username/Library/Android/sdk  并将 cmdline-tools 拷贝到该目录下        
进入目录：/Users/your_username/Library/Android/sdk/cmdline-tools/latest/bin，执行下列命令手动安装SDK         
```text
// 32是版本，可以指定自己需要的版本
./sdkmanager "build-tools;32.0.0" "platforms;android-32" "platform-tools" 


// 如果还需要安装tools目录，可以接着执行下面的命令
./sdkmanager "tools"
```

#### **设置环境变量**    

在 ~/.zshrc文件中设置环境变量   
```text
# Android 环境配置
export ANDROID_HOME="/Users/your_username/Library/Android/sdk"
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
```

验证是否安装成功
```text
adb --version

android --version 
```



## <a id="content66">Android Studio 使用技巧</a>

**字体大小设置**     
Settings - Editor - Font     

**编辑器右边有个线怎么去掉,见下图**    
Settings - Editor - Appearance  
找到右边的：Show hard wrap and visual guides 选项进行关闭   

**如何设置自动换行**   
Settings -> Editor -> General   
找到右边的 soft wraps 下的 Soft-wrap these files 选项进行打开    

**双栏设置**      
window -> Editor tabs -> split right


**查找替换**      
全局搜索快捷键：Ctrl + Shift + R    
页面内搜索快捷键 ：Ctrl + F   
替換快捷鍵 ：Ctrl + R   

**显示前进后退按钮**   
view - appearance - Toolbar       
在最新版本的Android Studio中已经没有前进后退按钮了    



----------
>  行者常至，为者常成！


