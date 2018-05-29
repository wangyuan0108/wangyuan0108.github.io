---
title: node部署vue项目
categories: WEB前端
copyright: true
date: 2018-05-29 10:38:44
tags: 服务器
---

### 背景

我们在用 vue 框架来做开发的时候，虽然在打包之前的文件有点和传统的前端代码不一样。但是我们线上部署的时候，所使用的代码还是和传统的代码是一样的，在这过程中，项目需要经过打包，<!--more-->上线的时候就是用打包之后的代码，也就是我们要部署到服务器上的代码。这里简单说下用 node 来部署 vue 项目。

### 打包

首先 vue-cli 中已经配置好了打包的命令，命令行执行下便是能够打包好等待上线的代码文件夹 dist

```
npm run build
```

### node 服务器代码

首先 vue 是 spa 项目，这里只有一个入口页的 html，用 node 写一个 app.js 脚本输出到客户端:

```
const fs = require('fs');
const path = require('path');
const express = require('express');
const app = express();

app.use(express.static(path.resolve(__dirname, './dist')));

app.get('*', function(req, res) {
    const html = fs.readFileSync(path.resolve(__dirname, './dist/index.html'), 'utf-8');
    res.send(html);
});
app.listen(80);
```

这个脚本中使用了express框架，我们需要安装一下：

```
npm install express --save
```

### 上线

把app.js、package.json和dist文件夹上传到服务器，例如www文件夹下。然后用pm2启动app.js服务。然后就能正常访问到你的线上项目了
