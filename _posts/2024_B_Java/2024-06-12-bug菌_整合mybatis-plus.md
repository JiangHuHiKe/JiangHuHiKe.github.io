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

#### **一、介绍下@select注解**     

`@select` 注解用于在 MyBatis-Plus 中定义 SQL 查询语句。    
它的作用是把一个 SQL 语句映射到一个方法上，当调用这个方法时，会自动执行对应的 SQL 语句。    

@select的用法：
```java
// 传参为String、Long、Integer 类型
// @Param("userId")的作用是 将Long userId 与 #{userId} 进行绑定
@Select("select * from user where id = #{userId}")
User getUserByIdWithZhuJie(@Param("userId") Long userId);


// 传参为 Object 类型
@Select("select * from user u  where u.sex = #{queryUser.sex} and u.age = #{queryUser.age}")
List<User> getUsersByQueryUserWithZhuJie(@Param("queryUser") QueryUser queryUser);
```


#### **二、参数类型**     

注解方式和 XML 方式都支持下面所有参数类型，区别只在于写法。    

| 参数类型 | 注解方式写法 | XML 方式写法 | 使用场景 |
| --- | --- | --- | --- |
| 基本参数（单个） | `@Param("name") String name` | `#{name}` | 按单个值查询：根据 id 查详情、根据用户名判断是否重复 |
| POJO / 实体对象 | 直接传实体，用 `#{属性名}` 取值 | 同左 | 新增、按实体字段更新：字段多时不用逐个传参 |
| Map 参数 | 传 `Map<String, Object>`，用 `#{key}` 取值 | 同左 | 动态多条件查询：查询条件个数和字段不固定 |
| 多个独立参数 | 每个参数加 `@Param("arg1")` | `#{arg1}` | 少量固定参数：如按用户名 + 状态两个条件查询 |
| 集合 / List 参数 | `@Param("ids") List<Integer> ids` | 配合 `<foreach>` 遍历 | `in` 查询、批量操作：按一批 id 查询或删除 |
| 数组参数 | `@Param("ids") Long[] ids` | 配合 `<foreach>` 遍历 | 调用方本身持有数组、不想再转 List 时使用 |
| `Map<String, Collection>` | 传嵌套 Map | 双层 `<foreach>` 遍历 | 一次传多组集合：如按多个分组分别批量查询，实际较少用 |

只有一个参数时 `@Param` 可以省略；   
有多个参数时建议都加 `@Param`，否则只能用 `arg0`、`param1` 这类默认名引用。      


## <a id="content4">MyBatis-Plus的自动生成骨架代码</a>

<span style="color:red;font-size:14px;">目前只做了解即可</span>








----------
>  行者常至，为者常成！


