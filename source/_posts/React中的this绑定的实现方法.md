---
title: React中的this绑定的实现方法
categories: WEB前端
copyright: true
date: 2018-06-14 08:39:31
tags: react
---

this 在 js 中使用频率非常高。就算是在框架中也依然很高，比如：vue react 等这些框架。所以就需要研究下 this 的各种使用场景和指向问题。特别是和箭头函数使用时的区别。这里主要说下在 react 中 this 的使用绑定问题。<!--more-->

### 1.使用 React.createClass 创建组件

如果你使用的是 React 15 及以下的版本，你可能使用过 React.createClass 函数来创建一个组件。你在里面创建的所有函数的 this 将会自动绑定到组件上。

```
const Comp = React.createClass({
  handleClick() {
    console.log('this is ', this); // this 指向Comp组件本身
  },
  render() {
    return (
      <div onClick={this.handleClick}>test</div>
    );
  }
});
```

但是需要注意随着 React 16 版本的发布官方已经将改方法从 React 中移除。

### 2.render 方法中使用 bind

如果你使用 React.Component 创建一个组件，在其中给某个组件/元素一个 onClick 属性，它现在并会自定绑定其 this 到当前组件，解决这个问题的方法是在事件函数后使用.bind(this)将 this 绑定到当前组件中。

```
class Comp extends React.Component {
  handleClick() {
    console.log('this is ', this);
  }
  render() {
    return (
      <div onClick={this.handleClick.bind(this)}>test</div>
    )
  }
}
```

这种方法很简单，可能是大多数初学开发者在遇到问题后采用的一种方式。然后由于组件每次执行 render 将会重新分配函数这将会影响性能。特别是在你做了一些性能优化之后，它会破坏 PureComponent 性能。不推荐使用

### 3.render 方法中使用箭头函数

这种方法使用了 ES6 的上下文绑定来让 this 指向当前组件，但是它同第 2 种存在着相同的性能问题，不推荐使用

```
class Comp extends React.Component {
  handleClick() {
    console.log('this is ', this);
  }
  render() {
    return (
      <div onClick={e => this.handleClick(e)}>test</div>
    )
  }
}
```

### 4.构造函数中 bind

为了避免在 render 中绑定 this 引发可能的性能问题，我们可以在 constructor 中预先进行绑定。

```
class Comp extends React.Component {
  constructor(props) {
    super(props);
    this.handleClick = this.handleClick.bind(this);
  }
  handleClick() {
    console.log('this is ', this);
  }
  render() {
    return (
      <div onClick={this.handleClick}>test</div>
    )
  }
}
```

然后这种方法很明显在可读性和维护性上没有第 2 种和第 3 种有优势，但是第 2 种和第 3 种由于存在潜在的性能问题不推荐使用，那么现在推荐 ECMA stage-2 所提供的箭头函数绑定。

### 5.在定义阶段使用箭头函数绑定

要使用这个功能，需要在.babelrc 种开启 stage-2 功能，绑定方法如下：

```
class Comp extends React.Component {
  constructor(props) {
    super(props);
  }
  handleClick = () => {
    console.log('this is ', this);
  }
  render() {
    return (
      <div onClick={this.handleClick}>test</div>
    )
  }
}
```

这种方法有很多优化：

-   箭头函数会自动绑定到当前组件的作用域种，不会被 call 改变

-   它避免了第 2 种和第 3 种的可能潜在的性能问题

-   它避免了第 4 种绑定时大量重复的代码

### 总结

综合以上方法使用 react16 的话最好的绑定方法是在定义阶段使用箭头函数绑定。
