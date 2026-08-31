---
layout: post
title: "flutter_riverpod"
date: 2022-02-24
tag: Flutter
---

## 目录
- [介绍](#content1) 





## <a id="content1">介绍</a>

**一、区分两个包**         
riverpod：纯 Dart 版本，无 Flutter 依赖，可在 Dart 命令行。         
flutter_riverpod：基于 riverpod，绑定 Flutter，提供 Widget 扩展，实际项目绝大多数用这个。    
flutter_riverpod 是 三方为Flutter提供的状态管理库，是 **Provider 的升级版**，    

**二、优缺点**   
**优点**    
<span style="color:red;">脱离 BuildContext，不依赖Widget，逻辑与UI分离。</span>             
单元测试友好，适合中大型项目。        
provider 之间可以灵活组合复用。          
自动内存回收，减少内存泄漏。        

**缺点**   
学习成本更高，概念多       
简单页面使用会增加样板代码    

**三核心概念**    

**1、ProviderScope**        
状态根容器，整个 Riverpod 的入口     
作用：存放所有 provider 的实例、缓存、状态；替代旧 provider 把状态挂在 Widget 树（InheritedWidget）的方式。
使用：必须包裹 MaterialApp；支持嵌套，实现局部状态隔离（弹窗、子页面独立状态）。    
注意：ProviderScope 以外无法访问任何 provider。     


**2、Provider（各类状态提供者）**    
Provider 是状态的定义声明，不是状态本身。    

|类型|	用途|
|Provider<T>  |	只读静态数据，工具实例、常量，不会变化|
|StateProvider<T>	|简单可变状态，基础类型 bool、int、String，简单表单|
|NotifierProvider<Notifier,T>|	复杂同步业务逻辑，封装修改状态的方法|
|AsyncNotifierProvider<AsyncNotifier,T>|	✅最常用，带异步逻辑（网络请求），返回AsyncValue<T>|
|FutureProvider<T>	|封装 Future，自动处理加载 / 错误，简单异步|
|StreamProvider<T>	|监听 Stream 数据流|


**3、Notifier / AsyncNotifier**    
业务逻辑封装载体，把状态修改逻辑从 Widget 抽离出去。     


**4、 Consumer / ConsumerStatefulWidget**
获取 ref 的两种 UI 组件    

**5、 Ref**     
操作状态的核心句柄，重中之重。               
不再依赖 BuildContext，所有读写、监听、失效都通过 ref。








----------
>  行者常至，为者常成！


