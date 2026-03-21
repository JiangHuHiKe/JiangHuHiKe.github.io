---
layout: post
title: "bug菌_如何使用starter"
date: 2024-06-08
tag: Java
---


- [参考文档：Spring Boot入门(05)：学习如何使用starter来简化项目配置](https://luoyong.blog.csdn.net/article/details/125806789)


## 目录
- [介绍](#content1)   
- [如何引入](#content2)   



## <a id="content1">介绍</a>

spring-boot-starter 是 Spring Boot 提供的一种“开箱即用依赖集合”机制，本质上是对一组常用依赖的聚合封装**，用来简化项目配置。     
可以把它理解成：👉 一键打包好的“功能套餐”依赖     

一个 Web 项目可能要配几十个依赖 + XML 配置    
Spring Boot 的思路是：👉 帮你把“常用组合”提前选好 + 自动配置
于是就有了 starter。   

例如
```text
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
```
它背后帮你引入了：     
Spring MVC    
Jackson（JSON）   
Tomcat（内嵌服务器）    
日志组件    
👉 你只写一个依赖，就能启动 Web 服务

## <a id="content2">如何引入</a>     

```text
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
</dependencies>
```

执行下面的指令可以查看依赖树          
```text
mvn dependency:tree
```

有没有注意到一个问题，即在以上 pom.xml 的配置中，引入依赖 spring-boot-starter-web 时，其实并没有指明其版本(version)，但在依赖树中，我们却看到所有的依赖都带有版本信息，那么这些版本信息是在哪里控制的呢?     

```text
    <!--SpringBoot父项目依赖管理-->
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.3.1.RELEASE</version>
        <relativePath/>
    </parent>
```
所以当你明确父版本，其实你在引入一个stater如果不指定版本，其实就会将该父版本默认指定的那些依赖按版本帮你下载进来，这样就省去人工指定版本而烦恼了，设置还有的依赖版本会冲突等问题，这些springboot囗 的stater都帮你解决过了的。       








----------
>  行者常至，为者常成！


