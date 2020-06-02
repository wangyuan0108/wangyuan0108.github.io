---
title: 自动打tag脚本
categories: WEB前端
copyright: true
date: 2020-06-02 15:20:38
tags:
  - git
  - 工具
---

### 背景

在代码管理过程中，我们每次上线完一个功能之后，我们都需要对当前的代码进行一个完结的节点。在 git 上我们一般是把当前的代码发布为一个 tag。<!--more-->

### 方法

1. 一种方式是通过 git 的命令，我们手动打完 tag，然后在上传到远程仓库

2. 还有就是我们到远程仓库的网站上进行打 tag。

以上的方式我都试过，感觉还是有点繁琐，于是就想着本地执行一个 shell 脚本自动打好 tag 并上传到远程，代码如下

```sh
#!/bin/bash
# 拉取分支上现有的tags

git fetch --tags

echo "所有tag列表"
git tag -l -n

echo "${tagList}"
#获取最新版本tag
LatestTag=$(git describe --tags `git rev-list --tags --max-count=1`)

echo "最新版本tag......"
echo "$LatestTag"

echo "请输入要新增的版本号...... 如 v1.0.1"
#输入tag名称
read tagName

git tag ${tagName}
#推到分支上
git push origin ${tagName}
```

- 将本代码放到项目根目录下比如我命名为 tag.sh

- 在 package.json 文件中配置脚本命令

```js
"tag": "sh ./tag.sh"
```

- 然后命令行中执行`npm run tag`然后填入每次的 tag 名字就可以了
