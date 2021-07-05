---
title: 使用umijs开发移动端h5
categories: WEB前端
copyright: true
date: 2021-07-05 10:53:11
tags:
---
## 简介

由于最近业务原因，需要开发一些移动端h5页面。之前是使用vue技术栈开发，这里因为一些原因需要使用react技术栈开发，在后台系统方面这里选择的是umijs作为开发框架。所以在h5开发的也选用umijs来进行开发，这里记录下框架搭建的基础过程，方便直接使用，少走弯路<!--more-->

## 开始

#### 环境准备

首先得有 [node](https://nodejs.org/en/)，并确保 node 版本是 10.13 或以上

```
node -v
v10.13.0
```

#### 使用脚手架创建

- 先创建一个目录

```
mkdir myapp && cd myapp
```

- 通过脚手架创建项目

```
yarn create @umijs/umi-app
# 或 npx @umijs/create-umi-app

Copy:  .editorconfig
Write: .gitignore
Copy:  .prettierignore
Copy:  .prettierrc
Write: .umirc.ts
Copy:  mock/.gitkeep
Write: package.json
Copy:  README.md
Copy:  src/pages/index.less
Copy:  src/pages/index.tsx
Copy:  tsconfig.json
Copy:  typings.d.ts
```

- 安装依赖

```
yarn

yarn install v1.21.1
[1/4] 🔍  Resolving packages...
success Already up-to-date.
✨  Done in 0.71s.
```

- 启动项目

```
yarn start

Starting the development server...

✔ Webpack
  Compiled successfully in 17.84s

 DONE  Compiled successfully in 17842ms                                       8:06:31 PM


  App running at:
  - Local:   http://localhost:8000 (copied to clipboard)
  - Network: http://192.168.12.34:8000
```

## 配置h5相关

#### 配置移动端适配

这里使用的是rem适配的方案，这个适配也可以改成其他的比如vw合vh。大家自行百度，就不多说了。rem适配的方案需要安装`amfe-flexible`和`postcss-pxtorem`。 前一个是用来缩放根节点字体大小的，后面一个是对css的px单位进行转换成对应的rem单位

```
yarn add amfe-flexible
yarn add postcss-pxtorem --dev
```

然后在global.js中引入amfe-flexible

```
import 'amfe-flexible/index'
```

global.js这个文件是全局的js文件，详细说明请参看umijs的文档

在使用postcss-pxtorem插件的时候需要配置转换的参考基数，大部分是以750px的设计稿来作为参考，这里就写下750px作为参考的配置，在umijs的配置文件.umirc.js中

```js
extraPostCSSPlugins: [
    pxtorem({
      rootValue: 75, // 换算的基数
      // 忽略转换正则匹配项。插件会转化所有的样式的px。比如引入了三方UI，也会被转化。目前我使用 selectorBlackList字段，来过滤
      //如果个别地方不想转化px。可以简单的使用大写的 PX 或 Px 。
      // selectorBlackList: ["am"],
      exclude: /node_modules/i,
      propList: ['*'],
    }),
  ],
```

#### ui库

移动端的ui库也没有多少，大家可以选用自己喜欢的。这里umijs中集成了antd-mobile，所以就直接使用这个库了。

#### 代理

本地开发需要配置代理，在配置文件.umirc.js中进行配置

```
proxy: {
    '/api': {
      target: 'http:/www.baidu.com/',
      changeOrigin: true,
      pathRewrite: { '^/api': '' },
    },
  },
```

#### 调试日志

由于移动端h5要在移动端打开进行调试，所以调试起来如果看不到日志也是非常麻烦的。这里使用vconsole库让移动端显示出调试日志

- 安装vconsole

```
yarn add vconsole --dev
```

- 使用vconsole

在global.js中实例化

```
import VConsole from 'vconsole';
new VConsole();
```

#### 打包部署

如果直接是部署在服务器根路径，直接打包生成dist目录就行了。如果不是根目录还需要添加一些配置如下，在.umirc.js中

```js
// 根据环境进行区分
publicPath: process.env.NODE_ENV === 'development' ? '/' : '/h5/',
```



## 小结

通过以上步骤，一个简单的umijs开发h5的基础框架就算完成了，可以进行业务开发了，希望对大家有帮助，觉得有帮助的给个赞，谢谢！
