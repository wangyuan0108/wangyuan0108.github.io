---
title: javaScript实现栈数据结构
categories: WEB前端
copyright: true
date: 2020-05-08 14:01:51
tags:
  - 数据结构
  - 算法
---

### 前言

对于编程基础，算法和数据结构是必不可少的知识，这里简单用 javaScript 语言来实现基本的数据结构。<!--more-->

### 用 javaScript 中的线性表数组来模拟实现

#### 使用函数的方式

```js
function Stack() {
  var stack = []
  this.push = element => stack.push(element)
  this.pop = () => stack.pop()
  this.length = () => stack.length
  this.top = () => {
    if (stack.length) {
      return stack[stack.length - 1]
    }
    return 'stack empty'
  }
  this.clear = () => {
    stack.length = 0
    return true
  }
  this.toString = () => {
    if (stack.length) {
      stack.reverse()
      return stack.join(' ')
    }
    return 'stack empty'
  }
}
```

#### 使用 class 类的方式

```js
class Stack {
  constructor() {
    this.items = []
  }
  push(element) {
    this.items.push(element)
  }
  pop() {
    return this.items.pop()
  }
  peek() {
    return this.items[this.items.length - 1]
  }
  isEmpty() {
    return !this.items.length
  }
  size() {
    return this.items.length
  }
  clear() {
    this.items = []
  }
  print() {
    console.log(this.items.toString())
  }
}
```

### 使用链表来模拟实现

```js
function LinkedStack() {
  var top
  var length = 0
  function Node(element) {
    this.element = element
    this.next = null
  }
  this.push = function (element) {
    var node = new Node(element)
    if (top) {
      node.next = top
      top = node
      length++
      return true
    } else {
      top = node
      length++
      return true
    }
  }
  this.pop = function () {
    if (top) {
      var current
      current = top
      top = top.next
      current.next = null
      length--
      return current
    } else {
      return 'stack empty'
    }
  }
  this.top = function () {
    return top
  }
  this.length = function () {
    return length
  }
  this.toString = function () {
    var string = ''
    var current = top
    while (current) {
      string += current.element
      current = current.next
    }
    return string
  }
  this.clear = function () {
    top = null
    length = 0
    return true
  }
}
```