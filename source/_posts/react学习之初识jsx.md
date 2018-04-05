---
title: react学习之初识jsx
categories: WEB前端
copyright: true
date: 2018-04-05 15:19:42
tags: react
---
## 简介

`jsx`是用在`React`中的一种虚拟`dom`的一种方式。`React`有一个核心机制就是虚拟`dom`，就是对虚拟`dom`的操作，减少了对实际`dom`的操作，大大提高了性能。`jsx`就是`javascript`和`xml`结合的一种格式，<!--more-->`React`发明了`jsx`，利用`html`语法来创建虚拟`dom`。当遇到`<`的时候，`jsx`就当做`html`来解析。当遇到`{`的时候，就当`javascript`解析。
例如：
```
const List = (
    <ul className="list">
        <li>first</li>
        <li>second</li>
    </ul>
)
```
如上面的代码需要注意一点，由于`class`是`javascript`中的关键字，所以需要用`className`来代替，而`for`用`htmlFor`代替。其实`jsx`在执行的过程中是经过翻译器翻译的，翻译成了原生的`javascript`代码来执行。

## 基本语法

* `jsx`中的大括号中放的是`javascript`代码，所以也可以放表达式，例如：

```
{a?1:0}
```

* 而且在`jsx`中，可以循环一个数组来返回列表数据。

* `jsx`中绑定事件，可以直接绑定到元素上。

```
<button onClick={this.submit.bind(this)}>submit</button>
```
在这里需要注意两点：
   1. `onClick`的`c`必须大写，因为这里是当做`javascript`来解析的，大小写要区分。
   2. `this`的指向需要手动绑定。

* 使用内联样式的时候，传入的属性值不能是字符串了，必须是对象。

```
<div style={{color:"#fff"}}>jsx</div>
```
这里需要主意的就是，并不是双大括号，而是在传入属性的时候里面的大括号是表示的是对象。

* 在组件内部添加`html`代码的时候，并将`html`代码渲染到页面上，`React`会默认转义，如果不想转义可以这样写：

```
var wy = '<h1>wy</h1>'
React.render(
    <div dangerouslySetInnerHTML={{__html:wy}}></div>,document.body
)
```

#小结

在刚接触`jsx`的时候，看着这种混合在一起的写法会很不适应，不过写的多了，看的多了慢慢也就习惯了。特别和vue不同，在vue中双引号之中也可能是`javascript`代码，而`jsx`中是大括号，这点要区分开。



