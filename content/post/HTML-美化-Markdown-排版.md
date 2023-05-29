---
title: HTML 美化 Markdown 排版
date: 2018-12-16 00:04:38
categories: [tech]
tags: [排版, 美化, html]

---

[Markdown](https://daringfireball.net/projects/markdown/syntax) 是一门轻量标记型语言，因其简单易用而受众甚广。但是正因其简单，故而也有一部分局限性（虽然说它保留的即是最常用、最基本的排版功能）。本文就来说说在使用 Markdown 排版的时候，如何引入一点 HTML 的技巧来帮助我们排版的更加好看。

<!--more-->

## 1. 对齐控制

标准的 Markdown 只支持居左对齐。

```html
<center>I am centered</center>
```
会排版出居中的效果：
<!-- centering -->
<center>I am centered</center>

```html
<!-- right-aligned -->
<div style="text-align:right">I am right aligned</div>
```
会排版出居右的效果：
<div style="text-align:right">I am right aligned</div>

<!-- more -->

## 2. 字体控制

通过 HTML 标签，我们可以精确的控制字体族，字体大小，字体颜色，字体形态（粗体，斜体，下划线，删除线）等等。具体参见[w3school](http://www.w3school.com.cn/tags/tag_font.asp).

```html
<font size='3' color="red">I am red of size 3</font>
<font size=5px color="#66CCFF">I am 天依蓝 of size 5px</font>
<font face="verdana" color="green">I am verdana of color green</font>
<u>I am underlined</u>
<s>I am deleted :(</s>
<b>I am bolded</b>
<i>I am italic</i>
<big>I am bigger than you</big>
<small>I am smaller than you</small>
look<sup>at</sup><sub>me</sub>
<kbd>Ctrl+Shift+D</kbd>
<q>using this for short quote</q>
<div style="background-color:black">举世皆白我独黑</div>
```
的排版效果：

<font size='3' color="red">I am red of size 3</font>
<font size=5px color="#66CCFF">I am 天依蓝 of size 5px</font>
<font face="verdana" color="green">I am verdana of color green</font>
<u>I am underlined</u>
<s>I am deleted :(</s>
<b>I am bolded</b>
<i>I am italic</i>
<big>I am bigger than you</big>
<small>I am smaller than you</small>
look<sup>at</sup><sub>me</sub>
<kbd>Ctrl+Shift+D</kbd>
<q>using this for short quote</q>
<div style="background-color:black">举世皆白我独黑</div>

## 3. 使用 FontAwesome 图标

[FontAwesome](https://fontawesome.com/start) 是一款图标字体集合。以下 Icon 的名称均可以在[官网](https://fontawesome.com/icons)查到：
```html
<i class="fa fa-check-square"> </i> completed
<i class="fa fa-square"> </i> uncompleted
<i class="fa fa-github"> </i> github icon
<i class="fa fa-weixin"> </i> wechat icon
<i class="fa fa-rss"> </i> rss icon
<i class="fa fa-twitter"> </i> twitter icon
<i class="fa fa-weibo"> </i> weibo icon
<i class="fa fa-weibo fa-lg"> </i> large weibo icon
<i class="fa fa-weibo fa-2x"> </i> 2\*weibo icon
<i class="fa fa-weibo fa-4x"> </i> 4\*weibo icon
```
的排版效果如下：
<i class="fa fa-check-square"> </i> completed
<i class="fa fa-square"> </i> uncompleted
<i class="fa fa-github"> </i> github icon
<i class="fa fa-weixin"> </i> wechat icon
<i class="fa fa-rss"> </i> rss icon
<i class="fa fa-twitter"> </i> twitter icon
<i class="fa fa-weibo"> </i> weibo icon
<i class="fa fa-weibo fa-lg"> </i> large weibo icon
<i class="fa fa-weibo fa-2x"> </i> 2\*weibo icon
<i class="fa fa-weibo fa-4x"> </i> 4\*weibo icon

## 4. 插图控制

### 大小控制

```html
<!-- 类似的可以设置 height="100" -->
<img src="miwa.png" width="100" alt="miwa-width=100" />
![miwa](miwa.png)
```
下面是排版结果的对比：

<img src="/img/miwa.png" width="100" alt="miwa-width=100" />

![miwa](/img/miwa.png "miwa gutarissimo")

### 图标题
```html
![hover text](https://hbimg.huaban.com/fe01cdf198b7da8ffec56f52fcf505acffca258a1fb3a-j6MBCO_/fw/480/format/webp "sample caption")
<figcaption>颇有意境的美少女</figcaption>
```

![hover text](https://hbimg.huaban.com/fe01cdf198b7da8ffec56f52fcf505acffca258a1fb3a-j6MBCO_/fw/480/format/webp "sample caption")
<figcaption>颇有意境的美少女</figcaption>

如此能生效的原因是本站加载了名为`figcaption`的 css，所以这个标签能够被正确排版。使用本主题 [^a] 只需要在主题文件夹下的`_custom.scss`中增加：

```scss
// file: <site-root>/themes/even/assets/sass/_custom/_custom.scss
figcaption {
  // background-color: #222;
  color: gray;
  padding: 3px;
  text-align: center;
  margin-top: -20px;
  margin-bottom: 20px;
}
```
即可。


## 5. ShortCode

Hugo 提供了 [ShortCode][1] 功能，简单来说就是强大的 html 替换模版，因为直接在 markdown 里面写 html 会显得冗长，所以将一个个排版样式作为 ShortCode 提供给用户使用。详情参考文档，这里列举一些本主题[^a]提供的 ShortCode.

> 不建议使用 ShortCode，因为脱离了 hugo，这些元素就无法渲染了。为了保持 markdown 源文件的兼容性，不推荐使用此功能。

```html
{{% center %}}
{{% bilibili BV1qs411D7Po %}}
sample b23 video desc
{{% /center %}}
```
> 完球，上述代码段已经是展开后的形式了，应该是 hugo 转网页的时候一定会做替换，目前还没找到 escape 的方法，先将就着看吧。

可排版出如下内容

{{% center %}}
{{% bilibili BV1qs411D7Po %}}
sample bilibli video desc
{{% /center %}}

但其实上述内容在普通
![](raw-shortcode.png)  
<figcaption>ShortCode 在 vscode 中的排版效果</figcaption>


## 6. 代码高亮

> NOTE: 这个功能依赖 hugo，不建议使用。

Cf. https://gohugo.io/content-management/syntax-highlighting/#highlighting-in-code-fences

<pre style="word-wrap: break-word; white-space: pre-wrap;">
```go  {linenos=table,hl_lines=[8,"15-17"],linenostart=199}
// GetTitleFunc returns a func that can be used to transform a string to
// title case.
//
// The supported styles are
//
// - "Go" (strings.Title)
// - "AP" (see https://www.apstylebook.com/)
// - "Chicago" (see https://www.chicagomanualofstyle.org/home.html)
//
// If an unknown or empty style is provided, AP style is what you get.
func GetTitleFunc(style string) func(s string) string {
  switch strings.ToLower(style) {
  case "go":
    return strings.Title
  case "chicago":
    return transform.NewTitleConverter(transform.ChicagoStyle)
  default:
    return transform.NewTitleConverter(transform.APStyle)
  }
}
```
</pre>
会排版出如下效果

```go  {linenos=table,hl_lines=[8,"15-17"],linenostart=199}
// GetTitleFunc returns a func that can be used to transform a string to
// title case.
//
// The supported styles are
//
// - "Go" (strings.Title)
// - "AP" (see https://www.apstylebook.com/)
// - "Chicago" (see https://www.chicagomanualofstyle.org/home.html)
//
// If an unknown or empty style is provided, AP style is what you get.
func GetTitleFunc(style string) func(s string) string {
  switch strings.ToLower(style) {
  case "go":
    return strings.Title
  case "chicago":
    return transform.NewTitleConverter(transform.ChicagoStyle)
  default:
    return transform.NewTitleConverter(transform.APStyle)
  }
}
```


## Reference

> 没有内容的 HTML 元素被称为空元素。空元素是在开始标签中关闭的。`<br>` 就是没有关闭标签的空元素（`<br>` 标签定义换行）。在 XHTML、XML 以及未来版本的 HTML 中，所有元素都必须被关闭。在开始标签中添加斜杠，比如 `<br />`，是关闭空元素的正确方法，HTML、XHTML 和 XML 都接受这种方式。即使 `<br>` 在所有浏览器中都是有效的，但使用 `<br />` 其实是更长远的保障。
> <div style="text-align:right">——w3shcool</div>

- [[HEXO] NexT 主题提高博客颜值](https://walesexcitedmei.github.io/2018/08/30/HEXO-NexT-%E4%B8%BB%E9%A2%98%E6%8F%90%E9%AB%98%E5%8D%9A%E5%AE%A2%E9%A2%9C%E5%80%BC/)
- [HTML 元素](http://www.w3school.com.cn/html/html_elements.asp)

[^a]: [Hugo theme even][1]

[1]: https://github.com/olOwOlo/hugo-theme-even
[2]: https://gohugo.io/content-management/shortcodes/
