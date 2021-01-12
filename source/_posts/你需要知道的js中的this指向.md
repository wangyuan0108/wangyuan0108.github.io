---
title: 你需要知道的js中的this指向
categories: WEB前端
copyright: true
date: 2021-01-12 10:30:44
tags:
---

## 简介

对于前端从业者来说，this的指向一直是绕不开的话题。也是对js基础掌握的好不好的一个体现。这里就this的一些指向做一个简单的整理，一方面方便不太清楚的同学查阅，另一方面也是让自己掌握的更加清楚。希望大家都对this有一个清楚的认识。<!--more-->

## this指向的规则

函数的this是在调用的时候绑定的，也就是说this的指向完全取决于函数的调用。为了搞清楚this的指向，必须知道函数是如何调用的。不同的调用方式执行上下文不同，理解的关键就是上下文的确定。而箭头函数没有自己的this，确定this的方式是看定义箭头函数的地方。

## 全局上下文

非严格模式和严格模式中this都是指向顶层对象（浏览器中是window，node中是global）。

```js
this === window // true
'use strict'
this === window;
this.name = 'water';
console.log(this.name); // water
```

## 函数上下文

**普通函数调用模式**

```js
// 非严格模式
var name = 'window';
var func = function(){
    console.log(this.name);
}
func(); // 'window'
```

你可能会误以为window.func()是调用的，所以是指向window。虽然本例中window.func确实等于func。name等于window.name。上面代码中这是因为在ES5中，全局变量是挂载在顶层对象（浏览器是window）中。
事实上，并不是如此。

```js
// 非严格模式
let name = 'window';
let func = function(){
    console.log(this === window);
    console.log(this.name);
}
func() // true, undefined
```

这个例子中let没有给顶层对象中（浏览器是window）添加属性，window.name和window.func都是undefined。
严格模式中，普通函数中的this则表现不同，表现为undefined。

```js
// 严格模式
'use strict'
var name = 'window';
var func = function(){
    console.log(typeof this === 'undefined');
    console.log(this.name);
}
func(); // true，// 报错，因为this是undefined
```

一些书上将这种叫做默认绑定。
对call，apply熟悉的会类比为：

```js
func.call(undefined);
func.apply(undefined);
```

效果是一样的，call，apply作用之一就是用来修改函数中的this指向为第一个参数的。
第一个参数是undefined或者null，非严格模式下，是指向window。严格模式下，就是指向第一个参数。后文详细解释。
经常有这类代码（回调函数），其实也是普通函数调用模式。

```js
var name = 'water';
setTimeout(function(){
    console.log(this.name);
}, 0);
// 语法
setTimeout(fn | code, 0, arg1, arg2, ...)
// 也可以是一串代码。也可以传递其他函数
// 类比 setTimeout函数内部调用fn或者执行代码`code`。
fn.call(undefined, arg1, arg2, ...);
```

**对象中的函数（方法）调用模式**

```js
var name = 'window';
var func = function(){
    console.log(this.name);
}
var student = {
    name: 'water',
    func: func,
    other: {
        name: 'other',
        func: func,
    }
}
student.func(); // 'water'
student.other.func(); // 'other'
// 用call类比则为：
student.doSth.call(student);
// 用call类比则为：
student.other.doSth.call(student.other);
```

但往往会有以下场景，把对象中的函数赋值成一个变量了。
这样其实又变成普通函数了，所以使用普通函数的规则（默认绑定）。

```js
var studentFunc = student.func;
studentFunc(); // 'window'
// 用call类比则为：
studentFunc.call(undefined);
```

**call、apply、bind 调用模式**
上文提到call、apply，这里详细解读一下。先通过MDN认识下call和apply
MDN 文档：`Function.prototype.call()`
语法

```js
fun.call(thisArg, arg1, arg2, ...)
```

**thisArg**
在fun函数运行时指定的this值。需要注意的是，指定的this值并不一定是该函数执行时真正的this值，如果这个函数处于非严格模式下，则指定为null和undefined的this值会自动指向全局对象(浏览器中就是window对象)，同时值为原始值(数字，字符串，布尔值)的this会指向该原始值的自动包装对象。
**arg1, arg2, ...**
指定的参数列表
**返回值**
返回值是你调用的方法的返回值，若该方法没有返回值，则返回undefined。
apply和call类似。只是参数不一样。它的参数是数组（或者类数组）。
根据参数thisArg的描述，可以知道，call就是改变函数中的this指向为thisArg，并且执行这个函数，这也就使JS灵活很多。严格模式下，thisArg是原始值是值类型，也就是原始值。不会被包装成对象。举个例子：

```js
var func = function(name){
    console.log(this);
    console.log(name);
}
func.call(2, 'water'); // Number{2}, 'water'
var me = function(name){
    'use strict';
    console.log(this);
    console.log(name);
}
me.call(2, 'water'); // 2, 'water'
```

虽然一般不会把thisArg参数写成值类型。但还是需要知道这个知识。
模拟实现JS的call和apply方法
就是利用对象上的函数this指向这个对象，来模拟实现call和apply的。bind和call和apply类似，第一个参数也是修改this指向，只不过返回值是新函数，新函数也能当做构造函数（new）调用。
`MDN Function.prototype.bind`

> bind()方法创建一个新的函数， 当这个新函数被调用时this键值为其提供的值，其参数列表前几项值为创建时指定的参数序列。

**语法**：

`fun.bind(thisArg[, arg1[, arg2[, ...]]])`

**参数**：

`thisArg`
调用绑定函数时作为this参数传递给目标函数的值。 如果使用new运算符构造绑定函数，则忽略该值。当使用bind在setTimeout中创建一个函数（作为回调提供）时，作为thisArg传递的任何原始值都将转换为object。如果没有提供绑定的参数，则执行作用域的this被视为新函数的thisArg。
`arg1, arg2, ...`
当绑定函数被调用时，这些参数将置于实参之前传递给被绑定的方法。

**返回值**

返回由指定的this值和初始化参数改造的原函数拷贝。
利用call和apply指向这个thisArg参数，来模拟实现bind的。

**构造函数调用模式**

```js
function Student(name){
    this.name = name;
    console.log(this); // {name: '若川'}
    // 相当于返回了
    // return this;
}
var result = new Student('若川');
```

使用new操作符调用函数，会自动执行以下步骤。

>1. 创建了一个全新的对象。
>2. 这个对象会被执行[[Prototype]]（也就是__proto__）链接。
>3. 生成的新对象会绑定到函数调用的this。
>4. 通过new创建的每个对象将最终被[[Prototype]]链接到这个函数的prototype对象上。
>5. 如果函数没有返回对象类型Object(包含Functoin, Array, Date, RegExg, Error)，那么new表达式中的函数调用会自动返回这个新的对象。

由此可以知道：new操作符调用时，this指向生成的新对象。
**特别提醒一下，new调用时的返回值，如果没有显式返回对象或者函数，才是返回生成的新对象。**

```js
function Student(name){
    this.name = name;
    // return function f(){};
    // return {};
}
var result = new Student('water');
console.log(result); {name: 'water'}
// 如果返回函数f，则result是函数f，如果是对象{}，则result是对象{}
```

很多人或者文章都忽略了这一点，直接简单用typeof判断对象。虽然实际使用时不会显示返回，但面试官会问到。

**原型链中的调用模式**

```js
function Student(name){
    this.name = name;
}
var s1 = new Student('water');
Student.prototype.func = function(){
    console.log(this.name);
}
s1.func(); // 'water'
```

会发现这个似曾相识。这就是对象上的方法调用模式。自然是指向生成的新对象。
如果该对象继承自其它对象。同样会通过原型链查找。
上面代码使用
ES6中class写法则是：

```js
class Student{
    constructor(name){
        this.name = name;
    }
    func(){
        console.log(this.name);
    }
}
let s1 = new Student('water');
s1.func();
```

**箭头函数调用模式**
先看箭头函数和普通函数的重要区别：

> 1. 没有自己的this、super、arguments和new.target绑定。
> 2. 不能使用new来调用。
> 3. 没有原型对象。
> 4. 不可以改变this的绑定。
> 5. 形参名称不能重复。
> 6. 箭头函数中没有this绑定，必须通过查找作用域链来决定其值。

如果箭头函数被非箭头函数包含，则this绑定的是最近一层非箭头函数的this，否则this的值则被设置为全局对象。
比如:

```js
var name = 'window';
var student = {
    name: 'water',
    func: function(){
        // var self = this;
        var arrowFunc = () => {
            // console.log(self.name);
            console.log(this.name);
        }
        arrowFunc();
    },
    arrowFunc2: () => {
        console.log(this.name);
    }
}
student.func(); // 'water'
student.arrowFunc2(); // 'window'
```

其实就是相当于箭头函数外的this是缓存的该箭头函数上层的普通函数的this。如果没有普通函数，则是全局对象（浏览器中则是window）。
也就是说无法通过call、apply、bind绑定箭头函数的this(它自身没有this)。而call、apply、bind可以绑定缓存箭头函数上层的普通函数的this。
比如：

```js
var student = {
    name: 'water',
    func: function(){
        console.log(this.name);
        return () => {
            console.log('arrowFn:', this.name);
        }
    }
}
var person = {
    name: 'person',
}
student.func().call(person); // 'water'  'arrowFn:' 'water'
student.func.call(person)(); // 'person' 'arrowFn:' 'person'
```

**DOM事件处理函数调用**

```html
addEventerListener、attachEvent、onclick
<button class="button">onclick</button>

<ul class="list">
    <li>1</li>
    <li>2</li>
    <li>3</li>
</ul>
<script>
    var button = document.querySelector('button');
    button.onclick = function(ev){
        console.log(this);
        console.log(this === ev.currentTarget); // true
    }
    var list = document.querySelector('.list');
    list.addEventListener('click', function(ev){
        console.log(this === list); // true
        console.log(this === ev.currentTarget); // true
        console.log(this);
        console.log(ev.target);
    }, false);
</script>
```

onclick和addEventerListener是指向绑定事件的元素。一些浏览器，比如IE6~IE8下使用attachEvent，this指向是window。
**顺便提下**：面试官也经常考察ev.currentTarget和ev.target的区别。ev.currentTarget是绑定事件的元素，而ev.target是当前触发事件的元素。比如这里的分别是ul和li。但也可能点击的是ul，这时ev.currentTarget和ev.target就相等了。
**内联事件处理函数调用**

```html
<button class="btn1" onclick="console.log(this === document.querySelector('.btn1'))">点我呀</button>
<button onclick="console.log((function(){return this})());">再点我呀</button>
```

第一个是button本身，所以是true，第二个是window。这里跟严格模式没有关系。当然我们现在不会这样用了，但有时不小心写成了这样，也需要了解。其实this的使用场景还有挺多，比如对象object中的getter、setter的this，new Function()、eval。但掌握以上几种，去分析其他的，就自然迎刃而解了。使用比较多的还是普通函数调用、对象的函数调用、new调用、call、apply、bind调用、箭头函数调用。那么他们的优先级是怎样的呢。

**优先级**

而箭头函数的this是上层普通函数的this或者是全局对象（浏览器中是window），所以排除，不算优先级。

```js
var name = 'window';
var person = {
    name: 'person',
}
var func = function(){
    console.log(this.name);
    return function(){
        console.log('return:', this.name);
    }
}
var Student = {
    name: 'water',
    func: func,
}
// 普通函数调用
func(); // window
// 对象上的函数调用
Student.func(); // 'water'
// call、apply 调用
Student.func.call(person); // 'person'
new Student.func.call(person);
```

试想一下，如果是Student.func.call(person)先执行的情况下，那new执行一个函数。是没有问题的。
然而事实上，这代码是报错的。运算符优先级是new比点号低，所以是执行new (Student.func.call)(person)
而Function.prototype.call，虽然是一个函数（apply、bind也是函数），跟箭头函数一样，不能用new调用。所以报错了。

```bash
Uncaught TypeError: Student.doSth.call is not a constructor
```

这是因为函数内部有两个不同的方法：[[Call]]和[[Constructor]]。
当使用普通函数调用时，[[Call]]会被执行。当使用构造函数调用时，[[Constructor]]会被执行。call、apply、bind和箭头函数内部没有[[Constructor]]方法。
从上面的例子可以看出普通函数调用优先级最低，其次是对象上的函数。
call（apply、bind）调用方式和new调用方式的优先级，在《你不知道的JavaScript》是对比bind和new，引用了mdn的bind的ployfill实现，new调用时bind之后的函数，会忽略bind绑定的第一个参数，(mdn的实现其实还有一些问题，感兴趣的读者，可以看我之前的文章：面试官问：能否模拟实现JS的bind方法)，说明new的调用的优先级最高。
所以它们的优先级是new 调用 > call、apply、bind 调用 > 对象上的函数调用 > 普通函数调用。

## 总结

如果要判断一个运行中函数的 this 绑定， 就需要找到这个函数的直接调用位置。 找到之后
就可以顺序应用下面这四条规则来判断 this 的绑定对象。

1. new 调用：绑定到新创建的对象，注意：显示return函数或对象，返回值不是新创建的对象，而是显式返回的函数或对象。
2. call 或者 apply（ 或者 bind） 调用：严格模式下，绑定到指定的第一个参数。非严格模式下，null和undefined，指向全局对象（浏览器中是window），其余值指向被new Object()包装的对象。
3. 对象上的函数调用：绑定到那个对象。
4. 普通函数调用： 在严格模式下绑定到 undefined，否则绑定到全局对象。

ES6 中的箭头函数：不会使用上文的四条标准的绑定规则， 而是根据当前的词法作用域来决定this， 具体来说， 箭头函数会继承外层函数，调用的 this 绑定（ 无论 this 绑定到什么），没有外层函数，则是绑定到全局对象（浏览器中是window）。 这其实和 ES6 之前代码中的 self = this 机制一样。

DOM事件函数：一般指向绑定事件的DOM元素，但有些情况绑定到全局对象（比如IE6~IE8的attachEvent）。

一定要注意，有些调用可能在无意中使用普通函数绑定规则。 如果想“ 更安全” 地忽略 this 绑
定， 你可以使用一个对象， 比如 ø = Object.create(null)， 以保护全局对象。

面试官考察this指向就可以考察new、call、apply、bind，箭头函数等用法。从而扩展到作用域、闭包、原型链、继承、严格模式等。这就是面试官乐此不疲的原因。