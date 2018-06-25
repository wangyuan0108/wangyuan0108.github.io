---
title: 快被遗忘的组件传值方法——EventBus
categories: WEB前端
copyright: true
date: 2018-06-25 09:41:38
tags:
- vue
- 组件传值
---

### 背景

我们在使用 vue 的时候都知道，组件化开发是 vue 的一个重要的特性。所以我们在开发业务的过程中会经常进行组件的封装，进而实现组件的复用，来提高开发效率。然而在我们使用组件化开发的时候，难免会有组件间的数据通信。<!--more-->父子级组件数据传递到还是很好解决，但是兄弟组件和多级嵌套的组件就显得不是那么友好了，单纯的 props 和事件传值已经有点吃力了，所以这里有两种解决的办法：EventBus 和 vuex。这里就主要说下 EventBus 实现的方法。

### EventBus 实现原理介绍

-   父组件发送数据给子组件，可以通过子组件的 props 来进行数据的传递。

-   EventBus 其实就是通过实例化一个 Vue 实例，然后通过该实例的$emit 方法发送数据消息和$on 方法接收数据消息。它适用在子组件发送消息给父组件或兄弟组件之间发送消息。

### EventBus 实现小事例

首先，我们需要实例化一个 Vue 来充当 EventBus 来进行数据的通信。这里定义一个 EventBus.js.

```
import Vue from 'Vue'
export default new Vue()
```

然后定义一个父组件和一个子组件以及一个兄弟组件。命名文件：parent.js child.js subItem.js

```
// parent.js 父组件
<template>
    <child></child>
    <sub-item></sub-item>
    <span>{{data}}</span>
</template>
<script>
import child from './child';
import subItem from './subItem';
import EventBus from './EventBus';
export default {
    data() {
        return {
            data:''
        }
    },
    mounted() {
        /**
        * 在mounted接受数据消息，$on接受两个参数。
        * 第一个参数是消息事件名，应该与发送数据消息的第一个参数相同，否则接收不到数据消息
        * 第二个参数是一个函数，对数据消息事件做处理；该函数带一个参数，则是数据。
        */
        EventBus.$on('search',(val)=>{
        this.data=val;
        //示例：如果数据传递的是对象形式
        // this.data=val.data;
        })
    },
    components: {
    child,
    subItem
  }
}
</script>
```

```
// child.js 子组件
<template>
  <div>
    <input placeholder="搜索内容" @input="sendHandleEvent" v-model="searchContent"/>   //增加了@input=“sendHandleEvent”，去监听onInput事件，并回调sendHandleEvent方法
  </div>
</template>

<script type="text/ecmascript-6">
  import EventBus from './EventBus'     //导入EventBus
  export default{
    data(){
      return{
        searchContent:""
      }
    },
    methods:{
      sendHandleEvent:function(){      //定义sendHandleEvent方法，在input中监听onInput，并回调该方法
        /**
         * 通过导入的EventBus调用$emit方法去发送数据消息。
         * 第一个参数为事件名，到时候我们要通过该事件名去接收数
         * 第二个参数为数据值，如果只有一个参数，我们可以直接传递该参数
         * 如果有两个及以上的参数，我们可以通过对象的形式去传递。
         */
        EventBus.$emit("search",this.searchContent)
        //多个参数传递的示例：
        //EventBus.$emit("search",{"content":this.searchContent,"flag
        ":"flag"})
      }
    },
    props:{

    }
  }
</script>

<style>

</style>
```

```
// subItem.js 子组件的兄弟组件
<template>
    <span>
      {{data}}
    </span>
</template>

<script>
  import EventBus from './EventBus'  //导入EventBus
  export default{
    data(){
      return{
        data:''
      }
    },
    mounted(){
    /**
     * 在mounted接受数据消息，$on接受两个参数。
     * 第一个参数是消息事件名，应该与发送数据消息的第一个参数相同，否则接收不到数据消息
     * 第二个参数是一个函数，对数据消息事件做处理；该函数带一个参数，则是数据。
     */
      EventBus.$on('search',(val)=>{
        this.data=val;
      })
    }
  }
</script>
```

在上面的示例我们主要做了以下事情：
1、在父组件和兄弟组件通过在组件 mounted 生命周期中调用 EventBus.on()方法去接收子组件和兄弟组件的数据消息，并对 data 进行修改值.

### 小结

1、父组件给子组件进行数据传递可以通过 props 进行传递。

2、子组件给父组件进行消息传递或子组件给兄弟组件进行消息传递可以通过 EventBus 去实例化一个 Vue，并通过该实例的$emit 和$on 方法去传递和接收数据消息。

3、数据消息一旦发送，所有注册了接收该数据消息的地方都会接收到该数据消息。
