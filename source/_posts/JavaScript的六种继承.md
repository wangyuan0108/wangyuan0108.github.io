---
title: JavaScript的六种继承
categories: WEB前端
copyright: true
date: 2020-08-11 16:23:12
tags:
---

## 原型链继承

```js
function Parent() {
  this.name = 'water'
}

Parent.prototype.getName = function() {
  console.log(this.name)
}

function Child() {}

Child.prototype = new Parent()

var child1 = new Child()

console.log(child1.getName()) // water
```

<!--more-->

缺点：

- 引用类型的属性被所有实例共享

```js
function Parent() {
  this.names = ['water', 'ice']
}

Parent.prototype.getName = function() {
  console.log(this.name)
}

function Child() {}

Child.prototype = new Parent()

var child1 = new Child()

child1.names.push('fire')

console.log(child1.names) // ['water', 'ice', 'fire']

var child2 = new Child()

console.log(child2.names) // ['water', 'ice', 'fire']
```

- 在创建 Child 的实例时，不能向 Parent 传参

## 借用构造函数(经典继承)

复制父类构造函数内的属性

```js
function Parent() {
  this.names = ['water', 'ice']
}

Parent.prototype.getName = function() {
  console.log(this.name)
}

function Child() {
  Parent.call(this)
}

var child1 = new Child()
var child2 = new Child()
child1.names.push('fire')
console.log(child1.names) // ['water', 'ice', 'fire']
console.log(child2.names) // ['water', 'ice']
```

优点：

- 避免了引用类型的属性被所有实例共享
- 可以在 Child 中向 Parent 传参

缺点：

- 只是子类的实例，不是父类的实例
- 方法都在构造函数中定义，每次创建实例都会创建一遍方法。

```js
function Parent(name) {
  this.name = name
}

Parent.prototype.getName = function() {
  console.log(this.name)
}

function Child(name) {
  Parent.call(this, name)
}

var child1 = new Child('water')
var child2 = new Child('ice')
console.log(child1.name) // water
console.log(child2.name) // ice
console.log(child1 instanceof Parent) // false   不能识别是Parent的实例
```

## 组合继承

原型链继承和经典继承双剑合璧：组合原型链继承和借用构造函数继承
背后的思路是：使用原型链实现对原型方法的继承，而通过借用构造函数来实现对实例属性的继承。

```js
function Parent(name) {
  this.name = name
  this.colors = ['red', 'blue', 'green']
}

Parent.prototype.getName = function() {
  console.log(this.name)
}

function Child(name, age) {
  Parent.call(this, name) // 第二次调用 Parent
  this.age = age
}

Child.prototype = new Parent() // 第一次调用Parent
Child.prototype.constructor = Child

var child1 = new Child('water', '20')
child1.colors.push('black')

console.log(child1.name) // water
console.log(child1.age) // 20
console.log(child1.colors) // ["red", "blue", "green", "black"]

var child2 = new Child('ice', '26')

console.log(child2.name) // ice
console.log(child2.age) // 26
console.log(child2.colors) // ["red", "blue", "green"]

console.log(child1 instanceof Child) // true
console.log(child1 instanceof Parent) // true
```

优点：融合原型链继承和构造函数的优点，是 JavaScript 中最常用的继承模式。
缺点：调用了两次父类构造函数（组合继承最大的问题是无论什么情况下，都会调用两次超类型构造函数：一次是在创建子类型原型的时候，另一次是在子类型构造函数内部）

## 原型式继承

```js
function createObj(o) {
  function F() {}
  F.prototype = o
  console.log(o.__proto__ === Object.prototype)
  console.log(F.prototype.constructor === Object) // true
  return new F()
}
var person = {
  name: 'water',
  friend: ['ice', 'fire'],
}

var person1 = CreateObj(person)
var person2 = CreateObj(person)

person1.name = 'person1'
console.log(person2.name) // xiaopao
person1.friend.push('joke')
console.log(person2.friend) // ['ice', 'fire', 'joke']
console.log(person) // {name: "water", friend: Array(3)}
person1.friend = ['Tom']
console.log(person1.friend) // ['Tom']
console.log(person.friend) //  ['ice', 'fire', 'joke']
// 注意： 这里修改了person1.name的值，person2.name的值并未改变，并不是因为person1和person2有独立的name值，而是person1.name='person1'是给person1添加了name值，并非修改了原型上的name值
// 因为我们找对象上的属性时，总是先找实例上对象，没有找到的话再去原型对象上的属性。实例对象和原型对象上如果有同名属性，总是先取实例对象上的值
```

就是 ES5 Object.create 的模拟实现，将传入的对象作为创建的对象的原型。

缺点：包含引用类型的属性值始终都会共享相应的值，这点跟原型链继承一样。
注意： 这里修改了 person1.name 的值，person2.name 的值并未改变，并不是因为 person1 和 person2 有独立的 name 值，而是 person1.name='person1'是给 person1 添加了 name 值，并非修改了原型上的 name 值。
因为我们找对象上的属性时，总是先找实例上对象，没有找到的话再去原型对象上的属性。实例对象和原型对象上如果有同名属性，总是先取实例对象上的值

## 寄生式继承

创建一个仅用于封装继承过程的函数，该函数在内部以某种形式来做增强对象，最后返回对象。可以理解为在原型式继承的基础上新增一些函数或属性

```js
// 寄生式继承  可以理解为在原型式继承的基础上增加一些函数或属性
var ob = {
  name: 'water',
  friends: ['ice', 'fire'],
}

function CreateObj(o) {
  function F() {} // 创建一个构造函数F
  F.prototype = o
  return new F()
}

// 上面CreateObj函数 在ECMAScript5 有了一新的规范写法，Object.create(ob) 效果是一样的 , 看下面代码
var ob1 = CreateObj(ob)
var ob2 = Object.create(ob)
console.log(ob1.name) // water
console.log(ob2.name) // water

function CreateOb(o) {
  var newob = CreateObj(o) // 创建对象 或者用 var newob = Object.create(ob)
  newob.sayName = function() {
    // 增强对象
    console.log(this.name)
  }
  return newob // 指定对象
}

var p1 = CreateOb(ob)
p1.sayName() // water
```

缺点：跟借用构造函数模式一样，每次创建对象都会创建一遍方法。

## 寄生组合式继承

子类构造函数复制父类的自身属性和方法，子类原型只接收父类的原型属性和方法

> 所谓寄生组合继承，即通过借用构造函数来继承属性，通过原型链的混成形式来继承方法。其背后的基本思路是：不必为了指定子类型的原型而调用超类型的构造函数，我们所需要的无非就是超类型的原型的一个副本而已。本质上，就是使用寄生式继承来继承超类型的原型，然后再将结果指定给予类型的原型。

```js
function Parent(name) {
  this.name = name
  this.colors = ['red', 'blue', 'green']
}

Parent.prototype.getName = function() {
  console.log(this.name)
}

function Child(name, age) {
  Parent.call(this, name)
  this.age = age
}

Child.prototype = new Parent()

var child1 = new Child('water', '20')

console.log(child1)
```

组合继承最大的缺点是会调用两次父构造函数。

- 设置子类型实例的原型的时候：

```js
Child.prototype = new Parent()
```

- 在创建子类型实例的时候：

```js
var child1 = new Child('water', '20')
```

回想下 new 的模拟实现，其实在这句中，我们会执行：

```js
Parent.call(this, name)
```

在这里，我们又会调用了一次 Parent 构造函数。所以，在这个例子中，如果我们打印 child1 对象，我们会发现 Child.prototype 和 child1 都有一个属性为 colors，属性值为['red', 'blue', 'green']。那么我们该如何精益求精，避免这一次重复调用呢？如果我们不使用 Child.prototype = new Parent() ，而是间接的让 Child.prototype 访问到 Parent.prototype 呢？看看如何实现：

```js
function Parent(name) {
  this.name = name
  this.colors = ['red', 'blue', 'green']
}

Parent.prototype.getName = function() {
  console.log(this.name)
}

function Child(name, age) {
  Parent.call(this, name)
  this.age = age
}

// 关键的三步
// var F = function() {}
// F.prototype = Parent.prototype
// Child.prototype = new F()
function CreateObj(o) {
  function F() {}
  F.prototype = o
  return new F()
}

// Child.prototype = new Parent(); // 这里换成下面
function prototype(child, parent) {
  var prototype = CreateObj(parent.prototype)
  prototype.constructor = child
  child.prototype = prototype
}
prototype(Child, Parent)
var child1 = new Child('water', 20)
console.log(child1)
```

这种方式的高效率体现它只调用了一次 Parent 构造函数，并且因此避免了在 Parent.prototype 上面创建不必要的、多余的属性。与此同时，原型链还能保持不变；因此，还能够正常使用 instanceof 和 isPrototypeOf。开发人员普遍认为寄生组合式继承是引用类型最理想的继承范式。
