---
layout: post
title: "bug菌_整合mybatis-plus"
date: 2024-06-12
tag: Java
---


- [参考文档：Spring Boot入门(12)：从零开始！轻松掌握Spring Boot整合MyBatis-Plus的最佳实践！](https://luoyong.blog.csdn.net/article/details/125845236)
- [参考文档：Spring Boot入门(13)：Mybatis-Plus之条件构造器使用手册：精通让你快速提高查询效率的技巧！](https://blog.csdn.net/weixin_43970743/article/details/125846402)
- [参考文档：Spring Boot入门(14)：使用Mybatis-Plus轻松实现高效自定义SQL操作！](https://blog.csdn.net/weixin_43970743/article/details/125849168)
- [参考文档：Spring Boot入门(15)：【实战教程】Spring Boot + MyBatis-Plus 自动生成骨架代码，告别枯燥的重复劳动！](https://luoyong.blog.csdn.net/article/details/130561646)


## 目录
- [MyBatis-Plus的最佳实践](#content1)   
- [MyBatis-Plus的条件构造器](#content2)   
- [MyBatis-Plus的自定义SQL操作](#content3)   
- [MyBatis-Plus的自动生成骨架代码](#content4)   



## <a id="content1">MyBatis-Plus的最佳实践</a>


#### **一、基础介绍**
1、基本的目录结构：controller、service、mapper、entity

2、BaseMapper：继承 MyBatis-Plus 提供的 BaseMapper 接口，用于基本的 CRUD 操作。

3、BaseService：继承 MyBatis-Plus 提供的 BaseService 接口，用于定义业务逻辑方法。

4、BaseServiceImpl：实现 BaseService 接口，用于实现业务逻辑方法。

5、BaseController：继承 Spring Boot 提供的 Controller 类，用于定义 RESTful API 接口。

#### **二、Mapper.xml**
Mapper.xml：用于定义 SQL 语句，实现数据库操作。



## <a id="content2">MyBatis-Plus的条件构造器</a>

Wrapper 基础说明

| 构造器名称       | 用途说明                                   | 适用场景               |
|------------------|--------------------------------------------|------------------------|
| QueryWrapper     | 用于构建SQL语句的查询条件构造器            | 主要用于SELECT查询语句 |
| UpdateWrapper    | 用于构建SQL语句的更新条件构造器            | 主要用于UPDATE更新语句 |

常用条件构造方法对照表

| 方法名     | 对应SQL语义       |
|------------|-------------------|
| eq         | 等于 (=)          |
| ne         | 不等于 (<>)       |
| gt         | 大于 (>)          |
| ge         | 大于等于 (>=)     |
| lt         | 小于 (<)          |
| le         | 小于等于 (<=)     |
| between    | 在指定区间内      |
| notBetween | 不在指定区间内    |
| like       | 模糊匹配查询      |
| notLike    | 模糊排除查询      |
| in         | 在指定列表中      |
| notIn      | 不在指定列表中    |
| isNull     | 字段值为空        |
| isNotNull  | 字段值不为空      |



## <a id="content3">MyBatis-Plus的自定义SQL操作</a>



## <a id="content4">MyBatis-Plus的自动生成骨架代码</a>

<span style="color:red;font-size:14px;">目前只做了解即可</span>








----------
>  行者常至，为者常成！


