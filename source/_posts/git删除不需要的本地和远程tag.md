---
title: git删除不需要的本地和远程tag
categories: WEB前端
copyright: true
date: 2020-06-10 18:03:32
tags:
  - git
  - 工具
---

### 背景
我们在用git做代码管理的时候，当一个需求结束需要做个节点记录。我们一般都会打一个tag作为一个节点记录，但是在打tag的过程中难免会出问题，有时我们需要删除掉不需要的tag。<!--more-->

### 操作
以tag 1.0.0为例，这个tag已经同步到远程，但是现在发现了一个问题，需要撤回该tag，git命令如下：

删除本地tag

```bash
git tag -d 1.0.0
```

删除远程tag

```bash
git push origin :refs/tags/1.0.0
```
