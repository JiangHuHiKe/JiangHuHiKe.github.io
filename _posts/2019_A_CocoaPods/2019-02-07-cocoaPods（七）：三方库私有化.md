---
layout: post
title: "cocoaPods（七）：三方库私有化"
date: 2019-02-07
description: ""
tag: CocoaPods
---




## 目录
* [三方库私有化](#content1)



## <a id="content1">三方库私有化</a>

1、创建一个自己的代码仓库比如是：   
```text
https://xxxx/yyyyy/myAfn.git     
```

2、将三方库完整的clone下来
```text
git clone https://github/afnetworking/afn.git
```

3、修改三方库的远程仓库地址    
```text
cd afn
git remote set-url origin https://xxxx/yyyyy/myAfn.git
```

4、创建一个新的分支,并推送到远端
```text
git checkout -b main
git push -u origin main

// 如果在远端看不到tag列表，需要手动推送上去
git push origin --tags
```

5、比如我们要在8.3.2的版本基础上进行修改         
先将head检出到8.3.2的tag对应的提交处，然后创建一个新的分支     
```text
git checkout 8.3.2
git checkout -b 8.3.2_fix
git push -u origin 8.3.2_fix
```

6、在工程中引用自己修改过的三方库
```text
// 使用这种方式，不需要关心索引库的配置
pod 'AFNetworking',:git => 'https://xxxx/yyyyy/myAfn.git', :commit => '6deea8a4466055237000243ebf2d66da597e3324'
```



----------
>  行者常至，为者常成！



