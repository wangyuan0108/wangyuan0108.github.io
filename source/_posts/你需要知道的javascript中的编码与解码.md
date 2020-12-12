---
title: 你需要知道的javascript中的编码与解码
categories: WEB前端
copyright: true
date: 2020-06-18 15:09:56
tags:
  - javaScript
  - 全局方法
---

## 背景

在 web 开发中，我们经常会和我网站 url 打交道。当我们跳转到一个其他网站的时候，也是通过 url 来进行跳转的。有时我们需要对 url 进行处理，例如拼接参数等。在一次开发中，我直接拿后台返回的 url 进行拼接参数，然后居然出错了。最后查到是因为 url 经过了转译编码，然后前端没有显示的进行解码操作，所以 url 地址是不正确的，由此用到了编码和解码，记录下自己踩过的坑。<!--more-->

## 编码：encodeURIComponent()和解码：decodeURIComponent()

1. encodeURIComponent()
   encodeURIComponent() 函数可把字符串作为 URI 组件进行编码。
   该方法不会对 ASCII 字母和数字进行编码，也不会对这些 ASCII 标点符号进行编码： - \_ . ! ~ \* ' ( ) 。
   其他字符（比如 ：;/?:@&=+\$,# 这些用于分隔 URI 组件的标点符号），都是由一个或多个十六进制的转义序列替换的。
   简单点就是能转的都给转了，例子如下：

```js
var uri = 'http://www.baidu.com?name=Tom&age=12&city=杭州'

console.log(encodeURIComponent(uri))
//输出 'http%3A%2F%2Fwww.baidu.com%3Fname%3DTom%26age%3D12%26city%3D%E6%9D%AD%E5%B7%9E'
```

2. decodeURIComponent()是对 encodeURIComponent()编码的解码操作，把转译成正常的 url 链接

```js
var urlCode = 'http%3A%2F%2Fwww.baidu.com%3Fname%3DTom%26age%3D12%26city%3D%E6%9D%AD%E5%B7%9E'
console.log(decodeURIComponent(urlCode))

//输出 'http://www.baidu.com?name=Tom&age=12&city=杭州'
```

## 编码：encodeURI()和解码：decodeURI()

1. encodeURI()
   encodeURI() 函数可把字符串作为 URI 进行编码。
   对以下在 URI 中具有特殊含义的 ASCII 标点符号，encodeURI() 函数是不会进行转义的： , / ? : @ & = + \$ # (可以使用 encodeURIComponent() 方法分别对特殊含义的 ASCII 标点符号进行编码。).

简单点就是对 url 进行部分转译，例子如下：

```js
var url = 'http://www.baidu.com?name=Tom&age=12&city=杭州'
console.log(encodeURI(url))
//输出 'http://www.baidu.com?name=Tom&age=12&city=%E6%9D%AD%E5%B7%9E'
```

2. decodeURI 是 encodeURI 编码的 URI 进行解码

```js
var urlCode = 'http://www.baidu.com?name=Tom&age=12&city=%E6%9D%AD%E5%B7%9E'
console.log(encodeURI(urlCode))
//输出 'http://www.baidu.com?name=Tom&age=12&city=杭州'
```

## 编码：escape()和解码：unescape()

1. escape() 函数可对字符串进行编码，这样就可以在所有的计算机上读取该字符串。该方法不会对 ASCII 字母和数字进行编码，也不会对下面这些 ASCII 标点符号进行编码： * @ - _ + . / 。其他所有的字符都会被转义序列替换。

   ```javascript
   var str = "http://www.baidu.com?name=Tom&age=12&city=杭州"
   console.log(escape(str))
   //输出 'http%3A//www.baidu.com%3Fname%3DTom%26age%3D12%26city%3D%u676D%u5DDE'
   
   var str = "爱我中华"
   console.log(escape(str))
   //输出 '%u7231%u6211%u4E2D%u534E'
   ```

2. unescape()函数是对escape()编码的进行解码（备注：ECMAScript v3 已从标准中删除了 unescape() 函数，并反对使用它，因此应该用 decodeURI() 和 decodeURIComponent() 取而代之）

```javascript
var str = "http%3A//www.baidu.com%3Fname%3DTom%26age%3D12%26city%3D%u676D%u5DDE"
console.log(unescape(str))
//输出 'http://www.baidu.com?name=Tom&age=12&city=杭州'
var str = "%u7231%u6211%u4E2D%u534E"
console.log(unescape(str))
//输出 '爱我中华'
```

## 小结

如果是对url整个进行编码解码就使用：encodeURIComponent()、decodeURIComponent()

如果是对url的参数进行编码解码就使用：encodeURI()、decodeURI()

如果是对字符串进行编码解码就使用：unescape()函数是对escape()，unescape()已被废弃请使用最新api