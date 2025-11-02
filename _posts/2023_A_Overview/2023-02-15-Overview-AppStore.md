---
layout: post
title: "AppStore"
date: 2023-02-15
tag: Overview
---





## 目录


- [打包流程](#content1)   
- [审核机制](#content2)   


## <a id="content1">打包流程</a>
 

**构建**     
<span style="color:gray;font-size:12px;">
编译-链接-归档打包-导出ipa     
ipa包的本质就是一个压缩文件，将其改为payload.zip后可看到内部的内容   
</span>    

**签名**         
<span style="color:gray;font-size:12px;">
苹果为了保证app的合法性和泛滥安装，设计了签名逻辑。    
签名分两个渠道，一个是appstore上的签名，一个是开发时的签名    
<br>
苹果自己会产生一对公私钥，公钥内置在苹果设备内，私钥在苹果后台。     
当app上传到appstore时，会使用苹果的私钥进行签名，当app安装到手机时，苹果公钥进行验签，保证app的合法性。      
<br>
另外一个就是我们在开发过程中构建的app包，怎么防止它的泛滥安装。    
增加一对公司要，我们自己生成一对本地的公私钥      
私钥用来签名我们的app      
公钥上传到苹果后台，用苹果的私钥进行签名，生成证书。我们上传到后台的csr文件就是公钥        
当app安装到设备时，苹果的私钥先对证书进行验签，验签通过后通过证书内的本地公钥，对app进行验签，这样就保证了app的合法性，如果app被修改，证书内的公钥验签要么过不去，要么验过去后散列值更改。   
但如果只是这样的话只解决了app合法性的问题，没有解决app泛滥安装的问题。     
证书 + deviceId + appId + 权限列表 用 苹果私钥再次签名，这就是profile文件，当设备不在列表内时无法安装，解决了泛滥安装的问题     
</span> 
 

**分发**     
<span style="color:gray;font-size:12px;">
测试包：用于真机调试       
appstore：用于发布市场       
企业包：企业内部分发       
<span>   


## <a id="content2">审核机制</a>


**自动审核**    
<span style="color:gray;font-size:12px;">
上传ipa后苹果首先会做自动化扫描    
1、检查图标、启动图、版本号是否合规    
2、检查证书，描述文件是否有效    
3、检查bundleId、权限是否一致     
…     
这一步有问题，在上传时会直接给出错误提示    
<span>   


**人工审核**     
<span style="color:gray;font-size:12px;">
1、登录机制是否完善     
2、隐私权限使用是否合规     
3、界面一致性，设计是否符合苹果规范。比如返回按钮和关闭按钮的位置。      
4、功能性是否完善，比如有类似敬请期待的字样会被拒    
5、内容性是否合规，比如设计赌博、色情、暴力等     
6、私有api调用等    
<span>   



**被拒原因**       
1、元数据被拒    
<span style="color:gray;font-size:12px;">
描述与app功能不相符     
截图没有反应app主要功能    
</span>   
2、二进制被拒    
<span style="color:gray;font-size:12px;">
启动崩溃   
权限不完善    
功能不完善   
内容不合规    
等
</span>   



























----------
>  行者常至，为者常成！


