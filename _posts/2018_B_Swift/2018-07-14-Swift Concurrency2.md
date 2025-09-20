---
layout: post
title: "Swift Concurrency 2"
date: 2018-07-14
description: ""
tag: Swift
---


## 目录

* [async / await](#content1)
* [Task 与 TaskGroup](#content2)
* [actor 与 MainActor](#content3)


## <a id="content1">async / await</a>

#### **一、基本用法**

**async：**声明异步函数。表示该函数可能会挂起执行    

**await：**调用异步函数，等待结果。     

创建两个异步函数，用来模拟数据请求   

```swift
//模拟请求数据
func fetchData () async -> String {
    // 模拟异步延迟
    print("---发起了fetchData")
    try? await Task.sleep(nanoseconds: 1_000_000_000)
    return "数据加载完成"
}


// 模拟请求数据，可能抛错
func fetchData(from url: String) async throws -> String {
    guard url.hasPrefix("https") else {
        // 进入 guard 的 else 要么抛错，要么 return
        // guard 使主流程更清晰。错误情况单独列出，并结束函数
        
        
        // 抛错后就不在执行后边
        throw NetworkError.badURL
    }
    
    try await Task.sleep(nanoseconds: 200_000_000)
    print("---发起了fetchData(from:)")
    return "网络数据"
}

```

声明两个异步函数，但内部没有挂起逻辑

```swift
    
func test () async {
    print("test方法调用：\(Thread.current)")
}


// 这个是Request类下的实例方法
    
func test () async {
    print("Request().test方法调用：\(Thread.current)")
}

```



**调用异步函数**   

```swift
func loadData() async {
    // 位置1：
    let result = await fetchData()// 只是挂起任务，不会阻塞线程。
    // 位置2
    print(result)
}
```
位置1 和 位置2 可能在不同的线程执行


#### **二、异步函数结合错误处理**   

**继续向上抛错**   

```swift
func loadData2() async throws {
    let data = try await fetchData(from: "https://example.com")
    print(data)
}
```

**在当前函数捕获错误**   
```swift
func loadData3() async {
    do {
        let data = try await fetchData(from: "https://example.com")
        print(data)
    } catch {
        print("请求失败: \(error)")
    }
}
```

**try?会将错误转化为nil**    

```swift
func loadData4() async {
    let data = try? await fetchData(from: "https://example.com")
    print(data ?? "发生了错误")
}
```


#### **三、async/await 与线程**   

**async/await ≠ 多线程**   
它是任务挂起和恢复的机制，线程是系统资源，async/await 只是利用线程执行任务。

 **挂起任务不阻塞线程**    
当任务等待异步操作时，线程可以执行其他任务，提高资源利用率。    
挂起意味着：任务暂停，但当前线程可以去执行别的任务。    

 **恢复可能在同一线程，也可能不同线程**       
取决于调用上下文和 actor 限制（如 MainActor）。    

 **多线程和 async/await 可以结合使用**     
CPU 密集型操作可以在 Task.detached 或 DispatchQueue.global 上执行。   
IO 密集型操作用 async/await 可以避免线程阻塞。   

**跨类型调用时有一些区别**

跨类型 async 调用：调度器可能选择后台线程执行任务，即使没有真正挂起。

```swift
func loadData6 () async {
    await test()
    await Request().test()
}

日志输出如下：   
test方法调用：<_NSMainThread: 0x281d20580>{number = 1, name = main}
Request().test方法调用：<NSThread: 0x281d70600>{number = 5, name = (null)}
```


#### **四、优势**    
 
 代码更直观、像同步逻辑。

 避免了回调地狱。

 错误处理更清晰 (try/catch)


## <a id="content2">Task 与 TaskGroup</a>

await 只能出现在 异步上下文（async function） 里。

Task {} 也可以创建一个新的异步任务。

在 Swift 并发里，异步代码可以放在async function，也可以在一个任务（Task）里运行。  



#### **一、Task 基本用法**

Task 提供了异步环境，函数不需要再声明 async   
```swift
func taskUse1(){
    Task {
        do {
            let data = try await fetchData(from: "http://example.com")
            print(data)
        } catch {
            print("请求失败: \(error)")
        }
    }
}


// 也可以这么写
func taskUse1() {
    Task {
        let data = try? await fetchData(from: "http://example.com")
        print(data ?? "发生了错误")
    }
}

```

task.value 等待task执行完成，并获取结果     
```swift
func taskUse2() async {
    let task = Task {
        let data = try? await fetchData(from: "https://example.com")
        print(data ?? "发生了错误")
    }
    
    // 等待task执行完成，如果task内部没有返回任何值，那么data就是一个空的元祖
    let data = await task.value
    print(data) // ()
}


func taskUse2()  {
    let task = Task {
        return try? await fetchData(from: "https://example.com")
    }
    
    // 也可以用另一个Task来提供异步环境
    Task {
        // 等待task执行完成，如果task内部有返回值，那么data就是返回的值
        let data = await task.value
        print(data ?? "发生了错误")
    }
}
```

生命周期：这个 Task 是“分离任务”（detached from caller scope）。         
当创建它的函数返回了，这个 Task 仍然继续运行，直到完成或被取消。       
调度：由 Swift 并发运行时安排到合适的线程池执行。     

```swift
let task = Task {
   let data = try await fetchData(from: "http://example.com")
}
...
task.cancel()  // 取消任务

```

保存 Task 的引用，可以稍后取消它。<br>适合那种用户离开页面就不需要继续请求的场景。    


**指定优先级**

```swift
Task(priority: .high) {
    await doImportantWork()
}

```
常见优先级有：.high、.medium、.low、.background。   
调度器会尽量先安排高优先级任务。    


**和 Task.detached 的区别**   

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


#### **二、Task 并发**    

```swift
func taskUse4() async {
    let task1 = Task {
        let data = await fetchData()
        print(data)
    }
    
    let task2 = Task{
        let data = await fetchData()
        return data
    }
    
    let data1 = await task1.value // 无返回值 ()
    let data2 = await task2.value // 有返回值  
    // 两个任务都完成后会来到这里
    print(data1, data2) // () 数据加载完成
}
```



✅ 总结一句话：    
**Task {} 是在同步环境里开启一个新的异步任务，可以使用 await，并且可以指定优先级和控制生命周期。**       


#### **三、TaskGroup 基本用法**    

**TaskGroup 的执行机制**   

**1、进入作用域：**    
写 await withTaskGroup(of: T.self) { group in ... }，编译器建立一个“任务组作用域”。    

**2、添加任务：**    
调用 group.addTask { ... }，每个子任务都是独立的 Task，继承父任务上下文。    

**3、并行执行：**      
所有子任务会被调度器并行运行。    
子任务遇到 await 也会挂起，让调度器切换执行其他任务。      

**4、收集结果：**    
用 for await result in group 迭代子任务的返回值。    
结果返回顺序 不是添加顺序，而是 完成顺序。    
或者用 await group.next() 逐个取。    

**5、取消：**    
调用 group.cancelAll()，会给所有未完成的子任务打取消标记。    
子任务自己检查并响应。   

**6、作用域结束：**    
子任务如果都能正常完成，withTaskGroup 会 等待它们全部完成，然后再退出作用域。      
如果提前退出作用域（比如 throw 出去，或者 return 提前结束）：    
Swift 会对所有 还没完成 的子任务调用 取消（group.cancelAll()）。    
同时也会等待这些子任务响应取消（至少安全退出），然后才真正释放资源。    


基本用法1:并发执行，离开作用域后，所有任务结束           

```swift
func taskGroupUse () async {
    
    // Void.self 指示 子任务没有返回值
    await withTaskGroup(of: Void.self) { group in
        
        group.addTask {[weak self] in
            let data = await self!.fetchData()
            print(data)
        }
        
        
        group.addTask {[weak self] in
            let data = try? await self!.fetchData(from: "https://example.com")
            print(data ?? "发生了错误")
        }
        
        print("将要离开作用域")
        // 在离开作用域之前会等待子任务都完成
    }
    
    print("离开作用域")
    
    
    /**
     
     将要离开作用域
     ---发起了fetchData:<_NSMainThread: 0x282014400>{number = 1, name = main}
     ---发起了fetchData(from:):<_NSMainThread: 0x282014400>{number = 1, name = main}
     网络数据
     数据加载完成
     离开作用域
     
     */
}
```

基本用法2：子任务带返回值，统一获取返回结果
```swift
func taskGroupUse2 () async {
    await withTaskGroup(of: String.self) { group in
        group.addTask {[weak self] in
            let data = await self!.fetchData()
            print(data)
            return data
        }
        
        
        group.addTask {[weak self] in
            let data = try? await self!.fetchData(from: "https://example.com")
            print(data ?? "发生了错误")
            return data ?? "发生了错误"
        }

        
        // 遍历结果（顺序由完成时间决定）
        for await data in  group {
            //哪个先完成，先打印哪个
            print(data)
        }
        print("将要离开作用域")
    }
    
    print("离开作用域")
    
    
    /**
     ---发起了fetchData:<_NSMainThread: 0x281860680>{number = 1, name = main}
     ---发起了fetchData(from:):<_NSMainThread: 0x281860680>{number = 1, name = main}
     网络数据
     网络数据
     数据加载完成
     数据加载完成
     将要离开作用域
     离开作用域
     */
}
```

基本用法3：整合数据        
```swift
    func taskUse6 () async {
        let datas = await withTaskGroup(of: String.self) { [weak self] group in
            
            group.addTask {[weak self] in
                return await self!.fetchData()
            }
            
            group.addTask {[weak self] in
                return (try? await self!.fetchData(from: "https://example.com")) ?? ""
            }
                   
            // 对数据进行统一整合后返回     
            var temp = []
            for await data in group {
                temp.append(data)
            }
            return temp
        }
                
        for data in datas {
            print(data)
        }
    }
```

基本用法4：逐个取数据    
```swift
func taskUse7 () async {
    await withTaskGroup(of: String.self) { group in
        group.addTask {
            return await self.fetchData()
        }
        
        group.addTask {
            return (try? await self.fetchData(from: "http://example.com")) ?? "发生了错误"
        }
        
        
//            var data = await group.next()
//            print(data ?? "数据为空")
//            data = await group.next()
//            print(data ?? "数据为空")
//            data = await group.next()
//            print(data ?? "没有数据了")
        
        
        while group.isEmpty == false {
            var data = await group.next()
            print(data ?? "")
        }
    }
}

```



## <a id="content3">actor</a>

在 Swift 并发里，Actor 是一种保证“同一时间只允许一个任务访问其内部状态”的**类型**，避免数据竞争。    
可以理解成：一个 **带有隐式锁** 的对象。    
<span style="color:red;">xy：actor 是在多任务状态下保证数据安全的一种类型</span>


#### **一、基本用法**    

创建一个actor类型的对象   

```swift
 actor Counter {
    private var value = 0

    func increment() {
        value += 1
    }

    func getValue() -> Int {
        return value
    }
}
```



在多任务状态下使用，可以保证数据的读写安全
```swift
func actorUse()  async {
    let counter = Counter()
    await withTaskGroup(of: Void.self) { group in
        group.addTask {
            print(Thread.current)
            for _ in 1...1000 {
                await counter.increment()
            }
        }
        
        group.addTask {
            print(Thread.current)
            for _ in 1...1000 {
                await counter.increment()
            }
        }
    }
    
    let data = counter.getValue()
    print(data)
}


// 打印结果如下
<NSThread: 0x281928780>{number = 27, name = (null)}
<NSThread: 0x281924580>{number = 28, name = (null)}
2000
```

可以尝试下把 actor 改为 class，然后再在多任务状态下运行，我们会发现最终打印的结果小于等于2000     



#### **二、MainActor**    

MainActor 是 Swift 内置的一个 特殊 Actor。    
它表示 主线程上的执行环境。    
所有标记了 @MainActor 的方法/属性，都会保证在 主线程（主 Actor） 上执行。       
标记 类 / 结构体 后整个类里的方法都会在主线程执行。   


**标记函数**

即使你从后台调用，Swift 也会切换到主线程再执行。

```swift
@MainActor
func showData() async {
    let result = await fetchData()  // fetchData 可能在后台执行
    label.text = result             // 但这里保证在主线程更新 UI
}

```



**标记类 / 结构体**    
整个类里的方法都会在主线程执行。       
很适合标记 UIViewController、ViewModel 等和 UI 相关的对象。   

```swift
@MainActor
class Counter2 {
    private var value = 0

    func increment() {
        value += 1
    }

    func getValue() -> Int {
        return value
    }
}
```

```swift

func actorUse2 () async {
    let counter2 = Counter2()

    await withTaskGroup(of: Void.self) { group in
        group.addTask {
            print(Thread.current)
            for _ in 1...1000 {
                await counter2.increment()
            }
        }
        
        group.addTask {
            print(Thread.current)
            for _ in 1...1000 {
                await counter2.increment()
            }
        }
    }
    
    let data = counter2.getValue()
    print(data)
    
}

// 打印结果如下
<NSThread: 0x280cde3c0>{number = 27, name = (null)}
<NSThread: 0x280ccc2c0>{number = 3, name = (null)}
2000
```

#### **三、切换到主线程**    

```swift
func actorUse3 () {
    Task.detached {
        print(Thread.current)
        await MainActor.run {
            print(Thread.current)
        }
    }
}

// 打印结果如下
<NSThread: 0x280e2e880>{number = 4, name = (null)}
<_NSMainThread: 0x280e68400>{number = 1, name = main}
```

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
#### **四、和 GCD 的对比**    

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


如果这么写就是正常的
```swift
func actorUse4() {
    let counter2 = Counter2()
    counter2.increment()
}
```

如果这么写编译器就会报错，因为 increment 是在 MainActor 上执行的，不能在后台调用    
```swift
func actorUse4() {
    let counter2 = Counter2()

    Task.detached {   // 👈 这里是后台 Task，不在主线程
        counter2.increment()  // ❌ 编译错误：MainActor 隔离的函数不能在这里调用
    }
}
```

修改后
```swift
func actorUse4() {
    let counter2 = Counter2()

    Task.detached {   
        await counter2.increment()
    }
}
```



----------
>  行者常至，为者常成！
