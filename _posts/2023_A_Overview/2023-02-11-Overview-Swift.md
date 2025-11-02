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
- [重要](#content11)   



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
常用方法：
```text
// 字符串的拼接
let str1 = "hello";
let str2 = "world"
let newStr = str1 + " " + str2;

// 字符串子串
let startIdx = newStr.index(newStr.startIndex, offsetBy: 6)
let endIdx = newStr.index(newStr.endIndex, offsetBy: -1)
let subStr = newStr[startIdx...endIdx];
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

常用方法：   
```text
var array = [0, 1, 2, 3, 4, 5, 6]

// 常用属性
array.count;
array.first;
array.last;
array[0];

//尾部操作
array.append(7);
array.popLast();

//通用操作
array.insert(7, at: array.count);
array.remove(at: array.count-1)

//子数组
let subArray = array[2...array.count-1];
print(subArray);// [2, 3, 4, 5, 6]


let startIdx = array.index(array.startIndex, offsetBy: 2)
let endIdx = array.index(array.endIndex, offsetBy: -1)
let subArray2 = array[startIdx...endIdx]
print(subArray2)// [2, 3, 4, 5, 6]
```

```text
let array = [0, 1, 2, 3, 4, 5, 6]

// 映射
let newArray = array.map({(item) in
    return item * 2
})
// [0, 2, 4, 6, 8, 10, 12]
print(newArray)

// 过滤
let filterArray = array.filter({(item) in
    return item % 2 == 0
})
// [0, 2, 4, 6]
print(filterArray)


// 求和
let reduce = array.reduce(0, {(result, element) in
    return result + element;
})
// 21
print(reduce)

```

**3、Dictionary 和 Set 也是结构体类型，也是值类型**

常用方法：
```text
// 初始化一个字典
var emptyDict = [String: Int]()

// 初始化一个字典
var map:[String : Any] = [
    "name" : "xiaoming",
    "age" : 18
]

// ["age": 18, "name": "xiaoming"]
print(map)


// 1-1、获取，如果不存在就返回缺省值
var name = map["name",default: "Tom"]
//xiaoming
print(name)

// 1-2、获取，因为可能是空所以返回可选项
name = map["name"]
//Optional("xiaoming")
print(name)

// 2、修改
map["name"] = "Alice"
// ["age": 18, "name": "Alice"]
print(map)

// 3、删除一个key
map.removeValue(forKey: "age")
// ["name": "Alice"]
print(map)

// 4、增加一个key
map["age"] = 19
// ["age": 19, "name": "Alice"]
print(map)
```

```text
var dic:[String : Any] = [
    "name" : "xiaoming",
    "age" : 18
]

// 映射
let array = dic.map({(item) in
    // return (item.key, item.value)
    return item
})
// [(key: "name", value: "xiaoming"), (key: "age", value: 18)]
print(array)


// 过滤
let newDic = dic.filter({element in
    if element.key == "name" {
        return true
    } else {
        return false
    }
})
// ["name": "xiaoming"]
print(newDic)

// 求和
let result = dic.reduce(0, {(result, element) in
    if element.value is Int {
        return result + (element.value as! Int)
    } else {
        return result + 0
    }
})
// 18
print(result)
```



**4、元组是一个复合类型，也是值类型**


#### 四、Any AnyObject AnyClass  

Any 任意类型：对象类型，int类型等    

AnyObject 任意对象类型：实例对象

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
看下图分析：
```text
num1 == num3; // true 非空的可选项比较会递归解包
num2 == num4; // false 空也是有类型的，它俩类型不同所以不相等。   

这里重点介绍下num5,num5是非空的，所以比较时会递归解包
num2 == num5; // ture
```

<img src="./images/swift/swift_11.png">

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
class Stack<E> {
    var elements = [E]()
    
    func push(_ element: E) {
        elements.append(element)
    }
    
    func pop() -> E {
        elements.removeLast()
    }
    
    func size() -> Int {
        elements.count
    }
}
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


## <a id="content11">重要</a>

#### **SwiftUI**

**介绍**    
<span style="color:gray;font-size:12px;">
是swift推出的一套声明式UI框架，只需要描述界面，而不用关心具体的创建和更新    
它最大的特点是用状态(数据)驱动界面更新  
<span>

**它有三个核心概念**    
<span style="color:gray;font-size:12px;">
View：界面结构        
VStack/HStack/ZStack、Text/Button/Image、List/ScrollView、if/ForEach  
Modifier：修饰符      
padding/margin、font/backgroundColor     
State：状态      
@State、@Binding、@ObserveObject、@EnvironmentObject     
当数据发生变化时，界面自动更新         
</span>  

**好处**   
<span style="color:gray;font-size:12px;">
代码简洁，可读性高    
自动响应数据变化，不需要手动更新UI    
支持跨平台：iOS，macos    
和swift的combine天然结合，combine的publisher发布数据，swiftui进行订阅，自动刷新界面。并且逻辑和界面进行了解耦，非常清晰   
</span>

**坏处**   
<span style="color:gray;font-size:12px;">
对版本有要求 iOS13以后   
和UIKit需要桥接   
</span>



#### **Combine**    

**介绍**    
<span style="color:gray;font-size:12px;">
是swift推出的一套响应式编程框架，它通过发布-过滤-订阅的模式来处理数据。主要用于处理异步数据和UI绑定    
</span>

**它有三个核心概念**    
<span style="color:gray;font-size:12px;">
Publisher、operator、subscribe        
publisher：用于发布数据，比如网络请求的publisher，通过Future/promise转为Anypublisher、监听的publisher比如监听文本输入框、还有PassthroughSubject/CurrentValueSubject/Just、    
operator：对数据进行过滤和转换。map(类型映射)、debounce(防抖，搜索框)、throttle(节流，滚动位置上送)、flatMap(串行请求)、zip(并行请求)、filtter    
subscribe：订阅，对数据进行消费。sink(获取数据和完成事件)、assgin(绑定数据)    
</span>

**好处**    
<span style="color:gray;font-size:12px;">
对kvo，notification等监听机制进行了统一能很好的替换他们，代码不用散落在工程的各处    
解决了回调地狱的问题，比如一个网络请求依赖另外一个网络请求时可以使用flatMap进行实现    
并行控制，有多个网络请求都完成时再刷新UI，可以使用zip     
UI与数据绑定，自动更新UI。天然适配swiftUI和mvvm的设计模式    
</span>

**坏处**    
<span style="color:gray;font-size:12px;">
对版本有要求，iOS13以后。所以对老项目兼容性差    
语法风格冲突，与常规写法不同，与async和await不兼容需要做转化，有一定的学习成本    
调试困难，sink收到fail时，调用栈通常已经丢失     
</span>

**什么情况下适用**    
<span style="color:gray;font-size:12px;">
UI数据绑定    
持续性的数据流：比如防抖和节流   
复杂的异步依赖，比如串行和并行    
</span>




#### **async/await、task、actor**     

**介绍**     
<span style="color:gray;font-size:12px;">
async/await 让异步代码像同步代码一样书写      
async：声明一个异步函数    
await：调用异步函数，等待结果(只能出现在异步上下文里)   
<br>
task：创建一个新的异步任务     
taskGroup：任务组，当多个并发任务都完成时，再统一处理数据    
<br>
actor：多任务状态下保证数据安全的一种类型          
MainActor：特殊的actor，表示在主线程上调用，可以标记方法、类、结构体    
</span>


**好处：**     
<span style="color:gray;font-size:12px;">
像写同步代码一样写异步代码，代码结构更清晰
</span>


**坏处：**     
<span style="color:gray;font-size:12px;">
对版本有要求，ios15以后
</span>




#### **常用三方库**     

**Kingfisher**  
介绍      
<span style="color:gray;font-size:12px;">
网络图片加载库，是swift开源库。用于网络图片的下载，具有内存缓存，磁盘缓存的功能。         
读取顺序是：内存缓存 - 磁盘缓存 - 网络请求   
与SDWebImage类似，SD是oc代码。    
</span>

好处    
<span style="color:gray;font-size:12px;">
同时它支持一些sd不支持的功能       
1 webp下载，sd需要额外插件       
2 支持图片处理，比如圆角滤镜(通过配置一个 imageProcessor对象)。       
3 支持SwiftUI(通过 KFImage 组件实现)        
</span>


**Snapkit**    

介绍    
<span style="color:gray;font-size:12px;">
自动布局框架，是masory的swift版本，用更简洁的方式编写约束
</span>

主要操作有：    
<span style="color:gray;font-size:12px;">
设置约束：view.snp.makeConstraints { make in …   }   
更新约束：view.snp.updateConstraints { make in … }   
重置约束：view.snp.reMakeConstraints { make in … }    
</span>

框架提供了大量的锚点属性    
<span style="color:gray;font-size:12px;">
边距：top、bottom、left、right    
尺寸：width、height    
居中：center、centerX、centerY    
</span>

框架提供了相对约束    
<span style="color:gray;font-size:12px;">
相对父视图：make.top.equalToSuperview().offset(10)、make.center.equalToSuperview    
相对兄弟视图：make.top.equalTo(otherView.snp.bottom).offset(10)    
设置宽高：make.width.height.equalTo(100)     
</span>


**SwiftJson**      

介绍       
<span style="color:gray;font-size:12px;">
一个用于json解析和数据读取的框架     
</span>

主要操作
<span style="color:gray;font-size:12px;">     
将字符串转为json对象
</span>
```swift
let jsonString = "{\"name\":\"Alex\", \"age\":25}"    
let json = JSON(parseJSON: jsonString)    
```

<span style="color:gray;font-size:12px;">
将data转为json对象    
</span>
```swift
let data = NSData()    
let json = try? JSON(data: data)    
```

<span style="color:gray;font-size:12px;">
可以链式读取    
</span>
```swift
let name = json?["data"]["user"]["name"].stringValue ?? ""    
```

好处    
<span style="color:gray;font-size:12px;">
与codable相比，不需要定义模型，能够容错，key不存在时返回空，不会崩溃
</span>

适用        
<span style="color:gray;font-size:12px;">
快速调试或者类型不确定的三方接口推荐使用SwiftJSON    
正式开发阶段推荐使用codable进行自定转模型     
</span>

```swift
struct T : Codable {}
let decoder = JSONDecoder()
let mode = try decoder.decode(T.self, from: responseData)
```




----------
>  行者常至，为者常成！


