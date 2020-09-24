---
title: 你需要知道的jest测试
categories: WEB前端
copyright: true
date: 2020-09-23 17:23:56
tags:
---

## 简介

引入 jest 官网的一段话：

> Jest 是一个令人愉快的 JavaScript 测试框架，专注于简洁明快。他适用但不局限于使用以下技术的项目：[Babel](https://babeljs.io/), [TypeScript](https://www.typescriptlang.org/), [Node](https://nodejs.org/en/), [React](https://reactjs.org/), [Angular](https://angular.io/), [Vue](https://vuejs.org/)

如官网所说，jest 是一个易于使用的测试框架，很多框架的单元测试也都选择使用 jest。所以 jest 也是我们的一大利器，学习一下总是好的<!--more-->

## 开始

### 安装

可以使用 npm 或者 yarn 来进行安装

```
npm install jest --save-dev
// or
yarn add jest --dev
```

### 测试安装是否成功

- 先编写一个需要测试的函数

```js
function sum(a, b) {
  return a + b
}
module.exports = sum
```

- 创建一个 sum.test.js 文件，并写入我们的测试用例

```js
const sum = require('./sum')
test('adds 1 + 2 to equal 3', () => {
  // 精确匹配等于3
  expect(sum(1, 2)).toBe(3)
})
```

- Package.json 中配置脚本命令

```json
{
  "scripts": {
    "test": "jest"
  }
}
```

- 运行测试

```
yarn test
// or
npm run test
```

- 结果

```
PASS  ./sum.test.js
✓ adds 1 + 2 to equal 3 (5ms)
```

当结果出现 pass 说明测试通过且 jest 测试框架安装成功！

## 常用测试 api

##### 普通匹配器

- toBeNull

判断是否匹配 null

- toBeUndefined

判断是否匹配 undefined

- toBeDefined

与 toBeUndefined 相反，匹配非 undefined

- toBeTruthy

判断布尔值为 true

- toBeFalsy

判断布尔值为 false

- not

取反

- toEqual 和 toBe

`toBe` 使用 `Object.is` 来测试精确相等。 如果您想要检查对象的值，请使用 `toEqual` 代替

例子：

```js
test('null', () => {
  const a = null
  expect(a).toBeNull()
  expect(a).toBeDefined()
  expect(a).not.toBeUndefined()
  expect(a).not.toBeTruthy()
  expect(a).toBeFalsy()
})

test('zero', () => {
  const b = 0
  expect(b).not.toBeNull()
  expect(b).toBeDefined()
  expect(b).not.toBeUndefined()
  expect(b).not.toBeTruthy()
  expect(b).toBeFalsy()
})
```

##### 数字匹配器

- toBeGreaterThan

判断返回值大于期望值

- toBeGreaterThanOrEqual

判断返回值大于或者等于期望值

- toBeLessThan

判断返回值小于期望值

- toBeLessThanOrEqual

判断返回值小于或等于期望值

- toBe

判断返回值全等于期望值

- toEqual

判断对象等值等于期望值

- toBeCloseTo

判断浮点数在允许的误差范围相等

例子：

```js
test('two plus two', () => {
  const value = 2 + 2
  expect(value).toBeGreaterThan(3)
  expect(value).toBeGreaterThanOrEqual(3.5)
  expect(value).toBeLessThan(5)
  expect(value).toBeLessThanOrEqual(4.5)

  // toBe and toEqual are equivalent for numbers
  expect(value).toBe(4)
  expect(value).toEqual(4)
})

test('两个浮点数字相加', () => {
  const value = 0.1 + 0.2
  //expect(value).toBe(0.3);  这句会报错，因为浮点数有舍入误差
  expect(value).toBeCloseTo(0.3) // 这句可以运行
})
```

##### 字符串匹配器

- toMatch

判断是否含有期望字符

例子：

```js
test('there is no I in team', () => {
  expect('team').not.toMatch(/I/)
})

test('but there is a "stop" in Christoph', () => {
  expect('Christoph').toMatch(/stop/)
})
```

##### 数组匹配器

- toContain

判断数组是否包含某个值

例子：

```js
const shoppingList = ['diapers', 'kleenex', 'trash bags', 'paper towels', 'beer']

test('the shopping list has beer on it', () => {
  expect(shoppingList).toContain('beer')
  expect(new Set(shoppingList)).toContain('beer')
})
```

##### Throw error 匹配器

例子：

```js
function compileAndroidCode() {
  throw new Error('you are using the wrong JDK')
}

test('compiling android goes as expected', () => {
  expect(compileAndroidCode).toThrow()
  expect(compileAndroidCode).toThrow(Error)

  // You can also use the exact error message or a regexp
  expect(compileAndroidCode).toThrow('you are using the wrong JDK')
  expect(compileAndroidCode).toThrow(/JDK/)
})
```

## 多次测试前后准备的钩子函数

如果你有一些要为多次测试重复设置的工作，你可以使用 `beforeEach` 和 `afterEach`。例如，我们考虑一些与城市信息数据库进行交互的测试。 你必须在每个测试之前调用方法 `initializeCityDatabase()` ，同时必须在每个测试后，调用方法 `clearCityDatabase()`

```js
beforeEach(() => {
  initializeCityDatabase()
})

afterEach(() => {
  clearCityDatabase()
})

test('city database has Vienna', () => {
  expect(isCity('Vienna')).toBeTruthy()
})

test('city database has San Juan', () => {
  expect(isCity('San Juan')).toBeTruthy()
})
```

在某些情况下，你只需要在文件的开头做一次设置，缓存数据方便后面的操作。Jest 提供 `beforeAll` 和 `afterAll` 处理这种情况

```js
beforeAll(() => {
  return initializeCityDatabase()
})

afterAll(() => {
  return clearCityDatabase()
})

test('city database has Vienna', () => {
  expect(isCity('Vienna')).toBeTruthy()
})

test('city database has San Juan', () => {
  expect(isCity('San Juan')).toBeTruthy()
})
```

## 关于分组块 describe

```js
beforeAll(() => {
  return initializeCityDatabase()
})

afterAll(() => {
  return clearCityDatabase()
})

test('city database has Vienna', () => {
  expect(isCity('Vienna')).toBeTruthy()
})

test('city database has San Juan', () => {
  expect(isCity('San Juan')).toBeTruthy()
})
```

分组和命名空间差不多,就是把我们的测试分块整理下，这样测试就比较有条理。

## 小结

以上就是关于 jest 测试的一些简单使用的总结和记录。欢迎大家查阅指正，觉得有帮助的给个赞，谢谢啦！
