---
title: div+css画三角形的方法和原理
categories: WEB前端
copyright: true
date: 2018-03-25 20:34:25
tags: css
---
## 原理

其实使用div和css做出三角形，原理就是对div盒子的border属性的运用。首先，先上个简单的代码：
<!--more-->
```
<div class="try"></div>

.try {
    width:0;
    height:0;
    border-top: 50px solid red;
    border-right: 50px solid green;
    border-bottom: 50px solid blue;
    border-left: 50px solid orange;
}
```
运行代码，打开浏览器浏览结果。你会看到一个div盒子被四种不同颜色的三角形分割。这是我们实现三角形的第一步！

## 形成一个三角形

看图我们可以知道，我们想要的那个方向的三角形显示，其他方向的三块三角形区域隐藏。这样，我们想要的三角形就做好了！

```

<div class="top"></div>
<div class="right"></div>
<div class="bottom"></div>
<div class="left"></div>

.top{
    width: 0;
    height: 0;
    border-right: 50px solid transparent;
    border-bottom: 50px solid red;
    border-left: 50px solid transparent;
}
.right{
    width: 0;
    height: 0;
    border-top: 50px solid transparent;
    border-bottom: 50px solid transparent;
    border-left: 50px solid red;
}
.bottom{
    width: 0;
    height: 0;
    border-top: 50px solid red;
    border-right: 50px solid transparent;
    border-left: 50px solid transparent;
}
.left{
    width: 0;
    height: 0;
    border-top: 50px solid transparent;
    border-right: 50px solid red;
    border-bottom: 50px solid transparent;
```

## 完成

div加css可以实现很多的图形，这里主要说三角形的做法。因为在开发中用的比较多！
