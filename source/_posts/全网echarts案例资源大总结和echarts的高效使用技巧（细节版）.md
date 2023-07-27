---
title: 全网echarts案例资源大总结和echarts的高效使用技巧（细节版）
categories: WEB前端
copyright: true
date: 2023-07-27 14:40:35
tags:
---
---
theme: mk-cute
---

##### 一.前言。
众所周知，在现今的开发大环境下，数据可视化（大屏化）项目在前端开发中的比重越来越大。而其中使用率最高的插件无疑就是 [Apache Echarts](https://echarts.apache.org/zh/index.html)。（ps: 以下简称为echarts）。本文就结合vue框架来讲解如何快速、高效、优雅地在项目中使用echarts。当然，本文篇幅也会为读者精心准备目前网络上**最全面、最高效**的**echarts案例资源站集合**。
<!--more-->

##### 二. 全网最全的echarts图表案例和实例资源站整理。
1. 资源一：**[分享你我](http://chart.majh.top/)**  *（推荐指数：⭐⭐⭐⭐）*
- 优点：案例资源丰富，有主体分类，可检索，访问速度较快。
- 缺点：未做分页。

2. 资源二：**[ISWWQ.com](https://www.isqqw.com/homepage#/homepage)**   *（推荐指数：⭐⭐⭐⭐）*
- 优点：案例资源丰富，可检索，有主体分类。
- 缺点：未做分页，访问速度较慢。

3. 资源三：**[PPChart](http://ppchart.com/#/)**  *（推荐指数：**⭐⭐⭐⭐⭐**）*
- 优点：案例资源丰富，有主体分类且分类较细，有分页，可检索，访问速度较快。
- 缺点：暂无。

4. 资源四：**[ECHARTS社区](https://www.makeapie.cn/echarts)**  *（推荐指数：⭐⭐⭐）*
- 优点：案例资源丰富，有主体分类且分类较细，有分页，可检索，提供登录和社区。
- 缺点：访问速度慢，有广告。

5. 资源五：**[Made A Pie](https://madeapie.com/#/)**   *（推荐指数：⭐⭐⭐⭐）*
- 优点：案例资源丰富，可检索，有主体分类。
- 缺点：访问速度较慢，未做分页。

6. 资源六：**[MCChart](http://echarts.zhangmuchen.top/#/index)**   *（推荐指数：⭐⭐⭐⭐）*
- 优点：案例资源丰富，可检索，有主体分类。
- 缺点：详情图例加载慢，图例加载不出。

7. 资源七：**[ECharts官方案例](https://echarts.apache.org/examples/zh/index.html)**  *（推荐指数：**⭐⭐⭐⭐⭐**）*
- 优点：官方案例，资源稳定，主体分类多，可调节模式，可直接查看对应案例的配置项。
- 缺点：案例资源较少，未做分页，未提供检索。

8. 资源八：**[chartsdev.com](http://192.144.199.210/forum-2-1.html)**   *（推荐指数：⭐⭐）*
- 优点：案例资源丰富，有主体分类。
- 缺点：访问速度一般，未能开箱即用，排版较差，适用性较差等。

9. 资源九：**[仿ECharts]**  *（推荐指数：⭐⭐⭐）*
- 优点：资源较稳定，图标效果加载速度较快。
- 缺点：案例资源较少，未做分页，未提供检索等。

10. 资源十：**[DataInsight](http://analysis.datains.cn/finance-admin/index.html#/chartLib/all)** *（推荐指数：⭐⭐）*
- 优点：案例资源较丰富。
- 缺点：访问速度慢，未做主体分类，未提供检索等。

11. 资源十一：**[阿里云--原ECharts官方社区Make A Pie案例源码及图表图](https://www.aliyundrive.com/s/hH9wXex8jYa)**    *（推荐指数：**⭐⭐⭐⭐⭐**）*
- 优点：提供原ECharts官方社区Make A Pie网站的所有案例源码及其对应的图例，可供查阅与开发成共享资源社区或网站。
- 缺点：未实现开箱即用。
- 说明：提取码：**6l3t**。

12. 资源十二：**[百度云--原ECharts官方社区Make A Pie案例源码及图表图](https://pan.baidu.com/s/1z73BAufIo0aV5_ZGQ66xmg)**     *（推荐指数：**⭐⭐⭐⭐⭐**）*
- 优点：提供原ECharts官方社区Make A Pie网站的所有案例源码及其对应的图例，可供查阅与开发成共享资源社区或网站。
- 缺点：未实现开箱即用。
- 说明：提取码：**qqsy**。


##### 三.echarts在vue项目中的使用说明和技巧。

1. 安装依赖和注意事项及对应的处理办法。
- 说明：
  vue中直接安装最新的echarts依赖包，可能会在运行时报echarts的init方法未定义的异常，此时可先**卸载当前版本的echarts依赖包，重新安装指定稳定版本（如：v4.8.0）**。如若此时还是报init未定义，那么可在入口文件main.js中引入时需按这种方式引入即可解决 ---- **import * as echarts from 'echarts'**。

- 核心代码和图例：


```js
//常规安装
 
npm install echarts --save
 
 
//如若按官网的上述依赖安装后报init未定义的话,那可能是由于所安装的当前ECharts版本过高导致,请安装以下版本
 
npm uninstall echarts --save   //卸载当前安装的ECahrts依赖
 
npm install echarts@4.8.0 --save     //重新安装低版ECahrts依赖
```

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/0841337029424d17b0cd27d9ead59c91~tplv-k3u1fbpfcp-watermark.image?)

2. 组件化实现每个echarts图表的独立管理，避免不必要的耦合。

- 说明：
  主组件（父组件）只用来存主内容区域和对应echrts图表的外部盒子；用子组件实现真正的容器来装载整个图表和实现对应图表的数据和图表渲染。


- 核心代码：

```js
父组件：

<div class="p-section bg">
    <div class="p-title">业务类型占比</div>
    <!--以下为子组件-->
    <ywlxzbChart></ywlxzbChart>
</div>
```


```js
子组件（echarts图表核心）：

<template>
  <div
    id="ywlx"
    style="width: 100%; height: 195px"
    v-loading="ywlezbLoading"
  ></div>
</template>

<script>
import echarts from "echarts";
import * as API from "api/home.js";
export default {
  data() {
    return {
      ywlezbLoading: false,
      myChartLine: null,
      formData: [],
      nameData: [],
    };
  },
  name: "ywlxzbChart",
  methods: {
    //获取数据,Promise确保执行和绘画顺序
    getProfessionalCardsCount() {
      return new Promise((resolve, reject) => {
        this.ywlezbLoading = true;
        API.getProfessionalCardsCount()
          .then((res) => {
            this.ywlezbLoading = false;
            if (res.code == 200) {
              this.formData = res.data.professions;
              this.nameData = [];
              this.formData.map((i) => {
                this.nameData.push(i.name);
              });
            }
            resolve(res);
          })
          .catch((err) => {
            this.ywlezbLoading = false;
            reject(err);
          });
      });
    },
    myEcharts() {
      // 基于准备好的dom，初始化echarts实例
      this.myChartLine = echarts.init(document.getElementById("ywlx"));

      // 指定图表的配置项和数据

      var option = {
        tooltip: {
          trigger: "item",
          formatter: "{a} <br/>{b} : {c} ({d}%)",
        },
        color: ["#31ceee", "#20adeb", "#6be7e8"],
        legend: {
          orient: "vertical",
          x: "right",
          align: "left",
          padding: [10, 5, 0, 0],
          data: this.nameData,
          formatter: function (name) {
            var oa = option.series[0].data;
            var num = oa[0].value + oa[1].value + oa[2].value;
            for (var i = 0; i < option.series[0].data.length; i++) {
              if (name == oa[i].name) {
                return name;
              }
            }
          },
        },
        series: [
          {
            name: "业务类型占比",
            type: "pie",
            radius: "68%",
            center: ["40%", "50%"],
            data: this.formData,
            itemStyle: {
              normal: {
                label: {
                  show: true,
                  //	                            position:'inside',
                  formatter: "{b}: {d}%",
                },
              },
              labelLine: { show: true },
            },
            labelLine: {
              normal: {
                length: 1,
              },
            },
          },
        ],
      };

      // 使用刚指定的配置项和数据显示图表。
      this.myChartLine.setOption(option);
    },
  },
  mounted() {
    //图的大小自适应
    window.addEventListener("resize", () => {
      if (this.myChartLine) {
        this.myChartLine.resize();
      }
    });
    this.getProfessionalCardsCount().then((res) => {
      this.myEcharts();
    });
  },
  beforeDestroy() {
    //实例销毁之前调用
    if (!this.myChartLine) {
      return;
    }
    this.myChartLine.dispose();
    this.myChartLine = null;
  },
};
</script>

<style>
</style>
```

- 注意点：
1. 将echarts图表的 **数据** 和 **绘制** 分为两部分各自处理，一目了然，层次分明。
2. **真实图表绘制操作务必放在数据请求赋值之后操作**；为了确保执行准确性和可靠性，这里借助了**Promise**来实现。
3. 组件销毁时要重置（销毁）图表。
4. 为了提高用户体验感，强烈建议为图表容器加上loading状态。



- 效果图：

![c99d048b8f1f40e98184d0c9ce4d00d8_tplv-k3u1fbpfcp-watermark.gif](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/5cc35b330d6442dbb95ad7822dbde976~tplv-k3u1fbpfcp-watermark.image?)
