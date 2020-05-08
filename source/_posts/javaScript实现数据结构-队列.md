---
title: javaScript实现数据结构--队列
categories: WEB前端
copyright: true
date: 2020-05-08 15:18:46
tags:
  - 数据结构
  - 算法
---

### 前言

学习数据结构和算法的笔记，方便下次复习巩固<!--more-->

### js 实现队列

#### 链表实现队列

```js
function LinkedQueue() {
  let Node = function (ele) {
    this.ele = ele
    this.next = null
  }

  let length = 0,
    front, //队首指针
    rear //队尾指针
  this.push = function (ele) {
    let node = new Node(ele),
      temp

    if (length == 0) {
      front = node
    } else {
      temp = rear
      temp.next = node
    }
    rear = node
    length++
    return true
  }

  this.pop = function () {
    let temp = front
    front = front.next
    length--
    temp.next = null
    return temp
  }

  this.size = function () {
    return length
  }
  this.getFront = function () {
    return front
    // 有没有什么思路只获取队列的头结点,而不是获取整个队列
  }
  this.getRear = function () {
    return rear
  }
  this.toString = function () {
    let string = '',
      temp = front
    while (temp) {
      string += temp.ele + ' '
      temp = temp.next
    }
    return string
  }
  this.clear = function () {
    front = null
    rear = null
    length = 0
    return true
  }
}

let myQueue = new LinkedQueue()

myQueue.push(1)
myQueue.push(2)
myQueue.push(3)
myQueue.push(4)
console.log(myQueue.toString()) // 1 2 3 4
console.log(myQueue.pop()) // Node { ele: 1, next: null }
console.log(myQueue.toString()) // 2 3 4
```

#### js 线性表内置数据实现

```js
function ArrayQueue() {
  var arr = []
  //入队操作
  this.push = function (element) {
    arr.push(element)
    return true
  }
  //出队操作
  this.pop = function () {
    return arr.shift()
  }
  //获取队首
  this.getFront = function () {
    return arr[0]
  }
  //获取队尾
  this.getRear = function () {
    return arr[arr.length - 1]
  }
  //清空队列
  this.clear = function () {
    arr = []
  }
  //获取队长
  this.size = function () {
    return length
  }
}
```
