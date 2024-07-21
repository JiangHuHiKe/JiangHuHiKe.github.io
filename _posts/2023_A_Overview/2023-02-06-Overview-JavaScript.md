---
layout: post
title: "JavaScript概要"
date: 2023-02-06
tag: Overview
---   




## 目录
* [语言](#content1)
* [变量/函数提升](#content2)
* [构造函数](#content3)
* [原型对象](#content4)
* [this指针](#content5)
* [闭包](#content6)
* [异步](#content7)
* [事件循环](#content8)
* [定时器](#content9)
* [捕获与冒泡](#content10)
* [Dom](#content11)
* [其它](#content12)





<!-- ************************************************ -->
## <a id="content1">语言</a>

#### **一、常量变量**  
```js
// 常量：不允许修改
const pi = 3.14 

// 变量：可以修改
let num = 99 
num= 100 
```

#### **二、基本数据类型**   
```js
// boolean
let isClick = false

// number(NaN也是number类型 浮点也是number类型)
let a = 0

// string
let str = 'hello world'

// undefine是一种类型
undefine
```

#### **三、对象类型**  
```js
let array = [1, 2, 3]

let dic = {key1:'value1', key2:'value2'}

let person = new Person('xiaoming', 18)

// 匿名函数
let blk = (a, str)=>{ return 10 }
let blk = function(a, str){ return 10}

// 函数
function sum (numA, numB) {}

// null 也是object类型
let test = null
```

#### **四、一门语言有哪些基本要素**     

**1、分支结构、循环结构**  

**2、面向对象、面向过程**    
封装、继承、多肽      
属性      
方法：构造函数、析构函数、普通函数    

**3、多线程、同步异步**   

**4、其它**   
运算：四则/逻辑/位运算    
事件：捕获与冒泡    
定时器：间隔执行、到点执行    


<!-- ************************************************ -->
## <a id="content2">变量/函数提升</a>

#### **一、变量提升**  

当你使用 `var` 关键字声明变量时，这个变量的声明会被提升到当前函数或全局作用域的顶部

```js
// 输出: undefined
console.log(x); 
var x = 10;

// 相当于
var x;
console.log(x); 
x = 10;
```

理解：函数作用域 和 块级作用域{}     
```js
// 使用 let 声明的变量，具有块级作用域
if (true) {
    // var blockScopedVar = 'I am block scoped';
    let blockScopedVar = 'I am block scoped';
}
console.log(blockScopedVar); // 报错：blockScopedVar is not defined


for (var i = 0; i < 5; i++) {
    setTimeout(function () {
        console.log(i); // 输出: 5，5，5，5，5（因为 i 具有函数作用域，共享相同的 i 变量）
    }, 1000);
}

for (let j = 0; j < 5; j++) {
    setTimeout(function () {
        console.log(j); // 输出: 0，1，2，3，4（因为 j 具有块级作用域，每个循环迭代都有自己的 j 变量）
    }, 1000);
}
```

#### **二、函数提升**    
声明一个函数时，整个函数体（包括函数名称和函数体内的内容）会被提升到当前函数或全局作用域的顶部    

```js
greet(); // 输出: Hello!
function greet() {
    console.log('Hello!');
}


// 实际上，上述代码在执行时会被解释为以下形式：
function greet() {
    console.log('Hello!');
}
greet();
```


<!-- ************************************************ -->
## <a id="content3">构造函数</a>

#### **一、构造函数**         
1、创建实例对象(属性 + 方法)     
2、方法内this指向实例对象   
3、person1.sing 和 person2.sing并不是同一个方法

```js
/*
命名以大写字母开头
只能由 "new" 操作符来执行 - 实例化
构造函数返回实例化对象，return 返回的值无效，所以不要写return
构造函数内部的this指向实例化对象
*/
function Person(name = '', age = 1) {
    this.name = name
    this.age = age
    this.sing = () => {
        console.log('我会唱歌')
    }
    this.dance = function () {
        console.log('我会跳舞')
    }
}

// 创建实例对象：因为参数有默认值，可以不传参
let person1 = new Person()
let person2 = new Person('qiaozhi', 6)

//获取属性、调用方法
console.log(`person = ${person.name}-${person.age}`)
person.sing()
person.dance()

//false
console.log(person1.sing == person2.sing);
```

#### **二、静态属性/方法**      
```js
/*
构造函数的属性和方法被称为静态成员
静态属性，静态方法
静态成员方法中的 this 指向构造函数本身
*/
Person.eyes = 2
Person.walk = function () {
    console.log('人多会走路', this.eyes)
}
console.log(Person.eyes, Person.walk());
```


<!-- ************************************************ -->
## <a id="content4">原型对象</a>

原型对象的本质，它也是一个对象     
作用：共享方法、共享属性、可以节省内存   

#### **一、原型对象**   

**原型对象共享方法**    
```js
// 在Person构造函数的原型对象上添加一个方法
Person.prototype.sing = function () {
    //构造函数和原型对象中的this 都指向 实例化的对象
    console.log(`${this.name}正在唱歌...`);
}

// 创建两个Person对象
let ldh = new Person('刘德华', 50)
let zxy = new Person('张学友', 55)

// 这两个对象共享相同的原型对象上的sing方法
ldh.sing()// 输出:刘德华正在唱歌
zxy.sing()// 输出:张学友正在唱歌

// 这是同一个方法
console.log(ldh.sing === zxy.sing); // 输出：true
```

**原型对象共享属性**    

```js
// 定义一个共享的age属性并初始化为0
Person.prototype.age = 0; 
const person1 = new Person('Alice');
const person2 = new Person('Bob');
console.log(person1.age); // 输出: 0
console.log(person2.age); // 输出: 0


// 修改了person1的age属性.
//实际上创建了一个名为age的属性并将其分配给person1对象，而不会修改原型对象上的age属性
person1.age = 25;
console.log(person1.age); // 输出: 25
console.log(person2.age); // 输出: 0（person2的age属性仍然是0，因为它没有被修改）
```

#### **二、原型链**   

基类    
```js
// 基类构造函数
function Animal(name) {
    this.name = name;
}
// 基类原型对象上的方法
Animal.prototype.sayHello = function () {
    console.log(`Hello, I'm ${this.name}`);
};
```

子类   
```js
// 派生类构造函数
function Dog(name, breed) {
    // 使用call方法调用基类构造函数，以继承基类属性
    Animal.call(this, name);
    this.breed = breed;
}


// 建立原型链，使Dog继承Animal
Dog.prototype = Object.create(Animal.prototype);
Dog.prototype.constructor = Dog; // 修复构造函数指向


// 派生类上的方法
Dog.prototype.bark = function () {
    console.log(`${this.name} is barking!`);
};
```

使用   
```js
// 创建Animal实例
const animal = new Animal('Generic Animal');
animal.sayHello(); // 输出: Hello, I'm Generic Animal

// 创建Dog实例
const dog = new Dog('Buddy', 'Golden Retriever');
dog.sayHello(); // 输出: Hello, I'm Buddy
dog.bark(); // 输出: Buddy is barking!

// 是否是同一个方法
console.log(dog.sayHello === animal.sayHello); // ture
```

**继承链关系图**  
三个关键：构造函数、原型对象、实例对象     
<img src="/images/web/3.png">

**instanceof的用法**

```js
// 是否在继承链上
console.log(arr instanceof Object); // true
```


<!-- ************************************************ -->
## <a id="content5">this指针</a>

#### **一、this讲解**   

<span style="color:red;font-weight:bold;">只有普通函数内才有this:</span>          
普通函数this指向调用者:Obj.testFunc(),指向Obj       
当函数直接调用时，this指向全局对象（在浏览器中是window，在Node.js中是global）。在严格模式下，this会是undefined。     
testFunc()，指向全局对象。        

```js
function generalFn() {
    // 普通函数的this是 [object Window]
    console.log(`普通函数的this是 ${this}`);
}
generalFn()
```

箭头函数：          
箭头函数中并不存在 this    
箭头函数会默认帮我们绑定外层 this 的值     
**箭头函数的this是在定义时确定，捕获的定义时上下文中的this**    
适用：需要使用上层this的地方      
不适用：    
构造函数/原型函数/字面量对象中函数/dom事件函数     

```js
let person = {
    name: "qiaozhi",
    age: 5,
    walk: function () {
        // 对象内普通函数的this是 [object Object]
        console.log(`对象内普通函数的this是 ${this}`);
    },
    eat: () => {
        // 对象内箭头函数的this是 [object Window]
        console.log(`对象内箭头函数的this是 ${this}`);
    }
}
person.walk()
person.eat()
```

```js
class Timer {
  constructor() {
    this.seconds = 0;
  }

  start() {
    setInterval(() => {
      this.seconds++;
      console.log(this.seconds);
    }, 1000);
  }
}

const timer = new Timer();
timer.start();
```

在这个例子中，setInterval的回调函数是一个箭头函数，因此this指向Timer实例，而不是setInterval的上下文(不是setInterval内的调用者)。

<span style="color:red;font-weight:bold;">箭头函数的this指向不变，避免了传统函数中this指向不确定的问题</span>   


#### **二、修改this指向**

三个函数：call、apply、bind(对箭头函数无效)     

```js
let person = { name: '乔治', age: 18 }
function sayHi(x, y) {
    console.log(`this 指向 ${JSON.stringify(this)}`, `参数1：${x}`, `参数2：${y}`);
}

// this 指向 {"name":"乔治","age":18} 参数1：call1 参数2：call2
sayHi.call(person, 'call1', 'call2')


//this 指向 {"name":"乔治","age":18} 参数1：apply1 参数2：apply2
sayHi.apply(person, ['apply1', 'apply2'])
// apply 主要跟数组有关系,把参数变成了数组形式传入，比如使用 Math.max() 求数组的最大值
console.log(Math.max.apply(null, [1, 2, 3]))
console.log(Math.max(...[1, 2, 3]))


// this 指向 {"name":"乔治","age":18} 参数1：bind1 参数2：bind2
let sayHello = sayHi.bind(person)
//bind 不会调用函数, 可以改变函数内部this指向.
sayHello('bind1', 'bind2')
```



<!-- ************************************************ -->
## <a id="content6">闭包</a>

什么是闭包？   
外层函数 + 内层函数 + 内层函数访问外层函数的变量     
                
逃逸闭包？   
在调用函数内部被执行为非逃逸闭包。    
函数调用结束了，仍然可以被调用是逃逸闭包。    

可能引起的问题：   
内存泄露    

**1、访问局部变量：计数器**     
```js
function counter() {
    let count = 0;
    return function () {
        return count++;
    };
}
const increment = counter();
console.log(increment()); // 0
console.log(increment()); // 1
```

**2、模块化：计算器**     
```js
// 闭包可以用于创建模块化的代码结构，将相关的功能函数(内部函数)封装在一个函数(外部函数)内部，并通过返回内部函数来暴露一些接口。
function createCalculator() {
    let result = 0;
    return {
        add: function (num) {
            result += num;
        },
        subtract: function (num) {
            result -= num;
        },
        getResult: function () {
            return result;
        }
    };
}
const calculator = createCalculator();
calculator.add(5);
calculator.subtract(2);
console.log(calculator.getResult()); // 3
```


**3、异步执行：网络请求**      
```js
function fetchData(url, callback) {
    // 外部函数：fetchData; 内部函数： setTimeout; 局部变量：callback;
    // 模拟异步请求
    setTimeout(function () {
        const data = 'Some data from the server';
        callback(data);
    }, 1000);
}
fetchData('https://example.com/api/data', function (result) {
    console.log('Data received:', result);
});
```


<!-- ************************************************ -->
## <a id="content7">异步</a>

#### **一、Promise**    

Promise的两个关键：resolve 和 reject     
resolve触发.then内的回调，reject触发.catch内的回调     
```js
const p1 = new Promise((resolve, reject) => {
    console.log('这个代码块是立即执行的1')
    setTimeout(() => {
        resolve('第一次回调')
    }, 2000);
})

// promise实例对象的then方法
const p2 = p1.then(result => {
    console.log(result)
    return new Promise((resolve, reject) => {
        console.log('这个代码块是立即执行的2')
        setTimeout(() => {
            resolve('第二次回调')
        }, 2000);
    })
})

p2.then((result) => {
    console.log(result)
})
```

以上代码可以使用链式编程写成下面这样     
```js
console.log(1)
new Promise((resolve, reject) => {
    console.log('这个代码块是立即执行的1')
    setTimeout(() => {
        resolve('第一次回调')
        // reject('第一次回调：失败')
    }, 2000);
}).then((result) => {
    console.log(result)
    return new Promise((resolve, reject) => {
        console.log('这个代码块是立即执行的2')
        setTimeout(() => {
            resolve('第二次回调')
            // reject('第二次回调：失败')
        }, 2000);
    })
}).then((result) => {
    console.log(result)
}).catch((error) => {
    console.log(`error:${error}`);
});
console.log(2)

/**
1
这个代码块是立即执行的1
2
第一次回调
这个代码块是立即执行的2
第二次回调
*/


//then可以传递两个回调函数，一个成功回调，一个失败回调
//.then((success)=>{},(error)=>{});
```

#### **二、async 和 await的使用**   

```js
function asyncAndAwaitTest() {

    console.log('执行顺序0')
    testFunc()
    console.log('执行顺序1')

    async function testFunc() {
        //async函数和await_捕获错误 使用try...catch
        try {

            console.log('执行顺序2');

            //重要：在 async 函数内，使用 await 关键字取代 then 函数，等待获取 Promise 对象成功状态的结果值
            let p = new Promise((resolve, reject) => {
                console.log('执行顺序3')
                setTimeout(() => {
                    resolve('这是resolve的结果')
                    // reject('这是reject的结果')
                }, 2000);
                console.log('执行顺序4')
            })

            //await 后边跟的是一个Promise 的实例对象p
            // p 的异步执行结果能拿到的两种方式就是 p.then((result)=>{})) 或 let result = await p
            const result = await p

            console.log('执行顺序5')
            console.log(result)
            console.log('执行顺序6')

        } catch (error) {
            console.log('error = ', error);
        }

        /*
            执行顺序0
            执行顺序2
            执行顺序3
            执行顺序4
            执行顺序1
            ... 2s后执行下面
            执行顺序5
            这是resolve的结果
            执行顺序6
        */
    }
}
```

```js
function promiseAllTest() {
    const bjPromise = axios({ url: 'http://hmajax.itheima.net/api/weatherc', params: { city: '110100' } })
    const shPromise = axios({ url: 'http://hmajax.itheima.net/api/weather', params: { city: '310100' } })
    Promise.all(
        [bjPromise, shPromise]
    ).then((result) => {
        // 注意：结果数组顺序和合并时顺序是一致
        console.log(result)
    }).catch((error) => {
        console.log('error = ', error)
    })
}
```


<!-- ************************************************ -->
## <a id="content8">事件循环</a>

<img src="/images/web/4.png">


<!-- ************************************************ -->
## <a id="content9">定时器</a>

**1、定时器**   
```js
setTimeout(() => {
    console.log('这段代码会在2秒后执行');
}, 2000);


const timer = setTimeout(() => {
    console.log('这段代码不会执行');
}, 2000);

//清除定时器
clearTimeout(timer)
```

**2、间歇函数**   

```js
setInterval(() => {
    console.log('这段代码会间隔1秒执行');
}, 1000);

const interval = setInterval(() => {
    console.log('这段代码不会执行');
}, 1000);

// 清除间歇函数
clearInterval(interval)
```


<!-- ************************************************ -->
## <a id="content10">捕获与冒泡</a>

lxy:捕获与冒泡是一个完整的事件链路，stopPropagation会终止整个链路的后续事件    
lxy:链路：父元素捕获回调 - 子元素捕获回调 - 子元素冒泡回调 - 父元素冒泡回调     

```js
// 捕获事件回调
container.addEventListener('click', function (e) {
    // console.log(e) // e 是事件对象

    //this 是环境对象
    console.log(`捕获：${this.className}监听回调，被点击对象是${e.target.className}`)
    // e.stopPropagation()
}, true)//默认是false:冒泡事件回调。true:捕获事件回调


// 冒泡事件回调  
container.addEventListener('click', function (e) {
    console.log(`冒泡：${this.className}监听回调，被点击对象是${e.target.className}`)
    // e.stopPropagation()
}, false)
```

<!-- ************************************************ -->
## <a id="content11">Dom</a>

**1、对一个节点，添加/删除/转换 一个类选择器**     
```js
let container = document.querySelector('.container')
container.classList.add('border')
container.classList.remove('container')
container.classList.toggle('container')
```

**2、克隆/追加/插入/删除一个节点**    
```js
//true 克隆所有子节点 false为只克隆自己
const cloneSub1 = sub1.cloneNode(true)
father.appendChild(cloneSub1)// 追加到后边
father.insertBefore(sub3, sub1)// 插入到sub1的前边
father.removeChild(sub3)
```

**3、拿到一个节点(父容器)，修改它的innerHTML**
```js
let sub = document.querySelector('.container .sub')
sub.style.backgroundColor = 'blue'
sub.innerHTML = `<h1>哈哈</h1>`

let divs = document.querySelectorAll('div')
console.dir(divs)
```

**4、节点的查询**   
```js
father.children
sub1.parentNode
sub1.nextElementSibling
```

**5、偏移计算**    
```js
//html 被卷去的头部
let scrollTop = document.documentElement.scrollTop
console.log(scrollTop)

//offsetTop以谁为准：带有定位的父级，如果都没有则以 文档左上角 为准
let offsetTop = document.querySelector('.sub').offsetTop
console.log(offsetH)
```



<!-- ************************************************ -->
## <a id="content12">其它</a>

#### **一、节流与抖动**   

**1、节流**    
对于连续触发的事件，在 n 秒中只执行一次函数。如果不加节流在n秒内可能调用上百次       

```js
let div = document.querySelector('.throttle')

let callFn = function () {
    div.innerHTML = i++
}

i = 0
// div.addEventListener('mousemove', callFn)

//节流：对于连续触发的事件，在 n 秒中只执行一次函数。如果不加节流在n秒内可能调用上百次
div.addEventListener('mousemove', throttle(callFn, 500))


//节流函数
function throttle(fn, msecond = 500) {
    let startTime = new Date()
    return function () {
        let now = new Date()
        if (now - startTime >= msecond) {
            fn()
            startTime = now
        }
    }
}
```

**2、抖动**   
在指定时间内，如果触发了第二次操作，就将第一次取消，然后重新计时。     
比如：输入框事件    
```js
let div = document.querySelector('.debounce')

let callFn = function () {
    div.innerHTML = i++
}

i = 0
// div.addEventListener('mousemove', callFn)

div.addEventListener('mousemove', debounce(callFn, 500))


//
function debounce(fn, msecond = 500) {
    let timeId
    return function () {
        if (timeId) clearTimeout(timeId)
        timeId = setTimeout(function () {
            fn()
        }, msecond);
    }
}
```




#### **二、JS的GC机制**   

JS同样也不需要我们去手动管理内存。JS的内存管理使用的是GC机制（Tracing Garbage Collection）。     
不同于OC的引用计数，Tracing Garbage Collection是由GCRoot（Context）开始维护的一条引用链，一旦引用链无法触达某对象节点，这个对象就会被回收掉。如下图所示：
<img src="/images/web/5.png">

----------
>  行者常至，为者常成！



