---
title: mac item2 ssh 登录云服务器
categories: WEB前端
copyright: true
date: 2023-03-14 19:14:26
tags:
---
### 1\. 创建脚本文件

新建一个名为tencentServerLogin的文件：

```zsh
touch tencenServerLogin
```

<!--more-->

将服务器信息写入到该文件中，内容示例如下：

```zsh
#!/usr/bin/expect -f
set user root
set host 33.123.323.41
set password 34343Bh-e343476-c
set timeout 30
spawn ssh $user@$host
expect "*assword:*"
send "$password\r"
interact
expect eof
```

### 2\. 新建一个iTerm2 Profile

1.  打开iTerm2 -> preferences -> Profiles
2.  点击左下角的"+"号, 新建一个profile
3.  在右边的内容框中,找到Command, 填入expect + 前面新建tencenServerLogin文件的绝对路径

示例如下图：

  

![](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202303141917407)

### 3\. iTerm2保持ssh连接不断开

用iTerm2进行ssh时，空闲了一段时间就会与服务器断开连接。这个问题可以通过添加以下配置来解决，配置示例如下图：

  

![](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202303141918096)

### 4\. 使用iTerm2登录云服务器

示例如下图：

  

![](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202303141918585)
