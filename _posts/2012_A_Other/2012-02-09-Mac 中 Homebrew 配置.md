---
layout: post
title: "Mac 中 Homebrew 配置"
date: 2012-02-09
description: ""
tag: 其它
---




## 目录
- [安装](#content1)   
- [配置](#content2)   




## <a id="content1">安装</a>

Homebrew 是 macOS 上的包管理工具。    

安装命令：
```text
// 这个命令会通过 curl 下载并执行 Homebrew 的安装脚本
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```


## <a id="content2">配置</a>

安装完成后，终端可能会显示一条消息，告诉你需要将 Homebrew 的路径添加到你的 shell 配置文件中（例如 .zshrc 或 .bash_profile，具体取决于你使用的 shell）。

要查看你当前使用的是 Zsh 还是其他 shell

```text
echo $SHELL
```

如果你使用的是 Zsh（默认的 shell）在终端执行下面代码进行配置：

```text
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/$(whoami)/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

查看是否配置成功：
```text
brew --version
```



----------
>  行者常至，为者常成！


