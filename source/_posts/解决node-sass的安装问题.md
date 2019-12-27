---
title: 解决node-sass的安装问题
categories: WEB前端
copyright: true
date: 2019-12-27 09:31:57
tags:
---
## 问题
在我们想使用scss来写样式的时候，避免不了的需要安装node-sass包，但是只要是安装的过这个包的都知道，这个包的安装是非常的困难。所以这里提供一个新的解决方法，解决这个包安装慢的问题。
<!--more-->
## 踩坑过程
在初学scss的时候安装node-sass当然是最普通的npm安装
```bash
npm install node-sass --save-dev
```
结果很显然，当然是安装不上。然后换npm的源，我用的是nrm来管理的npm源。也需要用nrm的可以安装。

```bash
npm install -g nrm
```
然后查看我的npm源
```
nrm ls

  npm -------- https://registry.npmjs.org/
  yarn ------- https://registry.yarnpkg.com/
  cnpm ------- http://r.cnpmjs.org/
* taobao ----- https://registry.npm.taobao.org/
  nj --------- https://registry.nodejitsu.com/
  npmMirror -- https://skimdb.npmjs.com/registry/
  edunpm ----- http://registry.enpmjs.org/
```
*号代表当前使用的源，切换源的命令：
```bash
nrm use npm
```
这样就切换到了npm的源。我使用淘宝源，下载node-sass，这个就是佛系了，有时网络好就下载下来了，不好就下载不了，现在大部分有时下不下来（yarn也是一样的问题）。然后我就用cpm来下载。
```bash
cnpm install node-sass --save-dev
```
结果是cnpm能够很快的下载下来，但是总有文章说使用cnpm有时会出现莫名的问题，这让我也很尴尬，所以也就寻找其他方法，然后找到了，对node-sass的包单独换源。

```bash
npm config set sass_binary_site https://npm.taobao.org/mirrors/node-sass/
```
然后在用npm就可以下载了，结果很奈斯

## 总结
过程是曲折的，但是结果是美好的，遇到问题慢慢找办法，这就是成长。

