---
title: 再遇Event对象使用场景
categories: WEB前端
copyright: true
date: 2017-11-03 19:33:43
tags:
- javascript
---

## 起因

在项目开发中遇到了这样一个需求：在上传图片过程中，之前是通过直接点击`input`标签的`type='file'`来实现选择和浏览本地文件。

但是,现在遇到的问题是，通过点击其他的按钮来触发这个节点的点击事件。<!--more-->开始觉得绑定一个点击的click事件，最后发现不能够自动触发上传文件的点击，然后搜索了一下，想起来了`event`事件对象，然后结合之前学习的，又看了一下资料，记录一下解决问题的历程。

## Event对象

Event对象本身是一个构造函数，所以，既然是对象，就可以实例化：

        event = new Event('click');

Event构造函数接受两个参数。第一个参数是字符串，表示事件的名称；第二个参数是一个对象，表示事件对象的配置。该参数可以有以下两个属性。

        event = new Event(eventName, configObj);

其中configObj有两个配置参数

        bubbles：布尔值，可选，默认为false，表示事件对象是否冒泡。
        cancelable：布尔值，可选，默认为false，表示事件是否可以被取消。

当我们触发这个对象生成的事件用`dispatchEvent`方法

        let event = new Event('click');
        dom.dispatchEvent(event);

这样就可以点击其他节点，触发本节点的事件了。

        const event = new Event('click');
        document.querySelector('.el-upload.el-upload--text').dispatchEvent(event);

用这种方法就可以解决上述问题了。     

