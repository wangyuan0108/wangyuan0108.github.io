---
title: 手写promise
categories: WEB前端
copyright: true
date: 2020-09-15 15:23:22
tags:
---

## 简介
promise是解决异步问题的大杀器，我们在使用的过程中有没有想过大概是怎么实现的呢？简单放上时间的源码供参考<!--more>

## 源码
```js
const STATUS = { PENDING: 'PENDING', FUFILLED: 'FUFILLED', REJECTED: 'REJECTED' }


// 我们的promise 按照规范来写 就可以和别人的promise公用
function resolvePromise(x, promise2, resolve, reject) {
    // If promise and x refer to the same object, reject promise with a TypeError as the reason.
    if (promise2 == x) { // 防止自己等待自己完成
        return reject(new TypeError('类型错了'))
    }
    // 看x 是普通值还是promise 如果是promise要采用他的状态
    if ((typeof x === 'object' && x !== null) || typeof x === 'function') {
        // x可以是一个对象 或者是函数
        let called;
        try {
            let then = x.then; // 就看一下这个对象是否有then方法
            if (typeof then == 'function') {
                // then是函数 我就认为这个x是一个promise
                // 如果x是promise 那么就采用他的状态
                then.call(x, function(y) { // 调用返回的promise 用他的结果 作为下一次then的结果
                    if (called) return
                    called = true;
                    // 递归解析成功后的值 直到他是一个普通值为止
                    resolvePromise(y, promise2, resolve, reject);
                }, function(r) {
                    if (called) return
                    called = true;
                    reject(r);
                })
            } else {
                resolve(x); // 此时x 就是一个普通对象
            }
        } catch (e) {
            if (called) return
            called = true;
            reject(e); // 取then时抛出错误了
        }
    } else {
        resolve(x); // x是一个原始数据类型 不能是promise
    }
    // 不是proimise 直接就调用resolve
}
class Promise {
    constructor(executor) {
        this.status = STATUS.PENDING;
        this.value = undefined;
        this.reason = undefined;
        this.onResolvedCallbacks = []; // 存放成功的回调的 
        this.onRejectedCallbacks = []; // 存放失败的回调的
        const resolve = (val) => {

            if(val instanceof Promise){ // 是promise 就继续递归解析
                return val.then(resolve,reject)
            }

            if (this.status == STATUS.PENDING) {
                this.status = STATUS.FUFILLED;
                this.value = val;
                // 发布
                this.onResolvedCallbacks.forEach(fn => fn());
            }
        }
        const reject = (reason) => {
            if (this.status == STATUS.PENDING) {
                this.status = STATUS.REJECTED;
                this.reason = reason;
                // 腹部
                this.onRejectedCallbacks.forEach(fn => fn());
            }
        }
        try {
            executor(resolve, reject);
        } catch (e) {
            // 出错走失败逻辑
            reject(e)
        }
    }
    then(onFulfilled, onRejected) { // swtich  作用域
        // 可选参数
        onFulfilled = typeof onFulfilled === 'function' ? onFulfilled : x => x
        onRejected = typeof onRejected === 'function'? onRejected: err=> {throw err}
        let promise2 = new Promise((resolve, reject) => {
            if (this.status === STATUS.FUFILLED) {
                // to....
                setTimeout(() => {
                    try {
                        let x = onFulfilled(this.value);
                        resolvePromise(x, promise2, resolve, reject)
                    } catch (e) {
                        reject(e);
                    }
                }, 0);
            }
            if (this.status === STATUS.REJECTED) {
                setTimeout(() => {
                    try {
                        let x = onRejected(this.reason);
                        resolvePromise(x, promise2, resolve, reject)
                    } catch (e) {
                        reject(e);
                    }
                }, 0);
            }
            if (this.status === STATUS.PENDING) {
                // 装饰模式 切片编程
                this.onResolvedCallbacks.push(() => { // todo..
                    setTimeout(() => {
                        try {
                            let x = onFulfilled(this.value);
                            resolvePromise(x, promise2, resolve, reject)
                        } catch (e) {
                            reject(e);
                        }
                    }, 0);
                })
                this.onRejectedCallbacks.push(() => { // todo..
                    setTimeout(() => {
                        try {
                            let x = onRejected(this.reason);
                            resolvePromise(x, promise2, resolve, reject)
                        } catch (e) {
                            reject(e);
                        }
                    }, 0);

                })
            }
        });
        return promise2;
    }
    catch(err){ // 默认没有成功 只有失败
        return this.then(null,err)
    }
    static resolve(val){
        return new Promise((resolve,reject)=>{
            resolve(val);
        }) 
    }
    static reject(reason){ // 失败的promise
        return new Promise((resolve,reject)=>{
            reject(reason);
        })
    }
}
// 测试时会调用此方法  Promise.finally  resolve reject catch all
Promise.defer = Promise.deferred = function () {
    let dfd = {};
    dfd.promise = new Promise((resolve,reject)=>{
        dfd.resolve = resolve;
        dfd.reject = reject
    })
    return dfd;
}

// npm install promises-aplus-tests -g
module.exports = Promise;
```
