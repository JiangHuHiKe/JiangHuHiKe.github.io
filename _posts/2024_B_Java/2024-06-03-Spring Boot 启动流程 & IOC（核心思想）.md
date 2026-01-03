---
layout: post
title: "Spring Boot 启动流程 & IOC（核心思想）"
date: 2024-06-03
tag: Java
---




## 目录
- [Spring Boot 从哪“醒来”？](#content1)   
- [IOC / DI（重头戏）](#content2)   



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

#### 一、一个示例**    
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





















----------
>  行者常至，为者常成！


