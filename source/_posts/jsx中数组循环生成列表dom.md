---
title: jsx中数组循环生成列表dom
categories: WEB前端
copyright: true
date: 2018-04-16 21:45:55
tags: react
---
列表和条件输出dom节点一样，在数据渲染到前台显示的方式很是常见。我们在做前端业务逻辑的时候也经常遇到这样的需求，比如：用户列表、文章列表等。所以我们需要这个技能。react.js中我们也可以对列表数据进行循环渲染。但是在jsx中有自己的一些规则和技巧。接下来我们就简单一起看下。<!--more-->

## 在jsx中渲染一个存有数据的数组

现在，我们在学习阶段，先造个列表的数据，存放我们想要渲染的列表中：

```
const list = [
    {name:'小A',like:'唱歌'},
    {name:'小B',like:'跳舞'},
    {name:'小C',like:'打球'},
    {name:'小D',like:'购物'},    
]
```
我们要把这个列表的数据渲染到页面。首先，我们都知道在jsx中的{}中，我们可以放任何的数据或者是表达式。所以，当我们放一个数组，就会以数组的顺序进行渲染，就像下面这样：

```
class List extends Component {
    render() {
        return (
            <div>
                {
                    [
                        <div>react</div>,
                        <div>vue</div>,
                        <div>mvvm</div>
                    ]
                }
            </div>
        )
    }
}

ReactDOM.render(
    <List />,
    document.getElementById('root')
)
```

这样输出的就是一个列表。

## 使用数组的map方法循环列表

首先用一个传统的方法来实现循环渲染：

```
class List extends Compont {
    render () {
        const ListArray = [] // 保存每个用户渲染以后 JSX 的数组
        for (let item of list) {
        ListArray.push( // 循环每个用户，构建 JSX，push 到数组中
            <div>
                <div>姓名：{item.name}</div>
                <div>爱好：{item.like}</div>
            </div>
        )
        }

    return (
      <div>{ListArray}</div>
    )
    }
}

ReactDOM.render(
  <List />,
  document.getElementById('root')
)
```
我们用一个新的数组存循环list数组给每个元素加上html标签构成的jsx。然后就直接放到{}插入到dom页面，这样就可以渲染出列表了。

当然，这虽然能解决问题，但是不是我们想要的，接下来我们感受一下map方法的魅力。如下重写上面的例子：

```
class List extends Component {
  render () {
    return (
      <div>
        {list.map((item) => {
          return (
            <div>
              <div>姓名：{item.name}</div>
              <div>爱好：{item.like}</div>
            </div>
          )
        })}
      </div>
    )
  }
}

ReactDOM.render(
  <List />,
  document.getElementById('root')
)
```
这样我们就完成了一个列表的渲染，但是在运行中会报错，因为没有绑定key，而且我们要绑定的key必须是唯一的，不能重复，这里我们就用索引来代替吧：

```
class List extends Component {
  render () {
    return (
      <div>
        {list.map((item,index) => {
          return (
            <div key={index}>
              <div>姓名：{item.name}</div>
              <div>爱好：{item.like}</div>
            </div>
          )
        })}
      </div>
    )
  }
}

ReactDOM.render(
  <List />,
  document.getElementById('root')
)
```
虽然此处我用索引绑定key，但是其实是不严谨的，在实际业务中，一定要找到不同的值进行绑定。