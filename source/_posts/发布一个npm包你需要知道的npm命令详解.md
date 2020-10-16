---
title: 发布一个npm包你需要知道的npm命令详解
categories: WEB前端
copyright: true
date: 2020-10-16 10:45:30
tags:
  - npm
---
## 背景

在前端工作中，npm是大家在熟悉不过的了。大家多多少少都会用到npm包来加快我们的业务开发。对于一个有梦想的咸鱼来说，有时候也想自己发布一个包。这里就分享下发布一个包需要使用到的npm命令和发布流程<!--more-->

## 准备

首先需要去[npm官网](https://www.npmjs.com/)注册自己的账号，这里需要用到用户名、邮箱、密码。这里的用户名就是你发布的包所属的作用域，邮箱是给你发通知用的。这些都搞定后，我们就可以开发准备发布的包了

## 发布

### 规范

>npm官方建议规范的包**至少**包含：
>
>- package.json（包的基本信息）
>
>- README.md（文档）
>
>- index.js （入口文件）

### 发布一个不在自己用户名作用域下的包

##### 发布[create-wy-umi](https://www.npmjs.com/package/create-wy-umi)包

##### 创建项目

1. 创建文件夹

```
mkdir create-wy-umi
cd create-wy-umi
```

2. 初始化项目

```
npm init/npm init -y
```

3. 创建包的入口文件，假设是index.js，则package.json文件如下

```
{
  "name": "wy-create-umi",
  "version": "1.0.0",
  "description": "my first npm package",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "keywords": [
    "npm",
    "packge"
  ],
  "author": "wy",
  "license": "ISC"
}
```

4. 创建README.md

5. 创建index.js
6. 最基本的目录结构如下

```
└── wy-create-umi
    ├── README.md
    ├── index.js
    └── package.json
```

##### 开始发布的步骤和使用的npm命令

1. 切换npm源为官网源，可以使用nrm进行管理

2. 登录

```
// 输入用户名和密码
npm login
```

3. 测试

```
//在本地先测试我们的包
npm link
```

这样在我们项目里就可以使用我们本地开发的包了，测试没有问题之后就可以进行发布

4. 卸载掉测试包

```
// 卸载掉本地测试包
npm unlink
```

5. 发布

```
// 如果包的名字是唯一的，那么这一步基本已经发布成功一个npm包了
npm publish
```

### 发布一个在自己用户名作用域下的包

基本的发布步骤差不多，主要区别是npm命令的不同。

1. 在初始化和发布的时候命令改成如下命令

```
// 初始化项目的时候
npm init --scope=@wy -y
// 发布项目的时候
npm publish --access public
```

如果这样的话，那么发布的指定作用域下的包就完成了，发布组织下的包，也是使用这样的方法，比如[@waterpack/wx-cli](https://www.npmjs.com/package/@waterpack/wx-cli)，这个是我发布的生成小程序页面或者组件的脚手架工具。

至此我们已经能成功发布一个包了，接下来就是对我们发的包的迭代更新

### 迭代和更新

当我们需要优化我们的包代码的时候，就需要对已经发布的包进行更新，这里就说下更新包的步骤和npm命令

1. 更新我们的代码比如`index.js`中的类容
2. 更新我们的包版本

```
// 更新版本的命令为
npm version <major | minor | patch>

```

| 包                   | 版本号意义 | 规则                                  | 版本  |
| -------------------- | ---------- | ------------------------------------- | :---- |
| 首次发布             | 首发       | 1.0.0开始                             | 1.0.0 |
| bug修复，向后兼容    | 补丁版本号 | 变更第三位数字                        | 1.0.1 |
| 新功能，向后兼容     | 此版本号   | 变更第二位数字，且第三位数字改为0     | 1.1.0 |
| 重大变更，不向后兼容 | 主版本号   | 变更第一位数字，且第二第三位数字改为0 | 2.0.0 |

3. 关于`npm version`

```
➜  npm version --help
npm version [<newversion> | major | minor | patch | premajor | preminor | prepatch | prerelease [--preid=<prerelease-id>] | from-git]
(run in package dir)
'npm -v' or 'npm --version' to print npm version (6.14.7)
'npm view <pkg> version' to view a package's published version
'npm ls' to inspect current package/dependency versions
```

可以看到命令的所有参数，这里解释下各个参数的意义和作用

- ##### prerelease

1. `npm version prerelease`
   package.json 中的版本号`1.0.0`变为 `1.0.1-0`
2. 再次执行 `npm version prerelease`
   package.json 中的版本号`1.0.1-0`变为 `1.0.1-1`

> 操作说明 当执行`npm version prerelease`时，如果没有预发布号，则增加补丁版本号，同时预发布号设为0；
> 如果有prerelease， 则prerelease 增加1。

- ##### prepatch

1. `npm version prepatch`
   package.json 中的版本号`1.0.1-1`变为 `1.0.2-0`

> prepatch - 直接升级补丁号，增加预发布号为0。

- ##### preminor

1. `npm version preminor`
   package.json 中的版本号`1.0.2-0`变为 `1.1.0-0`

> preminor - 直接升级次版本号，补丁版本号置为0，增加预发布号为0。

- ##### premajor

1. `npm version premajor`
   package.json 中的版本号`1.1.0-0`变为 `2.0.0-0`

> premajor - 直接升级主版本号，次版本号、补丁版本号置为0，增加预发布号为0。

- ##### patch: 主要目的升级补丁版本号

1. `npm version patch`
   package.json 中的版本号`2.0.0-0`变为 `2.0.0`;
2. 再次执行`npm version patch`
   package.json 中的版本号`2.0.0`变为 `2.0.1`;

> 操作说明，patch：如果有预发版本号 ，则去掉 ，其他保持不变；
> 如果没有预发版本号 ，则升级补丁版本号.

- ##### minor： 主要目的升级次要版本

1. `npm version minor`
   package.json 中的版本号`2.0.1`变为 `2.1.0`;

> 如果没有预发版本，直接升级次要版本， 同时补丁版本设置为0；

2. `npm version premajor` `2.1.0`–> `3.0.0-0`;

3. `npm version minor` `3.0.0-0`–> `3.0.0`;

4. `npm version prepatch` `3.0.0`–>`3.0.1-0`;

5. `npm version minor` `3.0.1-0`–>`3.1.0`;

> 如果有预发版本号， 首先需要去掉；如果补丁版本号为0，则不升级次要版本：如`3`；
> 如果补丁版本号不为0， 则升级次要版本号，同时补丁版本号设为0，如`5`。

- ##### major ：主要目的升级主版本

1. `npm version major` : `3.1.0` -->`4.0.0`

> 如果没有预发版本号，则直接升级主版本号，其他位都置为0；

2. `npm version premajor`: `4.0.0` --> `5.0.0-0`;

3. `npm version premajor`: `5.0.0-0` --> `5.0.0`;

> 如果有预发布号： 次版本号和补丁版本都为0，则不升级主版本，只将预发版本号去掉。

4. `npm version preminor` : `5.0.0-0`–> `5.1.0-0`

5. `npm version major` : `5.1.0-0` -->`6.0.0`

> 如果有预发布号：且次版本号和补丁版本号有任意一个不是0，则升级主版本号，其他位都置为0，并去掉预发版本。

##### 更新迭代发布

版本更改完毕后，直接执行发布命令，这时发布应该就成功了如下

```
➜  wx-cli git:(master) npm publish      
npm notice 
npm notice 📦  @waterpack/wx-cli@1.0.7
npm notice === Tarball Contents === 
npm notice 8.4kB bin/index.js            
npm notice 215B  template/comp/index.js  
npm notice 850B  template/page/index.js  
npm notice 48B   template/comp/index.json
npm notice 27B   template/page/index.json
npm notice 776B  package.json            
npm notice 2.1kB README.md               
npm notice 68B   template/comp/index.wxml
npm notice 80B   template/page/index.wxml
npm notice 29B   template/comp/index.wxss
npm notice 35B   template/page/index.wxss
npm notice === Tarball Details === 
npm notice name:          @waterpack/wx-cli                       
npm notice version:       1.0.7                                   
npm notice package size:  3.8 kB                                  
npm notice unpacked size: 12.6 kB                                 
npm notice shasum:        6e2389721598375d068ae12852694b1ce8
npm notice integrity:     sha512-agsPUF0J1fU8s[...]DdB8Gb3QVpWxg==
npm notice total files:   11                                      
npm notice 
+ @waterpack/wx-cli@1.0.7
```



## 小结

到此，发布一个包的讲解结束。觉得的有帮助的小伙伴欢迎给个赞！！！

