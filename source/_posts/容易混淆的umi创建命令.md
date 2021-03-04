---
title: 容易混淆的umi创建命令
categories: WEB前端
copyright: true
date: 2021-03-04 17:25:28
tags:
---

## 简介

在 react 开发中，不得不提的就是 umijs 框架。这个框架把 react 全家桶打了一个包，整合在了一起。让开发者不必苦于配置初始开发环境。在 umijs2.x 升级到 umijs3.x 之后，在创建新项目的命令也发生了变化，让人容易模糊，而且 npm 和 yarn 的使用命令也不相同。这里做个简单的分享，方便以后查阅。

## Umi 2.x

通过官网得知，2.x 版本 umi 通过 create-umi 提供脚手架能力来创建的新项目。使用方式如下

```bash
$ mkdir myapp && cd myapp
$ yarn create umi
```

> 你可以通过 yarn create umi 或 npm create umi 使用 create-umi。推荐使用 yarn create 命令，能确保每次使用最新的脚手架。

这里当时其实是很疑惑的，为啥使用的是 create-umi 脚手架来创建的项目，却不是 npm run create-umi 这样的使用命令？最后查阅资料得知，其实 yarn create umi 其实做了两步操作，根据 yarn 的官方文档。

![](https://gitee.com/wangyuan0108/image/raw/master/20210304175413.png)

而 npm create 确实平时不怎么见，而且文档也没有这个命令。最后多方查找说是 npm init 的别名，这里的作用就和 yarn create 一样随便用吧。大概就这样一段野史可证！！

![](https://gitee.com/wangyuan0108/image/raw/master/20210304175456.png)

由此创建项目的脚本命令就清楚了，就是使用了 create-umi 脚手架生成的。那么对以往的总结可以有以下方式来创建项目

```
yarn create umi // 创建文件在当前文件夹，执行脚本并更新create-umi包
npm create umi  // 创建文件在当前文件夹，只执行脚本不更新create-umi包
yarn create umi water // 创建文件在water文件夹，执行脚本并更新create-umi包
npm create umi water	// 创建文件在water文件夹，只执行脚本不更新create-umi包
// npx方式
npx create-umi
npx create-umi

第二种方式
1. yarn global add create-umi/npm install create-umi -g // 先安装包
2.
	create-umi // 在当前文件夹创建项目
	create-umi water //在water文件中创建项目
```

## Umi 3.x

有以上的文字参考，3.x 版本的创建也就容易理解了。主要使用的是@umijs/create-umi-app 包来创建项目的。官网文档是这样写的

```
$ mkdir myapp && cd myapp
$ yarn create @umijs/umi-app
# 或 npx @umijs/create-umi-app
```

由以上命令来说，总结下创建的命令

```
yarn create @umijs/umi-app
npm create @umijs/umi-app
// 带文件夹
yarn create @umijs/umi-app water
npm create @umijs/umi-app water
// npx方式
npx @umijs/create-umi-app
npx @umijs/create-umi-app water
// 直接使用包创建
1. 先安装包
@umijs/create-umi-app
2. 创建带不带文件夹
create-umi-app
create-umi-app water
```

## 小结

整体就是用以上用命令通过脚手架包来创建项目的总结，希望对你有所帮助！！！
