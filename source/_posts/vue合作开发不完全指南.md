---
title: vue合作开发不完全指南
categories: WEB前端
copyright: true
date: 2018-07-06 09:52:38
tags:
- vue
- 规范
- 合作
---

### 背景

我们在任何一家公司工作，合作是必不可少的。在前端工作上也是会有很多同事一起进行业务逻辑的开发。那么在合作开发的过程中，一些注意的事项和规则统一起来的话，合作得效率就会提高很多。<!--more-->这里我简单总结下 vue 开发中的能提高合作效率的要点，仅供参考。

1.  组件的命名尽可能的语义化，包括.vue 文件，有多个单词合成。根组件 App 除外

```
export default {
    name: 'TodoItem'
}
```

2.  组件的 data 必须是一个函数，并且在组件中，必须要用 return 返回一个对象

```
export default {
    data () {
        return {
            flag: true
        }
    }
}
```

3.  prop 的定义要尽量详细点，需要指定类型

```
props: {
    status: {
        type: String,
        require: true
    }
}
```

4.  v-for 循环的时候设置 key,并且 key 是唯一的值

```
<ul>
    <li v-for="item of items" :key="item.id">
        {{item.title}}
    </li>
</ul>
```

5.  尽量不要把 v-if 和 v-for 这另个指令放在同一个元素标签上

```
<ul v-if="flag">
    <li v-for="item of items" :key="item.id">
        {{item.title}}
    </li>
</ul>
```

6.  在为组件设置样式的时候，需要定义一个最外层的 class，来进行样式的隔绝，只作用于局部，这样的好处不会造成全局的污染，并且也容易进行样式的覆盖（不使用 scoped 的原因）。

```
<template>
    <div class="panel">

    </div>
</template>
```

7.  在写组件的时候，使用.vue 文件的方式。

```
components/
    User.vue
    IndexHeader.vue
```

8.  组件文件的命名使用大驼峰或者小驼峰的书写方式

9.  基础组件加个特定的前缀作为区分（Base）

10. 如果组件之间有关系，加上关系层的父组件前缀
