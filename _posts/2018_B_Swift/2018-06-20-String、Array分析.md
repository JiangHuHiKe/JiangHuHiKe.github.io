---
layout: post
title: "13、String、Array分析"
date: 2018-06-20
description: ""
tag: Swift
---


## 目录
* [字符串分析](#content1)
* [数组分析](#content2)
* [补充内容](#content3)



<!-- ************************************************ -->
## <a id="content1"></a>字符串分析

```swift
/// 一、字符串分析
func stringAnaly(){
    

    //1、长度小于等于15的字符串存储于str的内存中
    do{
        print("-------1-------")
        var str:String = "0123456789ABCDE"
        print(Mems.size(ofVal: &str))  //16
        print(Mems.ptr(ofVal: &str))   //0x00007ffeefbff5c0
        
        /**
         0x3736353433323130 0xef45444342413938
         后8个字节 的 ef e代表字符串的类型 f代表字符串的长度
         */
        print(Mems.memStr(ofVal: &str))
    }

    
    
    // 2、长度大于15的字符串位于常量区（常量区的内存在编译时分配，程序运行时无法更改）
    do{
        print("-------2-------")
        var str = "0123456789ABCDEF"
        print(Mems.size(ofVal: &str))   //16
        print(Mems.ptr(ofVal: &str))    //0x00007ffeefbff5b0
        print(Mems.memStr(ofVal: &str)) //0xd000000000000010 0x800000010004f400
        /**
         0x00000010004f400 + 0x20 是存储字符串的内存地址 位于常量区
         (lldb) memory read/8xg 00000010004f420
         0x10004f420: 0x3736353433323130 0x4645444342413938
         0x10004f430: 0x0000000000000000 0x0000000000000000
         0x10004f440: 0x732d2d2d2d2d2d2d 0x2d2d2d2d2d337274
         0x10004f450: 0x3433323130002d2d 0x0000003938373635
         */
    }
    

    //3、append后长度仍小于等于15的字符串 仍位于变量的内存
    do{
        print("-------3-------")
        var str = "0123456789"
        str.append("A")
        print(Mems.size(ofVal: &str))   //16
        print(Mems.ptr(ofVal: &str))    //0x00007ffeefbff5a0
        print(Mems.memStr(ofVal: &str)) //0x3736353433323130 0xeb00000000413938
    }


    
    //4、append前长度小于等于15，append后长度大于15的字符串 会存储于堆空间
    do{
        print("-------4-------")
        var str = "0123456789ABCDE"
        print(Mems.size(ofVal: &str))   //16
        print(Mems.ptr(ofVal: &str))    //0x00007ffeefbff3a0
        print(Mems.memStr(ofVal: &str)) //0x3736353433323130 0xef45444342413938
        
        print("-------------")
        
        str.append("FG")
        print(Mems.size(ofVal: &str))   //16
        print(Mems.ptr(ofVal: &str))    //0x00007ffeefbff3a0
        print(Mems.memStr(ofVal: &str)) //0xf000000000000011 0x0000000101005880
        /**
         0x0000000101005880 + 0x20 是存储字符串的内存地址 位于堆空间
         (lldb) memory read/8xg 0x00000001010058a0
         0x1010058a0: 0x3736353433323130 0x4645444342413938
         0x1010058b0: 0x3736353433320047 0x0000000000000000
         0x1010058c0: 0x0000000000000000 0xe0000000101005c0
         0x1010058d0: 0x6c36313025780002 0x0002000000000078
         */
    }
    
    
    //5、append前长度大于15位于常量区（只读，不可写），append后 会存储于堆空间
    do{
        print("-------5-------")
        var str = "0123456789ABCDEFG"
        print(Mems.size(ofVal: &str))   //16
        print(Mems.ptr(ofVal: &str))    //0x00007ffeefbff390
        print(Mems.memStr(ofVal: &str)) //0xd000000000000011 0x80000001000843f0
        
        print("-------------")
        
        str.append("HI")
        print(Mems.size(ofVal: &str))   //16
        print(Mems.ptr(ofVal: &str))    //0x00007ffeefbff390
        print(Mems.memStr(ofVal: &str)) //0xf000000000000013 0x0000000100707490
    }
}
```

#### **二、ChatGPT解释**

在Swift中，字符串的存储方式取决于它的长度和内容。Swift中的字符串有两种基本的存储方式：栈上存储和堆上存储。

**栈上存储**： 对于较短的字符串，Swift 会尝试将其存储在栈上。栈上存储的字符串具有值类型的性质，因此对于小型字符串，它们可以被快速创建和销毁。

**堆上存储**： 当字符串的长度超过一定阈值（通常是小于等于16个字符），或者字符串包含特殊字符或者需要额外的编码时，Swift 会将字符串存储在堆上。堆上存储允许更灵活的字符串长度，但它需要额外的内存管理。

在堆上存储的字符串实际上是通过一个指向实际字符数据的引用计数机制来管理的。这种方式允许多个字符串变量共享相同的字符数据，<span style="color:red;font-weight:bold">直到其中一个变量被修改，此时才会进行实际的复制。</span>这有助于提高性能和节省内存。

总的来说，Swift 根据字符串的长度和内容智能地选择存储方式，以便在性能和内存使用之间取得平衡。


#### **三、字符串和子串的关系**    

```text
let greeting = "Hello,world!"
let index = greeting.firstIndex(of:",")??greeting.endIndex
let beginning = greeting[..<index]
//beginning的值为“Hello”
//把结果转化为String以便长期存储
let newString = String(beginning)
```
<img src="/images/swift/swift_10.webp" style="width:500px;">

Swift编译器优化了字符串使用的资源，实际上拷贝只会在确定需要的时候才进行
```text
    var str = "0123456789abcdef"
    var str1 = str
    print(str == str1) // true
    
    str += "ghi"
    print(str)//0123456789abcdefghi
    print(str1)//0123456789abcdef
    print(str == str1)//false
```

<!-- ************************************************ -->
## <a id="content2"></a>数组分析


```swift
/// 二、数组分析
func arrayAnaly() -> Void {
    var arr:Array = [1,2,3,4]
    print(Mems.size(ofVal: &arr))   //8
    print(Mems.ptr(ofRef: arr))     //0x00000001007988d0
    print(Mems.memStr(ofRef: arr))
    /**
     
     变量 arr占用8个字节
     内存放的是一个地址0x00000001007988d0 该地址指向堆空间
     该堆空间放置的是数组的内容

     
     8
     0x00000001007988d0
     
     0x00007fff90063cc0 //暂时未知
     0x0000000200000002 //引用计数
     0x0000000000000004 //数组大小
     0x0000000000000008 //数组的容量 动态 会随着数组大小而发生变化
     //下面放置的是数组的内容
     0x0000000000000001 0x0000000000000002 0x0000000000000003 0x0000000000000004

     
     以上分析：可知Array在底层其实是引用类型 但实际使用时是结构体 行为上是值类型 本质是引用类型
     只是苹果隐藏了这一层
     */
}
```

<!-- ************************************************ -->
## <a id="content3"></a>补充内容

**一、内存分布**

<img src="/images/swift/swift13_0.png" alt="img">


**二、启动过程**

<img src="/images/swift/swift13_1.png" alt="img">



----------
>  行者常至，为者常成！
