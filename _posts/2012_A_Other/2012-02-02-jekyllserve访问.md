---
layout: post
title: "jekyll serve访问"
date: 2012-02-02
description: ""
tag: 其它
---







## 目录
- [jekyll serve访问](#content1)   
- [修改jekyll serve 的端口号](#content2)   



<!-- ************************************************ -->
## <a id="content1">jekyll serve访问</a>

jekyll搭建自己的博客非常方便，通过jekyll serve -w 可以持续监控文件的修改情况、编译成HTML并通过HTTP服务给本机（localhost）进行访问。

```
Server address: http://127.0.0.1:4000/

Server running... press ctrl-c to stop.
```

由于jekyll将地址绑定到了127.0.0.1，导致局域网的其它机器并不能访问它的服务。但实际上只要改变运行jekyll的参数就可以了。

```
$ jekyll serve -w --host=0.0.0.0

Server address: http://0.0.0.0:4000/

Server running... press ctrl-c to stop.
```

这样就可以通过该机器的IP地址访问网站了。



<!-- ************************************************ -->
## <a id="content1">修改jekyll serve 的端口号</a>

方式一：
```
jekyll serve --port 8888
```

方式二：
修改 _config.yml 文件,在文件内添加配置项   
```
port: 8080 # Add this line to specify the port number
```
然后在终端中运行   
```
jekyll serve
```

----------
>  行者常至，为者常成！


