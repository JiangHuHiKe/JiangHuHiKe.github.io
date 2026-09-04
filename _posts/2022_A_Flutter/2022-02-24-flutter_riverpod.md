---
layout: post
title: "flutter_riverpod"
date: 2022-02-24
tag: Flutter
---

## 目录
- [介绍](#content1) 
- [基本使用](#content2) 





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


## <a id="content2">基本使用</a>

#### **一、最简单的 Provider：只读数据**    

```dart
final nameProvider = Provider<String>((ref) {
  return 'Flutter';
});
```
```dart
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch(nameProvider)对应以前 Provider 的：context.watch<NameNotifier>()
    // Riverpod 最大的变化之一是：Provider 不再必须绑定在 Widget Tree 上。
    final name = ref.watch(nameProvider);

    return Text(name);
  }
}
```

#### **二、StateProvider：简单状态**     

```dart
final searchProvider = StateProvider<String>((ref) {
  return '';
});
```

```dart
class ProductPage extends ConsumerWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keyword = ref.watch(searchProvider);

    return Column(
      children: [
        Text('搜索：$keyword'),

        ElevatedButton(
          onPressed: () {
            ref.read(searchProvider.notifier).state = 'iPhone';
          },
          child: const Text('搜索 iPhone'),
        ),
      ],
    );
  }
}
```

#### **三、NotifierProvider更推荐的状态管理方式**    

```dart
class CartNotifier extends Notifier<List<String>> {

  @override
  List<String> build() {
    return [];
  }

  void add(String product) {
    state = [
      ...state,
      product,
    ];
  }

  void remove(String product) {
    state = [
      ...state.where((item) => item != product),
    ];
  }
}
```

```dart
final cartProvider =
    NotifierProvider<CartNotifier, List<String>>(
  CartNotifier.new,
);
```

```dart
class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // 状态变化 → 通知依赖者 → Widget rebuild
    final cart = ref.watch(cartProvider);

    return Column(
      children: [
        Text('商品数量：${cart.length}'),

        ElevatedButton(
          onPressed: () {
            ref
                .read(cartProvider.notifier)
                .add('iPhone');
          },
          child: const Text('加入购物车'),
        ),
      ],
    );
  }
}
```

#### **四、AsyncNotifierProvider：网络请求**

```dart
class ProductListNotifier extends AsyncNotifier<List<Product>> {
  bool mockNetworkError = true;

  Future<List<Product>> fetchProducts() async {

    await Future.delayed(
      const Duration(seconds: 2),
    );

    // 模拟网络异常
    if (mockNetworkError) {
      // 可以抛 Exception，也可以抛自定义异常对象
      throw Exception("网络请求失败，请检查网络连接");
    }

    return [
      Product(id: 1, name: 'iPhone'),
      Product(id: 2, name: 'MacBook'),
      Product(id: 3, name: 'iPad'),
    ];
  }


  
  @override // 初始化过程中会自动调用
  Future<List<Product>> build() async {
    // 在初始化过程中，如果build方法中有错误抛出，会走到AsyncValue的error回调
    return fetchProducts();
  }



  Future<void> reload() async {

    mockNetworkError = false;

    // 初始化状态为loading
    state = const AsyncLoading();

    // try {
    //   final result = await fetchProducts();
    //   state = AsyncData(result);
    // } catch (e, stackTrace) {
    //   state = AsyncError(e, stackTrace);
    // }

    // 这样写相当于，上边的try catch 逻辑
    state = await AsyncValue.guard(
          () => fetchProducts(),
    );

    /*
    * AsyncLoading会触发RiverpodBody.build()调用
    * 然后AsyncValue.when(loading,error,data)方法调用
    * 根据state不同，调用传入的loading方法或者error方法或者data方法
    *
    * */
  }
}
```

```dart
final productListProvider = AsyncNotifierProvider<ProductListNotifier, List<Product>>(ProductListNotifier.new);
```

```dart
class RiverpodBody extends ConsumerWidget {
  const RiverpodBody({super.key});

  @override
  Widget build( BuildContext context, WidgetRef ref) {

    // xy: ref.watch() -> dependence(依赖绑定) -> A方法 ->  ProductListNotifier.build()
    // xy:猜测A方法的实现逻辑大概如下：
    // // 1、初始化状态为loading
    // state = const AsyncLoading();
    // // 2、网络请求
    // try {
    //   final result = await ProductListNotifier.build();
    //   // 状态修改为成功
    //   state = AsyncData(result);
    // } catch (e, stackTrace) {
    //   // 状态修改为报错。此处说明初始化时在build中抛出的错误会被捕获，并更新状态
    //   state = AsyncError(e, stackTrace);
    // }

    final AsyncValue<List<Product>> products = ref.watch(productListProvider);

    // AsyncValue<List<Product>>
    // │
    // ├── loading
    // ├── error
    // └── data

    return products.when(
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },

      error: (error, stack) {
        return Center(
          child: Column(children: [
            Text('加载失败：$error'),
            TextButton(
                onPressed: (){
                  ref.read(productListProvider.notifier)
                      .reload();
                },
                child: const Text("点击刷新")
            )
          ],)
        );
      },

      data: (list) {
        return ListView.builder(
            itemCount: list.length + 1,
            itemBuilder: (context, index) {
              if(index < list.length) {
                return ListTile(
                  title: Text(list[index].name),
                );
              } else {
                return TextButton(
                    onPressed: (){
                      ref.read(productListProvider.notifier)
                          .reload();
                    },
                    child: const Text("点击刷新")
                );
              }
            });
      },
    );
  }
}
```

<span style="color:red;">flutter_riverpod其实结构是这三部分：asyncNotifier  + asyncNotifierProvider + consumer(ref)</span>     
<span style="color:red;">老的provider结构也是这三部分：changeNotifier  + changeNotifierProvider + consumer()</span>    
<span style="color:red;">它们不同点是asyncNotifierProvider与widget无关，changeNotifierProvider是widget</span>    






----------
>  行者常至，为者常成！


