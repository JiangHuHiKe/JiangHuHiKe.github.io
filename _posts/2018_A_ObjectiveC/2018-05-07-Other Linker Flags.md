---
layout: post
title: "Other Linker Flags"
date: 2018-05-07
tag: Objective-C
---


## 目录
- [一、other linker flags](#content1)
- [二、-Objc/-all_load/-force_load](#content1)



## <a id="content1">一、other linker flags</a>


Other Linker Flags 是 Xcode 中的一个编译选项，用于在编译项目时向链接器（linker）传递额外的命令行参数。链接器的作用是将编译生成的目标文件（object files）和依赖的库文件链接在一起，生成最终的可执行文件或库文件。


#### **一、Other Linker Flags 的用途**    

**1、指定库文件：**    
用来链接额外的静态库（.a 文件）或动态库（.dylib 文件、.framework 文件）。例如，如果你有一个名为 libAwesome.a 的静态库，你可能需要在 Other Linker Flags 中添加 -lAwesome（小写的 -l）来链接这个库。

**2、指定库路径：**     
使用 -L 选项可以指定搜索库文件的路径。例如，-L$(PROJECT_DIR)/libs 用于指定一个自定义库的路径。

**3、禁用某些默认行为：**    
你可以通过指定额外的标志来禁用或更改链接器的默认行为。例如，使用 -ObjC 标志来确保所有包含类别的方法被正确地链接。

**4、设置调试信息：**    
可以使用诸如 -g 这样的标志来包含调试信息，这在调试过程中非常有用。

**5、优化链接过程：**   
一些标志（如 -dead_strip）可以帮助去除未使用的代码，减少最终可执行文件的大小。


#### **二、常见的 Other Linker Flags**     
**1、-ObjC：**    
强制链接器加载所有 Objective-C 类和类别。对于 Objective-C 类别（category）扩展特别有用，因为默认情况下类别方法可能不会被加载。   

**2、-all_load：**     
强制加载库中的所有目标文件。与 -ObjC 类似，但作用更强，会加载库中所有的类和方法。

**3、-force_load：**     
类似于 -all_load，但允许你指定某个特定的静态库。  

**4、-L\<directory>：**     
添加库搜索路径。

**5、-l\<library>：**     
链接指定的库。

**6、-dead_strip：**      
删除未使用的代码，以减小生成文件的大小。

**7、-lz：**       
链接 zlib 压缩库。

## <a id="content2">二、-Objc/-all_load/-force_load</a>

<span style="color:red;">默认情况下，链接器只会加载静态库中直接使用的符号（类、方法等）。但是，Objective-C 的类别（Category这些方法不会被加载。</span>

理解 -ObjC、-all_load 和 -force_load 之间的区别，可以帮助你更好地控制如何将 Objective-C 类和类别（Categories）从静态库加载到你的应用程序中。
让我们详细讨论每个选项的作用及其使用场景，并通过例子说明它们的区别。

#### **一、-ObjC**
-ObjC 是一个链接器标志，告诉链接器在链接静态库时，加载所有的 Objective-C 类和类别（Categories）。   

**使用场景**   
如果你有一个静态库，其中包含一些 Objective-C 类别（Categories），并且你需要使用这些类别中的方法，但发现这些方法没有被链接进来（比如在运行时调用时崩溃，因为找不到方法），你可以使用 -ObjC 标志来强制加载所有 Objective-C 类别和类别方法。

<span style="color:red;font-weight:bold;">重要：如果一个库中某个类或者分类的方法没有被调用或者找不到，可以考虑是没有配置-ObjC的问题</span>     
<span style="color:gray;font-size:12px;font-style:italic;">提示：在研究swift混编时，通过协议的方式来达到不暴露oc代码给外部模块的目的，在oc的load方法内向中间类zoo注册类，发现oc的load方法不调用，始终找不到原因。后来配置了-Objc后解决了。xy：因为通过协议的方式oc类没有被直接使用所以链接时没有被加载进来</span>


#### **-all_load**    
-all_load 是一个更激进的标志，它会告诉链接器加载静态库中的所有对象文件，不论它们是否包含 Objective-C 代码。也就是说，不仅是 Objective-C 类和类别，所有的符号都会被加载。

**使用场景**   
-all_load会将所有的符号都加载进来，不只是OC类和类别，包括C语言等所有的。     
-all_load 常用于当你有多个静态库，并且你想确保它们所有的内容都被加载时使用。特别是，当你有一些 Objective-C 类或者类别的方法在多个库之间共享，或者你不确定哪些符号需要被加载时，可以使用这个选项。


#### **三、-force_load**    
-force_load 类似于 -all_load，但它允许你指定特定的静态库来强制加载。相比 -all_load，-force_load 更加精细化，只会对指定的库生效，不会对所有链接的库生效。

**使用场景**   
-force_load 用于你想要强制加载一个特定的静态库中的所有符号，而不是所有静态库。这样做可以避免使用 -all_load 时可能导致的多重定义（duplicate symbols）错误。

示例
假设你只有一个特定的静态库 libMyLibrary.a，你希望强制加载它的所有内容，而其他库不受影响：

```text
-force_load $(PROJECT_DIR)/libs/libMyLibrary.a
```


#### **四、使用建议**   
如果你只需要加载类别方法，使用 -ObjC。    
如果你需要确保所有符号都被加载，使用 -all_load（谨慎使用，因为它可能会导致符号冲突）。   
如果你只需要对特定库强制加载，使用 -force_load，它比 -all_load 更加安全和灵活。   
理解这些标志之间的差异，能够帮助你在项目中更有效地使用静态库，避免常见的链接错误。    



----------
>  行者常至，为者常成！


