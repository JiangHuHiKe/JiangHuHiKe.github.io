---
layout: post
title: "layoutSubviews"
date: 2018-02-06
tag: Objective-C
---

- [参考文章：setNeedsLayout VS layoutIfNeeded](https://www.jianshu.com/p/58f53e600a94)
- [参考文章：[译] 揭秘 iOS 布局](https://juejin.cn/post/6844903567610871816)
- [参考文章：runloop 与 布局](https://juejin.cn/post/6936385830185336869)








## 目录
* [介绍](#content1)
* [调用时机](#content2)
* [setNeedsLayout](#content3)
* [layoutIfNeeded](#content4)
* [总结](#content5)





<!-- ************************************************ -->
## <a id="content1">介绍</a>

```objc
-(void)layoutSubviews;
```

子类可以根据需要重写这个方法，以执行更精确的子视图布局。

<span style="color:red;font-weight:bold;">initWithFrame:是在初始化时拿到的frame，如果初始化完成之后，父view的size发生了变化，需要对当前view及其子view重新布局就需要重写layoutSubviews方法，并在其中根据情况进行布局</span>

你可以使用你的实现直接设置子视图的框架矩形。

不应该直接调用这个方法。

如果你想强制一个布局更新，在下一次绘图更新之前调用setNeedsLayout方法。

如果您想立即更新视图的布局，请调用layoutIfNeeded方法。


<!-- ************************************************ -->
## <a id="content2">调用时机</a>

  
自身被添加到父view上的时候会调用,自身被移除时不会调用
    
自身的x和y改变的时候不会调用,大小改变的时候会调用

添加或移除子view的时候会调用

更改子view的x和y时不会调用,更改子view的大小的时候会调用

思考：单纯的移动不会引起布局的递归更改，但改变大小有可能引起布局的递归更改，是否是这个原因？

<span style="color:red;font-weight:bold">仅仅改变父视图或子视图的位置并不会引起整个视图层次结构的重新布局,所以不会调用layoutsubviews。简单点说就是位置改变还不至于引起重新布局</span>    


<!-- ************************************************ -->
## <a id="content3">setNeedsLayout</a>


```
[self setNeedsLayout];
NSLog(@"xxx");

打印日志如下：
xxx
-[TestView layoutSubviews]
```

从打印日志可以看出，[self setNeedsLayout];调用后是<span style="color:red;font-weight:bold;">立即返回的，而不是等到layoutSubviews调用后再返回的</span>

setNeedsLayout用于<span style="color:red">标记</span>视图需要布局，但并不立即进行布局更新，而是等待下一个运行循环。

这个方法通常在你改变了视图的约束或者其他影响布局的属性后调用，以通知系统在适当的时机重新计算并更新布局。

```objc
// 修改视图约束或其他影响布局的属性
myView.widthConstraint.constant = 100
myView.setNeedsLayout()
```

**思考：为什么不立即更新而是在下一个运行循环更新？**    

1、不立即更新是为了收集多个布局请求，然后一次执行提高效率    

2、避免冗余计算，比如一个布局将width增加了10，另一个布局将size减少了10，放到最后一次执行的话就不需要改变size,如果立即执行的话就会改变两次size    

3、UI的更新是在收到runloop的kCFRunLoopBeforeWaiting通知时开始处理的。为什么不在当次runloop收到kCFRunLoopBeforeWaiting通知时进行呢？    
虽然在即将休眠时统一进行更新理论上是可行的，但这样做可能会导致在某些情况下的性能问题，尤其是在需要大量布局更新的情况下。    
因此，通过将布局更新延迟到下一个运行循环，系统可以更有效地管理和执行这些更新任务。这种设计可以提高系统的整体性能，同时确保良好的用户体验。 
xy:当有大量布局更新时，在当次的runloop即将休眠时计算不完全。     


<!-- ************************************************ -->
## <a id="content4">layoutIfNeeded</a>

```  
//这里只是为了演示，手动设置一个刷新标记
[self setNeedsLayout];

[self layoutIfNeeded];
NSLog(@"xxx");

打印日志
-[TestView layoutSubviews]
xxx
```

从打印日志可以看出，layoutIfNeeded是在layoutSubviews执行后再返回的     

layoutIfNeeded是<span style="color:red;">有刷新标记时</span>就立即调用layoutSubviews。

```swift
@IBAction func animateButtonTapped(_ sender: Any) {
    // Update the width constraint
    myViewWidthConstraint.constant = 200
    
    // Animate the change
    UIView.animate(withDuration: 0.5) {
        // Call layoutIfNeeded to ensure immediate layout update within the animation block
        self.view.layoutIfNeeded()
    }
}
```

<!-- ************************************************ -->
## <a id="content5">总结</a>

**总的来说，setNeedsLayout和layoutIfNeeded通常一起使用，前者用于标记需要布局，后者用于确保立即进行布局更新。**


----------
>  行者常至，为者常成！


