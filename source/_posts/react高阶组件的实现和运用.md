---
title: react高阶组件的实现和运用
categories: WEB前端
copyright: true
date: 2020-01-09 10:55:36
tags: react
---

## 简述
在项目中，有很多大致相同的页面。又不想每次都写相同的页面布局，所以封装一个公共的页面，然后通过继承多态来实现每个自己的页面实例。其中用到高阶组件的知识，这里巩固学习一下高阶组件的实现方法和使用场景。<!--more-->

## 高阶组件实现的方式

### 属性代理

函数返回一个我们自己定义的组件，然后在render中返回要包裹的组件，这样我们就可以代理所有传入的props，并且决定如何渲染，实际上 ，这种方式生成的高阶组件就是原组件的父组件，上面的函数visible就是一个HOC属性代理的实现方式。

```js
function proxyHOC(WrappedComponent) {
  return class extends Component {
    render() {
      return <WrappedComponent {...this.props} />;
    }
  }
}
```
对比原生组件增强的项：

- 可操作所有传入的props
- 可操作组件的生命周期
- 可操作组件的static方法
- 获取refs

### 反向继承

返回一个组件，继承原组件，在render中调用原组件的render。由于继承了原组件，能通过this访问到原组件的生命周期、props、state、render等，相比属性代理它能操作更多的属性。
```js
function inheritHOC(WrappedComponent) {
  return class extends WrappedComponent {
    render() {
      return super.render();
    }
  }
}
```
对比原生组件增强的项：

- 可操作所有传入的props
- 可操作组件的生命周期
- 可操作组件的static方法
- 获取refs
- 可操作state
- 可以渲染劫持

## 高阶组件可实现的功能

### 组合渲染

可使用任何其他组件和原组件进行组合渲染，达到样式、布局复用等效果。

>通过属性代理实现
```js
function stylHOC(WrappedComponent) {
  return class extends Component {
    render() {
      return (<div>
        <div className="title">{this.props.title}</div>
        <WrappedComponent {...this.props} />
      </div>);
    }
  }
}
```
>通过反向继承实现
```js
function styleHOC(WrappedComponent) {
  return class extends WrappedComponent {
    render() {
      return <div>
        <div className="title">{this.props.title}</div>
        {super.render()}
      </div>
    }
  }
}
```
### 条件渲染
根据特定的属性决定原组件是否渲染

>通过属性代理实现
```
function visibleHOC(WrappedComponent) {
  return class extends Component {
    render() {
      if (this.props.visible === false) return null;
      return <WrappedComponent {...props} />;
    }
  }
}
```
>通过反向继承实现
```js
function visibleHOC(WrappedComponent) {
  return class extends WrappedComponent {
    render() {
      if (this.props.visible === false) {
        return null
      } else {
        return super.render()
      }
    }
  }
}
```
### 操作props
可以对传入组件的props进行增加、修改、删除或者根据特定的props进行特殊的操作。

>通过属性代理实现
```js
function proxyHOC(WrappedComponent) {
  return class extends Component {
    render() {
      const newProps = {
        ...this.props,
        user: 'ConardLi'
      }
      return <WrappedComponent {...newProps} />;
    }
  }
}
```
### 获取refs
高阶组件中可获取原组件的ref，通过ref获取组件实力，如下面的代码，当程序初始化完成后调用原组件的log方法。

>通过属性代理实现
```js
function refHOC(WrappedComponent) {
  return class extends Component {
    componentDidMount() {
      this.wapperRef.log()
    }
    render() {
      return <WrappedComponent {...this.props} ref={ref => { this.wapperRef = ref }} />;
    }
  }
}
```
这里注意：调用高阶组件的时候并不能获取到原组件的真实ref，需要手动进行传递

### 状态管理
将原组件的状态提取到HOC中进行管理，如下面的代码，我们将Input的value提取到HOC中进行管理，使它变成受控组件，同时不影响它使用onChange方法进行一些其他操作。基于这种方式，我们可以实现一个简单的双向绑定，具体请看双向绑定。

>通过属性代理实现
```js
function proxyHoc(WrappedComponent) {
  return class extends Component {
    constructor(props) {
      super(props);
      this.state = { value: '' };
    }

    onChange = (event) => {
      const { onChange } = this.props;
      this.setState({
        value: event.target.value,
      }, () => {
        if(typeof onChange ==='function'){
          onChange(event);
        }
      })
    }

    render() {
      const newProps = {
        value: this.state.value,
        onChange: this.onChange,
      }
      return <WrappedComponent {...this.props} {...newProps} />;
    }
  }
}

class HOC extends Component {
  render() {
    return <input {...this.props}></input>
  }
}

export default proxyHoc(HOC);
```
### 操作state
上面的例子通过属性代理利用HOC的state对原组件进行了一定的增强，但并不能直接控制原组件的state，而通过反向继承，我们可以直接操作原组件的state。但是并不推荐直接修改或添加原组件的state，因为这样有可能和组件内部的操作构成冲突。

>通过反向继承实现
```js
function debugHOC(WrappedComponent) {
  return class extends WrappedComponent {
    render() {
      console.log('props', this.props);
      console.log('state', this.state);
      return (
        <div className="debuging">
          {super.render()}
        </div>
      )
    }
  }
}
```
复制代码上面的HOC在render中将props和state打印出来，可以用作调试阶段，当然你可以在里面写更多的调试代码。想象一下，只需要在我们想要调试的组件上加上@debug就可以对该组件进行调试，而不需要在每次调试的时候写很多冗余代码。

### 渲染劫持
高阶组件可以在render函数中做非常多的操作，从而控制原组件的渲染输出。只要改变了原组件的渲染，我们都将它称之为一种渲染劫持。
实际上，上面的组合渲染和条件渲染都是渲染劫持的一种，通过反向继承，不仅可以实现以上两点，还可直接增强由原组件render函数产生的React元素。

>通过反向继承实现
```js
function hijackHOC(WrappedComponent) {
  return class extends WrappedComponent {
    render() {
      const tree = super.render();
      let newProps = {};
      if (tree && tree.type === 'input') {
        newProps = { value: '渲染被劫持了' };
      }
      const props = Object.assign({}, tree.props, newProps);
      const newTree = React.cloneElement(tree, props, tree.props.children);
      return newTree;
    }
  }
}
```

