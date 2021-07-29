---
title: 你需要知道的在小程序中使用cookie
categories: WEB前端
copyright: true
date: 2021-07-29 23:19:50
tags: 小程序
---
## 前言

最近由于项目需要，需要开发一个h5。然后这h5是内嵌到小程序中使用的，在小程序中的web-view使用h5也是遇到了一些问题，主要是cookie的共享问题，还有一些奇怪的现象，这里简单记录下，方便遇到同样问题的有个参考

小程序中的cookie是无法带到接口上的

由于受到web开发的思路影响，觉得只要设置了cookie，那么在请求的时候就会自动带上cookie。在写小程序的cookie鉴权的时候，当时也是这样想的，但是事实是虽然是可以写入cookie，不过在请求接口的时候并不会自动带上cookie。果然还是太年轻了。

## 小程序请求如何带上cookie

因为请求不能够自动带上cookie，那就没得办法只能手动把cookie存下来然后在写入到请求头中，让每个请求都带上cookie

这样小程序的每次接口请求就都带上了cookie和web端的请求自动带cookie就功能相同了

## web-view中的h5如何使用cookie达到同步鉴权

按照正常思路，最好的方式就是h5中能够直接获取到小程序中的cookie。这样就简单了，但是小程序是不会让你如愿的。事实证明你在h5是无法拿到cookie。因为它们是两个独立的域，可以理解为小程序调用的是原生的能力，来发请求的，而且小程序的运行机制和web也不一样，web-view中的h5拿不到cookie倒是也能理解。然而小程序中的web-view和微信中直接打开的h5，因为用的是同一个浏览器内核，所以，它们的cookie、storage是可以共享的。

但是这个cookie是无论如何又需要共享的，所以还是要来解决这个问题。那没有办法，那就在跳转到web-view中页面的时候把小程序中的cookie作为url的参数传递过去，然后在h5中把cookie拿到，然后存储到cookie中。自此cookie共享就完成了。

```
document.cookie = `cookie=${history.location.query.cookie}`;
```

这样就把cookie共享搞定了。

## 使用js-cookie库设置的cookie在web-view中不生效

有简单的设置cookie的包，那就拿来用一下喽。

```
yarn add js-cookie
​
import cookies from 'js-cookie'
​
cookies.set('key',value)
```

这样cookie就设置成功了，h5在浏览器中使用也是生效的。但是当把h5接入到web-view中就出现问题了。看了下js-cookie的源码实现，发现也就多了加解码的过程保证字符串不改变，按道理是没有什么问题的。所以这里还是使用了原生的方式来写cookie，用这个库的老铁遇到这个问题可以先用原生的方法代替，具体为什么有知道的大佬告诉我一下，我也在找找是什么原因

## 小结

大概记录下小程序和web-view共享cookie遇到的问题和解决方法，对自己是个记录，希望对你有所帮助，欢迎点赞！！！谢谢！！
