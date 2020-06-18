---
title: encodeURIComponent()和encodeURI()编码和解码的区别
categories: WEB前端
copyright: true
date: 2020-06-18 15:09:56
tags:
  - javaScript
  - 全局方法
---

### 背景

在 web 开发中，我们经常会和我网站 url 打交道。当我们跳转到一个其他网站的时候，也是通过 url 来进行跳转的。有时我们需要对 url 进行处理，例如拼接参数等。在一次开发中，我直接拿后台返回的 url 进行拼接参数，然后居然出错了。最后查到是因为 url 经过了转译编码，然后前端没有显示的进行解码操作，所以 url 地址是不正确的，由此用到了编码和解码，记录下自己踩过的坑。<!--more-->

### 编码：encodeURIComponent()和解码：decodeURIComponent()

1. encodeURIComponent()
   encodeURIComponent() 函数可把字符串作为 URI 组件进行编码。
   该方法不会对 ASCII 字母和数字进行编码，也不会对这些 ASCII 标点符号进行编码： - \_ . ! ~ \* ' ( ) 。
   其他字符（比如 ：;/?:@&=+\$,# 这些用于分隔 URI 组件的标点符号），都是由一个或多个十六进制的转义序列替换的。
   简单点就是能转的都给转了，例子如下：

```js
var uri = 'http://w3cschool.cc/my test.php?name=ståle&car=saab'

console.log(encodeURIComponent(uri))
//输出 http%3A%2F%2Fw3cschool.cc%2Fmy%20test.php%3Fname%3Dst%C3%A5le%26car%3Dsaab
```

2. decodeURIComponent()是对 encodeURIComponent()编码的解码操作，把转译成正常的 url 链接

```js
var urlCode = 'http%3A%2F%2Fw3cschool.cc%2Fmy%20test.php%3Fname%3Dst%C3%A5le%26car%3Dsaab'
console.log(decodeURIComponent(urlCode))

//输出 http://w3cschool.cc/my test.php?name=ståle&car=saab
```

### 编码：encodeURI()和解码：decodeURI()

1. encodeURI()
   encodeURI() 函数可把字符串作为 URI 进行编码。
   对以下在 URI 中具有特殊含义的 ASCII 标点符号，encodeURI() 函数是不会进行转义的： , / ? : @ & = + \$ # (可以使用 encodeURIComponent() 方法分别对特殊含义的 ASCII 标点符号进行编码。).

简单点就是对 url 进行部分转译，例子如下：

```js
var url = 'http://www.baidu.com?name=Tom&age=12&city=杭州'
console.log(encodeURI(url))
// http://www.baidu.com?name=Tom&age=12&city=%E6%9D%AD%E5%B7%9E
```

2. decodeURI 是 encodeURI 编码的 URI 进行解码

```js
var urlCode = 'http://www.baidu.com?name=Tom&age=12&city=%E6%9D%AD%E5%B7%9E'
console.log(encodeURI(urlCode))
// http://www.baidu.com?name=Tom&age=12&city=杭州
```
