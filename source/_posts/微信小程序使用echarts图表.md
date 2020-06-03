---
title: 微信小程序使用echarts图表
categories: WEB前端
copyright: true
date: 2020-06-03 15:49:48
tags:
  - 微信
  - 小程序
  - echarts图表
---

### 前言

数据统计是我们经常使用的功能，我们一般在 pc 端使用的比较多，大多数用在管理系统中统计数据的分析，最近在做微信小程序的时候也遇到了相同的需求，把数据统计在小程序端以图表的形式展示，这里记录下自己的配置使用过程。<!--more-->

### 准备

首先百度的 echarts 没有提供小程序版本，这里找了个封装过可以用在微信端的仓库[小程序版 echarts](https://github.com/ecomfe/echarts-for-weixin),通过这个链接下载最新的包。解压之后有个`ec-canvas`文件夹就是封装的组件，放到小程序的组件文件夹目录下，以供使
用。

```js
├── ec-canvas
│   ├── ec-canvas.js
│   ├── ec-canvas.json
│   ├── ec-canvas.wxml
│   ├── ec-canvas.wxss
│   ├── echarts.min.js
│   └── wx-canvas.js
```

### 使用

1. 在需要使用的页面配置文件中引入该图表组件

```json
"usingComponents": {
    "ec-canvas": "../../ec-canvas/ec-canvas"
  }
```

2. index.wxml 中，我们创建了一个 <ec-canvas> 组件：

```wxml
<view class="container">
  <ec-canvas id="mychart-dom-bar" canvas-id="mychart-bar" ec="{{ ec }}"></ec-canvas>
</view>
```

3. 其中 ec 是一个我们在 index.js 中定义的对象，它使得图表能够在页面加载后被初始化并设置。index.js 的结构如下：

```js
Page({
  data: {
    ec: {
      onInit: initChart
    }
  },
  onLoad(){
      // 在需要的地方获取dom
      this.echartsComponnet1 = this.selectComponent('#mychart-dom-bar1')
      this.init_echarts1({ value: res.data.rotateSpeed || 0, name: 'x1000' })
  }
  // 初始化
    init_echarts1 (data) {
      this.echartsComponnet1.init((canvas, width, height) => {
        // 初始化图表
        const chart = echarts.init(canvas, null, {
          width: width,
          height: height
        })
        this.chart = chart
        // setGaugeChartOption1获取到基础配置
        chart.setOption(setGaugeChartOption1(data))
        // 注意这里一定要返回 chart 实例，否则会影响事件处理等
        return chart
      })
    },
});
```
