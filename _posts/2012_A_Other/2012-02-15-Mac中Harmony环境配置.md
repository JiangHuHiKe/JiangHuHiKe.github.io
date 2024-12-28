---
layout: post
title: "Mac 中 Harmony 环境配置"
date: 2012-02-15
tag: 其它
---

## 目录
- [环境配置流程](#content1) 



## <a id="content1">环境配置流程</a>


**1、下载**    
去鸿蒙官网下载 Deveco Studio 解压后安装

**2、配置鸿蒙相关的环境变量**    

```text
# 配置环境变量 (SDK, node, ohpm, hvigor)
export TOOL_HOME=/Applications/DevEco-Studio.app/Contents # mac环境
export DEVECO_SDK_HOME=$TOOL_HOME/sdk # command-line-tools/sdk
export PATH=$TOOL_HOME/tools/ohpm/bin:$PATH # command-line-tools/ohpm/bin
export PATH=$TOOL_HOME/tools/hvigor/bin:$PATH # command-line-tools/hvigor/bin
export PATH=$TOOL_HOME/tools/node/bin:$PATH # command-line-tools/tool/node/bin
export PATH=$TOOL_HOME/sdk/default/openharmony/toolchains:$PATH

# 配置 HOS_SDK_HOME
#export HOS_SDK_HOME=/Applications/DevEco-Studio.app/Contents/sdk
```

**3、配置SDK**   
在 preference - Appearance & Behavior - OpenHarmony SDK  
点击右侧的 edit 按钮，指定SDK的下载目录(选择默认就行)进行下载。     

**4、下载模拟器**   
在 状态栏选择设备的下拉菜单中，选择 device manager 按提示进行模拟器下载，安装目录选择默认即可。     






----------
>  行者常至，为者常成！


