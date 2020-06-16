---
title: uni-app接入友盟埋点统计
categories: WEB前端
copyright: true
date: 2020-06-16 16:50:17
tags:
  - 大前端
  - 小程序
  - 前端
---

### 背景

我们在做软件程序的时候，有时需要知道一些功能有多少人用。就拿微信小程序来举例子，我们关注的就是小程序的使用人数、小程序打开人数、小程序的每个页面的访问量等，我就需要对小程序进行埋点操作。这里我使用的是第三方的埋点服务[友盟](https://www.umeng.com/)，这里就记录下 uni-app 集成友盟的方式。<!--more-->

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

### 利用条件编译集成 sdk

在 main.js 中进行集成

```js
// #ifdef MP-WEIXIN
import uma from 'umtrack-wx'
uma.init({
  appKey: 'xxxx',
  useOpenid: false,
  autoGetOpenid: false,
  debug: true,
})
// #endif
// #ifdef MP-ALIPAY
import uma from 'umtrack-alipay'
uma.init({
  appKey: 'xxxx',
  debug: false,
})
// #endif
import Vue from 'vue'
import App from './App'

Vue.prototype.uma = uma || {} // 此处用来挂载入uma到组件实例上，方便组件内使用this.uma
Vue.config.productionTip = false

App.mpType = 'app'

const app = new Vue({
  ...App,
})
app.$mount()
```

### 自定义事件点

`/pages/index/index/vue`

```js
onLoad(){
  this.uma.trackEvent('eventID',{title:'uni-app'});
},
```

### sdk 集成位置尽量靠前
