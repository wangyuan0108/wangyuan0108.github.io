---
title: 自定义create-umi脚手架
categories: WEB前端
copyright: true
date: 2019-12-30 16:18:21
tags: react
---
## 简介
在开发react项目中，使用的是阿里开源的框架umi。这个架构非常好用，可以集成我们需要的dva、antd、antd pro、typescript等。对我们开发新项目的架构初始化非常友好。但是官方的umi虽然好用，但是文件结构是通用的，不符合我们各自的项目需求。比如：我们的项目需要一个api文件夹，这时我们就需要基于新建的项目添加文件夹。这样改一点的还好，万一我们改的多了，每次新建项目都需要复制修改，比较麻烦，这里我就想自定义脚手架，每次执行shell命令就生成我们定义好的架构目录，踩坑走起！

## 踩坑自定义脚手架步骤
### fork官方的create-umi脚手架仓库到自己的github中
### git clone 我们fork完的远程仓库

```sh
git clone https://github.com/wangyuan0108/create-umi.git
```
### 卸载之前全局装的官方的脚手架

```sh
yarn remove global umi create-umi
```
### 进入clone的create-umi项目并安装依赖包
```sh
cd create-umi
yarn
```
### 找到你想修改的地方
比如我想在app类型下面新加一个api的文件夹，就找到对应的位置进行修改就好了。模版所在的位置是
```sh
./lib/generators/ant-design-pro
./lib/generators/app
./lib/generators/block
./lib/generators/library
./lib/generators/plugin
```
## 总结
1. 要删除全局安装的官方脚手架
2. 如果修改package.json中的bin字段命令，那么name字段也要改成相应的字段
3. 
```sh
yarn create umi appname
// 等于以下两步
yarn global add create-umi（bin中指定的字段)
create-umi appname
```
至此就可以愉快的修改自己的脚手架了

