---
layout: post
title: "Swift Concurrency 2"
date: 2018-07-14
description: ""
tag: Swift
---


## 目录

* [Task](#content1)
* [actor](#content2)


## <a id="content1">Task</a>

在 Swift 并发里，所有异步代码都必须在一个任务（Task）里运行。

Task {} 就是最简单的方式：创建一个新的异步任务。

await 只能出现在 异步上下文（async function） 里。

#### **一、基本用法**

```swift
Task {
    // 这里可以安全写 await
    let user = try await fetchUser(id: 1)
    print(user)
}
```

生命周期：这个 Task 是“分离任务”（detached from caller scope）。         
当创建它的函数返回了，这个 Task 仍然继续运行，直到完成或被取消。       
调度：由 Swift 并发运行时安排到合适的线程池执行。     

```swift
let task = Task {
    await fetchUser(id: 1)
}
...
task.cancel()  // 取消任务

```

保存 Task 的引用，可以稍后取消它。<br>适合那种用户离开页面就不需要继续请求的场景。    


#### **二、指定优先级**

```swift
Task(priority: .high) {
    await doImportantWork()
}

```
常见优先级有：.high、.medium、.low、.background。   
调度器会尽量先安排高优先级任务。    


#### **三、和 Task.detached 的区别**   

```swift
Task {
    // 继承当前上下文（如 @MainActor）
}

Task.detached {
    // 完全独立，不继承任何 Actor 或优先级
}
```
一般用 Task {} 就够了；   
Task.detached 适合那种必须完全独立（不跟 UI/主线程挂钩）的后台任务。     

✅ 总结一句话：    
**Task {} 是在同步环境里开启一个新的异步任务，可以使用 await，并且可以指定优先级和控制生命周期。**       


## <a id="content2">actor</a>

在 Swift 并发里，Actor 是一种保证“同一时间只允许一个任务访问其内部状态”的**类型**，避免数据竞争。    
可以理解成：一个 **带有隐式锁** 的对象。    
<span style="color:red;">xy：actor 是在多线程状态下保证数据安全的一种类型</span>


#### **一、MainActor**    

MainActor 是 Swift 内置的一个 特殊 Actor。    
它表示 主线程上的执行环境。    
所有标记了 @MainActor 的方法/属性，都会保证在 主线程（主 Actor） 上执行。       
标记 类 / 结构体 后整个类里的方法都会在主线程执行。   


**标记函数**
```swift
@MainActor
func updateUI() {
    label.text = "Hello"
}
```

即使你从后台调用，Swift 也会切换到主线程再执行。

```swift
@MainActor
func showData() async {
    let result = await fetchData()  // fetchData 可能在后台执行
    label.text = result             // 但这里保证在主线程更新 UI
}

func fetchData() async -> String {
    "Hello"
}
```



**标记类 / 结构体**

```swift
@MainActor
class ProfileViewController: UIViewController {
    func refreshUI() {
        label.text = "User name"
    }
}
```
整个类里的方法都会在主线程执行。     
很适合标记 UIViewController、ViewModel 等和 UI 相关的对象。     

**切换到主线程**    

```swift
// 启动异步任务
Task {
    let data = await fetchData()
    
    // ⚠️ 注意：这里我们可能在后台线程
    // 所以需要切换到主线程更新 UI
    await MainActor.run {
        label.text = data
    }
}
```
**和 GCD 的对比**    

以前我们写：

```swift
DispatchQueue.main.async {
    label.text = "Hello"
}
```
在 Swift 并发里，更推荐写：
```swift
await MainActor.run {
    label.text = "Hello"
}
```
**区别：**        
GCD 是“裸奔”的队列调度，<span style="font-weight:bold;">编译器</span>不知道它做了啥。   
@MainActor 是 <span style="clor:red;font-weight:bold;color:red;">类型系统</span> 的一部分，编译器能检查你是否在错误的线程访问UI，从而 <span style="font-weight:bold;color:red;">编译时报错</span>（比运行时更安全）。    





----------
>  行者常至，为者常成！
