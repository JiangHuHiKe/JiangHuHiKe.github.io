---
layout: post
title: "DispatcherServlet 开始的请求"
date: 2024-06-05
tag: Java
---




## 目录
- [Spring / Spring mvc / Spring Boot](#content1)   
- [一次 HTTP 请求进来后，发生了什么？](#content2)   



## <a id="content1">Spring / Spring mvc / Spring Boot</a>

#### **一、Spring 是什么？**

Spring = 一个大的生态 / 容器     
核心能力是：     
<span style="color:gray;font-size:12px;">
IoC（容器）<br>
AOP<br>
事务<br>
Web（Spring MVC）<br>
数据（JPA / MyBatis / JDBC）<br>
安全（Spring Security）<br>
</span>
👉 Spring MVC 只是 Spring 生态中的一个模块       

#### **二、Spring MVC 是什么？**     

Spring MVC = Web 层框架    
它解决的问题是：     
<span style="color:gray;font-size:12px;">
HTTP 请求怎么进来<br>
URL 怎么映射到方法<br>
参数怎么绑定<br>
返回值怎么变成响应<br>
视图 / JSON 怎么处理
</span>    

#### **三、Spring Boot 是什么？**     

Spring Boot 做了 3 件大事：     
<span style="color:gray;font-size:12px;">
自动创建 ApplicationContext<br>
自动创建 DispatcherServlet<br>
自动把 Spring MVC 相关组件装进容器<br>
</span>

所以你只写：
```java
@SpringBootApplication
public class App {
    public static void main(String[] args) {
        SpringApplication.run(App.class, args);
    }
}
```

MVC 就已经能跑了。




#### **四、对比表**     

**概念级对比表**

| 维度           | Spring         | Spring MVC         | Spring Boot         |
| ------------ | -------------- | ------------------ | ------------------- |
| 本质           | Java 企业级开发框架   | Spring 的 Web 模块    | Spring 的启动 & 自动配置方案 |
| 解决什么问题       | 对象管理、解耦、事务、AOP | Web 请求 → 业务处理 → 响应 | 让 Spring / MVC 快速可用 |
| 是否是框架        | ✅ 是            | ✅ 是                | ❌ 不是新框架             |
| 是否依赖 Servlet | ❌ 不一定          | ✅ 是                | 间接依赖                |
| 是否可单独使用      | ✅              | ✅                  | ❌（必须基于 Spring）      |

**能力职责对比表（重点）**      

| 能力                | Spring | Spring MVC | Spring Boot |
| ----------------- | ------ | ---------- | ----------- |
| IoC / DI          | ✅ 核心能力 | 使用         | 自动配置        |
| AOP               | ✅ 核心能力 | 可用         | 自动启用        |
| Web 请求处理          | ❌      | ✅ 核心       | 自动装配        |
| DispatcherServlet | ❌      | ✅ 提供       | ✅ 自动注册      |
| Controller        | ❌      | ✅          | ✅           |
| Tomcat            | ❌      | ❌          | ✅ 内嵌        |
| JSON 转换           | ❌      | 部分         | ✅ 默认配置      |

**配置方式对比（很直观）**

| 项目   | Spring            | Spring MVC | Spring Boot |
| ---- | ----------------- | ---------- | ----------- |
| 配置方式 | XML / Java Config | XML + Java | 注解 + 约定     |
| 配置量  | ⭐⭐⭐⭐              | ⭐⭐⭐        | ⭐           |
| 上手成本 | 高                 | 中          | 低           |
| 生产主流 | ❌                 | ❌          | ✅           |

Spring = 一个大的生态 / 容器     
**Spring：管对象、管关系（IoC / AOP）**        
**Spring MVC：管 Web 请求**          
**Spring Boot：一键把它们装好并跑起来**    



## <a id="content2">一次 HTTP 请求进来后，发生了什么？</a>

```text
浏览器
  ↓
Tomcat
  ↓
DispatcherServlet
  ↓
HandlerMapping
  ↓
HandlerAdapter
  ↓
Controller
  ↓
返回 ModelAndView / ResponseBody
  ↓
ViewResolver（如需要）
  ↓
DispatcherServlet
  ↓
响应给浏览器
```


| 组件                | 角色定位      | 一句话理解    |
| ----------------- | --------- | -------- |
| DispatcherServlet | 总入口 / 总指挥 | 所有请求先找它  |
| HandlerMapping    | 路由器       | URL → 方法 |
| HandlerAdapter    | 执行器       | 真正调用方法   |













----------
>  行者常至，为者常成！


