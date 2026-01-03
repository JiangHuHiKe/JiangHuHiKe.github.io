---
layout: post
title: "写第一个真正可访问的 Controller"
date: 2024-06-04
tag: Java
---


- [参考文档：Mac中 Java 环境配置](https://jianghuhike.github.io/12212.html)


## 目录
- [环境配置](#content1)   
- [创建项目](#content2)   



## <a id="content1">环境配置</a>


| 工具            | 作用        | 推荐               |
| ------------- | --------- | ---------------- |
| JDK           | Java 运行环境 | **JDK 17（LTS）**  |
| IntelliJ IDEA | 开发 IDE    | **Community 即可** |
| Maven         | 依赖管理      | IDEA 内置          |
| 浏览器 / Postman | 调接口       | 浏览器即可            |


**Java环境配置，见参考文章。**    

**IDEA 首次配置建议**

设置 JDK    
Settings → Build, Execution, Deployment → Build Tools → Maven
JDK 选择 17    

自动导入 Maven    
勾选： Import Maven projects automatically

编码     
Settings → Editor → File Encodings    
Global Encoding：UTF-8     



## <a id="content2">创建项目</a>

#### **一、新建项目**   

打开 IDEA   
New Project     
左侧选择：Spring Initializr    

#### **二、项目基础配置（照抄）**    

| 项           | 值             |
| ----------- |---------------|
| Project SDK | **JDK 17**    |
| Type        | Maven         |
| Language    | Java          |
| Group       | `com.lxy`     |
| Artifact    | `HelloSpring` |
| Packaging   | Jar           |
| Java        | 17            |

**选择依赖（现在只选一个）**     
勾选： Spring Web    
其他一律不选（保持干净）    

#### **三、创建过程图示**    

<img src="./images/java/1.png" width="600px;">
<br>
<img src="./images/java/2.png" width="600px;">
<br>
<img src="./images/java/3.png" width="600px;">

#### **四、启动方式（任选）**    
✅ 推荐：IDEA 启动        
点击 main 左侧 ▶️，选择 Run     

启动成功的标志，在控制台看到类似：
```text
Tomcat started on port(s): 8080
Started SpringDemoApplication in xxx seconds
```




----------
>  行者常至，为者常成！


