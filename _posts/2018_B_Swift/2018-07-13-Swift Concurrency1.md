---
layout: post
title: "Swift Concurrency 1"
date: 2018-07-13
description: ""
tag: Swift
---


## 目录

* [Swift Concurrency 是什么](#content1)
* [为什么要有 Swift Concurrency](#content2)
* [举个小例子](#content3)


## <a id="content1">Swift Concurrency 是什么</a>


Swift Concurrency 是 Swift 从 5.5 开始引入的一套现代化并发模型，让我们用更安全、更直观的方式来写并发代码。   

它的核心有三部分：

**async/await**    
<span style="color:gray">用来写异步函数和等待异步结果。    
让异步代码像同步代码一样清晰。</span>

**Task & TaskGroup**  
<span style="color:gray">Task 用来创建并发任务。         
TaskGroup 用来同时启动多个任务，并等待它们全部完成。</span>

**Actor**    
<span style="color:gray">一种新的引用类型，保证数据在多线程访问时是安全的。         
用来解决“多线程共享数据的安全问题”（类似线程安全锁的升级版）。</span>


## <a id="content2">为什么要有 Swift Concurrency</a>

在 Swift Concurrency 之前，我们常用：   
GCD (DispatchQueue)：容易写出回调地狱（多层嵌套）。     
OperationQueue：结构化稍好，但还是容易出错。    

**Swift Concurrency 的优势：**        
✅ 用 async/await 让代码像同步一样直观。    
✅ 避免回调地狱，结构更清晰。    
✅ 有类型检查，编译器帮你保证线程安全。    
✅ 和 iOS UI 主线程（MainActor）结合紧密。    


## <a id="content3">举个小例子</a>

没有 Swift Concurrency 时（GCD 方式）：

```swift
DispatchQueue.global().async {
    let data = fetchData()
    DispatchQueue.main.async {
        label.text = data
    }
}
```

使用 Swift Concurrency：

```swift
Task {
    let data = await fetchData()
    await MainActor.run {
        label.text = data
    }
}
```

✅ 总结一句：         
**Swift Concurrency 是 一整套新的并发编程方案（async/await + Task + Actor），让多任务编程<span style="color:red">更直观</span>、<span style="color:red;">更安全</span>。**





----------
>  行者常至，为者常成！
