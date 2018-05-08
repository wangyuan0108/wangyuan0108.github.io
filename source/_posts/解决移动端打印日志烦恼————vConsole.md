---
title: 解决移动端打印日志烦恼——vConsole
categories: WEB前端
copyright: true
date: 2018-05-08 11:12:50
tags: 
- 效率
- 工具
---

平时我们在 web 应用开发过程中，我们可以使用 console.log 去输出日志来调试程序。但是在移动端，比如在手机上，console.log 的信息我们是看不到的。这种情况下，我们可以选择使用 alert 弹出一些信息，但是这种方法不怎么方便<!--more-->，也会阻断 JS 线程，导致后面的线程都不执行。也影响调试体验。那么，如果将 console.log 应用到移动端呢？这就是本片的主要内容，安利一款工具 vConsole

### 简介

vConsole:一个轻量、可拓展、针对手机网页的前端开发者调试面板。

### 功能和特点

1.  查看 console 日志
2.  查看网络请求
3.  手动执行 JS 命令行
4.  自定义插件

### 使用方法

*   直接引入使用引入 dist/vconsole.min.js 到项目中：

```
<script src="path/to/vconsole.min.js"></script>
<script>
    console.log('Hello world');
    // 然后点击右下角 vConsole 按钮即可查看到 log
</script>
```

*   在 vue 项目中使用

1.  package.json 安装 vconsole 包(可以放在 devDependencies 中)

```
npm install vconsole
```

2.  main.js 中引入：

```
// 因为vConsole并不需要调用，
// 所以前面加“eslint-disable no-unused-vars”规避掉eslint语法检查

/* eslint-disable no-unused-vars */
import vConsole from 'vconsole'
```

3.  此时可以使用 console.log
    原理：改写了 console.log,重写了实现，用 vConsole 代理
