---
title: jsx中组件或元素的条件输出
categories: WEB前端
copyright: true
date: 2018-04-15 17:57:58
tags: react
---
我们都知道，在我们在根据数据状态来展现view的时候，会涉及到组件按条件展示。还有在一个列表的展示的时候难免会遇到数据循环的处理。接下来就简单说下两种情况的处理。<!--more-->

## 组件或元素的条件渲染

* 在react中，你可以创建不同的组件各自封装你需要的东西。之后你可以值渲染其中一部分。这就取决于组件的state状态。

* 条件渲染在React里就和js里的条件语句一样。使用js里的if或者条件表达式创建元素来显示当前的状态，然后让React来更新UI。创建两个组件:

```
function BackHome(props) {
    return (
        <h1>BackHome</h1>
    )
}

function SignIn(props) {
    return (
        <h1>SignIn</h1>
    )
}
```
接下来，我创建一个可以按条件显示的组件:

```
function SetHome(props) {
    const isState = props.isState;
    if(isState) {
        return <BackHome />
    }
    return <SignIn />
}

ReactDOM.render(
    <SetHome isState={false}>,
    document.getElementById('root')
)
```
这里根据isState的值，来渲染不同的组件。

在条件渲染中，我们可以定义一个储存组件的变量。来通过不同的赋值条件显示。

### 行内条件使用&&操作符

if可以解决条件渲染，但是有时我们会追求简介的写法，下面就简单介绍下&&操作符。例如：

```
function And(props) {
    cosnt isLength = props.isLength;
    return (
        <div>
            <h1>hello</h1>
            {isLength.length > 0 && 
                <h2> isLength.length</h2>
            }
        </div>
    )
}

const isLength = [1,2,3];
ReactDOM.render(
    <And isLength={isLength} />,
    document.getElementById('root')
)
```
这里运用了短路运算，只有前面一个条件为true的时候才会渲染出组件
* 当然使用三目运算符也是很常见的简化方式。

### 阻止组件的渲染
有一些情况也许你希望一个组件隐藏起来。想要隐藏它就返回null作为输出而不是渲染输出。下面这个例子：

```
function PageComponent(props) {
  if (!props.num) {
    return null;
  }

  return (
    <div className="warning">
      Warning!
    </div>
  );
}

class Page extends React.Component {
  constructor(props) {
    super(props);
    this.state = {showComponent: true}
    this.handleToggleClick = this.handleToggleClick.bind(this);
  }

  handleToggleClick() {
    this.setState(prevState => ({
      showComponent: !prevState.showComponent
    }));
  }

  render() {
    return (
      <div>
        <PageComponent warn={this.state.showComponent} />
        <button onClick={this.handleToggleClick}>
          {this.state.showComponent ? 'Hide' : 'Show'}
        </button>
      </div>
    );
  }
}

ReactDOM.render(
  <Page />,
  document.getElementById('root')
);
```
组件的render方法返回null不会影响组件的生命周期方法的运行。比如，componentWillUpdate和componentDidUpdate将一直被调用。



