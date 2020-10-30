---
title: 用css画出一个半圆和环形进度条
categories: WEB前端
copyright: true
date: 2020-10-30 14:32:28
tags:
---

# 如何使用 css 画一个半圆呢？介绍三种方法

## border-radius

boder-radius 属性也支持单边设置弧度，不同的弧度可以绘制不同的图形，今天来画一个半圆<!--more-->

直接上代码：

```html
<div id="half_circle"></div>
<div id="half_circle1"></div>
<div id="half_circle2"></div>
<div id="half_circle3"></div>
```

```css
#half_circle {
  width: 100px;
  height: 200px;
  background: #000;
  border-radius: 0 100px 100px 0;
}

#half_circle1 {
  width: 200px;
  height: 100px;
  background: #000;
  border-radius: 100px 100px 0 0;
}

#half_circle2 {
  width: 100px;
  height: 200px;
  background: #000;
  border-radius: 100px 0 0 100px;
}

#half_circle3 {
  width: 200px;
  height: 100px;
  background: #000;
  border-radius: 0 0 100px 100px;
}
```

border-radius 的值顺序是左上、右上、右下、左下顺时针，盒子的宽高要求是 1:2 或者 2:1，border-radius 值不能是百分比，应该与短边一致

## clip

css3 中的 clip 属性可以剪裁绝对定位元素，画半圆的思想就是先画一个圆，然后用 clip 剪切掉一半

看代码：

```html
<div class="half_circle"></div>
<div class="half_circle1"></div>
```

```css
.half_circle {
  position: absolute;
  width: 200px;
  height: 200px;
  background: black;
  border-radius: 50%;
  clip: rect(0, 200px, 100px, 0);
}

.half_circle1 {
  position: absolute;
  top: 220px;
  width: 200px;
  height: 200px;
  background: black;
  border-radius: 50%;
  clip: rect(0, 200px, 200px, 100px);
}
```

clip 唯一合法的形状值是：rect (top, right, bottom, left)

## 线性渐变

思想还是先画一个圆，然后利用背景线性渐变展示一半

代码：

```html
<div class="half_circle"></div>
```

```css
.half_circle {
  width: 200px;
  height: 200px;
  border-radius: 50%;
  background: linear-gradient(transparent 50%, black 50%);
}
```

以上，有其他方法再补充~

# 实现一个环形进度条
遇到一个需求，需要实现一个环形进度条，下面是一种方法

## 环形进度条
实现思路：背景画一个圆形，在圆形上左右两边各覆盖一个半圆，顺时针旋转右边的半圆直至180deg，此时右边的半圆转到了左边，左右两个半圆完全重叠，下一步恢复右边半圆到初始位置，且背景色设置为与背景圆形一致，接着顺时针旋转左边半圆180deg（因为左边半圆渲染层级在右半圆的下方），即可完成一个完整的旋转进度，在上方盖一个同心小圆即可实现环形进度条的效果。

层级旋转效果：
```html
<div class="block">
  <div class="left"></div>
  <div class="right"></div>
  <div class="circle"></div>
</div>
```

```css
.block {
  position: relative;
  width: 200px;
  height: 200px;
  background: black;
  border-radius: 50%;
}

.block * {
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  right: 0;
  margin: auto;
}

.left {
  border-radius: 50%;
  background: red;
  clip: rect(0, 100px, 200px, 0);
}

.right {
  border-radius: 50%;
  background: blue;
  clip: rect(0, 200px, 200px, 100px);
}

.circle {
  width: 90%;
  height: 90%;
  background: rgba(255, 255, 255, .5);
  border-radius: 50%;
}
```

```js
let blockEl = document.querySelector('.block');
let leftEl = document.querySelector('.left');
let rightEl = document.querySelector('.right');

let percent = 0;

function step() {
  percent++;
  if(percent < 50) {
    rightEl.style.transform = 'rotate(' + (3.6 * percent) + 'deg)'; 
  } else {
    rightEl.style.transform = 'rotate(0)';
    rightEl.style.background = 'black';
    leftEl.style.transform = 'rotate(' + 3.6 * (percent - 50) + 'deg)';
  }
    
  if (percent < 100) {
    window.requestAnimationFrame(step);
  }
}

window.requestAnimationFrame(step);
```


完整实现：
```html
<div class="block">
  <div class="left"></div>
  <div class="right"></div>
  <div class="circle"></div>
</div>
```

```css
.block {
  position: relative;
  width: 200px;
  height: 200px;
  background: red;
  border-radius: 50%;
}

.block * {
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  right: 0;
  margin: auto;
}

.left {
  border-radius: 50%;
  background: black;
  clip: rect(0, 100px, 200px, 0);
}

.right {
  border-radius: 50%;
  background: black;
  clip: rect(0, 200px, 200px, 100px);
}

.circle {
  width: 90%;
  height: 90%;
  background: white;
  border-radius: 50%;
}
```

```js
let leftEl = document.querySelector('.left');
let rightEl = document.querySelector('.right');

let percent = 0;

function step() {
  percent++;
  if(percent < 50) {
    rightEl.style.transform = 'rotate(' + (3.6 * percent) + 'deg)'; 
  } else {
    rightEl.style.transform = 'rotate(0)';
    rightEl.style.background = 'red';
    leftEl.style.transform = 'rotate(' + 3.6 * (percent - 50) + 'deg)';
  }
    
  if (percent < 100) {
    window.requestAnimationFrame(step);
  }
}

window.requestAnimationFrame(step);

```

## 中间透明的环形进度条
又想，如果要求中间带透明度的或者中间完全透明的环形进度条怎么实现呢？

稍微调整一下，将半圆用border显示，底层背景用内阴影shadow表示，即可实现效果

代码：
```html
<div class="block">
  <div class="left"></div>
  <div class="right"></div>
  <div class="circle"></div>
</div>
```

```css
body {
  background: yellow;
}

.block {
  position: relative;
  width: 200px;
  height: 200px;
  box-shadow: inset 0 0 0 12px pink;
  border-radius: 50%;
}

.block * {
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  right: 0;
  margin: auto;
}

.left {
  border-radius: 50%;
  border: 12px solid black;
  clip: rect(0, 100px, 200px, 0);
}

.right {
  border-radius: 50%;
  border: 12px solid black;
  clip: rect(0, 200px, 200px, 100px);
}

.circle {
  width: 90%;
  height: 90%;
  background: rgba(255, 255, 255, .3);
  border-radius: 50%;
}
```

```js
let leftEl = document.querySelector('.left');
let rightEl = document.querySelector('.right');

let percent = 0;

function step() {
  percent++;
  if(percent < 50) {
    rightEl.style.transform = 'rotate(' + (3.6 * percent) + 'deg)'; 
  } else {
    rightEl.style.transform = 'rotate(0)';
    rightEl.style.borderColor = 'pink';
    leftEl.style.transform = 'rotate(' + 3.6 * (percent - 50) + 'deg)';
  }
    
  if (percent < 100) {
    window.requestAnimationFrame(step);
  }
}

window.requestAnimationFrame(step);
```


以上~

