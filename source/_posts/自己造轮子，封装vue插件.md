---
title: 自己造轮子——封装vue插件
categories: WEB前端
copyright: true
date: 2018-05-22 09:21:02
tags:
---

### 起因

当我们在开发一个项目时，有一个使用次数很多的组件。例如：`loading`动画、`toast`弹出框。如果每个使用的地方，我们都需要引用一次，那么很显然代码不优美。并且会添加很多无用的代码。于是 `vue` 插件的封装就上场了。<!--more-->

### 不同形式的封装和调用

首先定义两个文件夹：分别是`loading`、`toast`.各自文件夹下面定义一个`index.js`和`.vue`模板。

这两个插件的区别是：`loading`插件作为组件引入使用，而`toast`是直接挂载使用，通过方法改变状态使用。所以就有了不同的封装方法。

### 封装 toast 插件

`toast` 文件夹下有两个文件，后缀为 `vue` 的文件就是这个插件的模板，`js` 文件一个是将这个模板放入 `Vue` 全局中，并写明操作逻辑。

`toast.vue`的文件内容如下：

```
<template>
    <transition name="fade">
        <div class="toast" v-show="show">
            {{message}}
        </div>
    </transition>
</template>

<script>
export default {
  data() {
    return {
      show: false,
      message: ""
    };
  }
};
</script>

<style lang="scss" scoped>
.toast {
  position: fixed;
  top: 40%;
  left: 50%;
  margin-left: -15vw;
  padding: 2vw;
  width: 30vw;
  font-size: 4vw;
  color: #fff;
  text-align: center;
  background-color: rgba(0, 0, 0, 0.8);
  border-radius: 5vw;
  z-index: 999;
}

.fade-enter-active,
.fade-leave-active {
  transition: 0.3s ease-out;
}
.fade-enter {
  opacity: 0;
  transform: scale(1.2);
}
.fade-leave-to {
  opacity: 0;
  transform: scale(0.8);
}
</style>
```

这里的主要内容就是决定是否显示的`show`值和显示的内容`message`.

`index.js`内容如下：

```
import ToastComponent from './toast.vue'
const Toast = {};

// 注册Toast
Toast.install = function (Vue) {

    // 生成一个Vue的子类
    // 同时这个子类也就是组件
    const ToastConstructor = Vue.extend(ToastComponent)

    // 生成一个该子类的实例
    const instance = new ToastConstructor();

    // 将这个实例挂载在我创建的div上
    // 并将此div加入全局挂载点内部
    instance.$mount(document.createElement('div'))
    document.body.appendChild(instance.$el)

    // 通过Vue的原型注册一个方法
    // 让所有实例共享这个方法
    Vue.prototype.$toast = (msg, duration = 2000) => {
        instance.message = msg;
        instance.show = true;
        setTimeout(() => {
            instance.show = false;
        }, duration);
    }
}

export default Toast
```

这里主要是经过以下几步:

1.  创建一个空对象，这个对象就是日后要使用到的插件的名字。此外，这个对象中要有一个 `install` 的函数。

2.  使用 `vue` 的 `extend` 方法创建一个插件的构造函数（可以看做创建了一个 `vue` 的子类），实例化该子类，之后的所有操作都可以通过这个子类完成。

3.  之后再 `Vue` 的原型上添加一个共用的方法。

###　 toast 插件的调用

首先在修改`main.js`如下：

```
// 添加toast插件
import Toast from './components/toast';
Vue.use(Toast);
```

然后在`.vue`文件中使用：

```
// app.vue
<template>
  <div id="app">
    <button @click="toast">显示toast弹出框</button>
  </div>
</template>

<script>
export default {
  data() {
    return {

    };
  },
  methods: {
    toast() {
      this.$toast("hello world");
    }
  }
};
</script>

<style>

</style>
```

### 封装 loading 插件

`loading.vue`内容如下：

```
<template>
    <div class='wrapper' v-if="show">
        <div class='loading'>
            <img src="./loading.gif" alt="" width="40" height="40">
        </div>
    </div>
</template>

<script>
export default {
  name: 'Loading',
  props: {
    duration: {
      type: String,
      default: "1s" //默认1s
    },
    show: {
      type: Boolean,
      default: false
    }
  },
  data: function() {
    return {};
  }
};
</script>

<style lang="scss" scoped>

</style>
```

`index.js`文件内容如下：

```
import LoadingComponent from './loading.vue'

let Loading = {};

Loading.install = (Vue) => {
Vue.component(LoadingComponent.name, LoadingComponent)
}

export default Loading;
```

### loading 插件的调用

首先，修改`main.js`文件：

```
// 添加插件
import Loading from './components/loading';
Vue.use(Loading);
```

需要使用插件的`.vue`的文件调用：

```
// app.vue
<template>
  <div id="app">
    <loading duration='2s' :show='show'></loading>
    <button @click="show = !show">显示/隐藏loading</button>
  </div>
</template>

<script>
export default {
  data() {
    return {
      show: false
    };
  },
  methods: {

  }
};
</script>
```

以上就是`vue`插件的封装方法。

### 小结

这些封装的插件我们是在我们自己的项目中使用。其实我们可以把封装好的插件发布成`npm`包，这样想使用的人都可以使用了。
