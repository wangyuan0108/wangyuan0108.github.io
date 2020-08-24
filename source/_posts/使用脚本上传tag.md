---
title: 使用脚本上传tag
categories: WEB前端
copyright: true
date: 2020-08-24 14:18:16
tags:
---

## 使用脚本上传创建 tag

我们在创建 tag 时有两种方式，一种是在 gitlab 上进行创建提交，还有一种是在命令行通过 git 命令来进行提交。但是在实际开发中，发现操作的步骤比较繁琐和重复，故而思考使用 script 脚本来生成 tag，方便操作和提升效率。<!--more-->

```bash
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

然后使用命令行

```bash
sh ./tag.sh
```

配置成 script 命令简化操作

```json
"scripts": {
    "tag": "sh ./tag.sh"
  },
```

执行命令按提示生成 tag

```bash
npm run tag
```
