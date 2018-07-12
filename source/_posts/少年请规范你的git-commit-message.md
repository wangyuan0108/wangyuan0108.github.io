---
title: 少年请规范你的git commit message
categories: WEB前端
copyright: true
date: 2018-07-12 14:05:56
tags:
- git
- 技巧
---

### 背景

我们在开发代码的时候，都会用到代码版本控制工具（这里主要讲 git）。我们在用 git 的时候，不管是单人开发还是多人合作，我们都需要提交 commit 日志`git commit`。如果我们的提交日志写的很随意的话，不仅没有语义，而且以后查起来也难，还影响合作的开发效率，这里就简单说下提交日志的规范，仅供参考。<!--more-->

### 规范

社区有多种 commit message 的写法规范，但是用的较多的是 angular 规范。也是比较合理和系统化的，还有配套的使用工具。

### commit message 的格式化

每次提交的 commit message 都包括三个部分：header, body 和 footer。

```
<type>(<scope>):<subject>
//空行
<body>
//空行
<footer>
```

其中 header 是必须的但是其 scope 是可选的，body 和 footer 可以省略。
注意：commit message 的任何行不能超过 100 个字符，方便阅读。

#### header

header 部分只有一行：type、scope 和 subject。

1.  type

type 用于说明 commit 的类别，只允许下面 7 个标识。

```
* feat：新功能（feature）
* fix：修补bug
* docs：文档（documentation）
* style： 格式（不影响代码运行的变动）
* refactor：重构（即不是新增功能，也不是修改bug的代码变动）
* test：增加测试
* perf：代码更改，提高了性能
* build：影响构建系统或外部依赖的改变
* ci：改变ci配置文件和脚本
* chore：构建过程或辅助工具的变动
* revert：恢复以前的提交
```

如果 type 为 feat 和 fix，则该 commit 将肯定出现在 Change log 之中。其他情况（docs、chore、style、refactor、test）由你决定，要不要放入 Change log，建议是不要。

2.  scope

scope 用于说明 commit 影响的范围，比如数据层、控制层、视图层等等，视项目不同而不同。

3.  subject

subject 是 commit 目的的简短描述，不超过 50 个字符。

```
* 以动词开头，使用第一人称现在时，比如change，而不是changed或changes
* 第一个字母小写
* 结尾不加句号（.）
```

#### body

Body 部分是对本次 commit 的详细描述，可以分成多行。
注意：

使用第一人称现在时，比如使用 change 而不是 changed 或 changes。
应该说明代码变动的动机，以及与以前行为的对比。

#### footer

footer 分两种情况：

-   不兼容变动：如果当前代码与上一个版本不兼容，则 Footer 部分以 BREAKING CHANGE 开头，后面是对变动的描述、以及变动理由和迁移方法。
-   关闭 Issue：如果当前 commit 针对某个 issue，那么可以在 Footer 部分关闭这个 issue 。

#### revert

还有一种特殊情况，如果当前 commit 用于撤销以前的 commit，则必须以 revert:开头，后面跟着被撤销 Commit 的 Header。

```
revert: feat(pencil): add 'graphiteWidth' option

This reverts commit 667ecc1654a317a13331b17617d973392f415f02.
```

body 部分的格式是固定的，必须写成 This reverts commit <hash>.，其中的 hash 是被撤销 commit 的 SHA 标识符。

### commitizen

commitizen 是一个格式化 commit message 的工具。

#### 全局安装

```
npm install -g commitizen cz-conventional-changelog
```

然后，在项目目录下，运行下面的命令，使其支持 angular 的 commit message 格式

```
commitizen init cz-conventional-changelog --save --save-exact
```

#### 项目根目录安装

```
npm install -D commitizen cz-conventional-changelog
```

package.json 中配置:

```
"script": {
    ...,
    "commit": "git-cz",
},
 "config": {
    "commitizen": {
      "path": "node_modules/cz-conventional-changelog"
    }
  }
```

以后，凡是用到 git commit 命令，一律改为使用 git cz

### commitlint

#### commitlint 检验 commit message 格式

commitlint: 可以帮助我们 lint commit messages, 如果我们提交的不符合指向的规范, 直接拒绝提交.同样的, 它也需要一份校验的配置, 这里推荐 @commitlint/config-conventional (符合 Angular 团队规范).

```
// 安装

npm i -D @commitlint/config-conventional @commitlint/cli
```

同时需要在项目目录下创建配置文件.commitlintrc.js,如下

```
module.exports = {
  extends: [
    '@commitlint/config-conventional'
  ],
  rules: {
  }
};
```

#### 结合 husky 使用

校验 commit message 的最佳方式是结合 git hook, 所以需要配合 Husky.

```
// 安装

npm i husky@next
```

然后在 package.json 中添加：

```
"husky": {
    "hooks": {
      "commit-msg": "commitlint -e"
    }
  }
```

### 生成 change log

如果你的所有 Commit 都符合 Angular 格式，那么发布新版本时， Change log 就可以用脚本自动生成。

生成的文档包括以下三个部分。

```
* New features
* Bug fixes
* Breaking changes.
```

每个部分都会罗列相关的 commit ，并且有指向这些 commit 的链接。当然，生成的文档允许手动修改，所以发布前，你还可以添加其他内容。

#### conventional-changelog 就是生成 Change log 的工具。

运行如下命令:

```
npm install -g conventional-changelog-cli
$ cd my-project
$ conventional-changelog -p angular -i CHANGELOG.md -s
```

上面命令不会覆盖以前的 Change log，只会在 CHANGELOG.md 的头部加上自从上次发布以来的变动。

如果你想生成所有发布的 Change log，要改为运行下面的命令。

```
conventional-changelog -p angular -i CHANGELOG.md -s -r 0
```

为了方便使用，可以将其写入 package.json 的 scripts 字段。

```
{
  "scripts": {
    "changelog": "conventional-changelog -p angular -i CHANGELOG.md -s -r 0"
  }
}
```

然后直接执行：

```
npm run changelog
```
