---
title: create-react-app 配置scss第二种方法
categories: WEB前端
copyright: true
date: 2018-07-23 17:32:11
tags:
- react
- scss
---

### 背景

在编写css的时候我们会用到预编译器scss，之前在用的时候找到了一种配置方法，但是现在又找到一种配置方法<!--more-->

### 不使用yarn eject命令的配置方式
首先安装使用scss需要的包`sass-loader`,`node-sass`.

```
yarn add sass-loader node-sass --dev
```

用create-react-app创建好项目之后，依次查找目录找到:

```
node_modules => react-scripts => config => webpack.config.dev.js

node_modules => react-scripts => config => webpack.config.prod.js
```

然后找到文件中的以下位置并修改：

![图片](http://dinping.wangyuanweb.top/18-7-23/63661560.jpg)

重新执行`yarn start`

### 使用yarn eject命令的配置方式

首先执行命令：

```
yarn eject
```

然后找到项目目录下的`config`文件夹找到配置文件`webpack.config.dev.js`和`webpack.config.prod.js`，然后配置同上图所示

然后执行`yarn start`

