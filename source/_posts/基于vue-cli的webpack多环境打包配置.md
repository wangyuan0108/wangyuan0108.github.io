---
title: 基于vue-cli的webpack多环境打包配置
categories: WEB前端
copyright: true
date: 2018-05-14 16:25:08
tags:
---

在实际项目中，在开发过程会根据开发、测试、生产环境的不同来采用不用的配置，最常用的便是 api 接口调用的不同。因此，我们需要根据不同的环境设置不同的 api 地址。所以我们需要对 webpack 的不同配置来完成这个需求。<!--more-->

项目中，我使用的是 vue-cli 来初始化构建项目的。文件夹目录中会有 build 和 config 两个文件夹。

### ./config/index.js 修改配置

在此配置文件中添加需要增加的环境配置

```
build: {
        sitEnv: require('./sit.env'), // 添加测试环境
        preProdEnv: require('./preProd.env'), // 添加沙箱测试环境
        prodEnv: require('./prod.env'),  // 添加生产环境

        // Template for index.html
        index: path.resolve(__dirname, `../dist/${process.env.ENV_CONFIG}/index.html`),

        // Paths
        assetsRoot: path.resolve(__dirname, `../dist/${process.env.ENV_CONFIG}`),
        assetsSubDirectory: '',
        assetsPublicPath: './',

        /**
         * Source Maps
         */

        productionSourceMap: false,
        // https://webpack.js.org/configuration/devtool/#production
        devtool: '#source-map',

        // Gzip off by default as many popular static hosts such as
        // Surge or Netlify already gzip all static assets for you.
        // Before setting to `true`, make sure to:
        // npm install --save-dev compression-webpack-plugin
        productionGzip: false,
        productionGzipExtensions: ['js', 'css'],

        // Run the build command with an extra argument to
        // View the bundle analyzer report after build finishes:
        // `npm run build --report`
        // Set to `true` or `false` to always turn it on or off
        bundleAnalyzerReport: process.env.npm_config_report
    }
```

### 修改文件 webpack.prod.conf.js 下的配置如下：

```
const env = config.build[process.env.ENV_CONFIG+'Env']
```

### 修改文件 package.json 文件

```
"scripts": {
    "build:sit": "cross-env NODE_ENV=production ENV_CONFIG=sit  node build/build.js",
    "build:preProd": "cross-env NODE_ENV=production  ENV_CONFIG=preProd  node build/build.js",
    "build:prod": "cross-env NODE_ENV=production  ENV_CONFIG=prod node build/build.js"
  },
```

这里有几点需要注意：

1.  cross-env 是为了兼容各个系统之间差别，需要安装这个包

```
npm install cross-env --save-dev
```

2.  NODE_ENV 和 ENV_CONFIG 与环境配置文件中的大小写一定要一致，不然在 linux 系统服务器下面会出现问题，已踩坑。

### 添加相应的环境文件 sit.env.js 等

```
module.exports = {
    NODE_ENV: '"production"',
    ENV_CONFIG: '"sit"',
    BASE_URL: '"http://xxx.xxx.com/buy-api/"',
    CONFIG_TEXT: '"SIT测试环境"'
};
```

如果需要配置的环境比较多，就按照这个来进行改写添加相应的环境配置文件。

### 启动项目

```
#开发调试
npm run dev
#测试环境构建
npm run build:sit
#生产环境构建
npm run build:prod
```

### 小结

在开发中，使用的是 node 的环境下。所以我们写的环境的配置文件中的字段都是可以取到值得比如：

```
process.env.BASE_URL
```

当我们能取到这些值得时候，我们就可以在不同环境的打包的时候，把不同环境下的 api 的前缀在打包的时候进行更换。用命令来构建 webpack 的打包就比较方便了。可以在我们的 api 请求拦截器的时候进行拦截比如我使用的是 axios，配置是这样的：

```
axios.defaults.baseURL = process.env.NODE_ENV === 'development' ? '/buy-api/' : process.env.BASE_URL;
```
