---
title: taro接入友盟埋点统计
categories: WEB前端
copyright: true
date: 2020-06-16 17:08:52
tags:
  - 大前端
  - react
  - 前端
---

### 背景

我们在做软件程序的时候，有时需要知道一些功能有多少人用。就拿微信小程序来举例子，我们关注的就是小程序的使用人数、小程序打开人数、小程序的每个页面的访问量等，我就需要对小程序进行埋点操作。这里我使用的是第三方的埋点服务[友盟](https://www.umeng.com/)，这里就记录下 taro 集成友盟的方式。<!--more-->

### 注册友盟账号

去友盟的官网注册个账号，用这个账号登录到管理控制台

### 创建服务应用进行 Appkey 申请

选择创建小程序应用，填写需要埋点的小程序需要的信息进行申请

### 配置域名白名单

把友盟的域名添加到小程序的开发服务域名中`umini.shujupie.com`

### 安装 sdk

```bash
// 支付宝小程序sdk
npm install umtrack-alipay --save
// 微信小程序sdk
npm install umtrack-wx --save
```

### 集成 sdk

1. 但文件利用环境变量进行区分集成 `sdk`
   在 `src/app.jsx` 中进行集成

```js
let uma = {}
if (process.env.TARO_ENV === 'weapp') {
  uma = require('umtrack-wx')
  uma.init({
    appKey: 'YOUR_APP_KEY',
    useOpenid: false,
    autoGetOpenid: false,
    debug: true,
  })
} else if (process.env.TARO_ENV === 'alipay') {
  uma = require('umtrack-alipay')
  uma.init({
    appKey: 'YOUR_APP_KEY',
    debug: true,
  })
}
//把uma 添加到Taro，后续通过Taro.uma调用uma方法 ,es6模块导入的是模块引用，
//因此放心注入，后面页面导入Taro模块是可以获取uma的
import Taro, { Component } from '@tarojs/taro'
Taro.uma = uma
```

2. 利用跨平台文件进行集成
   `src/uma/index.weapp.js`

```js
import uma from 'umtrack-wx'

uma.init({
  appKey: 'YOUR_APP_KEY',
  useOpenid: false,
  autoGetOpenid: false,
  debug: true,
})
export default uma
```

`src/uma/index.alipay.js`

```js
import uma from 'umtrack-alipay'

uma.init({
  appKey: 'YOUR_APP_KEY',
  debug: true,
})
export default uma
```

两种方法调用 uma 模块: 1.在其他页面中直接 `import uma from 'path/to/uma'` 2.或者同单文件集成，在 `app.jsx`中注入 `uma` 到 `Taro`
`app.jsx`

```js
import uma from './uma'
import Taro, { Component } from '@tarojs/taro'
Taro.uma = uma
```

### 自定义事件点

```js
componentDidShow () {
    Taro.uma.trackEvent('eventID', {
      name: 'taro'
    });
}
```

### 注意事项

无论哪种集成方式，在 `app.jsx` 文件中 `uma` 模块的导入一定要在 `Taro` 的导入之前，如 `eslint` 出现提示，建议关掉 `app.jsx` 文件的相关 `eslint` 检查，一般是关于 `import` 前置 或 绝对路径模块要先于相对模块的 `eslint` 提示。
