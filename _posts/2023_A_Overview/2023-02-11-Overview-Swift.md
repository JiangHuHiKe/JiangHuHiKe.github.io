---
layout: post
title: "Swift概要"
date: 2023-02-11
tag: Overview
---





## 目录


- [常量/变量/数据类型](#content1)   
- [闭包](#content2)   
- [可选项](#content3)   
- [枚举/结构体/类](#content4)   
- [协议](#content5)   
- [泛型](#content6)   
- [模式匹配](#content7)   
- [其它](#content10)   



## <a id="content1">变量与数据类型</a>
<!--===============================================================================================-->

#### 一、常量
```Swift
//不要求编译时确定，如果声明时没有值需要指定类型
let a: Int = 10 

//可以省略类型说明和结尾的分号
let a = 10 
```


#### 二、变量
```Swift
var isClick:Bool = false //可以省略类型说明和结尾的分号

var a:Int = 0; 
var a:Float = 10.0; 
var a:Double = 10.0;

var cha:Character = "a" // 字符类型必须指定类型
var str:String = "hello world"

var array:Array = [1, 2, 3, 4]

var dic : Dictionary = ["key1":"value1", 1:"value2"]

var set:Set = ["age","weight"]

// 元组
let error = (404, "Not Fount")// error.0
let error = (code:404, msg:"Not Fount")//error.code

//对象类型
let p:Person = Person(name:"xiaoming",age:18)

//匿名函数:闭包表达式，可以作为参数，尾随闭包的调用
var blk:(Int,Int)->Int = {(a, b)->Int in return a + b}   // var result = blk(10,20)

//函数
func sum(a:Int, b:Int)->Int {return 10}
func goToWork(at time:String){} // goToWork(at:"10:00")
```

#### 三、数据类型

**1、String** 

swift中的字符串类型是结构体，是值类型<br>
值类型的特点是：将a赋值给b之后，对b进行修改不会影响a

```swift
//1、长度小于等于15的字符串存储于str的内存中
var str:String = "0123456789"

//2、append后长度仍小于等于15的字符串 仍位于变量的内存
str.append("A")

//3、长度大于15的字符串位于常量区（常量区的内存在编译时分配，程序运行时无法更改）
var str = "0123456789ABCDEF"

//4、不管之前长度是否大于15，append后长度大于15的字符串 会存储于堆空间
// 位于堆空间后，比如a = 堆空间地址  b = 堆空间地址，当 b 修改字符串时，会产生实际的复制。也不会影响a
// 字符串长度过长时，使用上是值类型，实际是引用类型
str.append("ABCDEF")

```

**2、Array**    
Swift中的数组也是结构体，是值类型
```swift
var arr:Array = [1,2,3,4]

var arr1 = arr
arr1.append(6)

//arr1的改变并不会影响arr
//arr1 = [1, 2, 3, 4, 6], arr = [1, 2, 3, 4]
print("arr1 = \(arr1), arr = \(arr)")
```
<span style="color:red;fontWeight:bold">PS:Array在底层其实是引用类型 但实际使用时是结构体<br> 行为上是值类型 本质是引用类型只是苹果隐藏了这一层</span>

**3、Dictionary 和 Set 也是结构体类型，也是值类型**

**4、元组是一个复合类型，也是值类型**


#### 四、Any AnyObject AnyClass  

Any 任意类型：对象类型，int类型等    

AnyObject 任意对象类型：实例对象、类对象   

AnyClass 任意类对象类型  

AnyObject.type 相当于 AnyClass 任意类对象类型

Person 比如 let p: Person = Person();  用于指定实例对象p的类型

Person.type 比如 let pClass : Person.type = Person.self; 用于指定类对象pClass的类型

注意： 
Person.self 是类对象，    
Person.type 是指定类型的(类对象的类型)，   
Person 是指定类型的(实例对象的类型)    


#### 五、self 与 Self

小写的self
在实例方法中指代实例对象      
在静态方法中指代类对象     

大写的Self    
1、作为返回值，用于指代当前类型   
2、在静态方法中指代类对象， Self.age静态属性 self.age也是静态属性       

## <a id="content2">闭包</a>
<!--===============================================================================================-->

#### 一、什么是闭包？
外层函数 + 内层函数 + 内层函数访问外层函数的变量

#### 二、闭包的作用？
1、捕获变量，在函数调用结束后仍能访问函数内部的变量：比如计数器<br>
2、代码模块化，比如返回一个包含了多个方法的元组或对象：比如计算器<br>
3、异步任务，函数调用结束后还能执行捕获的闭包表达式：网络请求<br>

#### 三、循环引用
跟OC一样，Swift也是采取基于引用计数的ARC内存管理方案(针对堆空间)<br>
强引用(strong reference):默认情况下，引用都是强引用<br>
弱引用(weak reference):通过weak定义弱引用<br>
无主引用(unowned reference):通过unowned定义无主引用<br>

```swift
class Person {
    var blk:Blk?
    var name:String
    init(blk: Blk? = nil, name: String) {
        self.blk = blk
        self.name = name
    }
    
    deinit {
        print("deinit")
    }
}

let p = Person(name: "xiaoming")

//不会调用deinit方法，p对象无法释放
p.blk = {(num) in
    let pname = p?.name ?? ""
    print("p 的 name是 \(pname)")
}
p.blk?(9)

//会调用deinit方法
p.blk = { [weak p] (num) in
    let pname = p?.name ?? ""
    print("p 的 name是 \(pname)")
}
p.blk?(9)
```


#### 四、逃逸闭包
非逃逸闭包、逃逸闭包，一般都是当做参数传递给函数<br>
非逃逸闭包：闭包调用发生在函数结束前，闭包调用在函数作用域内<br>
逃逸闭包：闭包有可能在函数结束后调用，闭包调用逃离了函数的作用域，需要通过@escaping声明<br>

```swift
typealias Blk = ((Int)->Void)

func handleEvent(blk: @escaping Blk) {
    DispatchQueue.global().async {
        blk(9)
    }
}

handleEvent { num in
    print("\(num)")
}
```
  
 
## <a id="content3">可选项</a>
<!--===============================================================================================-->

#### 一、空判断和强制解包
```Swift
let a:Int? = 10

if a! = nil {
    let num = a!
}
```

#### 二、自动解包

##### 1、可选项绑定自动解包
```Swift
// num的作用域是块作用域
if let num=a, num>0 {

}

while let num=a, num>0 {

}

// userName的作用域是函数作用域
// 字典返回的是可选项
guard let userName = info["userName"] { 
    return 
}
print(userName)
```

##### 2、! 自动解包
```Swift
let a:Int? = 1

let b:Int! = 2

// b可以赋值给c，a不行
let c:Int = b
```


#### 三、空合并运算符
```Swift
let a:Int? = 1

let b:Int? = 2

// a不为nil返回a,a为nil返回b.
// 返回的类型与b相同
let c = a ?? b
```



#### 四、多重可选项
```
多重可选项的比较：
    能解包出相同的具体值的多重可选项都是相等的

使用场景：GPT异步比如获取用户信息。没明白??
```

#### 五、可选链
```Swift
let person:Person? = Person()
//如果不是可选类型会包装成可选类型
let age = person?.age // optional
let age = person!.age // int

// 如果是可选类型不会重复包装
// car 是可选类型
let car = person?.car //optional
let car = person!.car //optional


// 如果person是nil就会终止后续操作
person?.run()

let num:Int? = 5
let num:Int? = nil
//num是nil会终止后续操作，不会赋值10
num? = 10
```

#### 六、可选项的本质是枚举

##### 1、举例
```swift
//可选项
var num:Int? = nil
print(num)  // nil
num = 10
print(num)  // Optional(10)

// 枚举
var num1:Optional<Int> = nil
print(num1) // nil
num1 = 10
print(num1) // Optional(10)


// .none 就是nil
var num2:Optional<Int> = .none
print(num2) // nil
num2 = .some(10)
print(num2) // Optional(10)
```

##### 2、自己实现
```swift
enum MYOptional<T> : ExpressibleByNilLiteral & ExpressibleByIntegerLiteral & CustomStringConvertible{
    case none
    case some(T)
    
    // 字面量协议： ExpressibleByNilLiteral
    init(nilLiteral: ()) {
        self = .none
    }
    
    // 字面量协议：ExpressibleByIntegerLiteral
    init(integerLiteral : Int) {
        self = .some(integerLiteral as! T)
    }

    // CustomStringConvertible 协议
    var description: String {
        switch self {
        case .none:
            return "nil"
        case let .some(val):
            return "Optional(\(val))"
        }
    }
}


var num3:MYOptional<Int> =  nil
print(num3) // nil
num3 = 10
print(num3) // Optional(10)


var num4:MYOptional<Int> = .none
print(num4) // nil
num4 = .some(10)
print(num4) // Optional(10)
```


## <a id="content4">枚举/结构体/类</a>
<!--===============================================================================================-->

### 枚举

#### **一、原始值**
内存占用1字节

```swift
enum Season:Int{
    case spring = 1,summer,autumn,winter
    
    //enum 的 rawValue的本质是计算属性
    var rawValue: Int{
        get{
            switch self {
            case .spring:
                return 10
            case .summer:
                return 20
            case .autumn:
                return 30
            case .winter:
                return 40
            }
        }
    }
}
    
let value = Season.spring.rawValue
print(value)// 10
```

#### **二、枚举关联值**
内存占用 1字节 + n字节
```swift
enum Score{
    case points(Int)
    case grade(Character)
}

var sc = Score.points(96)
sc = .grade("A")

// 关联值绑定
switch sc {
case let .points(i):
    print(i,"points")
case let .grade(i):
    print(i,"grade")//A grade
}
```

#### **三、枚举内也可以定义方法**
```swift
enum Season:String {
    case Spring, Summer, Autum, Winter
    func show(){
        print("rawValue is \(rawValue)")
    }
}
```


### 结构体
结构体是值类型  内存分布：栈空间<br>
let 对结构体变量和类变量的不同，理解let的本质<br>
结构体没有便捷初始化器<br>
具体的样式，参考下面的类对象<br>


### 类
#### 一、基本结构

类是引用类型<br>
内存分布：堆空间(16的倍数) 前8字节isa 再8字节引用计数。let p = Person() p占用8个字节<br>
嵌套的类型不占用外部类型的空间<br>

**Person对象**
```swift
class Animal {
    var age:Int = 0
    init(age: Int) {
        self.age = age
    }
}


class Person : Animal {
    //存储实例属性
    var name:String = ""{
        willSet{
            print(newValue)
        }
        didSet{
            print(oldValue)
        }
    }
    
    //计算实例属性 必须是var,本质是方法
    //计算属性必须执行类型
    var nameAndAge:String {
        set{
            print(newValue)
        }
        get{
            return "\(self.name) : \(self.age)"
        }
    }

    
    //存储类型属性
    static var armNum:Int = 2 {
        willSet {
            
        }
        didSet {
            
        }
    }
    
    static var legNum:Int{
        set {
            
        }
        get {
            return 2
        }
    }
    
    //init方法(重要)：指定初始化器 + 便捷初始化器，以及父子类中有哪些规则
    //指定初始化器不能互相调用，一个指定初始化器就是一个出口


    // 指定初始化器
    init(age: Int, name: String) {
        //初始化的第一阶段
        self.name = name
        super.init(age: 0)
        
        //初始化的第二阶段
        self.age = age
    }
    
    //便捷初始化器
    convenience init(name:String) {
        self.init(age: 0, name: "xiaoming")
    }
    
    
    // 实例方法
    func tellMeYourName(use language:String) -> String {
        if language == "En" {
            return "my name is \(self.name)"
        } else {
            return "我的名字叫 \(self.name)"
        }
    }
    
    // 静态方法
    static func runDes (){
        print("run is a ability of human")
    }

    // deinit 方法不适用于结构体和枚举，因为它们是值类型，而不是引用类型
    // deinit方法：先子类后父类
    deinit{

    }
}

let p = Person(age: 18, name: "Jim")
p.tellMeYourName(use: "En")
Person.runDes()
Person.legNum
```


#### 二、实例对象与类对象
```Swift
class Person {}
let p :Person = Person()
let cls :Person.type = Person.self
// p 对应OC中的实例对象
// Person.self 对应OC中的类对象
// Person.type 对应OC中的Class
// Person 与 Person.self 都能调用类方法
// let pcls : Person.type = Person.self; 但是不能 let pcls:Person.type = Person
```

### 共同

#### **一、扩展**

扩展可以给类添加方法：方法、计算属性、下标

扩展不能重写类的方法：如果能重写是不是就覆盖掉了系统类的实现，那些使用系统类方法的地方就会有问题

扩展不能添加指定初始化器：Swift中的初始化是一个严格的过程，不允许在扩展中添加，保证初始化的一致性

```swift
// 给stack类扩展遵守Equatable协议
// E 类中的泛型在扩展中仍然可以使用
// 满足某些条件才会有扩展
extension Stack : Equatable where E : Equatable {
    static func == (left: Stack, right: Stack) -> Bool {
        left.elements == right.elements
    }
}


// 扩展系统类
extension Array {
    subscript(nullable idx: Int) -> Element? {
        if (startIndex..<endIndex).contains(idx) {
            return self[idx]
        }
        return nil
    }
}
```

#### **二、访问控制**
模块：指的是独立的代码单元,框架或应用程序会作为一个独立的模块来构建和发布。在 Swift 中,一个模块可以使用 import 关键字导入另外一个模块

在访问权限控制这块，Swift提供了5个不同的访问级别(以下是从高到低排列， 实体指被访问级别修饰的内容)

**open:**允许其他模块访问、继承、重写(open只能用在类、类成员上)

**public:**其他模块中访问，不允许其他模块进行继承、重写

**internal:**只允许在当前模块访问、继承、重写，不允许其他模块访问

**fileprivate:**只允许在定义实体的源文件中访问

**private:**只允许在定义实体的封闭声明中访问，都在文件下的话private 和 fileprivate 作用相同

绝大部分实体默认都是internal 级别


## <a id="content5">协议</a>
<!--===============================================================================================-->
#### 一、一个完整的协议格式
```Swift
protocol Life {
    //Property in protocol must have explicit { get } or { get set } specifier
    var age:Int{get}
    var name:String{get set}
    init(age:Int, name:String)//也可以int?(xxx) int!(xxx)
    func run()
    mutating func grow()
    static func walk()
}

//协议的继承
protocol Dog : Life {
    func fake()
}

protocol Person : Life {
    var car:String{get}
}

protocol Teach {
    var studens:Array<Any>{get}
}


//协议的使用
class Teacher : Person & Teach {
    xxx
}
```

#### 二、带关联类型的协议
```swift
protocol Runable {
    associatedtype Speed // 关联类型
    func run(s:Speed)
}

//带关联类型和Self的协议只能作为泛型的约束，不能作为参数类型和返回值类型
//xy:参数类型和返回值类型需要确定的类型，不能包含不透明类型(协议内的关联类型为不透明类型或者叫不确定类型)
//要想带关联类型和Self的协议作为参数类型和返回值类型可以使用some关键字
func setObj(obj:some Runable) {
    
}
```

#### 三、给协议添加扩展

```swift
//提供默认实现
extension BinaryInteger {
    func isOdd() -> Bool { self % 2 != 0 }
}
```



## <a id="content6">泛型</a>
<!--===============================================================================================-->

#### 一、泛型就是将类型作为参数，或者说是类型的占位

```swift
// 方法与泛型
func test<T>(num:T) -> T {
    //返回值的类型也应该是T
    // 不能返回 num + 10,因为不知道num是否支持+号运算，也不知道(num+10)是否是T类型
    // 泛型在使用时要将其作为一个特定类型使用它就是T类型而不是其它任何类型。
    return num
}
test(num:10)

//枚举与泛型
enum Score<T>{
    case point(T)
    case grade(String)
}
let Score<Int>.point(10)


//类与泛型
class Stack<T> {
    var elements = [T]()
    func push(element:T) {
        elements.append(element)
    }
}
let st = Stack<Int>()
st.push(element:10)


//类与泛型与协议
protocol Stackable {
    associatedtype E // 关联类型
    mutating func push(element: E)
}

class Stack<T> : Stackable {
    //指定协议内的关联类型为具体类型
    //typealias E = Int
    //func push(element:E) {}
    
    //指定关联类型为泛型
    //typealias E = T
    //func push(element:E) {}
    
    //自定指定关联类型为Int
    //func push(element: Int) {}
    
    // 自定指定关联类型为T
    func push(element: T) {}
    
    // typealias 就是一个别名
}
```

#### 二、可以给泛型指定约束
```swift

// 用协议约束泛型
func compaire<T : Equatable>(num1:T, num2:T) -> Bool {
    return num1 == num2
}

// 用带有关联类型的协议约束泛型
protocol Runable {
    associatedtype Speed // 关联类型
    func run(s:Speed)
}
func setObj<T:Runable>(obj:T) {
}

class Animal : Runable {
    //指定关联类型为Int
    func run(s: Int) {}
}

let ani =  Animal()
setObj(obj:ani)
```

#### 三、some关键字
带关联类型和Self的协议只能作为泛型的约束，不能作为参数类型和返回值类型<br>
xy:参数类型和返回值类型需要确定的类型，不能包含不透明类型(协议内的关联类型为不透明类型或者叫不确定类型)<br>
```swift
// 下面两个方法会报错

//Protocol 'Runnable4' can only be used as a generic constraint because it has Self or associated type requirements
func get() -> Runable{
    return Animal() as! Runable
}

//Protocol 'Runnable4' can only be used as a generic constraint because it has Self or associated type requirements
func setobj(obj:Runable) {

}
```
要想带关联类型和Self的协议作为参数类型和返回值类型可以使用some关键字<br>
```swift
func get() -> some Runable{
    return Animal() as! Runable
}

func setobj(obj:some Runable) {

}
```

还可以使用泛型解决
```swift
func get<T:Runable> () -> T {

}

func set<T:Runable>(obj:T) {
    
}
```

## <a id="content7">模式匹配</a>
<!--===============================================================================================-->

#### 一、Switch 语句
```swift
let day = "Monday"

switch day {
case "Monday":
    print("It's the start of the week")
case "Friday":
    print("It's almost the weekend")
default:
    print("It's another day")
}
```

#### 二、元组解构
```swift
let person = ("Alice", 30)
let (name, age) = person

print("Name: \(name), Age: \(age)")
```

#### 三、Optional绑定
```swift
let optionalValue: Int? = 42

if let value = optionalValue {
    print("The value is \(value)")
} else {
    print("No value")
}
```

#### 四、联值绑定
##### 1、关联值绑定
```swift
var sc = Score.points(96)

// 关联值绑定
switch sc {
case let .points(i):
    print(i,"points")
case let .grade(i):
    print(i,"grade")
}
```

##### 2、值绑定
```swift
let values: [Int?] = [2, 3, nil, 5]

for case let value? in values {
    print("Found non-nil value: \(value)")
}
```


#### 五、类型模式匹配
```swift
let someValue: Any = "Hello, Swift"

if someValue is String {
    print("It's a string")
} else if someValue is Int {
    print("It's an integer")
}
```

#### 六、where 子句
```swift
let temperature = 25

switch temperature {
case let temp where temp < 0:
    print("It's freezing!")
case let temp where temp >= 0 && temp < 20:
    print("It's cold")
default:
    print("It's warm")
}

```


## <a id="content10">其它</a>
<!--===============================================================================================-->

mutating的使用

subscript的使用

final的使用：禁止被子类重写和继承<br>


```
inout的本质：地址传递
// 计算属性 和 设置了属性观察器的属性
copy in copy out(会产生一个副本)
```

```Swift
单利对象
public static let share = FileManager()
private func init(){}
```


进度：15-02


----------
>  行者常至，为者常成！


