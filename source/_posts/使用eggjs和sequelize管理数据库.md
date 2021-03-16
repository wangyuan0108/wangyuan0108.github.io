---
title: 使用eggjs和sequelize管理数据库
categories: WEB前端
copyright: true
date: 2021-03-16 10:38:56
tags:
---

## 简介

为什么使用eggjs自不必言说，前端开发者想搞一下服务器接口啥的，最低学习成本的就是nodejs。加之koa是nodejs的封装库，使得nodejs更加好用。然而在eggjs的约定大于配置的前提下，对koa做了封装，使得上手成本更低，固然选择eggjs来作为写接口的框架。数据库使用sequelize的缘由自不必说了，让多人开发合作更加简单规范！！！<!--more-->

## eggjs快速上手

#### 生成项目

快速生成基础项目，提高开发效率，这里推荐使用脚手架快速生成项目。具体命令如下：

```
mkdir egg-example && cd egg-example
npm init egg --type=simple
npm i
npm run dev
// 打开一下链接
http://localhost:7001
```

#### 项目目录介绍

```
egg-project
├── package.json
├── app.js (可选)
├── agent.js (可选)
├── app
|   ├── router.js
│   ├── controller
│   |   └── home.js
│   ├── service (可选)
│   |   └── user.js
│   ├── middleware (可选)
│   |   └── response_time.js
│   ├── schedule (可选)
│   |   └── my_task.js
│   ├── public (可选)
│   |   └── reset.css
│   ├── view (可选)
│   |   └── home.tpl
│   └── extend (可选)
│       ├── helper.js (可选)
│       ├── request.js (可选)
│       ├── response.js (可选)
│       ├── context.js (可选)
│       ├── application.js (可选)
│       └── agent.js (可选)
├── config
|   ├── plugin.js
|   ├── config.default.js
│   ├── config.prod.js
|   ├── config.test.js (可选)
|   ├── config.local.js (可选)
|   └── config.unittest.js (可选)
└── test
    ├── middleware
    |   └── response_time.test.js
    └── controller
        └── home.test.js
```

如上，由框架约定的目录：

- `app/router.js` 用于配置 URL 路由规则，具体参见 [Router](https://eggjs.org/zh-cn/basics/router.html)。
- `app/controller/**` 用于解析用户的输入，处理后返回相应的结果，具体参见 [Controller](https://eggjs.org/zh-cn/basics/controller.html)。
- `app/service/**` 用于编写业务逻辑层，可选，建议使用，具体参见 [Service](https://eggjs.org/zh-cn/basics/service.html)。
- `app/middleware/**` 用于编写中间件，可选，具体参见 [Middleware](https://eggjs.org/zh-cn/basics/middleware.html)。
- `app/public/**` 用于放置静态资源，可选，具体参见内置插件 [egg-static](https://github.com/eggjs/egg-static)。
- `app/extend/**` 用于框架的扩展，可选，具体参见[框架扩展](https://eggjs.org/zh-cn/basics/extend.html)。
- `config/config.{env}.js` 用于编写配置文件，具体参见[配置](https://eggjs.org/zh-cn/basics/config.html)。
- `config/plugin.js` 用于配置需要加载的插件，具体参见[插件](https://eggjs.org/zh-cn/basics/plugin.html)。
- `test/**` 用于单元测试，具体参见[单元测试](https://eggjs.org/zh-cn/core/unittest.html)。
- `app.js` 和 `agent.js` 用于自定义启动时的初始化工作，可选，具体参见[启动自定义](https://eggjs.org/zh-cn/basics/app-start.html)。关于`agent.js`的作用参见[Agent机制](https://eggjs.org/zh-cn/core/cluster-and-ipc.html#agent-机制)。

由内置插件约定的目录：

- `app/public/**` 用于放置静态资源，可选，具体参见内置插件 [egg-static](https://github.com/eggjs/egg-static)。
- `app/schedule/**` 用于定时任务，可选，具体参见[定时任务](https://eggjs.org/zh-cn/basics/schedule.html)。

**若需自定义自己的目录规范，参见 [Loader API](https://eggjs.org/zh-cn/advanced/loader.html)**

- `app/view/**` 用于放置模板文件，可选，由模板插件约定，具体参见[模板渲染](https://eggjs.org/zh-cn/core/view.html)。
- `app/model/**` 用于放置领域模型，可选，由领域类相关插件约定，如 [egg-sequelize](https://github.com/eggjs/egg-sequelize)。

由此一个基础项目已经创建完成，详细的eggjs如何使用可自行查看官方文档https://eggjs.org/zh-cn/

## eggjs使用sequelize

1. 安装并配置 [egg-sequelize](https://github.com/eggjs/egg-sequelize) 插件（它会辅助我们将定义好的 Model 对象加载到 app 和 ctx 上）和 [mysql2](https://github.com/sidorares/node-mysql2) 模块：

- 安装

```
npm install --save egg-sequelize mysql2
```

- 在 `config/plugin.js` 中引入 egg-sequelize 插件

```
exports.sequelize = {
  enable: true,
  package: 'egg-sequelize',
};
```

- 在 `config/config.default.js` 中编写 sequelize 配置

```
config.sequelize = {
  dialect: 'mysql',
  host: '127.0.0.1',
  port: 3306,
  database: 'egg-sequelize-doc-default',
};
```

我们可以在不同的环境配置中配置不同的数据源地址，用于区分不同环境使用的数据库，例如我们可以新建一个 `config/config.unittest.js` 配置文件，写入如下配置，将单测时连接的数据库指向 `egg-sequelize-doc-unittest`。

```
exports.sequelize = {
  dialect: 'mysql',
  host: '127.0.0.1',
  port: 3306,
  database: 'egg-sequelize-doc-unittest',
};
```

完成上面的配置之后，一个使用 sequelize 的项目就初始化完成了。[egg-sequelize](https://github.com/eggjs/egg-sequelize) 和 [sequelize](http://docs.sequelizejs.com/) 还支持更多的配置项，可以在他们的文档中找到。

2. sequelize 提供了 [sequelize-cli](https://github.com/sequelize/cli) 工具来管理，我们也可以在 egg 项目中引入 sequelize-cli。

- 安装 sequelize-cli

```
npm install --save-dev sequelize-cli
```

在 egg 项目中，我们希望将所有数据库 Migrations 相关的内容都放在 `database` 目录下，所以我们在项目根目录下新建一个 `.sequelizerc` 配置文件：

```
'use strict';

const path = require('path');

module.exports = {
  config: path.join(__dirname, 'database/config.json'),
  'migrations-path': path.join(__dirname, 'database/migrations'),
  'seeders-path': path.join(__dirname, 'database/seeders'),
  'models-path': path.join(__dirname, 'app/model'),
};
```

然后查看下sequelize-cli的所有命令

```
sequelize <命令>

命令：
  sequelize db:migrate                        Run pending migrations
  sequelize db:migrate:schema:timestamps:add  Update migration table to have timestamps
  sequelize db:migrate:status                 List the status of all migrations
  sequelize db:migrate:undo                   Reverts a migration
  sequelize db:migrate:undo:all               Revert all migrations ran
  sequelize db:seed                           Run specified seeder
  sequelize db:seed:undo                      Deletes data from the database
  sequelize db:seed:all                       Run every seeder
  sequelize db:seed:undo:all                  Deletes data from the database
  sequelize db:create                         Create database specified by configuration
  sequelize db:drop                           Drop database specified by configuration
  sequelize init                              Initializes project
  sequelize init:config                       Initializes configuration
  sequelize init:migrations                   Initializes migrations
  sequelize init:models                       Initializes models
  sequelize init:seeders                      Initializes seeders
  sequelize migration:generate                Generates a new migration file  [aliases: migration:create]                                         
  sequelize model:generate                    Generates a model and its migration   [aliases: model:create]                                              
  sequelize seed:generate                     Generates a new seed file       [aliases: seed:create]                                                     
```

接下来就简单介绍下使用方式

#### 使用命令操作数据库

1. 初始化数据库相关

```
npx sequelize init
```

这将创建以下文件夹:

- config, 包含配置文件，它告诉CLI如何连接数据库
- models,包含您的项目的所有模型
- migrations, 包含所有迁移文件
- seeders, 包含所有种子文件

在建立模型之前，应先修改database/config.json，以告诉 CLI 如何连接到数据库。database/config.json内容如下：

```
{
  "development": {
    "username": "root",
    "password": "12345678",
    "database": "egg_test",
    "host": "127.0.0.1",
    "dialect": "mysql"
  },
  "test": {
    "username": "root",
    "password": "23456789",
    "database": "database_test",
    "host": "127.0.0.1",
    "dialect": "mysql"
  },
  "production": {
    "username": "root",
    "password": "12345679",
    "database": "database_production",
    "host": "127.0.0.1",
    "dialect": "mysql"
  }
}
```

2. 使用如下命令创建数据库：

```
npx sequelize db:create
```

3. 使用如下命令删除数据库：

```
npx sequelize db:drop
```

### 创建模型

我们将使用 model:generate 命令。 此命令需要两个选项：

- name, 模型的名称
- attributes, 模型的属性列表

创建一个名叫 User 的模型：

```css
npx sequelize model:generate --name User --attributes firstName:string,lastName:string,email:string
```

这将创建一下文件:

- 在 models 文件夹中创建了一个 user 模型文件
- 在 migrations 文件夹中创建了一个名字像 XXXXXXXXXXXXXX-create-user.js 的迁移文件

注意: _Sequelize 将只使用模型文件，它是表描述。另一边，迁移文件是该模型的更改，或更具体的是说 CLI 所使用的表。 处理迁移，如提交或日志，以进行数据库的某些更改。

这里感觉这样用命令创建模型有点繁琐，主要是如果字段太多，命令行岂不是要写很多，我的理解是这样的不知道有其他好的方法不，初次使用这个。

我是先创建migrations文件，然后在手动创建模型文件。具体如下

```
npx sequelize migration:generate --name=init-users
```

执行完后会在 `database/migrations` 目录下生成一个 migration 文件(`${timestamp}-init-users.js`)，我们修改它来处理初始化 `users` 表：

```
'use strict';

module.exports = {
  // 在执行数据库升级时调用的函数，创建 users 表
  up: async (queryInterface, Sequelize) => {
    const { INTEGER, DATE, STRING } = Sequelize;
    await queryInterface.createTable('users', {
      id: { type: INTEGER, primaryKey: true, autoIncrement: true },
      name: STRING(30),
      age: INTEGER,
      created_at: DATE,
      updated_at: DATE,
    });
  },
  // 在执行数据库降级时调用的函数，删除 users 表
  down: async queryInterface => {
    await queryInterface.dropTable('users');
  },
};
```

执行 migrate 进行数据库变更

```
# 升级数据库
npx sequelize db:migrate
# 如果有问题需要回滚，可以通过 `db:migrate:undo` 回退一个变更
# npx sequelize db:migrate:undo
# 可以通过 `db:migrate:undo:all` 回退到初始状态
# npx sequelize db:migrate:undo:all
```

执行之后，我们的数据库初始化就完成了。

现在终于可以开始编写代码实现业务逻辑了，首先我们来在 `app/model/` 目录下编写 user 这个 Model：

```
'use strict';

module.exports = app => {
  const { STRING, INTEGER, DATE } = app.Sequelize;

  const User = app.model.define('user', {
    id: { type: INTEGER, primaryKey: true, autoIncrement: true },
    name: STRING(30),
    age: INTEGER,
    created_at: DATE,
    updated_at: DATE,
  });

  return User;
};
```

然后就可以结合eggjs的模式来进行数据库的处理了。

说下可以使用的cli命令

```
npx sequelize db:migrate:status // 看一下当前状态
```

> 撤销迁移      
>
> db:migrate:undo        - 撤销上一次的迁移操作      
>
> db:migrate:undo:all        - 撤销所有的迁移操作      
>
> db:migrate:undo --name 具体迁移脚本

我们现在要添加一个字段 lastname，新建一个迁移文件

```
npx sequelize migration:create --name addLastname
```

**queryInterface**文档： https://sequelize.org/master/class/lib/dialects/abstract/query-interface.js~QueryInterface.html

### 种子文件

种子文件      

> 迁移文件是用来构建数据库以及表结构的，种子文件是用来构建数据的      
>
> seed:generate --name demo-user （自定义的名字）    
>
> 种子文件脚本与迁移脚本类似，由up于down函数组成，传入的参数也是一致的

先生成种子文件 name 后边接的是自定义的名字

```bash
npx sequelize seed:generate --name userseed
```

会在database/seeders下创建一个种子文件以userseed结尾，然后手动修改这个文件添加点测试数据

```
module.exports = {
  up: (queryInterface, Sequelize) => {
    return queryInterface.bulkInsert('users', [{
      id: 1,
      name: 'man',
      age: 18,
    }], {});
  },

  down: (queryInterface, Sequelize) => {
    return queryInterface.bulkDelete('users', null, {});
  },
};
```

执行种子

> db:seed 指定种子文件        运行指定种子文件      
>
> db:seed:all        运行所有种子文件

```
npx sequelize db:seed:all
```

然后查看数据库，添加上了一条数据

### 撤销种子执行

> db:seed:undo --seed 指定种子文件        撤销指定种子文件      
>
> db:seed:undo:all        撤销所有种子文件

```
npx sequelize db:seed:undo:all
```

具体使用请查看官方文档

