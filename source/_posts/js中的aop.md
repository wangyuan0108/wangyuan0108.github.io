---
title: js中的aop
categories: WEB前端
copyright: true
date: 2021-03-10 10:15:50
tags:
---
## AOP介绍
简介
AOP （面向切面编程），缩写为Aspect Oriented Programming，意为：面向切面编程，通过预编译方式和运行期动态代理实现程序功能的统一维护的一种技术。AOP是OOP的延续，是软件开发中的一个热点，也是JAVA 中Spring框架的一个重要内容，是函数式编程的一种衍生范型。<!--more-->利用AOP可以对业务逻辑的各个部分进行隔离，从而使得业务逻辑各部分之间的耦合度降低，提高程序的可重用性，同时提高了开发的效率。

1. 主要功能
2. 日志记录
3. 性能统计
4. 安全控制
5. 事务处理
6. 异常处理

等等。

### 主要意图

将日志记录，性能统计，安全控制，事务处理，异常处理等代码从业务逻辑代码中划分出来，通过对这些行为的分离，我们希望可以将它们独立到非指导业务逻辑的方法中，进而改变这些行为的时候不影响业务逻辑的代码。

> 注：请慎重的在JS的中使用AOP！因为部分JS的方法是异步的。必要时使用ES7中的async/await/Promise，以保证代码的顺序执行。

## AOP在JS中的实现原理
js中aop的实现原理主要依靠Function的两个函数:apply和call。

### apply函数

- Function.apply(obj, args);

- apply方法能劫持另外一个对象的方法，继承另外一个对象的属性

- Function.apply(obj, args)方法能接收两个参数

- obj：这个对象将代替Function类里this对象

- args：这个是数组，它将作为参数传给Function（args–>arguments）

利用Function.apply()的参数数组化来提升程序的性能

示例：
```
function dosomething(a,b,c){
    console.log('do something.', a, b, c);
    // 预期结果：   do something. see say run
}

let something = ['see', 'say', 'run'];
dosomething.apply(this, something);
```
### call函数
- Function.call(obj, arg, arg, ...);

示例：

```
function dosomething(a,b,c){
    console.log('do something.', a, b, c);
    // 预期结果：   do something. see say run
}

dosomething.call(this, 'see', 'say', 'run');
```
推荐：使用apply函数。call函数和apply函数的效果是一样，但是call函数的参数不够灵活，在写法上参数无法灵活伸缩；apply函数，只需要把参数放到数组里即可。apply比call函数更适合在项目实际开发中使用，并且apply比call的性能要好。

## AOP在JS中的实现
从事过Java Web开发的童鞋，一定用过Spring框架。在Spring的框架中有before（前置通知）、after（后置通知）、around（环绕通知）。
今天我们在JS中实现的这三种通知。

1. before（前置通知）
before函数，用来实现函数的前置通知。在目标函数的前面执行一些前置操作。

```
// AOP 前置通知函数声明
/**
 * 给方法加入前置切片函数
 * 可以在执行方法之前执行一些操作,
 * 前置切片的返回值为false时，不影响原方法的执行
 * @param func {Function} 被前置执行的函数
 * @return {Function} 加入前置通知的函数
 */
Function.prototype._before = function(func){
    var __self = this;
    return function(){
        func.apply(__self, arguments);
        return __self.apply(__self, arguments);
    }
}

// 代码
function a(){
    console.log('I\'m a');
}

a = a._before(function(){
    console.log('before');
});

a();
// 结果：
// before
// I'm a
```
2. after（后置通知）
after函数，用来实现函数的后置通知。在目标函数的后面面执行一些后置操作。
```
// AOP 后置通知函数声明
/**
 * 给方法加入后置切片函数
 * 可以在执行方法之之后执行一些操作
 * 后置切片的返回值为false时，不影响原方法的执行
 * @param func {Function} 被后置执行的函数
 * @return {Function} 加入后置通知的函数
 * @constructor
 */
Function.prototype._after = function(func){
    var __self = this;
    return function(){
        var ret = __self.apply(__self, arguments);
        func.apply(__self, arguments);
        return ret;
    }
}

// 代码
function b(){
    console.log('I\'m b');
}

b = b._after(function(){
    console.log('after');
});

b();
// 结果：
// I'm b
// after
```
3. around（环绕通知）
在around函数中，引入了一个JoinPoint对象。JoinPoint对象封装了目标函数和目标函数的参数。在调用JoinPoint对象的invoke函数时，会去调用原来的目标函数。在调用invoke时，如果需要改变目标函数的this对象，需要将对象传入到invoke的参数中。around函数，可以在目标函数的前面和后面随意加入逻辑代码，也可以根据条件判断是否执行目标函数。
```
// AOP 环绕通知函数声明
/**
 * 切入点对象
 * 不允许切入对象多次调用
 * @param obj   对象
 * @param args  参数
 * @constructor
 */
function JoinPoint(obj, args){
    var isapply = false;                       // 判断是否执行过目标函数
    var result = null;                         // 保存目标函数的执行结果

    this.source = obj;                         // 目标函数对象
    this.args = args;                          // 目标函数对象传入的参数

    /**
     * 目标函数的代理执行函数
     * 如果被调用过，不能重复调用
     * @return {object} 目标函数的返回结果
     */
    this.invoke = function(thiz){              
        if(isapply){ return; }
        isapply = true;
        result = this.source.apply(thiz || this.source, this.args);
        return result;
    };

    // 获取目标函数执行结果
    this.getResult = function(){
        return result;
    }
}

/**
 * 方法环绕通知
 * 原方法的执行需在环绕通知方法中执行
 * @param func {Function} 环绕通知的函数
 *     程序会往func中传入一个JoinPoint(切入点)对象, 在适当的时机
 *     执行JoinPoint对象的invoke函数，调用目标函数
 * 
 * @return {Function} 切入环绕通知后的函数，
 */
Function.prototype._around = function(func){
    var __self = this;
    return function(){
        var args = [new JoinPoint(__self, arguments)];
        return func.apply(this, args);
    }
}

// 代码

var isAdmin = true;

function c(){
    console.log('show user list');
}

c = c._around(function(joinpoint){
    if(isAdmin){    // 满足条件时，执行目标函数
        console.log('is admin');
        joinpoint.invoke(this);
    }
});

c();
// 结果
// if isAdmin == true
//     is admin
//     show user list
// if isAdmin == false
//     
```
## AOP在JS中的应用
### AOP在数据库方面的应用
记录sql的执行记录(AOP的前置通知)
记录sql的执行时间(AOP的环绕通知)
sql执行完后自动释放连接(AOP的环绕通知)