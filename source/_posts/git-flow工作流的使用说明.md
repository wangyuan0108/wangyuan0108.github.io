---
title: git flow工作流的使用说明
categories: WEB前端
copyright: true
date: 2020-03-23 13:42:12
tags:
---

### 前言

在代码开发过程中，代码的版本管理是必不可少的。现在大部分使用的都是 git 版本管理工具，关于 git 的优点和安装使用方式我就不一一叙述了，需要的可以自行百度。这里我主要记录下当前比较流行的 git-flow 工作流的安装和使用。<!--more-->

### git flow 工作流简介

git flow 是 git 分支和发行版管理工作流程，可帮助开发人员跟踪大型软件项目中的功能，修补程序和发行版。这个工作流程有很多命令可以输入和记住，因此还有 git 子命令的 git-flow 库，可以帮助自动化流程的某些部分，从而使流程更容易使用。

### git fow 安装

以 mac 电脑为例，列举几种安装方式

- 通过 Homebrew 进行安装

```bash
brew install git-flow-avh
```

- 通过 wget 进行安装

```bash
wget --no-check-certificate -q -O - https://github.com/petervanderdoes/gitflow-avh/raw/develop/contrib/gitflow-installer.sh install stable| sudo bash
```

- 通过 curl 进行安装

```
curl -sL https://github.com/petervanderdoes/gitflow-avh/raw/develop/contrib/gitflow-installer.sh | sudo bash -s install stable
```

- 通过 github 仓库手动安装

1. 首现 clone 下官方的仓库

```bash
git clone git://github.com/petervanderdoes/gitflow.git
```

2. 进入到项目文件夹执行命令

```bash
sudo make install
```

### git flow 默认分支介绍

1. master 分支存放所有正式发布的版本，可以作为项目历史版本记录分支，不直接提交代码。仅用于保持一个对应线上运行代码的 code base。

2. develop 分支为主开发分支，一般不直接提交代码

3. feature 分支为新功能分支，feature 分支都是基于 develop 创建的，开发完成后会合并到 develop 分支上。同时存在多个

4. release 分支基于最新 develop 分支创建，当新功能足够发布一个新版本(或者接近新版本发布的截止日期)，从 develop 分支创建一个 release 分支作为新版本的起点，用于测试，所有的测试 bug 在这个分支改。测试完成后合并到 master 并打上版本号，同时也合并到 develop，更新最新开发分支。(一旦打了 release 分支之后不要从 develop 分支上合并新的改动到 release 分支)，同一时间只有 1 个，生命周期很短，只是为了发布。

5. hotfix 分支基于 master 分支创建，对线上版本的 bug 进行修复，完成后直接合并到 master 分支和 develop 分支，如果当前还有新功能 release 分支，也同步到 release 分支上。同一时间只有 1 个，生命周期较短

### git flow 常用命令

- git flow init：初始化一个现有的 git 库,将会设置一些初始的参数，如分支前缀名等，建议用默认值。

- git flow feature start [featureBranchName]: 创建一个基于'develop'的 feature 分支，并切换到这个分支之下。

- git flow feature finish [featureBranchName]: 完成开发新特性, 合并 MYFEATURE 分支到 'develop', 删除这个新特性分支, 切换回 'develop' 分支。

- git flow feature publish [featureBranchName]：发布新特性分支到远程服务器，也可以使用 git 的 push 命令

- git flow feature pull origin [featureBranchName]：取得其它用户发布的新特性分支，并签出远程的变更。也可以使用 git 的 pull 命令

- git flow feature track [featureBranchName]：跟踪在 origin 上的 feature 分支。

- git flow release start [releaseBranchName]：开始准备 release 版本，从 'develop' 分支开始创建一个 release 分支。

- git flow release publish [releaseBranchName]：创建 release 分支之后立即发布允许其它用户向这个 release 分支提交内容。

- git flow release track [releaseBranchName]：签出 release 版本的远程变更。

- git flow release finish [releaseBranchName]：归并 release 分支到 'master' 分支，用 release 分支名打 Tag，归并 release 分支到 'develop'，移除 release 分支。

- git flow hotfix start [hotfixBranchName]：开始 git flow 紧急修复，从 master 上建立 hotfix 分支。

- git flow hotfix finish [hotfixBranchName]：结束 git flow 紧急修复，代码归并回 develop 和 master 分支。相应地，master 分支打上修正版本的 TAG。

### 使用方法

- 使用基本分支结构初始化新的存储库

```bash
// 初始化项目仓库
git flow init [-d]
```

-d 参数是接受默认配置

- 新需求开发新建新的功能分支

```bash
// 列出所有功能分支
git flow feature
// 开始新建一个新的功能分支
git flow feature start <name> [<base>]
// 完成一个新的功能分支
git flow feature finish <name>
// 删除当前分支
git flow feature delete <name>
// 开放当前分支可以让其他人提交
git flow feature publish <name>
// 签出当前分支版本的远程变更
git flow feature track <name>
```

- 处理测试待发布分支

```bash
// 列出待发布分支
git flow release
// 开始创建一个待发布分支
git flow release start <release> [<base>]
// 完成一个待发布分支
git flow release finish <release>
// 删除一个待发布分支
git flow release delete <release>
```

- 线上问题修复分支

```bash
// 列出修复分支
git flow hotfix
// 创建开始一个修改分支
git flow hotfix start <release> [<base>]
// 结束一个修改分支
git flow hotfix finish <release>
// 删除一个修改分支
git flow hotfix delete <release>
```

- 支持分支

```bash
// 列出支持分支
git flow support
// 开始一个支持分支
git flow support start <release> <base>
```

就简单写下自己知道的，为了防止以后忘记。
