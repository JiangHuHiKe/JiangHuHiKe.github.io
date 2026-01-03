---
layout: post
title: "Spring Boot 启动流程 & IOC（核心思想）"
date: 2024-06-03
tag: Java
---




## 目录
- [Spring Boot 从哪“醒来”？](#content1)   
- [IOC / DI（重头戏）](#content2)   
- [示例代码解读](#content3)   



## <a id="content1">Spring Boot 从哪“醒来”？</a>

#### **一、标准启动类**     
```java
@SpringBootApplication
public class DemoApplication {

    public static void main(String[] args) {
        SpringApplication.run(DemoApplication.class, args);
    }
}
```
main 是 JVM 程序入口    

SpringApplication.run()：    
- 启动 Spring 容器   
- 扫描所有 Bean     
- 启动 Web 服务（Tomcat）

#### **二、@SpringBootApplication 是啥？**     

它是 3 个注解的集合体（先知道，不背）：

```java
@Configuration
@EnableAutoConfiguration
@ComponentScan
```
只需要记住一句话：     
它让 Spring：自动扫描 + 自动配置 + 自动启动


## <a id="content2">IOC / DI（重头戏）</a>

#### **一、一个示例**    
```java
@Service
public class UserServiceImpl implements UserService {}

@RestController
public class UserController {

    @Autowired
    private UserService userService;
}
```

你要能一眼看出：
- Spring 先创建 UserServiceImpl
- 再把它“塞”进 Controller
- Controller 不 new 任何东西


#### **二、Bean**    

```java
@Service
public class OrderService {}
```
**Bean = 被 Spring 管理的对象**          
有这个注解，Spring 才会：
- 创建它
- 管理它
- 注入它

**Bean 默认是单例（非常重要）**     

**Spring 管一生，你只负责“用”**     
Bean 生命周期：创建 → 初始化 → 使用 → 销毁   


#### **三、必须形成的 4 个“后台直觉”**   
1️⃣ Spring 项目中 不主动 new 业务对象   
2️⃣ 类要想被用，必须是 Bean    
3️⃣ 注解 = 身份声明    
4️⃣ Spring Boot ≠ Spring（它是“自动化的 Spring”）    


## <a id="content3">示例代码解读</a>

#### 一、示例代码分析**    
```java
// @Service ≈ @Component
// 作用只有一个：👉 告诉 Spring：这是一个要被我管理的对象（Bean）
// 在应用启动时：SpringApplication.run(...)Spring 会做一件事：
// 扫描包 -> 找到所有带 @Component / @Service 的类 -> 创建对象 -> 放进 IOC 容器
@Service

// Spring 会建立一个映射关系：接口 UserService → 实现类 UserServiceImpl
public class UserServiceImpl implements UserService {}


// @RestController = 两个注解的组合
// @Controller @ResponseBody
// 含义是：这是一个 Web 控制器 + 返回值直接转成 JSON
// UserController 也是 Bean 和 @Service 一样：
// Spring 会创建它 -> Spring 管理它 -> Spring 控制生命周期
// ⚠️ Controller 也不是你自己 new 的
@RestController
public class UserController {

    /*
        1. 创建 UserServiceImpl（因为它是 @Service）
        2. 创建 UserController（因为它是 @RestController）
        3. 发现 UserController 里有 @Autowired
        4. 看字段类型：UserService
        5. 去容器里找：谁实现了 UserService？
        6. 找到：UserServiceImpl
        7. 注入进去
     * */
    @Autowired
    private UserService userService;
}
```

**如果有多个实现怎么办？**    
```java
@Service
public class UserServiceImplA implements UserService {}

@Service
public class UserServiceImplB implements UserService {}
```
❌ Spring 会直接报错：不知道用哪个.后续会学到解决方式。         

**为什么 Spring 要你这么写？下面这种写法不行吗？**

```java
public class UserController {

    private UserService userService = new UserServiceImpl();
}
```
❌ 不行： Spring 管不了这个对象   
无法做： AOP（日志、事务）、代理、生命周期管理    
强耦合   

#### **二、Spring 的设计目标**

Controller 只关心“我需要什么”    
至于“怎么来的”，交给容器

































----------
>  行者常至，为者常成！


