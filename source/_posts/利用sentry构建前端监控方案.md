---
title: 利用sentry构建前端监控方案
categories: WEB前端
copyright: true
date: 2020-09-25 14:04:02
tags:
---

## 背景

作为程序员，每次开发完自测充分的时候，但还是会有线上异常情况。如何快速发现 或者提前监控到这些异常的出现呢，是不是需要一个错误监控系统呢？<!--more-->

## 需求

一个错误监控系统应该做下面这些事情

 **监控错误 -> 搜集错误 -> 存储错误 -> 分析错误 -> 错误报警-> 定位错误 -> 解决错误**

当错误发生的时候我们更需要一些辅助信息来帮我们更快的定位错误，比如 *JS错误类型、 JS错误信息、JS错误堆栈、JS错误发生的位置以及相关位置的代码；JS错误发生的几率、浏览器的类型，版本号，设备机型等等辅助信息*

## sentry概述

Sentry是程序的哨兵，它可以监控我们在生产环境中项目的运行状态，一旦某段代码运行报错或者异常，会第一时间把报错的路由异常文件，请求方式 等一些非常详细的信息以消息或者邮件给我们，让我们第一时间知道：程序出错了，然后我们可以从 Sentry 给我们的详细的错误信息中瞬间找到我们需要处理的代码，及时解决异常！

官方地址：

https://github.com/getsentry/onpremise   //安装部署

[https://sentry.io](https://sentry.io/)

https://github.com/getsentry/sentry

https://github.com/docker-library/docs/tree/master/sentry   //dockerhub官方镜像 v9.1.2

**Requirements**

-  Docker 17.05.0+

- Compose 1.17.0+

**Minimum Hardware Requirements:**

-  You need at least 3GB RAM

 **env:**

- centos7.x

## sentry架构

注意：当前分析v9.1.2

　　Sentry到底是如何实现实时日志监控报警的呢？首先，Sentry是一个C/S架构，我们需要在自己应用中集成Sentry的SDK(支持前后端语言)才能在应用发生错误是将错误信息发送给Sentry服务端。根据语言和框架的不同，我们可以选择自动或自定义设置特殊的错误类型报告给Sentry服务端。
　　Sentry的服务端分为web、cron、worker这几个部分，应用（客户端）发生错误后将错误信息上报给web，web处理后放入消息队列或Redis内存队列，worker从队列中消费数据进行处理，postgresql对数据持久化。

my-sentry：sentry的web服务
sentry-cron：sentry的定时任务，活性检测
sentry-worker：业务处理，数据持久化，报警

![img](https://gitee.com/wangyuan0108/image/raw/master/790307-20200328013405726-1523196842.png)

## 安装与部署

### 安装方式

1. **远程仓库直接安装**

```
git clone https://github.com/getsentry/onpremise
cd onpremise
./install.sh
```

**中间会有一次让你配置管理员账号密码的过程** 下载完毕以后执行

```
docker-comose up -d
```

2. **docker安装**

### 先安装

- docker-ce

- docker-compose

### 部署sentry

##### 拉取镜像

```
docker pull sentry       

docker pull redis

docker pull postgres
```

##### 启动服务

```
docker run -d --name sentry-redis --restart=always redis   ###保证了，异常自动拉起
docker run -d --name sentry-postgres -e POSTGRES_PASSWORD=secret -e POSTGRES_USER=sentry --restart=always postgres
```

##### 生成密钥

```
docker run --rm sentry config generate-secret-key

n8ntkj(u3z5(o18tm*wprg^sqp2)z%980f@upd7(e86v67g*ut  ###打印出secret-keys
```

##### 数据库及账户初始化

注意：过程中需要你创建用户和密码
During the upgrade, you will be prompted to create the initial user which will act as the superuser.

```
docker run -it --rm -e SENTRY_SECRET_KEY='n8ntkj(u3z5(o18tm*wprg^sqp2)z%980f@upd7(e86v67g*ut' --link sentry-postgres:postgres --link sentry-redis:redis sentry upgrade
```

##### 启动sentry的web服务

The web interface needs to expose port 9000 into the container. This can just be done with –publish 9000:9000:
You should now be able to test the web service by visiting http://localhost:9000/

```
docker run -d -p 9000:9000 --name my-sentry -e SENTRY_SECRET_KEY='n8ntkj(u3z5(o18tm*wprg^sqp2)z%980f@upd7(e86v67g*ut' --link sentry-redis:redis --link sentry-postgres:postgres --restart=always sentry
```

##### 启动sentry-cron/work服务

```
docker run -d --name sentry-cron -e SENTRY_SECRET_KEY='n8ntkj(u3z5(o18tm*wprg^sqp2)z%980f@upd7(e86v67g*ut' --link sentry-postgres:postgres --link sentry-redis:redis sentry run cron

docker run -d --name sentry-worker-1 -e SENTRY_SECRET_KEY='n8ntkj(u3z5(o18tm*wprg^sqp2)z%980f@upd7(e86v67g*ut' --link sentry-postgres:postgres --link sentry-redis:redis sentry run worker
```

##### 登录测试效果

账号密码是刚才创建的管理员的密码

![image-20200927111801382](https://gitee.com/wangyuan0108/image/raw/master/image-20200927111801382.png)

监控的错误详情

![image-20200927112011576](https://gitee.com/wangyuan0108/image/raw/master/image-20200927112011576.png)

## 项目接入监控

**创建项目**

![image-20200927112855400](https://gitee.com/wangyuan0108/image/raw/master/image-20200927112855400.png)

这里我们选 **javascript** 项目名叫 **myapp**

然后sentry后台多了个项目, 然后在我们的前端项目里面像下面这样引入

```
// 脚本引入
<script
  src="https://browser.sentry-cdn.com/5.22.3/bundle.tracing.min.js"
  integrity="sha384-HfEJlGrJtFM0B01Wt4sGzTbxWqLMcMeGAXCbyQyB+iK9BhnDmNAtIGovhekIQOa2"
  crossorigin="anonymous"
></script>
// npm 
import * as Sentry from '@sentry/browser';
import { Integrations } from '@sentry/tracing';

Sentry.init({
  dsn: 'xxxx',
  integrations: [
    new Integrations.BrowserTracing(),
  ],
  tracesSampleRate: 1.0,
});
复制代码
```

这样整个流程就通了，可以用起来了

## Sourcemap 上传

众所周知，我们的线上代码都是被压缩混淆过的。所以就算拿到了错误信息，只能靠猜了，所以要配合 souremap 精准定位错误信息

**准备**

1. sentry 后台配置 authToken 用于上传sourcemap 使用，如下图注意勾选

![image-20200927112142155](https://gitee.com/wangyuan0108/image/raw/master/image-20200927112142155.png)

1. 下载 webpack 插件

```
npm i @sentry/webpack-plugin -D
复制代码
```

然后在根目录下新建 **.sentryclirc**

```
[defaults]
### 你的域名
defaults.url='http://localhost:9000'
### 组织团队名默认是 sentry
org=sentry
### 项目名称
project=myapp
### 步骤1创建的
[auth]
token=1234
复制代码
```

配置插件

```
const SentryWebpackPlugin = require('@sentry/webpack-plugin');
if (process.env.NODE_ENV !== 'development') { // 注意只在生成环境开启，不然npm run dev也会上传
    new SentryWebpackPlugin({
      release: Date.now(), // 唯一标识，可以用其他的比如 hash
      include: './build', // 要上传的文件夹 有的叫 dist
      ignoreFile: '.sentrycliignore', // 可不要
      ignore: ['node_modules', 'config-overrides.js'], 
      configFile: '.sentryclirc' // 默认同级，如果不一样需要用node path模块处理一下
    });
  }
复制代码
```

然后运行 npm run build

```
Creating an optimized production build...
> Found 10 release files
> Analyzing 10 sources
> Rewriting sources
> Adding source map references
> Bundled 10 files for upload
> Uploaded release files to Sentry
> File upload complete
复制代码
```

恭喜你配置成功了

### 其他常用api

**主动上报**

```
Sentry.captureMessage('Hello, world!'); // 上报信息
Sentry.captureException(new Error('Good bye')); // 上报异常
Sentry.captureEvent({ // 上报事件
  message: 'Manual',
  stacktrace: [
    // ...
  ],
});
复制代码
```

**配置用户信息**

```
Sentry.configureScope((scope) => {
        scope.setUser({
          ...data.userInfo,
          time: new Date().toLocaleString()
        });
      });
复制代码
```

### 其他

- 邮件
- 钉钉机器 可以去自己下载一些插件配置

### 最后

看了其他大佬的自研方案发现可以扩展成埋点+性能监控，sentry 还是有一定的局限性，不过对于一般公司来说够用了