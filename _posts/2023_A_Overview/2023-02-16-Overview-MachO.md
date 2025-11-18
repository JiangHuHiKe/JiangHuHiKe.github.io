---
layout: post
title: "MachO"
date: 2023-02-16
tag: Overview
---





## 目录


- [静态库/动态库](#content1)   
- [MachO文件结构](#content2)   


## <a id="content1">静态库/动态库</a>

静态库是编译产物，.o文件的集合，没有经过链接阶段，也就是还没有分配地址。所以可以合并。

动态库是链接产物已经分配了地址，无法再合并。强行合并会有地址冲突，符号冲突。      
<span style="color:gray;font-size:12px;">
地址冲突：两个库的代码都期望从某个基准地址（例如 0x0）开始布局，合并后谁在前谁在后？它们的内部寻址会全部错乱。<br>
符号表冲突：两个独立的符号表被强行合并，同名符号无法共存。
</span>

在编译链接阶段只知道符号(未定义符号)，在运行时dyld通过@Rpath找到动态库并绑定真实地址。


## <a id="content2">MachO文件结构</a>


Mach-O    

Header:     
描述信息，比如cpu类型：arm64还是armv7，文件类型：可执行文件还是静态库、动态库

Load Commands     
哪些segment需要加载     
程序入口    
符号表    
签名信息     

Segment和section     
代码段     
数据段     



























----------
>  行者常至，为者常成！


