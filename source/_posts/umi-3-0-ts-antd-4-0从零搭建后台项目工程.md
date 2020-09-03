---
title: umi@3.0+ts+antd@4.0从零搭建后台项目工程
categories: WEB前端
copyright: true
date: 2020-09-03 14:30:53
tags:
  - umi
  - ts
  - antd
---

## 前言

umi 和 antd 升级有一段时间了，一直准备用这个插件式开发套件新建一个项目，用来体验下这个框架的优点。因为这个 umi 升级完成之后，文档写的略微对新手不太友好（比如我这样的菜鸡）。在新建一个基础架构的过程中也遇到了不少问题，把解决过程记录下，像大家分享下！<!--more-->

## 开始

首先 umi 的[文档](https://umijs.org/zh-CN/docs/getting-started)在此，可以参照这个快速上手进行搭建，我也是参照这个进行搭建的，简单说下步骤。

- 首先得有 node，并确保 node 版本是 10.13 或以上。（mac 下推荐使用 nvm 来管理 node 版本）

```bash
$ node -v
v10.13.0
```

- 用脚手架搭建一个初始项目目录
  找个位置新建一个文件夹用来放置代码

```
mkdir test_umi && cd test_umi
```

然后执行命令`yarn create @umijs/umi-app`通过官方工具创建项目,成功会得到如下项目目录代码

```
$ yarn create @umijs/umi-app
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

- 安装 npm 依赖包

```bash
$ yarn
yarn install v1.21.1
[1/4] 🔍  Resolving packages...
success Already up-to-date.
✨  Done in 0.71s.
```

- 启动项目

```bash
$ yarn start
Starting the development server...
✔ Webpack
  Compiled successfully in 17.84s
 DONE  Compiled successfully in 17842ms                                       8:06:31 PM
  App running at:
  - Local:   http://localhost:8000 (copied to clipboard)
  - Network: http://192.168.12.34:8000
```

在浏览器里打开 http://localhost:8000/，不出意外的话就能看到界面了
![img](https://img.alicdn.com/tfs/TB1JpeLwxD1gK0jSZFsXXbldVXa-1540-950.png)

## 修改配置添加需要的插件

### 布局

默认的脚手架内置了 @umijs/preset-react，包含布局、权限、国际化、dva、简易数据流等常用功能。比如想要 ant-design-pro 的布局，编辑 .umirc.ts 配置 layout: {}，**并且需要安装 @ant-design/pro-layout**。这里尤其注意这个依赖包的安装，如果没有这个包，antd-pro 的布局是不能正确显示的。之前官方文档没有这个提示，后期踩坑才发现，给加到文档上了。

```js
import { defineConfig } from 'umi'
export default defineConfig({
  // 配置开启布局插件
+ layout: {},
  routes: [{ path: '/', component: '@/pages/index' }],
})
```

layout 配置请参考[文档](https://umijs.org/zh-CN/plugins/plugin-layout#%E9%85%8D%E7%BD%AE)这里主要说下我踩的坑：

1. 在使用这个布局的时候，我需要显示右上方的用户名和头像，但是文档没有提及如何修改默认的头像。这里官网说过，要使用登录按钮和用户名需要进行运行时配置

```js
// src/app.js
export const layout = {
  logout: () => {}, // do something
  rightRender: initInfo => {
    return 'hahah'
  }, // return string || ReactNode;
}
```

如果配置了 `rightRender`，那么用户名和退出的逻辑都需要自定义了。这里我不需要自定义交互只是想修改下名称和头像，所以修改这个 rightRender 方法是不合适的，因为默认在顶部右侧并不会显示退出按钮，需要在运行配置中配合`@umijs/plugin-intial-state` 的 `getInitialState` 返回一个对象，才可以显示。所以需要安装插件`@umijs/plugin-intial-state`

### 全局初始化数据

- 概念
  在全局定义一个初始化数据的地方，以供全局任何地方使用。安装插件`@umijs/plugin-intial-state`
- 启用
  在 `src/app.ts` 并且导出 `getInitialState` 方法时启用。需要运行时配置
- 依赖
  不可直接使用，必须搭配 `@umijs/plugin-model` 一起使用。
- 配置

```js
// src/app.ts
export async function getInitialState() {
  const data = {
    userId: '1',
    role: 'admin',
    name: '清风', // 这个就是配置布局中默认用户名的地方
    avatar: 'http://dinping.wangyuanweb.top/18-4-12/31903640.jpg', // 这个就是配置布局中默认用户头像的地方
  }
  return data
}
// 配置右上方退出登录的逻辑函数
export const layout = {
  logout: () => {
    console.log('1234')
  },
}
```

- 获取全局共享数据需要插件`@umijs/plugin-model`
  这个插件获取的是存在全局共享的数据，不是存在 dva 数据流中的数据。此处需要特别注意下，简单使用方式

```js
const { initialState, loading, error, refresh, setInitialState } = useModel('@@initialState')
```

### 接口请求

插件`@umijs/plugin-request`默认是启用的。

使用的例子：

```js
import { request } from 'umi'
request(url, {
  method: 'POST',
  headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
  requestType: 'form',
  data,
})
```

更多使用方式请参考[文档](https://umijs.org/zh-CN/plugins/plugin-request#userequest)

### 接入antd@4.0

启用方式是配置开启

```js
import { defineConfig } from 'umi'
export default defineConfig({
  // 配置开启布局插件
+ layout: {},
+ antd: {},
  routes: [{ path: '/', component: '@/pages/index' }],
})
```
**有个注意的地方就是antd@4.0的图标库单独分出去了，使用的时候要单独安装**
具体详见[文档](https://ant.design/components/icon-cn/)
### 使用 dva 数据流

插件是`@umijs/plugin-dva`,启用方式是配置开启

```js
import { defineConfig } from 'umi'
export default defineConfig({
  // 配置开启布局插件
+ layout: {},
+ antd: {},
+ dva: {
    immer: true,
    hmr: false,
  },
  routes: [{ path: '/', component: '@/pages/index' }],
})
```

详细配置请参考[文档](https://umijs.org/zh-CN/plugins/plugin-dva#extramodels)

### 使用代理跨域请求

添加配置

```js
import { defineConfig } from 'umi'
export default defineConfig({
  // 配置开启布局插件
+ layout: {},
+ antd: {},
+ dva: {
    immer: true,
    hmr: false,
  },
+ proxy: {
    '/api': {
      target: 'https://a.b.com/',
      changeOrigin: true,
      pathRewrite: { '^/api': '' },
    },
  },
  routes: [{ path: '/', component: '@/pages/index' }],
})
```

### 开启微前端

微前端插件`@umijs/plugin-qiankun`使用方式是配置开发,需要安装此插件：

```bash
yarn add @umijs/plugin-qiankun -D
```

配置开启

```js
import { defineConfig } from 'umi'
export default defineConfig({
  // 配置开启布局插件
+ layout: {},
+ antd: {},
+ dva: {
    immer: true,
    hmr: false,
  },
+ proxy: {
    '/api': {
      target: 'https://a.b.com/',
      changeOrigin: true,
      pathRewrite: { '^/api': '' },
    },
  },
+ qiankun:{
    master: {
      // 注册子应用信息
      apps: [
        {
          name: 'app1', // 唯一 id
          entry: 'http://localhost:8001', // html entry
        },
      ],
    },
  },
  routes: [
      { path: '/', component: '@/pages/index' },
    + { path: '/dashboard/analysis', microApp: 'app1' } // 微前端的子页面路由
    ],
})
```

![例子](https://gw.alipayobjects.com/mdn/rms_655822/afts/img/A*TroZSp_cH0MAAAAAAAAAAAAAARQnAQ)
更多使用配置请看[文档](https://umijs.org/zh-CN/plugins/plugin-qiankun#%E5%90%AF%E7%94%A8%E6%96%B9%E5%BC%8F)
