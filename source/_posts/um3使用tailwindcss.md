---
title: um3使用tailwindcss
categories: WEB前端
copyright: true
date: 2023-02-08 16:14:33
tags:
---


[Tailwind CSS](https://tailwindcss.com/docs/installation/using-postcss) 是最近几年很火的 CSS UI 框架，遵循 Atomic/Utility-First 的原则，能够大幅提升样式开发效率。在本篇博客中，我将介绍 UmiJS 项目接入 Tailwind CSS 的流程，并分享遇到的问题及其解决方法。<!--more-->

安装 Tailwind
-----------

### PostCSS

Tailwind 依赖 [PostCSS](https://postcss.org) 提供的样式处理能力。PostCSS 将 CSS 代码解析成 AST 结构，并交由 JS 插件来进行处理，常见的 PostCSS 插件有 `autoprefixer`、`cssnano` 等。其中，`autoprefixer` 用于为 CSS 中的属性添加浏览器特定的前缀，提升 CSS 代码的兼容性。

### 安装依赖

目前，Umi 的稳定版本是 `3.5.20` ，其（[@umijs/bundler-webpack](https://github.com/umijs/umi/blob/master/packages/bundler-webpack/package.json)）使用的 PostCSS 版本为 `7.0.32` ，而 Tailwind 依赖 PostCSS 的版本为 `8.x.x` 。因此，我们需要安装兼容 PostCSS 7 的 Tailwind 版本。

```
yarn add \
  tailwindcss@npm:@tailwindcss/postcss7-compat \
  @tailwindcss/postcss7-compat \
  autoprefixer@^9
```

修改 Umi 配置
---------

完成相关依赖的安装后，我们需要修改 Umi 配置文件（`.umirc` 或 `config/config.ts`）的 `extraPostCSSPlugins` 选项。

```
import { defineConfig } from "umi";

export default defineConfig({
  // ...
  extraPostCSSPlugins: [require("tailwindcss"), require("autoprefixer")],
  // ...
});

```

默认情况下，`tailwindcss` 会识别根目录下的 `tailwind.config.js` 配置文件。如果我们想指定配置文件的读取路径，可设置 `config` 属性。

```
import { defineConfig } from "umi";

export default defineConfig({
  // ...
  extraPostCSSPlugins: [
    require("tailwindcss")({ config: "[custom_path]/tailwind.config.js" }),
    require("autoprefixer"),
  ],
  // ...
});

```

添加 Tailwind 配置
--------------

`tailwind.config.js` 是 Tailwind 的配置文件，通常存放在项目根目录中。

```
module.exports = {
  mode: "jit",
  purge: ["./src/**/*.{ts,tsx,js,jsx}"],
  darkMode: false,
  theme: {},
  variants: {},
  plugins: [],
};

```

注意到在上面的文件中，通过配置 `mode` 属性为 `jit` ，我们开启了 Tailwind 的 JIT（Just In Time）编译模式。开启 JIT 模式，有什么好处呢？

### JIT 编译模式

首先，我们需要了解在不开启 JIT 模式（**传统模式**）下的 Tailwind 构建流程：Tailwind 通过读取配置文件，预生成所有的工具类，提供给开发者使用。最后在打包时，通过 PostCSS 提供的 `pure` 插件，执行 Tree Shaking 操作，移除未被使用的工具类，从而简化产物。在该模式下，如果配置文件有很多自定义的配置，那么就会延长预生成的时间。  
  
在开启 JIT 模式后，Tailwind 不预生成所有的工具类，而是根据开发者的实际使用，来生成对应的类，大大提升了编译速度。  
  
此外，JIT 模式支持 `w-[100px]` 等包含特殊尺寸的工具类生成，而不需要开发者自行编写特定尺寸的 `style` 或 `class` ，这也提升了开发体验。

使用 Tailwind
-----------

如下图所示，[官方文档](https://tailwindcss.com/docs/installation/using-postcss)建议我们在项目中引入 `base`、`components` 和 `utilities` 。

![](https://pic2.zhimg.com/v2-2528ab6ca625c66252d9b99a8e81ff51_r.jpg)

Tailwind 官方建议引入的编译指令

经过验证，`base` 和 `components` 会影响 Ant Design 的样式，会带来样式问题。因此，在 Umi 项目的 `global.less` 文件中，我们只需引入 `utilities` 样式。

```
@tailwind utilities;
```

修复工具类无法生成的问题
------------

在开启 JIT 模式后，会遇到工具类无法生成的问题。如下图所示，可以发现 Tailwind 并没有为 `text-red-500` 生成对应的样式规则。

![](https://pic1.zhimg.com/v2-0183b45405630e6d64c02826b7c9b8b0_r.jpg)

Tailwind 工具类无法生成

查看相关 [Issue](https://github.com/tailwindlabs/tailwindcss/issues/5132%23issuecomment-894549642) 得知，该问题只会在 PostCSS 7 开启 JIT 模式出现，因为 PostCSS 7 不支持 `dir-dependency` 的消息类型。  
  
该问题的具体解决办法是在执行 `umi start` 命令时，配置 `TAILWIND_MODE=watch` 的环境变量。

```
// package.json
{
  "script": {
    "start": "TAILWIND_MODE=watch umi dev"
  }
}
```

参考资料
----

*   [一文搞懂什么是 PostCSS](https://www.dute.org/blog/what-is-postcss.html)
*   [github.com/dewfall123/umi-plugin-tailwindcss](https://github.com/dewfall123/umi-plugin-tailwindcss)
*   [在 Umi 中使用 TailwindCSS](https://iorigina.com/p/%25E5%259C%25A8-umi-%25E4%25B8%25AD%25E4%25BD%25BF%25E7%2594%25A8-tailwindcss/)
*   [Tailwind 适配 Umi H5 方案](https://juejin.cn/post/7025549579495931935)

  
