---
title: vscode插件Settings Sync使用方法
categories: WEB前端
copyright: true
date: 2018-04-22 21:22:04
tags: 编辑器
---
在使用`vscode`的时候，我们会根据自己的喜好和提高开发效率进行对编辑器的配置和一些辅助插件的配置。但是我们有时会在不同的电脑也安装`vscode`，如果我们在安装和配置一遍`vscode`这是非常繁琐的，也是非常低效。于是乎`Settings Sync`插件产生了。接下来就简单说下这个插件的使用方法。

# 初次使用`Setting Sync`

## 安装

- 安装`vscode`编辑器

- 安装`Setting Sync`插件

##　在github上设置 Personal access tokens

- 进入github（没有的话，当然自己注册一个账号啦！）

- 找到个人设置`settings`并点击

- 找到`Developer settings`并点击

- 找到`Personal access tokens`并点击

- 找到`Generate new token`并点击

然后要记住token值，在插件中需要用到。

如图所示：
![settings](http://images.wangyuanweb.top/vscode-setting-1.png?imageView2/3/w/600/h/400/q/75%7Cimageslim)
![settings](http://images.wangyuanweb.top/vscode-setting-2.png?imageView2/3/w/600/h/400/q/75%7Cimageslim)
![settings](http://images.wangyuanweb.top/vscode-setting-3.png?imageView2/3/w/600/h/400/q/75%7Cimageslim)
![settings](http://images.wangyuanweb.top/vscode-setting-4.png?imageView2/3/w/600/h/400/q/75%7Cimageslim)
![settings](http://images.wangyuanweb.top/vscode-setting-5.png?imageView2/3/w/600/h/400/q/75%7Cimageslim)
![settings](http://images.wangyuanweb.top/vscode-setting-6.png?imageView2/3/w/600/h/400/q/75%7Cimageslim)

## 在vscode中使用该插件

首先打开命令工具`ctrl+shift+p`,然后输入`sync`关键字,就会出现需要使用的命令。然后如图所示：

![settings](http://images.wangyuanweb.top/vscode-setting-7.png?imageView2/3/w/600/h/400/q/75%7Cimageslim)
![settings](http://images.wangyuanweb.top/vscode-setting-8.png?imageView2/3/w/600/h/400/q/75%7Cimageslim)

具体命令的意思，可以查看插件的文档，很详细。

# 更新配置的时候出现的问题

## token失效

这个问题应该是在使用的时候遇到的最多的情况，因为github的token值是有时间限制的，所以这里简单说一下解决的方法。对已经失效的token更新如图：

![settings](http://images.wangyuanweb.top/vscode-setting-9.png?imageView2/3/w/600/h/400/q/75%7Cimageslim)
![settings](http://images.wangyuanweb.top/vscode-setting-10.png?imageView2/3/w/600/h/400/q/75%7Cimageslim)
![settings](http://images.wangyuanweb.top/vscode-setting-11.png?imageView2/3/w/600/h/400/q/75%7Cimageslim)

然后把得到的token值配置到vscode的配置文件中。

# 小结

这个插件的基本使用方法在这里，一是为了更多的人使用，提供一个参考。而是让自己有资料可查，加深记忆！











