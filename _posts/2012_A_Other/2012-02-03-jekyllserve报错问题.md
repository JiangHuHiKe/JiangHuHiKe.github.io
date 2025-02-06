---
layout: post
title: "jekyll serve报错问题"
date: 2012-02-03
description: "jekyll serve报错问题"
tag: 其它
---




- [参考文章：Mac 中配置 Jekyll](https://www.jianshu.com/p/25111a6002ec)



## 目录
- [jekyll](#content1)   
- [jekyll serve报错](#content2)   





## <a id="content1">jekyll</a>


Jekyll 是一个简单的免费的 Blog 生成工具，类似 WordPress。但是和 WordPress 又有很大的不同，原因是 Jekyll 只是一个生成静态网页的工具，不需要数据库支持。Jekyll 可以免费部署在 Github 上，而且可以绑定自己的域名


Jekyll 可以使用 .html、.md、.sass 文件进行维护，和其他类似的应用一样，它也需要运行在一个环境下，其访问地址如：http://127.0.0.1:4000。


安装 Jekyll 需要 Ruby 环境支持，Mac 系统是自带了 Ruby 环境的。目前的 Jekyll 需要 Ruby 2.2.5+，终端中使用 ruby -v 可以查看当前 Ruby 版本。

除了 Ruby，还需要 RubyGems，RubyGems（简称 gems）是一个用于对 Ruby 组件进行打包的 Ruby 打包模块。 它提供一个分发 Ruby 程序和库的标准格式，还提供一个管理程序包安装的工具。如果已安装该模块，终端中输入 gem -v 可以查看其版本。

另外，还需要 GCC 和 Make 支持，这一般是系统自带的，可通过 gcc -v、g++ -v 和 make -v 查看其版本。


确认上述的环境都配置正确后，就可以开始使用 gem 安装 Jekyll 了，

安装指令

`gem install jekyll bundler`

安装完成后查看指令 

`bundler -v` 和 `jekyll -v`


 执行项目指令

 `jekyll serve` 或者 `bundle exec jekyll serve`



## <a id="content2">jekyll serve报错</a>

#### **报错一**
今天之前jekyll serve 一直正常运行，也没有进行特别的配置更改，但在今天执行 jekyll serve时就报错了,报错内容GemNotFound，大概意思是bundler下一个文件内引用的内容缺失。

接着执行指令,安装缺失的文件：
```
bundle install
```

然后执行指令：
```
jekyll serve
```

仍然报错内容如下：     
```
$ jekyll serve
Traceback (most recent call last):
        10: from /Users/LKLC/.rvm/gems/ruby-2.6.0/bin/jekyll:23:in `<main>'
         9: from /Users/LKLC/.rvm/gems/ruby-2.6.0/bin/jekyll:23:in `load'
         8: from /Users/LKLC/.rvm/gems/ruby-2.6.0/gems/jekyll-4.0.0/exe/jekyll:11:in `<top (required)>'
         7: from /Users/LKLC/.rvm/gems/ruby-2.6.0/gems/jekyll-4.0.0/lib/jekyll/plugin_manager.rb:52:in `require_from_bundler'
         6: from /Users/LKLC/.rvm/rubies/ruby-2.6.0/lib/ruby/2.6.0/bundler.rb:107:in `setup'
         5: from /Users/LKLC/.rvm/rubies/ruby-2.6.0/lib/ruby/2.6.0/bundler/runtime.rb:26:in `setup'
         4: from /Users/LKLC/.rvm/rubies/ruby-2.6.0/lib/ruby/2.6.0/bundler/runtime.rb:26:in `map'
         3: from /Users/LKLC/.rvm/rubies/ruby-2.6.0/lib/ruby/2.6.0/forwardable.rb:230:in `each'
         2: from /Users/LKLC/.rvm/rubies/ruby-2.6.0/lib/ruby/2.6.0/forwardable.rb:230:in `each'
         1: from /Users/LKLC/.rvm/rubies/ruby-2.6.0/lib/ruby/2.6.0/bundler/runtime.rb:31:in `block in setup'
/Users/LKLC/.rvm/rubies/ruby-2.6.0/lib/ruby/2.6.0/bundler/runtime.rb:319:in `check_for_activated_spec!': You have already activated public_suffix 4.0.3, but your Gemfile requires public_suffix 3.0.3. Prepending `bundle exec` to your command may solve this. (Gem::LoadError)
```

但给出了提示       

<div style="background:black;color:white;">
  You have already activated public_suffix 4.0.3, but your Gemfile requires public_suffix 3.0.3.
  Prepending bundle exec to your command may solve this. (Gem::LoadError)
</div>


接着按提示执行指令：
```
bundle exec jekyll serve
```

服务终于正常开启了，但还是有一段提示代码

<div style="color:yellow;background:black;">Deprecation: The 'gems' configuration option has been renamed to 'plugins'. Please update your config file accordingly.</div>

我们找到_config.yml文件，将其中的        
```
gems: [jekyll-paginate]
```

改为     
```
plugins: [jekyll-paginate]
```
执行指令：
```
bundle exec jekyll serve
```
服务正常开启且提示语消失。

但当我们执行：
```
jekyll serve
```
的时候仍然报错。

我们在工程内搜索 public_suffix，发现在Gemfile.lock内有如下版本信息：

```
public_suffix (3.0.3) 
```
基本上可以肯定是安装版本和引用版本不匹配造成的问题，我们执行指令       
```
bundle help
```    
来看看有没有更新该文件的指令

<div style="background:black;color:white">
  bundle install [OPTIONS]       # Install the current environment to the system<br>
  bundle update [OPTIONS]        # Update the current environment
</div>

很好有一条用于更新当前环境的指令，执行指令

```
bundle update
```
然后执行
```
jekyll serve
```
服务正常启动，问题解决。


#### **报错二**

```text
jekyll serve            
/Users/lixiaoyi/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/bundler-2.6.1/lib/bundler/runtime.rb:319:in check_for_activated_spec!': You have already activated concurrent-ruby 1.3.5, but your Gemfile requires concurrent-ruby 1.3.4. Prepending bundle exec to your command may solve this. (Gem::LoadError)
        from /Users/lixiaoyi/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/bundler-2.6.1/lib/bundler/runtime.rb:25:in block in setup'
        from /Users/lixiaoyi/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/bundler-2.6.1/lib/bundler/spec_set.rb:196:in each'
        from /Users/lixiaoyi/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/bundler-2.6.1/lib/bundler/spec_set.rb:196:in each'
        from /Users/lixiaoyi/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/bundler-2.6.1/lib/bundler/runtime.rb:24:in map'
        from /Users/lixiaoyi/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/bundler-2.6.1/lib/bundler/runtime.rb:24:in setup'
        from /Users/lixiaoyi/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/bundler-2.6.1/lib/bundler.rb:167:in setup'
        from /Users/lixiaoyi/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/jekyll-4.3.4/lib/jekyll/plugin_manager.rb:52:in require_from_bundler'
        from /Users/lixiaoyi/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/jekyll-4.3.4/exe/jekyll:11:in <top (required)>'
        from /usr/local/bin/jekyll:25:in load'
        from /usr/local/bin/jekyll:25:in <main>'
```

**报错原因：**          
jekyll serve 命令报错的原因是 concurrent-ruby 版本冲突：    
Gemfile 需要 concurrent-ruby 1.3.4，但系统里已经激活了 concurrent-ruby 1.3.5，导致 Jekyll 运行失败。   

**解决方法一：使用 bundle exec**       
解决方案是在 jekyll serve 前加上 bundle exec，确保使用 Gemfile.lock 里指定的依赖版本。

**解决方法二：更新 Gemfile.lock**     
如果你想更新 Gemfile.lock 让它兼容 concurrent-ruby 1.3.5：    

```text   
bundle update concurrent-ruby
```

然后再运行：    
```text
jekyll serve
```






----------
>  行者常至，为者常成！


