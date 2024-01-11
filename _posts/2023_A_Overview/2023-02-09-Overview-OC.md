---
layout: post
title: "OC概要"
date: 2023-02-09
tag: Overview
---





## 目录

- [速记](#content0)  
- [对象的本质](#content1)  
- [kvc/kvo](#content2)  
- [Category](#content3)   
- [block](#content4)   
- [Runtime](#content5)  
- [多线程](#content6)  
- [Runloop](#content7)  


<!-- ************************************************ -->
## <a id="content0">速记</a>

#### **一、基础**  

**1、对象本质**    
实例对象、类对象、元类对象    
关系图(isa、super 指针)      

**2、kvc/kvo**   

kvc:先找方法，再找变量，都找不到报错    
kvo:派生类kvo_person,实例对象isa指向kvo_person, kvo_person的super指向Person类对象，kvo_person内重写setAge方法，  

**3、Category**       
+load方法、+initialize方法、关联对象(全局hash表)     

**4、block**       
block的定义和使用          
block的数据结构(impl+desc+捕获变量)和调用原理         
block的变量(全局变量、静态局部变量、自动变量)捕获原理(age/person)      
block的类型(globalBlock, stackBlock, mallocBlock; copy/dispose)     
_ _block的原理           
循环引用         

#### **二、runtime**   

**1、类对象的结构：isa、super、cache、bits**      

isa：   
是否优化、是否有关联对象、是否有弱引用、是否有引用计数表、引用计数 

super:     
指向父类    

cache:        
散列表，buket_t(key, _imp)           

bits:       
class_rw_t(方法列表，属性列表，协议列表)                
这些列表都是二维数组：method_list_t  -  method_t      

**2、消息机制**   

runtime主要指的是消息机制，有三个阶段：消息发送、动态方法解析、消息转发      

消息发送是在查找方法实现：当前类cache查找，方法列表查找，父类cache查找，父类方法列表查找      

动态方法解析是给类一个机会自己动态生成对应的方法       
调用resoleveInstanceMethod方法，在方法内给类添加方法实现，打标记，重走消息发送         

消息转发是当前类没有处理能力看看其它的类能不能处理              
forwardingTarget方法，返回一个能处理消息的实例对象         
methodSignature返回一个方法签名，如果返回空报doesntRecognizeSelector方法        
forwardInvocation 内可以进行一些自定义处理，比如进行一些提示      


**3、runtime的应用**   
修改 textField 的占位文字、字典转模型、自动归解档 （本质都是遍历属性列表，配合kvc完成）    

方法交换，解决数组越界崩溃问题    

消息转发，解决方法找不到的崩溃问题     

**4、其它**     
@synthesize 和 @dynamic       
super调用的原理      
isMemberOfClass 和 isKindOfClass      
cls分析     


#### **三、多线程**   

**1、进程与线程**   
进程资源分配的基本单位        
线程任务调度的基本单位    

**2、gcd**   

串行队列，并行队列、同步任务、异步任务(死锁情况分析)   

线程组的两种用法：
dispatch_group_async     
dispatch_group_enter/dispatch_group_leave              

栅栏函数：  
dispatch_barrier_sync(queue, ^{ });    
dispatch_barrier_async(queue, ^{ });     

semaphore    
初始为0：可以设置依赖关系   
初始为1：可以设置串行，索的作用    

其它     
dispatch_once    
dispatch_after   

**3、perform**   
主线程：都依赖runloop        
子线程：依赖runloop的情况waitUntilDone:NO 和 afterDelay:      


**4、看看经典面试题**     


**5、NSOperation**         
对GCD的封装，异步并发队列        
最大并发数，依赖关系        


#### **四、runloop**   

**1、基础**  

什么是runloop,runloop的作用    

运行在特定的mode下(defaultMode/trackingMode/commonMode)        
每个mode包含若干：source0/source1/observer/timer 

运行逻辑：运行顺序、如何唤醒、退出条件    

**2、相关**   

source1:基于port的线程间通讯，系统事件捕获，比如触摸事件    
timer:NSTimer/afterDelay
gcd:回主线程     
source0:触摸事件、perform、通知(kvo)   

observer:    
runloop状态监听     
beforeWaiting:(UI刷新、手势回调、autoreleasepool)     

**3、重要**   

触摸事件是如何传递和响应的？        
屏幕 - springboard - source1 - source0 - handleEventQueue - UIWindow - SubView     

UI刷新     
layoutSubViews调用时机          
setNeedsLayout 和 layoutIfNeeded 

drawRect调用时机    
setNeedsDisplay     

cpu负责计算、GPU负责渲染、垂直同步信号   





<!-- ************************************************ -->
## <a id="content1">对象的本质</a>
三种类型的对象：实例对象、类对象、元类对象

两个重要指针：isa指针、super指针

内存分布

<img src="/images/underlying/oc5.png" alt="img">


<!-- ************************************************ -->
## <a id="content2">kvc/kvo</a>

#### kvc

1、找set方法<br>
2、调用是否允许直接访问变量<br>
3、找成员变量<br>
4、调用setValue:forUndefinedKey抛错<br>
<img src="/images/underlying/oc9.png" alt="img">


1、找get方法<br>
2、调用是否允许直接访问变量<br>
3、找成员变量<br>
4、调用ValueForUndefinedKey抛错<br>
<img src="/images/underlying/oc10.png" alt="img">


#### kvo

派生出一个新的类<br>
kvo_person<br>
重写set方法<br>

<img src="/images/underlying/oc8.png" alt="img">

```Objc
NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
[self.person1 addObserver:self forKeyPath:@"age" options:(options) context:@"123"];

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context{

}

-(void)dealloc{
    //一定要移除监听，否则引起内存泄漏
    [self.person1 removeObserver:self forKeyPath:@"age"];
}
```

```Objc
#import "NSKVONotifying_MJPerson.h"

@implementation NSKVONotifying_Person

- (void)setAge:(int)age{
    _NSSetIntValueAndNotify();
}

// 伪代码
void _NSSetIntValueAndNotify(){
    [self willChangeValueForKey:@"age"];
    [super setAge:age];
    [self didChangeValueForKey:@"age"];
}

- (void)didChangeValueForKey:(NSString *)key{
    // 通知监听器，某某属性值发生了改变
    [oberser observeValueForKeyPath:key ofObject:self change:nil context:nil];
}

// 屏幕内部实现，隐藏了NSKVONotifying_MJPerson类的存在
- (Class)class{
    return [MJPerson class];
}

- (void)dealloc{
    // 收尾工作
}

- (BOOL)_isKVOA{
    return YES;
}

@end
```

<!-- ************************************************ -->
## <a id="content3">Category</a>

#### +Load方法
程序启动加载类的时候，<br>
只调用一次，直接地址调用<br>
先父类再子类，先父类分类再子类分类<br>

#### +initialize方法：
类第一次收到消息的时候调用，<br>
至少调用一次，msg_send方式调用<br>
先父类在子类，分类会覆盖类的initialize方法<br>

#### 关联对象：
全局的hash表

```objc
#import <objc/runtime.h>
- (void)setWeight:(int)weight{
    objc_setAssociatedObject(self, @selector(weight), @(weight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (int)weight{
  // _cmd == @selector(weight)
  return [objc_getAssociatedObject(self, _cmd) intValue];
}
```



<!-- ************************************************ -->
## <a id="content4">block</a>

### 介绍

#### block：匿名函数，可以作为参数和返回值
```objc
int(^blk)(int a, NSString* str) = ^int(int a, NSString* str){  
    return 10;
};
```
	
#### 变量捕获
被捕获的变量在block内无法修改<br>
要修改：__block int a = 10 修饰


### block的本质

<img src="/images/memory/block1.png" alt="img">

#### block的本质是对象
impl<br>
Desc<br>
捕获的变量<br>

```objc
struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  int age;
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int _age, int flags=0) : age(_age) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};

struct __block_impl {
  void *isa;
  int Flags;
  int Reserved;
  void *FuncPtr;
};

static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
    int age = __cself->age; // bound by copy
    
    printf("Block\n age=%d\n",age);
}
```

#### block的调用本质是方法
impl下有一个FuncPtr指针<br>
block初始化时传入方法地址<br>
要清楚方法的参数是如何传递的<br>
```objc
int main(int argc, char * argv[]) {

        int age = 10;

        void(*blk)(void)=&__main_block_impl_0(
                                              __main_block_func_0,
                                              &__main_block_desc_0_DATA,
                                              age));

        age = 20;

       ((__block_impl *)blk)->FuncPtr)(blk);
    }
    return 0;
}
```


#### 捕获的变量

自动变量：值捕获 int / Person

静态局部变量：地址捕获
 
不会捕获全局变量


### block的类型

#### 一、block的类型（block是对象）

没有捕获auto变量：__NSGlobalBlock__:数据段<br>
copy操作无反应

捕获auto变量：__NSStackBlock__:栈区<br>
copy操作复制到堆空间

__NSStackBlock__执行copy后： __NSMallocBlock__:堆区<br>
copy操作引用计数加1


#### 二、block的copy

作为返回值会执行copy操作

强指针指向会执行copy操作

usingBlock中做参数会执行copy操作

GCD中做参数会执行copy操作




#### 三、捕获对象类型自动变量
1、如果Block在栈上，不会对对象类型auto变量产生强引用。<br>
2、如果Block在堆上，<span style="color:red;font-weight:bold">会根据对象类型auto变量的修饰符</span> __strong、 __weak、 __unsafe_unretained
做出相应的操作，形成强引用或若引用。



#### 四、desc下的copy方法和dispose方法
Block被拷贝到堆上会调用Block内部的copy函数，对捕获的变量强弱引用<br>
Block从堆上移除会调用Block内部的dispose函数，释放捕获的变量


### __block原理

#### 一、_ _block 修饰为什么就能在block内部修改值了

```objc
__block int age = 10;
blk b=^(){
    age = 20;
};
```

——block修饰的age会变成一个对象block_age<br>
对象内部有一个属性age<br>
对象block_age会被block捕获<br>
block内修改的是block_age下的age属性而不是<br>
block_age对象<br>

```objc
typedef void(*blk)(void);
struct __Block_byref_age_0 {
    void *__isa;
    __Block_byref_age_0 *__forwarding;
    int __flags;
    int __size;
    int age;
};

struct __main_block_impl_0 {
    struct __block_impl impl;
    struct __main_block_desc_0* Desc;
    __Block_byref_age_0 *age; // by ref
    __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, __Block_byref_age_0 *_age, int flags=0) : age(_age->__forwarding) {
        impl.isa = &_NSConcreteStackBlock;
        impl.Flags = flags;
        impl.FuncPtr = fp;
        Desc = desc;
    }
};


static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
    __Block_byref_age_0 *age = __cself->age; // bound by ref
    
    (age->__forwarding->age) = 20;
}
```
#### 二、forwarding指针

<img src="/images/memory/block7.png" alt="img">

这就是为什么是 (age->__forwarding->age) = 20;而不是(age->age) = 20;的原因


### block的循环引用

```objc
Person * person = [[Person alloc] init];
person.blk = {
    person.name
}
```
<img src="/images/memory/block8.png" alt="img">

```objc
Person * person = [[Person alloc] init];
__weak typeof(person) weakPerson = person;
person.blk = {
    person.name
}
```
<img src="/images/memory/block9.png" alt="img">



<!-- ************************************************ -->
## <a id="content5">Runtime</a>

### class的结构
<img src="/images/underlying/oc16.png" alt="img">


#### 一、isa的结构
```objc
union isa_t {
    Class cls;
    uintptr_t bits;
    struct {
      uintptr_t nonpointer        : 1;  //是否是优化过的指针                                     
      uintptr_t has_assoc         : 1;  //是否有关联对象                                     
      uintptr_t has_cxx_dtor      : 1;                                       
      uintptr_t shiftcls          : 33; /*MACH_VM_MAX_ADDRESS 0x1000000000*/ 
      uintptr_t magic             : 6;                                       
      uintptr_t weakly_referenced : 1;  //是否有弱引用                                     
      uintptr_t deallocating      : 1;                                       
      uintptr_t has_sidetable_rc  : 1;  //是否有引用计数表                                     
      uintptr_t extra_rc          : 19  //引用计数
    };
};
```

#### 二、cache的结构
<img src="/images/underlying/oc22.png" alt="img">


#### 三、bits的结构
二维数组
<img src="/images/underlying/oc17.png" alt="img">

<img src="/images/underlying/oc19.png" alt="img">


### 消息机制

1、消息发送是在查找方法实现<br>
2、动态方法解析是给类一个机会自己动态生成对应的方法<br>
3、消息转发是当前类没有处理看看其它的类能不能处理<br>


#### 一、消息发送
```objc
objc_msgSend(person, sel_registerName("test"));   
消息接收者（receiver）：person    
消息名称：test 
```

<img src="/images/underlying/msgsend1.png" alt="img">


#### 二、动态方法解析
<img src="/images/underlying/msgsend2.png" alt="img">
```objc
+(BOOL)resolveInstanceMethod:(SEL)sel{
    if (sel == @selector(test)) {
        
        NSLog(@"resolveInstance");
        
        //获取method
        Method method = class_getInstanceMethod(self, @selector(other));
        
        //动态添加方法
        class_addMethod(self,
                        sel,
                        method_getImplementation(method),
                        method_getTypeEncoding(method));
        
        //
        return YES;
    }
    
    return [super resolveInstanceMethod:sel];
}
```

#### 三、消息转发
<img src="/images/underlying/msgsend3.png" alt="img">
```objc
-(id)forwardingTargetForSelector:(SEL)aSelector{
    NSLog(@"%s",__func__);
    if (aSelector == @selector(test)) {
        Class Cat = NSClassFromString(@"Cat");
        
        //返回一个实例对象 就会调用实例对象的test方法
        //return [[Cat alloc] init];
        
        //返回nil 就会调用methodSignatureForSelector
        return nil;
    }
    return [super forwardingTargetForSelector:aSelector];
}


- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    NSLog(@"%s",__func__);
    
    if (aSelector == @selector(test)) {
        //注册消息转发到的方法的类型
        return [NSMethodSignature signatureWithObjCTypes:"i20@0:8i:4"];
    }
    
    return [super methodSignatureForSelector:aSelector];
}


- (void)forwardInvocation:(NSInvocation *)anInvocation{
    NSLog(@"%s",__func__);
    
    //anInvocation 包含selector targe argument
    if (anInvocation.selector == @selector(test)) {
        
        Class Cat = NSClassFromString(@"Cat");
        id cat = [[Cat alloc] init];
        
        //更改消息接收者
        anInvocation.target =cat;
        //更改selector
        anInvocation.selector = @selector(catTest:);
        //设置新方法参数
        int age = 5;
        [anInvocation setArgument:&age atIndex:2];
        
        //新方法调用
        [anInvocation invoke];
        
        //获取新方法的返回值
        int reValue;
        [anInvocation getReturnValue:&reValue];
        NSLog(@"reValue=%d",reValue);
    }
}
@end
```

### 几个知识点

#### 一、@synthesize 和 @dynamic
```objc
@synthesize的作用就是通知编译器为相关属性自动生成，成员变量、set、get方法。
@synthesize age=_age,height=_height;

@dynamic是告诉编译器不用自动生成成员变量、set、get方法，等到运行时再添加方法实现。
@dynamic age;
```

#### 二、Super的原理
```objc
[super test];
static void _I_Student_test(Student * self, SEL _cmd) {
    struct __rw_objc_super arg = {
        self,//消息的接收者还是self
        self.superClass//查找从父类开始
    }
    objc_msgSendSuper(arg,sel_registerName("test"));
}

[self class] //Student
[self superclass]//Person
[super  class]);//Student
[super superclass]//Person
```

#### 三、isMemberOfClass 和 isKindOfClass
```objc
NSLog(@"%d",[person isMemberOfClass:[Person class]]);//1
NSLog(@"%d",[person isMemberOfClass:[NSObject class]]);//0
NSLog(@"%d",[person isKindOfClass:[Person class]]);//1
NSLog(@"%d",[person isKindOfClass:[NSObject class]]);//1

NSLog(@"%d",[NSObject isMemberOfClass:[NSObject class]]);//0
NSLog(@"%d",[NSObject isKindOfClass:[NSObject class]]);//1
NSLog(@"%d",[Person isMemberOfClass:[Person class]]);//0
NSLog(@"%d",[Person isKindOfClass:[Person class]]);//0

isMemberOf不会顺着super指针向上查找
isKindOf会顺着super向上查找
```

#### 四、cls指针
```objc
-(void)print{
    NSLog(@"my name is %@",self.name);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    id cls = [Person class];//cls就是isa指针
    void * obj = &cls;//obj就是实例对象
    // 是否调用成功，打印什么？
    [(__bridge id)obj print];//栈空间的内存分布
}
调用成功打印
my name is <ViewController: 0x100704080>
```


### runtime的应用

#### 一、遍历查看所有的成员变量和属性
```
1.textfiled修改占位文字的颜色
2.字典转模型：
    for循环拿到属性转为字符串作为key
     通过key,dic[key]取出value
     通过kvc,setValueForKey(key,value)对属性赋值
3.自动归档解档
     自定义类型存数据库需要归解档
     for循环拿到属性转为字符串作为key
     归档:通过kvc拿到value，调用encode(key,value)归档
     解档:value = decode(key),然后kvc,setValueForKey(key,value)
```

#### 二、交换方法实现
```
1.交换数组的insertObject方法，解决索引越界崩溃问题
```

#### 三、消息转发解决方法找不到的崩溃问题
```
实现methodSignature方法
实现forwardInvocation方法,方法内可以做一些提示或上送操作
```

#### 四、利用关联对象给分类添加属性


<!-- ************************************************ -->
## <a id="content6">多线程</a>

#### **一、进程和线程**   
**1、进程**    
一个app就是一个进程    
操作系统进行资源分配的基本单位，每个进程运行在独立的内存空间内    

**2、线程**   
进程的基本执行单元        
线程是操作系统进行任务调度的基本单位     

**3、线程的状态**   
创建线程 - 就绪 - 运行 - 阻塞 - 死亡   

**4、线程的优缺点**     
优点：提高程序执行效率；提高CPU利用率；       
缺点：程序变复杂；开启线程本身就会占用空间，开启过多会占用大量内存空间，调度频率也会降低；          


#### **二、GCD - sync 和 async**   

**1、几个重要概念**     

```objc
//同步：代码块执行完才返回，在当前线程执行          
dispatch_sync(queue,{   });

//异步：立即返回，在新线程执行   
dispatch_async(queue,{   });

//串行队列：在队列里的多个任务按先后顺序，一个一个取出。
dispatch_queue_t serialQueue = dispatch_queue_create("serial", DISPATCH_QUEUE_SERIAL);

//并发队列：在队列里的多个任务允许同时取出。
dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);

//主队列:串行队列
dispatch_queue_t mainQueue = dispatch_get_main_queue()

//全局队列：并发队列
dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
```

**2、重要规则**         
<span style="color:red;font-weight:bold">先看队列是串行并行，再看执行是同步异步</span>   

<span style="color:red;font-weight:bold">放在串行队列里的任务一定是一个执行完再取下一个，是有顺序的</span>    
<span style="color:red;font-weight:bold">串行队列里会不会死锁，就看任务能不能正常取出</span>     
放在并行队列里的任务可以同时取出     

<span style="color:red;font-weight:bold">同步执行:在当前线程执行，一定是整个任务块执行完再返回的</span>      
异步执行：立即返回        


**3、典型面试题**   

```objc
- (IBAction)sync2:(id)sender {
    //global_queue - main_queue
    NSLog(@"current1  %@",[NSThread currentThread]);
    
    dispatch_sync(dispatch_get_global_queue(0,0), ^{
        NSLog(@"current2  %@",[NSThread currentThread]);
        
        //死锁
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"current3  %@",[NSThread currentThread]);
        });
    });
    NSLog(@"current4  %@",[NSThread currentThread]);

    /**
     2022-04-02 00:12:04.476120+0800 XYApp[79949:3633423] current1  <_NSMainThread: 0x283228600>{number = 1, name = main}
     2022-04-02 00:12:04.476297+0800 XYApp[79949:3633423] current2  <_NSMainThread: 0x283228600>{number = 1, name = main}
     死锁
     */
}

- (IBAction)sync3:(id)sender {
    //main_queue - global_queue
    NSLog(@"current1  %@",[NSThread currentThread]);
    
    //死锁
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"current2  %@",[NSThread currentThread]);
        
        dispatch_sync(dispatch_get_global_queue(0,0), ^{
            NSLog(@"current3  %@",[NSThread currentThread]);
        });
    });
    
    NSLog(@"current4  %@",[NSThread currentThread]);

    /**
     2022-04-02 00:19:15.663318+0800 XYApp[80099:3637866] current1  <_NSMainThread: 0x280fe8880>{number = 1, name = main}
     死锁
     */
}

- (IBAction)sync3:(id)sender {
    dispatch_async(mainQueue, ^{//block0
        NSLog(@"block0");
    });

    //不用等async任务执行,就可以直接来到此处
}


- (IBAction)sync6:(id)sender {
    [self subThreadWithDoneBlock:^{
        NSLog(@"current1  %@",[NSThread currentThread]);
        
        dispatch_sync(dispatch_get_global_queue(0,0), ^{
            NSLog(@"current2  %@",[NSThread currentThread]);
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                NSLog(@"current3  %@",[NSThread currentThread]);
            });
        });
        NSLog(@"current4  %@",[NSThread currentThread]);
    }];
    NSLog(@"current5  %@",[NSThread currentThread]);
    sleep(2);
    NSLog(@"current6  %@",[NSThread currentThread]);

    /**
     2022-04-01 23:20:22.017079+0800 XYApp[79118:3610327] current5  <_NSMainThread: 0x280ea8880>{number = 1, name = main}
     2022-04-01 23:20:22.017094+0800 XYApp[79118:3610359] current1  <NSThread: 0x280ef8040>{number = 5, name = (null)}
     2022-04-01 23:20:22.017421+0800 XYApp[79118:3610359] current2  <NSThread: 0x280ef8040>{number = 5, name = (null)}
     2022-04-01 23:20:24.018549+0800 XYApp[79118:3610327] current6  <_NSMainThread: 0x280ea8880>{number = 1, name = main}
     2022-04-01 23:20:24.020729+0800 XYApp[79118:3610327] current3  <_NSMainThread: 0x280ea8880>{number = 1, name = main}
     2022-04-01 23:20:24.021011+0800 XYApp[79118:3610359] current4  <NSThread: 0x280ef8040>{number = 5, name = (null)}
     */
}
```

```objc
- (IBAction)async1:(id)sender {
    //创建一个串行队列
    dispatch_queue_t queue = dispatch_queue_create("serial", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(queue, ^{
        NSLog(@"current1  %@",[NSThread currentThread]);
        
        dispatch_async(queue, ^{
            NSLog(@"current2  %@",[NSThread currentThread]);
        });
    });
    
    NSLog(@"current3  %@",[NSThread currentThread]);

    /**
     2022-04-02 23:27:46.457775+0800 XYApp[18862:12321559] current1  <_NSMainThread: 0x280280800>{number = 1, name = main}
     2022-04-02 23:27:46.458091+0800 XYApp[18862:12321559] current3  <_NSMainThread: 0x280280800>{number = 1, name = main}
     2022-04-02 23:27:46.458149+0800 XYApp[18862:12321571] current2  <NSThread: 0x2802ec280>{number = 7, name = (null)}
     */
    
}

- (IBAction)async2:(id)sender {
    
    dispatch_queue_t queue = dispatch_queue_create("SERIAL", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        NSLog(@"current1  %@",[NSThread currentThread]);
        
        //死锁
        dispatch_sync(queue, ^{
            NSLog(@"current2  %@",[NSThread currentThread]);
        });
    });
    
    NSLog(@"current3  %@",[NSThread currentThread]);
    
    /**
     2022-04-02 23:28:15.568690+0800 XYApp[18862:12321559] current3  <_NSMainThread: 0x280280800>{number = 1, name = main}
     2022-04-02 23:28:15.568787+0800 XYApp[18862:12321573] current1  <NSThread: 0x2802c7f00>{number = 3, name = (null)}
     死锁
     */

}
```

#### **三、GCD - group**   

**1、用法一**   
```objc
-(void)GCD_GroupTest{
    //全局队列
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    
    //创建线程组
    dispatch_group_t group = dispatch_group_create();
    
    //添加任务
    dispatch_group_async(group, globalQueue, ^{
        NSLog(@"block0-%@",[NSThread currentThread]);
    });
    
    dispatch_group_async(group, globalQueue, ^{
        NSLog(@"block1-%@",[NSThread currentThread]);
    });
    
    //等待通知
    dispatch_group_notify(group, globalQueue, ^{
        NSLog(@"block2-%@",[NSThread currentThread]);
    });
}
```

**2、用法二**       
```objc
- (void)groupDemo2{
    
    // 问题: 如果 dispatch_group_enter 多 dispatch_group_leave 不会调用通知
    // dispatch_group_enter 少 dispatch_group_leave  奔溃
    // 成对存在
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        NSLog(@"第一个走完了");
        dispatch_group_leave(group);
    });
    

    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        NSLog(@"第二个走完了");
        dispatch_group_leave(group);
    });
    
    //如果没有 dispatch_group_leave(group); 就不会来到dispatch_group_notify
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"所有任务完成,可以更新UI");
    });
}

intptr_t result = dispatch_group_wait(group, dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 6));
if (result == 0) {
    //enter 与 leave平衡
    NSLog(@"current6  %@",[NSThread currentThread]);
} else  {
    //超时
    NSLog(@"current7  %@",[NSThread currentThread]);
}
```

#### **四、GCD - barrier**    

```objc
// 一定要使用自定义的队列
dispatch_queue_t queue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);


// 两个重要的函数
dispatch_barrier_sync(queue, ^{
    NSLog(@"[lilog]:barrier_sync");
});
    

dispatch_barrier_async(queue, ^{
    NSLog(@"[lilog]:barrier_async");
});

```

#### **五、GCD - semaphore**      
初始信号量为0,可以设置依赖关系            
```objc
- (IBAction)semaphoreOrder {
    
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"任务1");
        dispatch_semaphore_signal(sem);
    });
    
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"任务2");
        dispatch_semaphore_signal(sem);
    });
    
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"任务3");
    });
}
```

初始信号量为1,可以做串行队列       
```objc
dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);

intptr_t isSuccess = dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
NSLog(@"drawMoney-isSuccess = %ld",isSuccess);//成功时返回0  

intptr_t process = dispatch_semaphore_signal(semaphore);
NSLog(@"drawMoney-process = %ld",process);//它只表示成功发送信号的次数,不用过多关注  
```

#### **六、GCD - 其它**   

```objc
// 一次执行
-(void)GCD_Once{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"lilog - once");
    });
}

// 延迟执行
-(void)GCD_After{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"大牛");

    });
    NSLog(@"IT民工");
}

```

#### **七、perform**

**主线程执行perform相关方法的情况** 

```objc
// 依赖runloop，处理source0时处理
[self performSelector:@selector(test4)];
[self performSelector:@selector(test5:) withObject:@"hehe"];
// 阻塞当前线程，直到test1执行完成
[self performSelector:@selector(test1) onThread:currentThread withObject:nil waitUntilDone:YES];
// 不会阻塞当前线程，立即返回
[self performSelector:@selector(test1) onThread:currentThread withObject:nil waitUntilDone:NO];


// 依赖runloop，处理timer时处理
[self performSelector:@selector(test1) withObject:nil afterDelay:0];
```

**子线程执行perform相关方法的情况**     
```objc
// 以下情况不依赖运行循环。会在当前线程立即调用
[self performSelector:@selector(test4)];
[self performSelector:@selector(test5:) withObject:@"hehe"];
//阻塞当前线程，直到test1执行完成
[self performSelector:@selector(test1) onThread:currentThread withObject:nil waitUntilDone:YES];
 

// 下面perform开头的方法都会依赖运行循环。在没有开启运行循环的线程里是没发执行的。
[self performSelector:@selector(test1) onThread:currentThread withObject:nil waitUntilDone:NO];
[self performSelector:@selector(test1) withObject:nil afterDelay:0];
 

另外performSelector:withObject:afterDelay:和 dispatch_after 都是立即返回。当两者延迟都是0，前者的执行时机比后者慢，因为前者依赖运行循环。
```

#### **八、interview**   

**1、小米面试题**   
```objc
- (IBAction)interview4:(id)sender {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self test1];//主队列排队
    });
    
    
    [self performSelector:@selector(test2) withObject:nil afterDelay:0];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self test3];//主队列排队:是在指定时间之后将任务追加到主队列中
    });
    
    
    
    [self performSelector:@selector(test4)];//当前线程立即执行

    [self test5];//当前线程立即执行
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self test6];//主队列排队
        });
        [self test7];
        
        [self performSelector:@selector(test8) withObject:nil afterDelay:0];//依赖线程的运行循环，所以不会执行
    });
    
    
    /**
     2022-08-19 12:27:15.094636+0800 XYApp[49643:6816750] test4
     2022-08-19 12:27:15.094888+0800 XYApp[49643:6816750] test5
     2022-08-19 12:27:15.095116+0800 XYApp[49643:6816968] test7
     2022-08-19 12:27:15.096323+0800 XYApp[49643:6816750] test1
     2022-08-19 12:27:15.096513+0800 XYApp[49643:6816750] test3
     2022-08-19 12:27:15.096664+0800 XYApp[49643:6816750] test6
     2022-08-19 12:27:15.096876+0800 XYApp[49643:6816750] test2

     
     //如果将执行test3的延迟改为3秒，打印顺序如下
     2022-08-19 12:32:51.156387+0800 XYApp[49790:6822158] test4
     2022-08-19 12:32:51.156642+0800 XYApp[49790:6822158] test5
     2022-08-19 12:32:51.156919+0800 XYApp[49790:6822177] test7
     2022-08-19 12:32:51.158391+0800 XYApp[49790:6822158] test1
     2022-08-19 12:32:51.158598+0800 XYApp[49790:6822158] test6
     2022-08-19 12:32:51.158820+0800 XYApp[49790:6822158] test2
     2022-08-19 12:32:54.368531+0800 XYApp[49790:6822158] test3
     */
}
```

**2、面试题**  
```objc
- (IBAction)lg_test3:(id)sender {
    self.num = 0;
    int time = 0;
    while (self.num < 100) {
        time ++;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            self.num ++;
            //self.num = self.num + 1;
        });
    }
    NSLog(@"self.num = %d",self.num);
    NSLog(@"time = %d",time);
    /**
     肯定会 >= 100
     2022-08-15 16:01:48.269255+0800 XYApp[25881:5838957] self.num = 102
     2022-10-11 11:40:28.179999+0800 XYTestModule_Example[57853:4429651] time = 555
     */
}


- (IBAction)lg_test4:(id)sender {
    self.num = 0;
    for (int i = 0; i < 100; i ++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            self.num ++;
        });
    }
    NSLog(@"self.num = %d",self.num);
    
    /**
     肯定会<=100
     2022-08-15 16:03:43.624062+0800 XYApp[25881:5838957] self.num = 79
     */
}
```

#### **九、NSOperation**   

NSOperation是对GCD的封装，更加面向对象话       
```objc
//queue：异步并发队列的封装  
NSOperationQueue * concurrentQueue = [[NSOperationQueue alloc] init];
concurrentQueue.maxConcurrentOperationCount = 2;//最大并发数为2 可同时执行2个任务

//operation
NSBlockOperation * operation1 = [NSBlockOperation blockOperationWithBlock:^{
    for (int i = 0; i<10; i++) {
        NSLog(@"thread = %@ i = %d",[NSThread currentThread],i);
    }
}];

NSBlockOperation * operation2 = [NSBlockOperation blockOperationWithBlock:^{
    for (int j = 0; j<10; j++) {
        NSLog(@"thread = %@ j = %d",[NSThread currentThread],j);
    }
}];
[operation2 addDependency:operation1];//依赖关系

// 将operation添加到queue
[queue addOperation:operation1];
[queue addOperation:operation2];
```


<!-- ************************************************ -->
## <a id="content7">Runloop</a>

#### **一、runloop介绍**    

**1、介绍**  
事件处理循环，不停的处理输入事件。      
线程保活    
让线程有工作的时候忙于工作，没工作的时候处于休眠状态。        

全局字典里：一个线程(key)对应一个runloop(value)   

**2、mode**   
<img src="/images/objectC/loop1.png">

一个RunLoop包含<span style="color:red">若干个</span>Mode,启动时只能选择其中一个Mode，作为currentMode    
每个Mode又包含<span style="color:red">若干个</span>Source0/Source1/Timer/Observer        
```objc
kCFRunLoopDefaultMode
UITrackingRunLoopMode
NSRunLoopCommonModes
```
#### **二、runloop的运行逻辑**    

<img src="/images/objectC/loop4.png">

**runloop的源**   
输入源：source1、source0    
定时源：timer     

**runloop的唤醒**   
注意：source0不能唤醒runloop      
```objc
if (被Timer唤醒) {
    __CFRunLoopDoTimers(rl, rlm, mach_absolute_time())
} else if (被GCD唤醒) {
    __CFRUNLOOP_IS_SERVICING_THE_MAIN_DISPATCH_QUEUE__(msg)
} else {
     __CFRunLoopDoSource1(rl, rlm, rls, msg, msg->msgh_size, $reply)
}
```

**runloop的退出**   
手动调用 CFRunLoopStop 函数,停止 Runloop。    
所有输入源和定时器都被移除。   
Runloop 遇到错误。   


#### **三、runloop相关**    

**source1(唤醒runloop)**    
基于port的线程间通讯   
系统事件捕获(比如触摸事件)  

**Timer(唤醒runloop)**   
NSTimer(可以观察调用栈：__CFRunLoopDoTimer)    
performSelector:withObject:afterDelay:(可以观察调用栈：__CFRunLoopDoTimer)

**GCD回主线程(唤醒runloop)**    
可以观察调用栈(__CFRUNLOOP_IS_SERVICING_THE_MAIN_DISPATCH_QUEUE__),跟source0和source1没关系   


**source0**  
触摸事件(事件是如何分发给source0的？) 
```objc
点击屏幕 - springboard进程捕获点击事件 - 通过端口传给当前进程 -
source1检测到事件唤醒runloop，调用source1的回调 - 在处理source1的回调中触发source0 -
source0再触发_UIApplicationHandleEventQueue() - UIWindow - SubView - SubView
```   
performSelector:onThread:(哪些是依赖runloop的？)  
```objc
// 下面perform开头的方法都会依赖运行循环。在没有开启运行循环的线程里是没发执行的。
[self performSelector:@selector(test1) onThread:currentThread withObject:nil waitUntilDone:NO];
[self performSelector:@selector(test1) withObject:nil afterDelay:0];
```

通知(通知也是source0处理的，可以观察调用栈)   


**Observer**   
监听runloop的状态      
UI刷新(BeforeWaiting)       
AutoReleasePool(BeforeWaiting)     
手势回调调用(BeforeWaiting)         

<span style="color:red;font-weight:bold">不管是source1还是source0都是通过回调来处理事件的</span>


#### **四、UI刷新**   


**1、布局**    
layoutSubviews的调用时机           
自身被添加到父view上          
自身大小改变         
添加或移除子view        
子view大小改变       

setNeedsLayout：打标记，该方法立即返回，不会立即调用layoutSubviews，下一个运行循环刷新        
layoutIfNeeded：有刷新标记时就立即调用layoutSubviews，然后该方法才会返回。     

**2、绘制**   
drawRect的调用时机      
首次显示    
生使视图可见部分失效的事件      

setNeedsDisplay：打标记在下一个绘制周期进行重绘 

```objc
layout_and_display_if_needed
    layout_if_needed
        -[CALayer layoutSublayers]
            -[UIView layoutSubviews]
        
    -[CALayer display]
        -[UIView(CALayerDelegate) drawLayer:inContext:]
            -[UIView drawRect:]
```

**3、渲染原理**    

**CPU(计算)**     
视图的创建、布局计算、图片解码、文本绘制等

**GPU(渲染)**     
则在物理层上完成了对图像的渲染(顶点着色器、片元着色器等)     
数据提交到帧缓冲区    
   
**垂直同步信号**     
Frame Buffer、视频控制器等相关部件，将图像显示在屏幕上      





----------
>  行者常至，为者常成！


