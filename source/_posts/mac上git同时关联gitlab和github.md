---
title: mac上git同时关联gitlab和github
categories: WEB前端
copyright: true
date: 2022-12-29 11:31:57
tags:
---
## 一、生成ssh密钥并配置
分别对gitlab和github生成对应的密钥（默认情况下本地生成的秘钥位于/Users/用户名/.ssh/）
### 1 、生成gitlab密钥并配置
    打开Timinal终端，输入命令：
```
ssh-keygen -t rsa -C “公司邮箱地址”
```
生成对应的`gitlab`密钥：id_rsa和id_rsa.pub，将gitlab公钥即id_rsa.pub（Mac下路径为/Users/用户名/.ssh/）中的内容配置到公司的gitlab上。
### 2、生成github密钥并配置
在Timinal终端中输入命令：
```
ssh-keygen -t rsa -C “github邮箱地址” -f  ~/.ssh/github_rsa
```
生成对应的github密钥：github_rsa和github_rsa.pub，将github公钥即github_rsa.pub中的内容配置到自己的github上。
### 3、配置git，访问不同host时使用不同的密钥。
进入密钥生成的位置（/Users/用户名/.ssh/），手动创建一个config文件（注意这个config文件要无后缀）。
在新建的config文件里面配置如下内容：
```
Host github.com
HostName github.com
User xxx@xxx.com       //user后边为github的邮箱
IdentityFile ~/.ssh/github_rsa

Host gitlab.xxx.cn    //host后边为公司gitlab域名
HostName gitlab.xxx.cn   //同上为公司gitlab域名
User xxx@xxx.com          //user后为gitlab的邮箱
IdentityFile ~/.ssh/id_rsa
备注：公司内网地址，设置HostName时需要注意，复制公司gitlab或者自己的github地址时，需要把”https://" 去掉。
```
### 二、验证是否设置成功
 打开Timinal终端，分别输入命令：
测试github
```
  ssh -T git@github.com
```
测试gitlab(@符后面的为公司gitlab地址)
```
ssh -T git@gitlab.xxx.com
```
