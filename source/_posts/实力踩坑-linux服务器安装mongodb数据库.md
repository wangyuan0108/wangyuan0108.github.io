---
title: 实力踩坑--linux服务器安装mongodb数据库
categories: WEB前端
copyright: true
date: 2018-06-08 09:25:55
tags: 
- mongodb
- linux
- 服务器
---

### 简述

在使用 node 做为服务端的时候，我配合使用的是 mongodb 数据库。因为 mongodb 数据库是 json 格式的，对前端入门数据库相对比较友好。所以果断选择，但是在服务器上安装确实出现了很多问题。好在最后得到解决，这里记录下自己的实践过程。<!--more-->

### 使用 yum 安装 mongodb

我这里使用的是 yum 安装，虽然还有其他安装方法。比如：源码安装。但是我觉得这个方法比较简单、简便。并且对新手比较友好。

-   首先查看下 linux 服务器上是否存在 mongodb 的 yum 源。

```
// 切换到目录
cd /etc/yum.repos.d

// 使用ls命令查看文件
ls
```

-   如果没有则添加 yum 源

```
// 创建文件
touch mongodb-3.6.repo

// 编辑该文件
vim mongodb-3.6.repo

// 编辑内容
[mongodb-org-3.6]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.6/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-3.6.asc
```

简单说明一下，这里的 3.6 是版本号，大家可以安装自己喜欢的版本，直接修改这个版本号就行了，其他不变。

-   使用 yum 命令安装

```
yum install -y mongodb-org
```

这里注意一下，如果没有权限，那么就执行以下代码：

```
sudo yum install -y mongodb-org
```

安装完毕后，修改下配置文件：

```
// 修改配置文件的 bind_ip, 默认是 127.0.0.1 只限于本机连接。所以安装完成后必须把这个修改为 0.0.0.0 ,否则通过别的机器是没法连接的!
vim /etc/mongod.conf
```

-   启动、停止、重新启动 mongodb

MongoDB 默认将数据文件存储在/var/lib/mongo 目录，默认日志文件在/var/log/mongodb 中。如果要修改,可以在 /etc/mongod.conf 配置中指定备用日志和数据文件目录。

```
// 启动
service mongod start

// 停止
service mongod stop

// 重启
service mongod restart
```

查看 mongoDB 是否启动成功,可以通过查看日志文件

```
cat /var/log/mongodb/mongod.log
```

如果日志文件出现如下一句说明则成功

```
[initandlisten] waiting for connections on port <port>
```

其中`<port>`是 mongodb 的运行端口

也可以用以下命令来检查是否成功：

```
chkconfig mongod on
```

-   mongo shell

然后就可以像本地一样命令行操作了

```
[rootxxx*** ~]# mongo

## 查看数据库
> show dbs;

## 查看数据库版本
> db.version();

## 常用命令帮助
> db.help();
```

-   卸载移除 mongo

```
yum erase $(rpm -qa | grep mongodb-org)
```

-   移除数据库文件和日志文件

```
rm -r /var/log/mongodb
rm -r /var/lib/mongo
```
