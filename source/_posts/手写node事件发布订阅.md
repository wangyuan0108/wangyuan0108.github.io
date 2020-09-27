<!--
 * @Author: wangyuan
 * @Date: 2020-09-27 15:16:08
 * @LastEditTime: 2020-09-27 15:18:48
 * @LastEditors: wangyuan
 * @Description: 
-->
---
title: 手写node事件发布订阅
categories: WEB前端
copyright: true
date: 2020-09-27 15:16:08
tags:
---
## 简介
node中的事件是必然要用到的，这也就让了解node事件机制变得很有必要，了解下原来总是好的。简单贴下代码，方便查阅学习。<!--more-->

## 源码
```js
function EventEmitter(){
    this._events = {}
}
// 订阅
EventEmitter.prototype.on = function (eventName,callback) {
    if(!this._events){
        this._events = Object.create(null);
    }
    //  当前绑定的事件 不是newListener事件就触发newListener事件
    if(eventName !== 'newListener'){
        this.emit('newListener',eventName)
    }
    if(this._events[eventName]){
        this._events[eventName].push(callback)
    }else{
        this._events[eventName] = [callback]
    }
}
// 发布
EventEmitter.prototype.emit = function (eventName,...args) {
    if(!this._events) return
    if(this._events[eventName]){
        this._events[eventName].forEach(fn=>fn(...args))
    }
}
// 绑定一次
EventEmitter.prototype.once = function (eventName,callback) {
    const once = (...args) =>{
        callback(...args);  
        // 当绑定后将自己移除掉
        this.off(eventName,once);
    }
    once.l = callback; // 用来标识这个once是谁的
    this.on(eventName,once)
}
// 删除
EventEmitter.prototype.off = function (eventName,callback) {
    if(!this._events) return
    this._events[eventName] = this._events[eventName].filter(fn=>((fn !== callback) && (fn.l!=callback)))
}
module.exports = EventEmitter 


```