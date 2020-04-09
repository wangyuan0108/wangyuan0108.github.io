---
title: css实现内凹圆角
categories: WEB前端
copyright: true
date: 2020-04-09 16:24:37
tags: css
---

### 起因

最近在做项目中，遇到一个项目需求，在 ui 上显示一个优惠券的卡片。这个卡片和大家一般看到的类似，中间会有两个内凹的半圆。实现这个背景卡片的方式最简单的就是用背景图这里我就不说了。还有一个方式就是用 css 样式来写一个这样的效果。

### 具体实现

#### 用四个 div 遮盖的方式

```html
<html>
  <head>
    <meta charset="utf-8" />
    <title>内凹圆角</title>
    <style type="text/css">
      .cro {
        width: 100px;
        height: 100px;
        border: 1px solid #58c4e6;
        position: relative;
      }

      .cro_left_top,
      .cro_right_top,
      .cro_left_bottom,
      .cro_right_bottom {
        position: absolute;
        width: 20px;
        height: 20px;
        border: 1px solid #fff;
        z-index: 1;
        background: #fff;
      }

      .cro_left_top {
        top: -1px;
        left: -1px;
        border-radius: 0 0 20px 0;
        border-bottom: 1px solid #58c4e6;
        border-right: 1px solid #58c4e6;
      }

      .cro_right_top {
        top: -1px;
        right: -1px;
        border-radius: 0 0 0 20px;
        border-bottom: 1px solid #58c4e6;
        border-left: 1px solid #58c4e6;
      }

      .cro_left_bottom {
        left: -1px;
        bottom: -1px;
        border-radius: 0 20px 0 0;
        border-top: 1px solid #58c4e6;
        border-right: 1px solid #58c4e6;
      }

      .cro_right_bottom {
        right: -1px;
        bottom: -1px;
        border-radius: 20px 0 0 0;
        border-top: 1px solid #58c4e6;
        border-left: 1px solid #58c4e6;
      }
    </style>
  </head>
  <body>
    <div class="cro">
      <div class="cro_left_top"></div>
      <div class="cro_right_top"></div>
      <div class="cro_left_bottom"></div>
      <div class="cro_right_bottom"></div>
    </div>
  </body>
</html>
```

#### 用背景的渐变来实现

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Document</title>
  </head>
  <body>
    <style>
      p {
        margin: 0;
        padding: 0;
      }
      .top-box {
        width: 100%;
        height: 200px;
        background: red;
        position: relative;
        margin-bottom: 20px;
        border-radius: 4px 4px 0 0;
      }
      .bottom-box {
        width: 100%;
        height: 100px;
        background: #000;
        position: relative;
        border-radius: 0 0 4px 4px;
      }
      .top-box p,
      .bottom-box p {
        width: calc(100% - 20px);
        height: 10px;
        position: absolute;
        left: 10px;
      }
      .top-box p {
        background: red;
        bottom: -10px;
      }
      .bottom-box p {
        background: #000;
        top: -10px;
      }
      .top-box p::before,
      .bottom-box p::before {
        content: '';
        position: absolute;
        width: 10px;
        height: 10px;
        left: -10px;
      }
      .top-box p::after,
      .bottom-box p::after {
        content: '';
        position: absolute;
        width: 10px;
        height: 10px;
        right: -10px;
      }
      .top-box p::before {
        background-image: radial-gradient(circle 10px at 0 100%, transparent 50px, red 50%);
      }
      .top-box p::after {
        background-image: radial-gradient(circle 10px at 100% 100%, transparent 50px, red 50%);
      }
      .bottom-box p::before {
        background-image: radial-gradient(circle 10px at 0 0, transparent 50px, #000 50%);
      }
      .bottom-box p::after {
        background-image: radial-gradient(circle 10px at 100% 0, transparent 50px, #000 50%);
      }
    </style>

    <div id="modal">
      <div class="mask"></div>
      <div class="wrap">
        <div class="top-box">
          <p></p>
        </div>
        <div class="bottom-box">
          <p></p>
        </div>
      </div>
    </div>
  </body>
</html>
```

### 各自的特点

第一种方式相对来说简单点，但是这样的实现不能够透出下边背景的内容，如果有需要透出背景中的文字就需要使用第二种方式。
