---
title: HTML 美化 Markdown 排版
date: 2018-12-16 00:04:38
categories: ['Techniques']
tags: ['layour','beautify','html']
---

[Markdown](https://daringfireball.net/projects/markdown/syntax) 是一门轻量标记型语言，因其简单易用而受众甚广。但是正因其简单，故而也有一部分局限性（虽然说它保留的即是最常用、最基本的排版功能）。本文就来说说在使用 Markdown 排版的时候，如何引入一点 HTML 的技巧来帮助我们排版的更加好看。

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
<font size=5px color="#0066FF">I am 天依蓝 of size 5px</font>
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
<font size=5px color="#0066FF">I am 天依蓝 of size 5px</font>
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

```html
<!-- 类似的可以设置 height="100" -->
<img src="miwa.png" width="100" alt="miwa-width=100" />
![miwa](miwa.png)
```
下面是排版结果的对比：
<img src="miwa.png" width="100" alt="miwa-width=100" />
![miwa](miwa.png)

## Reference

> 没有内容的 HTML 元素被称为空元素。空元素是在开始标签中关闭的。`<br>` 就是没有关闭标签的空元素（`<br>` 标签定义换行）。在 XHTML、XML 以及未来版本的 HTML 中，所有元素都必须被关闭。在开始标签中添加斜杠，比如 `<br />`，是关闭空元素的正确方法，HTML、XHTML 和 XML 都接受这种方式。即使 `<br>` 在所有浏览器中都是有效的，但使用 `<br />` 其实是更长远的保障。
> <div style="text-align:right">——w3shcool</div>

- [[HEXO] NexT 主题提高博客颜值](https://walesexcitedmei.github.io/2018/08/30/HEXO-NexT-%E4%B8%BB%E9%A2%98%E6%8F%90%E9%AB%98%E5%8D%9A%E5%AE%A2%E9%A2%9C%E5%80%BC/)
- [HTML 元素](http://www.w3school.com.cn/html/html_elements.asp)
