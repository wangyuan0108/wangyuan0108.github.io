---
title: css布局自省
categories: WEB前端
copyright: true
date: 2018-11-01 10:09:50
tags:
    - css
    - 布局
---

### 背景

布局是我们前端开发中不可避免的，简单回忆一下 css 的布局方案，供大家参考以及自己参阅。

### 居中布局

这里的居中布局是不定宽度为前提，固定宽度情况也包含其中。

#### 水平居中

1. `inline-block + text-align`

```
.parent {
    text-align: center;
}

.child {
    display: inline-block;
}
```

<!--more-->

这个方案的兼容性比较好，可兼容到 IE8，对于 IE567 不支持`inline-block`,需要使用 css hack 进行兼容。

2. `table + margin`

```
.child {
    display: table;
    margin: 0 auto;
}
```

这个方案兼容到 IE8，可以使用<table />代替 css 写法，兼容性更好。

3. `absolute + transform`

```
.parent {
    position:relative;
    height:1.5em;
}
.child {
    position:absolute;
    left:50%;
    transform:translateX(-50%);
}
```

这个方案兼容到 IE9，因为`transform`兼容性导致，如果`.child`为定宽元素，可以使用以下写法，提高兼容性。

```
.parent {
    position: relative;
    height:1.5em;
}
.child {
    position: absolute;
    width:100px;
    left:50%;
    margin-left:-50%;
}
```

4. `flex + justify-content`

```
.parent {
    display:flex;
    justify-content;
}
.child {
    margin:0 auto;
}
```

flex 布局很强大，但是受到兼容的限制。不考虑兼容可以大胆使用。

#### 垂直居中布局

1. `table-cell + vertial-align`

```
.parent {
    display: table-cell;
    vertical-align: middle;
}
```

此方案可以用<table />替换，提高兼容性。

2. `absolute + transform`

```
.parent {
    position: relative;
}
.child {
    position: absolute;
    top: 50%;
    transform: translateY(-50%);
}
```

css3 新属性兼容性不是很好。

3. `flex + align-items`

```
.parent {
    display: flex;
    align-items: center;
}
```

兼容性不是很好,不考虑低版本浏览器。

#### 水平垂直居中

1. `inline-block + table-cell + text-align + vertical-align`

```
.parent{
	text-align: center;
	display: table-cell;
	vertical-align: middle;
}
.child{
	display: inline-block;
}
```

兼容到 IE8.

2. `absolute + transform`

```
.parent{
	position: relative;
}
.child{
	position: absolute;
	left: 50%;
	top: 50%;
	transform: translate(-50%,-50%);
}
```

兼容性差，兼容 IE10 以上

3. `flex`

```
.parent{
	display: flex;
	justify-content: center;
	align-items: center;
}
```

兼容差

### 多列布局

#### 一列定宽，一列自适应

1. `float + margin`

```
.left{
	float: left;
	width: 100px;
}
.right{
	margin-left: 120px;
}
```

此方案对于定宽布局比较好，不定宽布局推荐下面方法 2.

2. `float + overflow`

```
.left{
	float: left;
	width: 100px;
	margin-right: 20px;
}
.right{
	overflow: hidden;
}
```

此方案不管是多列定宽或是不定宽，都可以完美实现，同时可以实现等高布局。

3. `table`

```
.parent{
	display: table; width: 100%;
	table-layout: fixed;
}
.left,.right{
	display: table-cell;
}
.left{
	width: 100px;
	padding-right: 20px;
}
```

4. `flex`

```
.parent{
	display: flex;
}
.left{
	width: 100px;
	padding-right: 20px;
}
.right{
	flex: 1;
}
```

#### 多列定宽，一列自适应

1. `float + overflow`

```
.left,.center{
	float: left;
	width: 100px;
	margin-right: 20px;
}
.right{
	overflow: hidden;
}
```

2. `table`

```
.parent{
	display: table; width: 100%;
	table-layout: fixed;
}
.left,.center,.right{
	display: table-cell;
}
.right{
	width: 100px;
	padding-right: 20px;
}
```

3. `flex`

```
.parent{
	display: flex;
}
.left,.center{
	width: 100px;
	padding-right: 20px;
}
.right{
	flex: 1;
}
```

#### 一列不定宽，一列自适应

1. `float + overflow`

```
.left{
	float: left;
	margin-right: 20px;
}
.right{
	overflow: hidden;
}
.left p{width: 200px;}
```

2. `table`

```
.parent{
	display: table; width: 100%;
}
.left,.right{
	display: table-cell;
}
.left{
	width: 0.1%;
	padding-right: 20px;
}
.left p{width:200px;}
```

3. `flex`

```
.parent{
	display: flex;
}
.left{
	margin-right: 20px;
}
.right{
	flex: 1;
}
.left p{width: 200px;}
```

#### 多列不定宽，一列自适应

1. `float + overflow`

```
.left,.center{
	float: left;
	margin-right: 20px;
}
.right{
	overflow: hidden;
}
.left p,.center p{
	width: 100px;
}
```

#### 等分

1. `float + margin`

```
.parent{
	margin-left: -20px;
}
.column{
	float: left;
	width: 25%;
	padding-left: 20px;
	box-sizing: border-box;
}
```

2. `table + margin`

```
.parent-fix{
	margin-left: -20px;
}
.parent{
	display: table;
	width:100%;
	table-layout: fixed;
}
.column{
	display: table-cell;
	padding-left: 20px;
}
```

3. `flex`

```
.parent{
	display: flex;
}
.column{
	flex: 1;
}
.column+.column{
	margin-left:20px;
}
```

#### 等高

1. `float + overflow`

```
.parent{
	overflow: hidden;
}
.left,.right{
	padding-bottom: 9999px;
	margin-bottom: -9999px;
}
.left{
	float: left; width: 100px;
}
.right{
	overflow: hidden;
}
```

2. `table`

```
.parent{
	display: table;
	width: 100%;
}
.left{
	display:table-cell;
	width: 100px;
	margin-right: 20px;
}
.right{
	display:table-cell;
}
```

3. `flex`

```
.parent{
	display:flex;
	width: 100%;
}
.left{
	width: 100px;
}
.right{
	flex:1;
}
```
### 并排等分，单排对齐靠左布局

#### flex

```
.main {
    display: flex;
    flex-flow: row wrap;
    justify-content: space-between;
}
.item {
    display: inline-block;
}
.empty{
    height: 0;
    visibility: hidden;
}
```

### 圣杯布局&双飞翼布局

#### 圣杯布局

```
<div class="container">
    <div class="header">header</div>
    <div class="wrapper clearfix">
        <div class="main col">main</div>
        <div class="left col">left</div>
        <div class="right col">right</div>
    </div>
    <div class="footer">footer</div>
</div>



.container {width: 500px; margin: 50px auto;}
.wrapper {padding: 0 100px 0 100px;}
.col {position: relative; float: left;}
.header,.footer {height: 50px;}
.main {width: 100%;height: 200px;}
.left {width: 100px; height: 200px; margin-left: -100%;left: -100px;}
.right {width: 100px; height: 200px; margin-left: -100px; right: -100px;}
.clearfix::after {content: ""; display: block; clear: both; visibility: hidden; height: 0; overflow: hidden;}
```

#### 双飞翼布局

```
<div class="container">
    <div class="header">header</div>
    <div class="wrapper clearfix">
        <div class="main col">
            <div class="main-wrap">main</div>
        </div>
        <div class="left col">left</div>
        <div class="right col">right</div>
    </div>
    <div class="footer">footer</div>
</div>




.col {float: left;}
.header {height: 50px;}
.main {width: 100%;}
.main-wrap {margin: 0 100px 0 100px;height: 200px;}
.left {width: 100px; height: 200px; margin-left: -100%;}
.right {width: 100px; height: 200px; margin-left: -100px;}
.footer {height: 50px;}
.clearfix::after {content: ""; display: block; clear: both; visibility: hidden; height: 0; overflow: hidden;}
```

### 定位布局

```
<div class="header">header</div>
<div class="wrapper">
    <div class="main col">
        main
    </div>
    <div class="left col">
        left
    </div>
    <div class="right col">
        right
    </div>
</div>
<div class="footer">footer</div>



.wrapper { position: relative; }
.main { margin:0 100px;}
.left { position: absolute; left: 0; top: 0;}
.right { position: absolute; right: 0; top: 0;}
```
