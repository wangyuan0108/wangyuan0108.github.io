---
title: 初次尝试配置nginx服务器
categories: WEB前端
copyright: true
date: 2019-12-03 16:39:19
tags:
---

### 安装

一般服务器是 linux 系统，所以我也是在这个系统下安装使用 nginx 的，简单记录下使用过程

1. 在 linux 系统上安装 nginx 有很多方式，我这里选择一个比较简单的方式 yum 来进行安装。一般买的服务器都默认装好了以下工具，如果没有就安装一下：
   <!--more-->

```js
    yum -y install gcc gcc-c++ autoconf pcre-devel make automake
    yum -y install wget httpd-tools vim
```

2. 查看服务器是否有 nginx 的 yum 源，有的话就可以直接安装，如果没有就先配置 yum 源：

- 查看源

```bash
    yum list | grep nginx
```

- 如果不存在，或者不是你需要的版本，那我们可以自行配置 yum 源

```
    [nginx]
    name=nginx repo
    baseurl=http://nginx.org/packages/OS/OSRELEASE/$basearch/
    gpgcheck=0
    enabled=1
```

- 把配置写入到以下配置文件

```bash
    vim /etc/yum.repos.d/nginx.repo
```

- 赋值完成后，你需要修改一下对应的操作系统和版本号，因为我的是 centos 和 7 的版本，所以改为这样。

```
    baseurl=http://nginx.org/packages/centos/7/$basearch/
```

- yum 安装 nginx

```
    yum install nginx
```

- 验证安装是否成功并查看版本

```
    nginx -v
```

如果出现版本号的详细信息就说明成功了

### 基础配置

1. 查看安装 nginx 的文件夹

```
rpm -ql nginx
```

2. 找到 nginx 的配置文件并打开

```
cd /etc/nginx
vim nginx.conf
```

3. 查看基本的配置信息

```bash
#运行用户，默认即是nginx，可以不进行设置
user  nginx;
#Nginx进程，一般设置为和CPU核数一样
worker_processes  1;
#错误日志存放目录
error_log  /var/log/nginx/error.log warn;
#进程pid存放位置
pid        /var/run/nginx.pid;


events {
    worker_connections  1024; # 单个后台进程的最大并发数
}


http {
    include       /etc/nginx/mime.types;   #文件扩展名与类型映射表
    default_type  application/octet-stream;  #默认文件类型
    #设置日志模式
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;   #nginx访问日志存放位置

    sendfile        on;   #开启高效传输模式
    #tcp_nopush     on;    #减少网络报文段的数量

    keepalive_timeout  65;  #保持连接的时间，也叫超时时间

    #gzip  on;  #开启gzip压缩

    include /etc/nginx/conf.d/*.conf; #包含的子配置项位置和文件
```

3. 查看引入的默认配置文件

```bash
cd /conf.d
vim default.conf
```

然后看配置信息

```bash
server {
    listen       80;   #配置监听端口
    server_name  localhost;  //配置域名

    #charset koi8-r;
    #access_log  /var/log/nginx/host.access.log  main;

    location / {
        root   /usr/share/nginx/html;     #服务默认启动目录
        index  index.html index.htm;    #默认访问文件
    }

    #error_page  404              /404.html;   # 配置404页面

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;   #错误状态码的显示页面，配置后需要重启
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

    # proxy the PHP scripts to Apache listening on 127.0.0.1:80
    #
    #location ~ \.php$ {
    #    proxy_pass   http://127.0.0.1;
    #}

    # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
    #
    #location ~ \.php$ {
    #    root           html;
    #    fastcgi_pass   127.0.0.1:9000;
    #    fastcgi_index  index.php;
    #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
    #    include        fastcgi_params;
    #}

    # deny access to .htaccess files, if Apache's document root
    # concurs with nginx's one
    #
    #location ~ /\.ht {
    #    deny  all;
    #}
}
```

4. 看了以上配置可以找到我们的静态页面存放的位置

```
cd /usr/share/nginx/html
ls
```

到此我们的 nginx 基本配置使用完成，可以打开浏览器输入服务器地址验证下。如果没有出现 nginx 的欢迎页，还需要去服务器配置开放 80 端口。

### Nginx 服务启动、停止、重启

1. 启动

- nginx 直接启动

在 CentOS7.4 版本里（低版本是不行的），是可以直接直接使用 nginx 启动服务的。

```bash
nginx
```

- 使用 systemctl 命令启动

```bash
systemctl start nginx.service
```

- 输入命令后，没有任何提示,可以输入以下命令查询下

```bash
ps aux | grep nginx
```

2. 停止 Nginx 服务

- 立即停止服务，直接停止进程。

```
nginx  -s stop
```

- 从容停止服务，需要进程完成当前工作后再停止。

```
nginx -s quit
```

- killall 方法杀死进程，直接杀死

```
killall nginx
```

- systemctl 停止

```
systemctl stop nginx.service
```

3. 重启 Nginx 服务

- 重新启动服务

```
systemctl restart nginx.service
```

- 重新载入配置

```
nginx -s reload
```

4. 查看端口占用情况

```
netstat -tlnp
```

### 反向代理

- 最简单的反向代理

```
server{
        listen 80;
        server_name water.wangyuanweb.top;
        location / {
               proxy_pass http://www.baidu.com;
        }
}
```
