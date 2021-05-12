---
title: 你需要知道的vue开发公众号网页
categories: WEB前端
copyright: true
date: 2021-05-11 17:27:53
tags: 
- vue
- 微信
---

## 简介
因为项目需要，近期做了一个公众号网页开发。在此期间也踩了一些坑，解决这些坑之后，准备对这个项目进行复盘。记录下项目从开发到上线所解决的问题，并对使用vue进行公众号开发的步骤进行一个总结。方便以后有问题进行查阅。希望对你有所帮助<!--more-->

## 项目背景
主要就是一个h5页面，涉及的功能不是很难，主要很久没有开发公众号，对整个开发步骤有些生疏。其中包括对微信sdk的调用方式、用户的微信授权和sdk的接入等。主要围绕开发步骤进行梳理。
## 开始
因为是一个h5页面，整体而言项目不大，然后在项目技术选型的时候确定使用vue框架进行开发。使用vue开发h5，个人整体感觉还是效率比较高的。在ui库方面选择的是vant库，组件整体而言还是不错的，支持自定义主题方便样式自定义比较适合h5的开发。
## 通过vue-cli创建项目
安装脚手架工具
```
npm install -g @vue/cli
# OR
yarn global add @vue/cli
```
创建一个项目
```
vue create water_project
```
然后就创建了项目目录
```
.
├── README.md
├── babel.config.js
├── jsconfig.json
├── package-lock.json
├── package.json
├── public
│   ├── favicon.ico
│   └── index.html
├── src
│   ├── App.vue
│   ├── api
│   ├── assets
│   ├── components
│   ├── global.less
│   ├── main.js
│   ├── mock
│   ├── router
│   ├── store
│   ├── utils
│   └── views
└── vue.config.js
```
## 关于移动的适配
因为是移动端网页，所以需要做适配。网上有很多适配方案这里就不展开说了，主要说下本项目使用的方案是`amfe-flexible`结合`rem`来做的，是淘宝的一种解决方案。关于设计稿的单位`px`转换为`rem`使用的是`postcss`的`postcss-pxtorem`方案。其实用`webpack`的`loader`来做也是可以的，具体方案自行百度。

1. 安装`amfe-flexible`包

```bash
npm i amfe-flexible -S
```

2. 安装`postcss-pxtorem`插件

```bash
npm i postcss-pxtorem -D
```

3. 在main.js中引入`amfe-flexible`

```js
import "amfe-flexible"
```

4. 在vue.config.js中配置postcss插件

项目中如果没有vue.config.js文件就手动创建一个，这个是vue cli的配置文件。

```js
css: {
    loaderOptions: {
      postcss: {
        plugins: [
          autoprefixer(),
          pxtorem({
            rootValue: 37.5,
            propList: ["*"],
          }),
        ],
      },
  },
```

到此样式适配已经完成，至于rootValue为什么是37.5.主要是为了vant的适配，所以设计稿以375px为参考。如果没有使用第三方ui库可以设计稿以750为参考，此时rootValue为75。

## 使用 normalize.css

使用normalize.css来消除浏览器之间的基础样式差异

```bash
npm i normalize.css -S
```

在`main.js`中引入

```js
import "normalize.css"
```



## 接入vant库

vant是有赞出品的一个ui库，站在巨人的肩膀上效率当然是要快很多。这种第三方库只能作为基础，在有设计稿的情况下要对样式进行定制。简单的样式vant都支持主题定制化还是比较方便的，如果有一些样式没有提供自定义主题，就只能写样式进行覆盖了。

- 下载安装vant

```bash
npm i vant -S
```

- 引入组件有3种方式，官网也有介绍，[详情可以查看官网](https://vant-contrib.gitee.io/vant/#/zh-CN/quickstart)，简单说下使用方式：

### 方式一. 自动按需引入组件 (推荐)

[babel-plugin-import](https://github.com/ant-design/babel-plugin-import) 是一款 babel 插件，它会在编译过程中将 import 的写法自动转换为按需引入的方式。

```bash
# 安装插件
npm i babel-plugin-import -D
// 在.babelrc 中添加配置
// 注意：webpack 1 无需设置 libraryDirectory
{
  "plugins": [
    ["import", {
      "libraryName": "vant",
      "libraryDirectory": "es",
      "style": true
    }]
  ]
}

// 对于使用 babel7 的用户，可以在 babel.config.js 中配置
module.exports = {
  plugins: [
    ['import', {
      libraryName: 'vant',
      libraryDirectory: 'es',
      style: true
    }, 'vant']
  ]
};
```

```js
// 接着你可以在代码中直接引入 Vant 组件
// 插件会自动将代码转化为方式二中的按需引入形式
import { Button } from 'vant';
```

### 方式二. 手动按需引入组件

在不使用插件的情况下，可以手动引入需要的组件。

```js
import Button from 'vant/lib/button';
import 'vant/lib/button/style';
```

### 方式三. 导入所有组件

Vant 支持一次性导入所有组件，引入所有组件会增加代码包体积，因此不推荐这种做法。

```js
import Vue from 'vue';
import Vant from 'vant';
import 'vant/lib/index.css';

Vue.use(Vant);
```

> Tips: 配置按需引入后，将不允许直接导入所有组件。

## 定制vant主题

### 步骤一 引入样式源文件

定制主题时，需要引入组件对应的 Less 样式文件，支持按需引入和手动引入两种方式。

#### 按需引入样式（推荐）

在 babel.config.js 中配置按需引入样式源文件，注意 babel6 不支持按需引入样式，请手动引入样式。

```js
module.exports = {
  plugins: [
    [
      'import',
      {
        libraryName: 'vant',
        libraryDirectory: 'es',
        // 指定样式路径
        style: (name) => `${name}/style/less`,
      },
      'vant',
    ],
  ],
};
```

#### 手动引入样式

```js
// 引入全部样式
import 'vant/lib/index.less';

// 引入单个组件样式
import 'vant/lib/button/style/less';
```

### 步骤二 修改样式变量

使用 Less 提供的 [modifyVars](http://lesscss.org/usage/#using-less-in-the-browser-modify-variables) 即可对变量进行修改，下面是参考的 webpack 配置。

```js
// webpack.config.js
module.exports = {
  rules: [
    {
      test: /\.less$/,
      use: [
        // ...其他 loader 配置
        {
          loader: 'less-loader',
          options: {
            // 若 less-loader 版本小于 6.0，请移除 lessOptions 这一级，直接配置选项。
            lessOptions: {
              modifyVars: {
                // 直接覆盖变量
                'text-color': '#111',
                'border-color': '#eee',
                // 或者可以通过 less 文件覆盖（文件路径为绝对路径）
                hack: `true; @import "your-less-file-path.less";`,
              },
            },
          },
        },
      ],
    },
  ],
};
```

如果 vue-cli 搭建的项目，可以在 `vue.config.js` 中进行配置。

```js
// vue.config.js
module.exports = {
  css: {
    loaderOptions: {
      less: {
        // 若 less-loader 版本小于 6.0，请移除 lessOptions 这一级，直接配置选项。
        lessOptions: {
          modifyVars: {
            // 直接覆盖变量
            'text-color': '#111',
            'border-color': '#eee',
            // 或者可以通过 less 文件覆盖（文件路径为绝对路径）
            hack: `true; @import "your-less-file-path.less";`,
          },
        },
      },
    },
  },
};
```

## 引入微信jssdk

引入jsssdk有两种方式，一种是用js链接直接引入，写在index.html中。

```html
 <script src="https://res2.wx.qq.com/open/js/jweixin-1.6.0.js "></script>
```

然后在使用的地方就调用window.wx.xxx就能使用sdk提供的方法了。

第二种就是使用npm包的方式

- 安装weixin-js-sdk

```bash
npm i weixin-js-sdk -S
```

- 在main.js中使用

```js
import wx from "weixin-js-sdk"

// 挂在vue的原型上方便使用
Vue.prototype.$wx = wx;

```

这样引入之后就可以用this.$wx.xx来使用相应的方法了比如：

```js
 this.$wx.config({
          debug: false, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
          appId: res.data.appId, // 必填，公众号的唯一标识
          timestamp: String(res.data.timestamp), // 必填，生成签名的时间戳
          nonceStr: String(res.data.nonceStr), // 必填，生成签名的随机串
          signature: res.data.signature, // 必填，签名，见附录1
          jsApiList: [
            "getNetworkType",
            "getLocation",
          ], // 必填，需要使用的JS接口列表，所有JS接口列表见附录2
        });
```

### 注册验证sdk才可以使用api

其实注册的重要逻辑都在后端，提供一个获取配置信息的接口，前端直接调用sdk的config方法进行注册就好了。这里把sdk的注册逻辑写在app.vue文件中

- 封装一个注册sdk的方法

```js
async getWxJssdkConf() {
      const res = await this.$api.getSdkConfig({
        url: window.location.href.split("#")[0],
      });
      if (res.success) {
        this.$wx.config({
          debug: false, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
          appId: res.data.appId, // 必填，公众号的唯一标识
          timestamp: String(res.data.timestamp), // 必填，生成签名的时间戳
          nonceStr: String(res.data.nonceStr), // 必填，生成签名的随机串
          signature: res.data.signature, // 必填，签名，见附录1
          jsApiList: [
            "getNetworkType",
            "getLocation",
          ], // 必填，需要使用的JS接口列表，所有JS接口列表见附录2
        });
        this.$wx.ready(() => {
          this.$wx.checkJsApi({
            jsApiList: ["getNetworkType", "getLocation"], // 需要检测的JS接口列表，所有JS接口列表见附录2,
            success: function (res) {
              console.log("checkJsApi", res);
            },
          });
        });
        this.$wx.error((res) => {
          console.log("wx.error", res);
        });
      }
    },
```

```js
created() {
    this.getWxJssdkConf();
  },
```

其中`this.$api.getSdkConfig`为调用后台的接口，这里是给api也挂载到了vue的原型上，方便使用不用每个页面都去引入api

```js
Vue.prototype.$api = api
```

在app.vue中注册成功后，就可以使用sdk的api了。

## 微信的授权

如果要获取用户的信息，就必须让用户进行授权。在授权的时候使用的是微信提供的接口，[详细请看这里](https://developers.weixin.qq.com/doc/offiaccount/OA_Web_Apps/Wechat_webpage_authorization.html)，如果是只获取用户的openid只用静默授权就可以了，不用用户主动授权。具体请看文档，这里只需要openid就使用静默授权如下：

- 在需要授权的主入口使用，比如这里是主页Home，要先调用微信的接口获取code，在用code去后端换取openid

```js
/**
     * @description: 获取授权code
     * @param {*}
     * @return {*}
     */
    getCode() {
      // 从 window.location.href 中截取 code 并且赋值
      // window.location.href.split('#')[0]
      if (window.location.href.indexOf("state") !== -1) {
        this.code = qs.parse(
          window.location.href.split("#")[0].split("?")[1]
        ).code;
      } 
      
      if (this.code) {
          // 存在 code 直接调用接口
          this.handGetUserInfo(this.code);
        } else {
          this.handLogin();
        }
    },
    /**
     * @description: 获取用户授权登陆
     * @param {*}
     * @return {*}
     */
    handLogin() {
      // 重定向地址重定到当前页面，在路径获取 code
      const hrefUrl = window.location.href;

      if (this.code === "") {
        window.location.replace(`
						https://open.weixin.qq.com/connect/oauth2/authorize
						?appid=XXXXXXXX
						&redirect_uri=${encodeURIComponent(hrefUrl)}
						&response_type=code
						&scope=snsapi_base
						&state=h5#wechat_redirect
					`);
      }
    },
    /**
     * @description: 获取用户信息
     * @param {*} code
     * @return {*}
     */
    handGetUserInfo(code) {
      // 调用后台接口
    },
```

这里就是授权的主要逻辑，没啥意外就基本走通了。

## 断网进行提示

如果用户的网络断了，就跳转到断网提示页。主要使用的是html提供的方法进行判断，判断逻辑写在app.vue文件中，因为每个页面都会提示，就直接在主入口进行处理。

```js
mounted() {
    window.addEventListener("online", this.updateOnlineStatus);
    window.addEventListener("offline", this.updateOnlineStatus);
  },
  
 methods: {
 		updateOnlineStatus(e) {
      const { type } = e;
      console.log("type==============", type);
      this.onLine = type === "online";
    },
 }
 beforeDestroy() {
    window.removeEventListener("online", this.updateOnlineStatus);
    window.removeEventListener("offline", this.updateOnlineStatus);
  },
```

主要就是这个方法来检查用户网络连接情况

## 判断是不是微信打开的网页

这里主要使用的是vue-router的导航守卫来做的，在跳转之前对浏览器进行判断，如果不是微信内置浏览器就直接跳转到异常提示页

```js
router.beforeEach((to, from, next) => {
  const ua = navigator.userAgent.toLowerCase();
  if (
    to.path !== "/notwx" &&
    !(ua.match(/MicroMessenger/i) == "micromessenger")
  ) {
    next("/notwx");
  } else {
    next();
  }
});
```

有时跳转页面，页面的滚动高度会保留在上个页面的滚动高度，这里也是在导航守卫中解决的，主动给滚动到顶部

```js
router.afterEach(() => {
  window.scrollTo(0, 0);
});
```

## 小结

到此整个开发流程简单记录完毕，也是对自己开发的一个梳理，也方便以后查阅。希望对看到文章的你有所帮助，个人见解，如有问题欢迎指正，觉得有帮助，欢迎点个赞，谢谢。