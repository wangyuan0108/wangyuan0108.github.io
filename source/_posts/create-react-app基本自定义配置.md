---
title: create-react-app基本自定义配置
categories: WEB前端
copyright: true
date: 2018-03-17 22:13:35
tags: react
---
create-react-app作为最常用的react脚手架集成了很多的常用功能，比如支持es6、JSX、动态import、Fetch(polyfill)、proxy、postcss、eslint等。但也有些功能并没有提供支持比如Hot-reloading和css预处理器，所以我们需要自定义配置这些功能。
<!--more-->

首先需要npm run eject进行自定义配置。

## 配置proxy

在package.json中添加proxy字段。

```
 "eslintConfig": {
    "extends": "react-app"
  },
  "proxy": {
    "/api": {
      "target": "https://m.weibo.cn",
      "changeOrigin": true
    }
  },
```

在`index.js`中实验一下代理的功能。

```
registerServiceWorker();

fetch('/api/comments/show?id=4199740256395164&page=1').then(res => {
    res.json().then(data => {
        console.log(data);
    })
})
```

然后运行`yarn start`打开控制台看下打印的日志，如果成功就会看到请求到的数据了。

## 配置css的预处理器sass

首先需要安装对应的`loader`.

```
yarn add sass-loader node-sass --dev
```
然后在修改`dev`环境的配置,在如下代码所试的地方

```
 test: /\.css$/,
            use: [
              require.resolve('style-loader'),
              {
                loader: require.resolve('css-loader'),
                options: {
                  importLoaders: 1,
                },
              },
```

改为下面的代码

```
 test: /\.(css|scss)$/,
            use: [
              require.resolve('style-loader'),
              {
                loader: require.resolve('css-loader'),
                options: {
                  importLoaders: 2,
                },
              },
```
然后在`use`规则的结尾加上一个`loader`如下`

```
{
loader: require.resolve('postcss-loader'),
options: {
    // Necessary for external CSS imports to work
    // https://github.com/facebookincubator/create-react-app/issues/2677
    ident: 'postcss',
    plugins: () => [
    require('postcss-flexbugs-fixes'),
    autoprefixer({
        browsers: [
        '>1%',
        'last 4 versions',
        'Firefox ESR',
        'not ie < 9', // React doesn't support IE8 anyway
        ],
        flexbox: 'no-2009',
    }),
    ],
},
},
{
    loader:require.resolve('sass-loader')
}
```

然后修改生产环境下的方法同上。

## 配置模块热更新

模块热跟新就是不刷新页，需要更新的模块自己跟新。首先我们需要安装所需要的模块，执行以下命令进行安装。

```
yarn add react-hot-loader --dev
```
然后在webpack.config.dev.js配置文件的入口配置中添加以下代码

```
    'react-hot-loader/patch',
    // We ship a few polyfills by default:
    require.resolve('./polyfills'),
```

然后在`babel-loader`中添加一个`plugins`.

```
{
    test: /\.(js|jsx|mjs)$/,
    include: paths.appSrc,
    loader: require.resolve('babel-loader'),
    options: {
        
        // This is a feature of `babel-loader` for webpack (not Babel itself).
        // It enables caching results in ./node_modules/.cache/babel-loader/
        // directory for faster rebuilds.
        cacheDirectory: true,
        plugins: [
        'react-hot-loader/babel'
        ]
    },
}
```

然后在修改入口文件代码`index.js`

```
import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import App from './App';
import registerServiceWorker from './registerServiceWorker';

import { AppContainer } from 'react-hot-loader';

// ReactDOM.render(<App />, document.getElementById('root'));

const render = Component => {
    ReactDOM.render(
        <AppContainer>
            <Component></Component>
        </AppContainer>,
        document.getElementById('root')
    )
}

render(App);

if(module.hot) {
    module.hot.accept('./App',() => {
        render(App);
    });
}

registerServiceWorker();

//之前实验proxy代理的代码
fetch('/api/comments/show?id=4199740256395164&page=1')
    .then(res => {
        res.json().then(data => {
            console.log(data)
        })
    })
```

这样就完成了热更新的配置。到此基本的自定义配置已经完成了。有新的需求在补充。
