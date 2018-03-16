---
title: js统计数组中元素出现的次数所引出的思考
categories: WEB前端
copyright: true
date: 2018-03-16 15:07:54
tags:
---
## 有需求才有动力

在做项目的时候，有表格数据的展示。在后端的给的数据，前台显示的时候需要知道每个数据的`key`出现的次数。然后我就想了一下，基本解决需求。下面是我的实现方式。
<!--more-->

## 统计次数

```
function getCount(arr){ 
    var obj = {}, k, arr1 = [];
    for (var i = 0, len = arr.length; i < len; i++) {
        k = arr[i];
        if (obj[k]) 
            obj[k]++;
        else 
            obj[k] = 1;
    }
    //保存结果{el-'元素'，count-出现次数}
    for (var o in obj) {
        arr1.push({el: o, count: obj[o]});
    }
```

这里说明一下，首先定义一个函数`getCount`.参数是一个数组，然后里面的具体逻辑就直接看代码吧···

## 需求改变

这时，产品经理过来说这个个数是统计出来了，但是排序有点混乱啊！万一客户需要排序呢？（心里想你是客户吧！！）。没办法，改喽！！

```
function getCount(arr, ranktype){ 
    var obj = {}, k, arr1 = [];
    for (var i = 0, len = arr.length; i < len; i++) {
        k = arr[i];
        if (obj[k]) 
            obj[k]++;
        else 
            obj[k] = 1;
    }
    //保存结果{el-'元素'，count-出现次数}
    for (var o in obj) {
        arr1.push({el: o, count: obj[o]});
    }
    //排序（降序）
    arr1.sort(function (n1, n2) {
        return n2.el - n1.el
    });
    //如果ranktype为1，则为升序，反转数组
    if(ranktype===1){
        arr1=arr1.reverse();
    }
    return arr1;
}
```
这样加一点代码，就实现了。默认是降序排的，如果参数`ranktype`为1就是升序！

## 需求又来了！！！（我要拿刀了！！！）

这时，产品经理过来说排序是出来了，万一客户需要取出一部分排序呢？（心里想你是客户吧！！）。没办法，改喽！！

```
function getCount(arr, rank,ranktype){ 
    var obj = {}, k, arr1 = [];
    for (var i = 0, len = arr.length; i < len; i++) {
        k = arr[i];
        if (obj[k]) 
            obj[k]++;
        else 
            obj[k] = 1;
    }
    //保存结果{el-'元素'，count-出现次数}
    for (var o in obj) {
        arr1.push({el: o, count: obj[o]});
    }
    //排序（降序）
    arr1.sort(function (n1, n2) {
        return n2.count - n1.count
    });
    //如果ranktype为1，则为升序，反转数组
    if(ranktype===1){
        arr1=arr1.reverse();
    }
    var rank1 = rank || arr1.length;
    return arr1.slice(0,rank1);
}
```
这样加一点代码，一个判断参数就又实现了。`rank`排序的前几位。


