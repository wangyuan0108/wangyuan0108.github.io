---
title: vue项目中使用微信sdk
categories: WEB前端
copyright: true
date: 2020-04-08 23:38:39
tags:
  - vue
  - 微信
---

### 背景

我们在做微信公众号开发的时候，在编写 H5 页面的时候难免要用到微信的功能。比如：微信的分享功能。H5 中使用微信客户端的能力是通过调用微信 sdk 来实现的。<!--more-->一般移动端 H5 比较简洁，大部分使用 vue 进行开发，这里简单记录下 vue 中使用微信 sdk 的方法。

### 使用 js 链接的方式进行调用

首现我使用的是 vue-cli 创建的项目，在文件目录中有一个模版 html 文件，我们去微信官方文档获取到当前的 sdk 的最新版本链接，然后放到我们的 html 文件中。

```html
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0, user-scalable=0, viewport-fit=cover;" />
    <link rel="icon" href="<%= BASE_URL %>favicon.ico" />
    <title><%= htmlWebpackPlugin.options.title %></title>
    <script src="http://res.wx.qq.com/open/js/jweixin-1.6.0.js"></script> // 微信的sdk线上版本
<head>
```

然后当 html 加载了这个 js 后，会把 wx 对象放到 window 全局变量上，通过 window.wx 可以调用相应的方法。

```js
window.wx.config({
  debug: true, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
  appId: '', // 必填，公众号的唯一标识
  timestamp: '', // 必填，生成签名的时间戳
  nonceStr: '', // 必填，生成签名的随机串
  signature: '', // 必填，签名
  jsApiList: [], // 必填，需要使用的JS接口列表
})
```

然后我们就可以在 vue 的钩子函数中处理业务逻辑来调用 wx 的 api 了

### 使用 npm 包的方式进行使用

- 首现去 npm 上安装微信 sdk 的包

```bash
npm install weixin-js-sdk
```

- 然后在需要使用的地方引入文件

```js
import wx from 'weixin-js-sdk'
```

- 微信方法的使用

```js
wx.config({
  debug: true, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
  appId: '', // 必填，公众号的唯一标识
  timestamp: '', // 必填，生成签名的时间戳
  nonceStr: '', // 必填，生成签名的随机串
  signature: '', // 必填，签名
  jsApiList: [], // 必填，需要使用的JS接口列表
})
```
