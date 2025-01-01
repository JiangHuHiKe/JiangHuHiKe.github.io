---
layout: post
title: "新项目去除storyboard"
date: 2018-07-10
description: ""
tag: Swift
---


## 目录

* [介绍](#content0)



## <a id="content0">如何去除</a>

删除 Main.storyboard 文件    
删除 info 下面的 Storyboard Name 条目     
<img src="/images/swift/swift_14.png">

再删除下面的条目    
<img src="/images/swift/swift_15.png">

代码创建窗口和根视图    
```text
func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    
    window = UIWindow(windowScene: windowScene)
    window?.backgroundColor = UIColor.white
    
    let vc = ViewController()
    let navVc = UINavigationController(rootViewController: vc)
    window?.rootViewController = navVc
    window?.makeKeyAndVisible()
}
```




----------
>  行者常至，为者常成！
