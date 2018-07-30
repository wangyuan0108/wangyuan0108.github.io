---
title: create-react-app配置css moudles 和 scss 并防止和antd样式冲突
categories: WEB前端
copyright: true
date: 2018-07-30 11:33:12
tags:
- react
- create-react-app
- antd
---

### 背景

我们在使用 react 来开发的时候，用的是它的组件化开发的思想，在封装组件的时候，样式的书写方式和引入也是我们在开发中需要考虑的问题。这里简单记录下自己使用 css moudles 和解决与 antd 的样式发生冲突的过程<!--more-->

### 配置 css modules 和 sass 并且解决样式冲突

因为 create-react-app 内置支持 css modules，所以只需开启下就好，先配置下 sass：

```
yarn add sass-loader node-sass --dev
```

我们需要给 webpack 配置上 css-modules 和 sass-loader。但是使用 css-modules 会使 node_modules 库里的 css 样式找不到，比如后面要使用到的 antd，这个时候我们需要 inclube 来排除影响 node_modules，使得 css-modules 不会影响到 node_modules。

修改项目中 config 目录下的 webpack.config.dev.js 和 webpack.config.prod.js，说明下这两个文件，前一个是开发环境 npm start 使用，后一个是 npm run build 打包后使用。

-   修改 webpack.config.dev.js 文件

```
{
            //这里增加SCSS的支持,两种方式用一种就可以
            // test: /.(css|scss)$/
            test: [/\.css$/, /\.scss$/],
            exclude: [/node_modules/],// 这里去排除node_modules，防止css modules影响到node_modules
            use: [
              require.resolve('style-loader'),
              {
                loader: require.resolve('css-loader'),
                options: {
                  importLoaders: 1,
                  modules: true, // 这里增加对css modules的支持
                  localIdentName: '[name]__[local]__[hash:base64:5]' //这里增加对css modules的支持
                },
              },
              {
                loader: require.resolve('sass-loader'), // 这里增加sass的支持
              },
              {
                loader: require.resolve('postcss-loader'),
                options: {
                  // Necessary for external CSS imports to work
                  // https://github.com/facebookincubator/create-react-app/issues/2677
                  ident: 'postcss',
                  plugins: () => [
                    require('postcss-flexbugs-fixes'),
                    autoprefixer({
                      browsers: [
                        '>1%',
                        'last 4 versions',
                        'Firefox ESR',
                        'not ie < 9', // React doesn't support IE8 anyway
                      ],
                      flexbox: 'no-2009',
                    }),
                  ],
                },
              },
            ],
          },
          // 因为上面排除了css_modules所以这里一定要再添加个排除src来识别css_modules
          // 其实就是复制之前没修改前的所有，再增加一个exclude: [/src/]
          {
            test: /\.css$/,
            exclude: [/src/], // 这里添加排除src，
            use: [
              require.resolve('style-loader'),
              {
                loader: require.resolve('css-loader'),
                options: {
                  importLoaders: 1,
                },
              },
              {
                loader: require.resolve('postcss-loader'),
                options: {
                  // Necessary for external CSS imports to work
                  // https://github.com/facebookincubator/create-react-app/issues/2677
                  ident: 'postcss',
                  plugins: () => [
                    require('postcss-flexbugs-fixes'),
                    autoprefixer({
                      browsers: [
                        '>1%',
                        'last 4 versions',
                        'Firefox ESR',
                        'not ie < 9', // React doesn't support IE8 anyway
                      ],
                      flexbox: 'no-2009',
                    }),
                  ],
                },
              },
            ],
          }
```

-   webpack.config.prod.js 文件修改方式与 webpack.config.dev.js 方式类似

```
 {
            //这里增加SCSS的支持,两种方式用一种就可以
            // test: /.(css|scss)$/
            test: [/\.css$/, /\.scss$/],
            exclude: [/node_modules/], // 这里去排除node_modules
            loader: ExtractTextPlugin.extract(
              Object.assign(
                {
                  fallback: {
                    loader: require.resolve('style-loader'),
                    options: {
                      hmr: false,
                    },
                  },
                  use: [
                    {
                      loader: require.resolve('css-loader'),
                      options: {
                        importLoaders: 1,
                        minimize: true,
                        sourceMap: true,
                        modules: true, // 这里添加css modules支持
                      },
                    },
                    {
                      loader: require.resolve('postcss-loader'),
                      options: {
                        // Necessary for external CSS imports to work
                        // https://github.com/facebookincubator/create-react-app/issues/2677
                        ident: 'postcss',
                        plugins: () => [
                          require('postcss-flexbugs-fixes'),
                          autoprefixer({
                            browsers: [
                              '>1%',
                              'last 4 versions',
                              'Firefox ESR',
                              'not ie < 9', // React doesn't support IE8 anyway
                            ],
                            flexbox: 'no-2009',
                          }),
                        ],
                      },
                    },
                    {
                      loader: require.resolve('sass-loader'), // 这里添加sass支持
                    }
                  ],
                },

                extractTextPluginOptions
              )
            ),
            // Note: this won't work without `new ExtractTextPlugin()` in `plugins`.
          },
          {
            test: /\.css$/,
            exclude: [/src/], // 排除src
            loader: ExtractTextPlugin.extract(
              Object.assign(
                {
                  fallback: {
                    loader: require.resolve('style-loader'),
                    options: {
                      hmr: false,
                    },
                  },
                  use: [
                    {
                      loader: require.resolve('css-loader'),
                      options: {
                        importLoaders: 1,
                        minimize: true,
                        sourceMap: true,
                      },
                    },
                    {
                      loader: require.resolve('postcss-loader'),
                      options: {
                        // Necessary for external CSS imports to work
                        // https://github.com/facebookincubator/create-react-app/issues/2677
                        ident: 'postcss',
                        plugins: () => [
                          require('postcss-flexbugs-fixes'),
                          autoprefixer({
                            browsers: [
                              '>1%',
                              'last 4 versions',
                              'Firefox ESR',
                              'not ie < 9', // React doesn't support IE8 anyway
                            ],
                            flexbox: 'no-2009',
                          }),
                        ],
                      },
                    }
                  ],
                },

                extractTextPluginOptions
              )
            ),
            // Note: this won't work without `new ExtractTextPlugin()` in `plugins`.
          }
```