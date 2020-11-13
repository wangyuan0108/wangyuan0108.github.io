---
title: css伪元素实现尾随三角形
categories: WEB前端
copyright: true
date: 2020-11-13 10:00:22
tags: css
---

## 简介

在写页面中，不可避免的会用css去实现一些小的图标。其中三角形最常用，比如在实现类似气泡的弹框效果。普通的用div实现三角形已经有[文章](https://wangyuanweb.top/2018/03/25/div-css画三角形的方法和原理/)写过，有兴趣的可以自行查看。这里我主要记录下我在开发过程中遇到的问题，需要写一个类似气泡的小箭头，就是一个尾随的三角形，这里我觉得用伪元素特别适合这个场景，我就简单记录下实现的方法。<!--more-->

## 概念

先说伪元素和伪类的区别：

> 伪类是针对CSS，而伪元素是针对HTML，伪类选择器是CSS选择器的一种，而伪类是“假”的HTML标签伪类（选择器）本质上是为了弥补常规CSS选择器的不足，以便获取到更多信息；伪元素本质上是创建了一个有内容的虚拟容器；在CSS3中，伪类和伪元素的语法得到了进一步的调整（一个冒号和两个冒号）；在开发当中，可以同时使用多个伪类，而只能同时使用一个伪元素；

## 实现实心三角形

用伪元素实现一个实心的三角形，其实和之前的div+css实现的方式差不多，只是把css的代码写到了伪元素中，话不多说，直接上代码

```css
#demo{
  margin-right: 20px;
  margin-top: 20px;
  width: 100px;
  height: 100px;
  border: 1px solid black;
  position: relative;
}

// 右边三角
#demo:before {
  content: "";
  width: 0;
  height: 0;
  position: absolute;
  top: 34px;
  left: 100px;
  border-top: solid 15px transparent;
  border-left: solid 15px black;
  border-bottom: solid 15px transparent;
}

// 上边三角
#demo:before {
  content: "";
  width: 0;
  height: 0;
  position: absolute;
  top: -15px;
  left: 50%;
  transform: translateX(-50%);
  border-right: solid 15px transparent;
  border-left: solid 15px transparent;
  border-bottom: solid 15px black;
}
// 下边三角
#demo:before {
  content: "";
  width: 0;
  height: 0;
  position: absolute;
  top: 100%;
  left: 50%;
  transform: translateX(-50%);
  border-top: solid 15px black;
  border-right: solid 15px transparent;
  border-left: solid 15px transparent;
}
// 左边三角
#demo:before {
  content: "";
  width: 0;
  height: 0;
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  left: -15px;
  border-top: solid 15px transparent;
  border-right: solid 15px black;
  border-bottom: solid 15px transparent;
}
// 直角三角
#demo:before {
  content: "";
  width: 0;
  height: 0;
  position: absolute;
  top: 34px;
  left: 100px;
  border-right: solid 15px transparent;
  border-bottom: solid 15px black;
}
```

![image-20201113142259204](https://gitee.com/wangyuan0108/image/raw/master/image-20201113142259204.png)

## 实现实心三角形简写方式

```vue


<div class="water_top"></div>         <!--三角形在上边-->
<div class="water_right"></div>       <!--三角形在右边-->
<div class="water_bottom"></div>      <!--三角形在底边-->
<div class="water_left"></div>        <!--三角形在左边-->

.water_top,
.water_right,
.water_bottom,
.water_left {
  width: 150px;
  height: 100px;
  background: #cccccc;
  border-radius: 8px;
  margin: 50px;
  position: relative;
}
/*上三角*/
.water_top:before {
  content: "";
  border: 10px solid transparent;
  border-bottom-color: red;
  position: absolute;
  top: -20px;
  left: 65px;
}
/*右三角*/
.water_right:before {
  content: "";
  border: 10px solid transparent;
  border-left-color: yellow;
  position: absolute;
  top: 40px;
  left: 150px;
}
/*下三角*/
.water_bottom:before {
  content: "";
  border: 10px solid transparent;
  border-top-color: blue;
  position: absolute;
  top: 100px;
  left: 70px;
}
/*左三角*/
.water_left:before {
  content: "";
  border: 10px solid transparent;
  border-right-color: green;
  position: absolute;
  top: 40px;
  left: -20px;
}

```

![image-20201113143330128](https://gitee.com/wangyuan0108/image/raw/master/image-20201113143330128.png)

## 实现空心三角形

这里的实现空心三角形思路是用两个三角形重叠，达到空心的视觉效果。通过前后两个伪元素实现，单个的三角形实现上以上实心三角方法一致，只是这两个三角形大小不一样，达到了空心有边框，上demo代码

```
.water_top, .water_right, .water_bottom, .water_left{
                width: 150px;
                height: 100px;
                border: 1px solid #000000;
                border-radius: 8px;
                margin: 50px 50px;
                position: relative;
                float: left;
            }
            .water_top:before{
                content: "";
                width: 0px;
                height: 0px;
                border-left: 15px solid transparent;
                border-right: 15px solid transparent;
                border-bottom: 15px solid #000000;
                position: absolute;
                top: -15px;
                left: 65px;
            }
            .water_top:after{
                content: "";
                width: 0px;
                height: 0px;
                border-left: 14px solid transparent;
                border-right: 14px solid transparent;
                border-bottom: 14px solid #FFFFFF;
                position: absolute;
                top: -14px;
                left: 66px;
            }
            .water_right:before{
                content: "";
                width: 0px;
                height: 0px;
                border-top: 15px solid transparent;
                border-bottom: 15px solid transparent;
                border-left: 15px solid #000000;
                position: absolute;
                top: 39px;
                left: 150px;
            }
            .water_right:after{
                content: "";
                width: 0px;
                height: 0px;
                border-top: 14px solid transparent;
                border-bottom: 14px solid transparent;
                border-left: 14px solid #FFFFFF;
                position: absolute;
                top: 40px;
                left: 149px;
            }
            .water_bottom:before{
                content: "";
                width: 0px;
                height: 0px;
                border-top: 15px solid #000000;
                border-left: 15px solid transparent;
                border-right: 15px solid transparent;
                position: absolute;
                top: 101px;
                left: 69px;
            }
            .water_bottom:after{
                content: "";
                width: 0px;
                height: 0px;
                border-top: 14px solid #FFFFFF;
                border-left: 14px solid transparent;
                border-right: 14px solid transparent;
                position: absolute;
                top: 100px;
                left: 70px;
            }
            .water_left:before{
                content: "";
                width: 0px;
                height: 0px;
                border-top: 15px solid transparent;
                border-bottom: 15px solid transparent;
                border-right: 15px solid #000000;
                position: absolute;
                top: 40px;
                left: -15px;
            }
            .water_left:after{
                content: "";
                width: 0px;
                height: 0px;
                border-top: 14px solid transparent;
                border-bottom: 14px solid transparent;
                border-right: 14px solid #FFFFFF;
                position: absolute;
                top: 41px;
                left: -14px;
            }
            
            <div class="water_top"></div>         <!--三角形在上边-->
        	<div class="water"></div>              <!--三角形在右边-->
        	<div class="water_bottom"></div>      <!--三角形在底边-->
        	<div class="water_left"></div>        <!--三角形在左边-->
```

![image-20201113144207110](https://gitee.com/wangyuan0108/image/raw/master/image-20201113144207110.png)

## 小结

通过以上的对比。相信大家也能看出其中的原理。总结出了一个道理：**三角形往哪个方向，那个方向无需设置border，而相反方向设置border颜色，相邻两边的border设为透明。**这样就可实现各个方向的三角形。实心三角形利用CSS中的伪元素（:before）实现，再利用border的transparent属性即可达到效果。而空心三角形是在空心三角形的基础上再加上伪元素（:after）实现。伪元素（:before）实现的是一个实心的三角形，伪元素（:after）实现的是空心的三角形，进而把实心的三角形覆盖，利用绝对定位的top与left的差值绝对了三角形线的粗细而达到如图的效果。