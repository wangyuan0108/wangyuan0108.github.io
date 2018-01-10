---
title: webpack中的px2rem
categories: WEB前端
copyright: true
date: 2017-12-31 00:29:15
tags:
---
# vue做移动端适配，借助px2rem插件方便的将px单位转换为rem

## 安装

```
npm install px2rem-loader --save

```
<!--more-->

##  在build下的 utils.js中，找到generateLoaders 方法，在这里添加。

```
const px2remLoader = {
loader: 'px2rem-loader',
options: {
        remUnit: 37.5
    }
}

function generateLoaders (loader, loaderOptions) {
const loaders = [cssLoader, px2remLoader]
if (loader) {
    loaders.push({
        loader: loader + '-loader',
        options: Object.assign({}, loaderOptions, {
            sourceMap: options.sourceMap
        })
    })
}

```

##  重启项目，会发现自己设置的px被转为rem 了


##  以上实现转换适用于：

1. 组件中编写的<style></style>下的css

2. 从index.js或者main.js中import ‘../../static/css/reset.css’引入css

3. 在组件的<script type=”text/ecmascript-6″> import ‘../../static/css/reset.css'</script>中引入css

## 另外的情况

1. 组件`<style></style>`中`@import “../../static/css/reset.css` (可考虑上面（2）、（3）的形式引入)

2. 外部样式:`<link rel=”stylesheet” href=”static/css/reset.css”>`

3. 元素内部样式：`style=”height: 417px; width: 550px;”`



