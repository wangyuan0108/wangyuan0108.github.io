---
title: vue再遇监视对象改变
categories: WEB前端
copyright: true
date: 2017-12-15 15:24:52
tags:
---

## 造坑

在 vue 项目中，我们都知道对吸引人的莫过于数据的双向绑定。今天我要说的就是在数据绑定操作中遇到的问题。话不多说，上代码：

```
<h5>互动记录</h5>
<div class="check_box_style">
    <el-form-item :label="`${item}届`" v-for="item in enumsConfig.SysExpert.active" :key="item.id">
        <span class="box_style">
            <span v-for="(ele,index) in enumsConfig.SysExpert.status" :key="index" style="margin-right:10px;" class="colorC" :class="{ colorActive: expert_status_map[item] && expert_status_map[item].includes(ele.key) }" @click="setExpertStatus(item,ele.key)">{{ele.title}}</span>
        </span>
    </el-form-item>
</div>
```

<!-- more -->

主要需求就是根据`enumsConfig.SysExpert.status`中的`key`在不在`expert_status_map[item]`来高亮。

## 过程

1. 当我在做这个组键的时候，是有编辑页面和添加页面公用同一个页面，所以在业务逻辑上面有一点分歧。首先，在需求上面，编辑页面的互动记录是点击每一个按钮，都调用一次接口。对数据进行操作。但是在添加页面的时候，只是最后一起把按钮选择的数据传过去。

2. 重点是`expert_status_map`需要一个类似这样的数据结构

```
{
    2016:[a,b,c],
    2017:[b,c,e]
}
```

3. 然后我`data`中存的`expert_status_map`数据是个空对象，所以传统的赋值`this.expert_status_map[item] = []`看似很成功，但是在操作的时候，发现虽然数据改变了，但是`html`高亮并没有发生变化。

## 解决

最后看了 vue 官方文档：

![vue](http://images.wangyuanweb.top/vue.png)

这样赋值：

```
this.$set(this.expert_status_map, item, []);
```
这样vue就能检测到数据的变化啦！