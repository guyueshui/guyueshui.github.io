---
title: Melody 主题的一些个人更改
date: 2018-12-19 14:31:24
categories: ['Techniques']
tags: ['beautify']
---

## 更改字体

Melody 主题字体配置文件在 `$BLOG/themes/melody/source/css/var.styl`，其中 `$BLOG` 为 Hexo 博客根目录。截取一段如下：

```styl
// Global Variables
$font-size = 16px
$font-color = #1F2D3D
$rem = 20px
$font-family = Martel Sans, Spectral, Lato, Helvetica Neue For Number, -apple-system, BlinkMacSystemFont, Segoe UI, Roboto, PingFang SC, Hiragino Sans GB, Microsoft YaHei, Helvetica Neue, Helvetica, Arial, sans-serif
$code-font = Monaco, consolas, Menlo, "PingFang SC", "Microsoft YaHei", monospace, Helvetica Neue For Number
$text-line-height = 2
```

这样的话就可以使用自定义的字体 Martel Sans 了。但是这仅限于在本地使用，因为别人的计算机中可能没有这个字体。所以必须制定网页去哪儿加载这个字体。一个方法是，将你系统的字体文件复制到博客根目录的 `source/fonts` 文件夹。

<!-- more -->

```sh
cp /usr/share/fonts/userfonts/MartelSans-Regular.ttf $BLOG/source/fonts/
```
然后编辑主题文件夹下的 `index.styl` 文件，在文件末尾加上
```styl
// $BLOG/themes/melody/source/css/index.styl
...
...

// custom fonts
@font-face{
  font-family: Martel Sans;
  src: url('/fonts/MartelSans-Regular.ttf');
}

// 要添加多个字体，亦复如是
@font-face{
  font-family: IM FELL DW Pica;
  src: url('/fonts/IMFePIrm28P.ttf');
}
```
在修改完这个文件之后，运行 `hexo clean && hexo g` 则会自动在生成的 CSS 文件中加上这段代码，使用指定字体。具体请看
```css
// $BLOG/public/css/index.css
...
...

@font-face {
  font-family: Martel Sans;
  src: url("/fonts/MartelSans-Regular.ttf");
}
@font-face {
  font-family: IM FELL DW Pica;
  src: url("/fonts/IMFePIrm28P.ttf");
}
```

![Font load from localhost:4000 rather than local](fontload.png)
![Font rendered correctly](fontrender.png)

从上面两张图可以看出，指定的字体是从网络加载而非本地。这样以来，执行 `hexo deploy` 命令部署之后，指定字体将会从正确的网络地址被加载，从而正确应用。

## 去除hrline的动画效果

Melody主题对于默认的hrline分割线做了效果，我不太喜欢，认为有失简约，移除之。另外hrline的上下间距也改小了一点。

```styl
// $BLOG/themes/melody/source/css/_global/index.styl

hr
  position: relative
  margin: 1.1rem auto
  width: calc(100% - 4px)
  border: 2px dashed $pale-blue
  background: $white

## add by yychi for removing the
## animation of hrline, 2019-3-16
#  &:hover
#    &:before
#      left: calc(95% - 20px)

  &:before
    position: absolute
    top: -10px
    left: 5%
    z-index: 1
    color: $light-blue
    content: "\f0c4"
    font: normal normal normal 14px / 1 FontAwesome
    font-size: 20px
    transition: all 1s ease-in-out
```

## 去除列表样式

Melody主题对markdown的有序和无序列表做了css样式，不喜，移除之。

```styl
// $BLOG/themes/melody/source/css/_layout/post.styl

// add by yychi for removing the
// ol,ul styles
// 2019-3-16
// 注释掉以下全部代码即可

ol,
ul
  margin-top: 0.4rem
  padding: 0 0 0 0.8rem
  list-style: none
  counter-reset: li

  p
    margin: 0

  ol,
  ul
    padding-left: 0.5rem

  li
    position: relative
    margin: 0.2rem 0
    padding: 0.1rem 0.5rem 0.1rem 1.5rem

    &:hover
      &:before
        transform: rotate(360deg)

    &:before
      position: absolute
      top: 0
      left: 0
      background: $light-blue
      color: #FF0000
      cursor: pointer
      transition: all 0.3s ease-out

ol
  > li
    &:before
      margin-top: 0.2rem
      width: w = 1.2rem
      height: h = w
      border-radius: 0.5 * w
      content: counter(li)
      counter-increment: li
      text-align: center
      font-size: 0.6rem
      line-height: h

ul
  > li
    &:hover
      &:before
        border-color: $ruby

    &:before
      $w = 0.3rem
      top: 10px
      margin-left: 0.45rem
      width: w = $w
      height: h = w
      border: 0.5 * w solid $light-blue
      border-radius: w
      background: $white
      content: ""
      line-height: h
```

## Reference

- [Use multiple @font-face rules in CSS](https://stackoverflow.com/questions/4872592/use-multiple-font-face-rules-in-css)
- [Next主题自定义CSS样式（字体）](https://www.maoxuner.cn/2017/03/08/hexo-next-custom-style.html)
- [使用自定义字体](https://support.google.com/richmedia/answer/7214245?hl=zh-Hans)
