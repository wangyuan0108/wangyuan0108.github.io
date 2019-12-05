---
title: 在react函数式组件中用hook使用debounce和throttle工具函数
categories: WEB前端
copyright: true
date: 2019-12-05 10:53:48
tags:
---

### 简述

之前在 react 的类组件中就使用过 lodash 的防抖和节流的工具函数，具体可查看文章。但是当 hook 盛行的时候，我也尝试用这种方式来从新使用一次，但是在使用的过程中出现了挖坑填坑，特此记录下，方便自己查看。<!--more-->

### 事例

```js
import React, { useCallback } from 'react'
import { debounce } from 'lodash'

// 定义一个滚动的事件函数
const onOwnScroll = e => {
  e.persist()
  if (e.target) {
    const { target } = e
    if (target.scrollTop + target.offsetHeight === target.scrollHeight && data.length < total) {
      onPopupScroll() // 父组件方法
    }
  }
}
// 定义一个防抖使用函数
const debounceFnSearch = useCallback(debounce(onSearch, 1000), [loading])
```

### 解释

这里遇到的坑就是，我之前是这样写的

```js
const debounceFnSearch = useCallback(debounce(onSearch, 1000))
```

我想在事件结束后更新 loading 的状态，但是 loading 的状态没有更新,最后知道防抖原来有数据缓存，需要传入需要更新的值

```js
const debounceFnSearch = useCallback(debounce(onSearch, 1000), [loading])
```

以上就是踩的小坑，记录下
