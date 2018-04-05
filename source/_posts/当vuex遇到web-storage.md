---
title: 当vuex遇到web storage
categories: WEB前端
copyright: true
date: 2017-11-07 20:46:50
tags: vue
- 数据管理
- 本地存储
---
## 遇到的业务需求

在写一个vue后台项目的时候，遇到了登录权限的管理。这时，后台给我的权限数据我获取之后，需要保存下来以备后来使用。然后我想到了vue的数据状态管理vuex和html5的本地存储功能。
<!--more-->
## 确定使用方案

在这个项目中，我考虑着权限获取之后要保存在本地，然后页面刷新又不用再次取数据。我决定是用web storage存储。大家知道vuex在页面刷新的时候数据是清空的。

## 介绍web storage

这个api的作用就是使得网页可以在浏览器端储存数据，它分成两类：sessionStorage和localStorage。sessionStorage保存的数据用于浏览器的一次会话，当会话结束（通常是该窗口关闭），数据被清空；localStorage保存的数据长期存在，下一次访问该网站的时候，网页可以直接读取以前保存的数据。除了保存期限的长短不同，这两个对象的属性和方法完全一样。

## 使用方法

* 存储数据

sessionStorage和localStorage保存的数据，都以“键值对”的形式存在。也就是说，每一项数据都有一个键名和对应的值。所有的数据都是以文本格式保存。存入数据使用setItem方法。它接受两个参数，第一个是键名，第二个是保存的数据。

~~~
sessionStorage.setItem("key","value");
localStorage.setItem("key","value");
~~~

* 读取数据

读取数据使用getItem方法。它只有一个参数，就是键名。

~~~
var valueSession = sessionStorage.getItem("key");
var valueLocal = localStorage.getItem("key");
~~~

* 清除数据

removeItem方法用于清除某个键名对应的数据。

~~~
sessionStorage.removeItem('key');
localStorage.removeItem('key');
~~~

clear方法用于清除所有保存的数据。

~~~
sessionStorage.clear();
localStorage.clear(); 
~~~
## 遇到的问题

虽然，这样也解决了数据存储问题，但是却遇到了另外几个问题：

1. 像用户权限这样重要的数据暴露出去是非常不安全的。
2. 权限数据是在登录完成时获取的，那样如果后台数据变化，刷新浏览器不会更新数据。
3. 用户自己改变了权限，也必须先退出再登录，才能更新。
4. 数据清空的等到浏览器关闭

## 解决方法

基于以上问题，最后改用了vuex，通过它来进行权限数据的存储。在路由开始之前调用钩子函数，来更新vuex中的数据。

~~~
router.beforeEach((to, from, next) => {
    api.sysenums.sysEnums()(res => {
        store.dispatch('getInitEmus', res);
    });
});
~~~
知识有限，忘指教。
