---
title: "Metapost学习笔记"
date: 2020-03-31T09:20:44+08:00
lastmod: 2020-03-31T09:20:44+08:00
keywords: []
categories: [Notes]
tags: [metapost, 作图]
draft: false
mathjax: false

---

想必你也有过这样的疑问，中学数学书上的那些精美的作图是如何画出来的？一直以来，我都想学习一门绘图语言，只是久久未能行动orz...

![](https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=3812944475,2492602811&fm=26&gp=0.jpg)

闲话少叙，开始学习！

## Metapost

介绍什么的，我其实不太关心，所以就不写了……

## 一个简单的例子

和C语言一样，Metapost有一个源文件`xxx.mp`，有一个编译器`mpost`，然后编译之，即得到图片（默认后缀`.mps`）。

```mp
% file:///hello.mp
prologues := 3;
outputtemplate := "%j-%c.mps";
outputformat := "mps";

beginfig(1);
  draw (0,0)--(11,0)--(11,11)--(0,11)--cycle;
endfig;

beginfig(2);
  draw (0,0)..(11,0)..(11,11)..(0,11)..cycle;
endfig;
end
```
几点说明：

- Metapost语句以分号结尾，**除了最后的`end`**!
- 设置`prologues:=3`会在生成的图像文件`.ps`中嵌入字体信息，这会增加图片大小
- 默认单位：PostScript Points (1/72in = 0.352777... mm)

这里简单说一下源码结构，和LaTeX一样，Metapost有导言区，可以做一些设置之类的工作。如`hello.mp`中前三句就设置了输出文件格式，以及文件名规范等。然后作图部分主要由`beginfig--endfig`块控制。
```mp
beginfig(x);
  draw something;
  draw anything;
endfig;
```
括号中的x替换为数字，类似图片id. 一个源文件中可以有多个`beginfig--endfig`块，编译后每个块对应一张图片。

编译`hello.mp`后即可得到两张图片：
```bash
$ mpost hello.mp
This is MetaPost, version 2.00 (TeX Live 2018) (kpathsea version 6.3.0)
(/usr/local/texlive/2018/texmf-dist/metapost/base/mpost.mp
(/usr/local/texlive/2018/texmf-dist/metapost/base/plain.mp
Preloading the plain mem file, version 1.005) ) (./hello.mp [1] [2] )
2 output files written: hello-1.mps .. hello-2.mps
Transcript written on tmp.log.
```

<center>
<figure>
    <object data="/img/posted/mpost/hello-1.svg" type="image/svg+xml" width="100" height="100">
    </object>
    <figcaption>Fig-1</figcaption>
</figure>
<figure>
    <object data="/img/posted/mpost/hello-2.svg" type="image/svg+xml" width="100" height="100">
    </object>
    <figcaption>Fig-2</figcaption>
</figure>
</center>

Metapost按坐标画图非常简单，将坐标点一个一个连起来就行了，注意到`--`表示直线连接，`..`表示平滑的曲线连接。和众多编程语言一样，你也可以定义变量方便重复使用。

```mp
beginfig(3);
  z0 = (0,0);
  z1 = (60,40);
  z2 = (40,90);
  z3 = (10,70);
  z4 = (30,50);
  draw z0..z1..z2..z3..z4;
endfig
```
<figure>
  <center>
    <object data="/img/posted/mpost/hello-3.svg" type="image/svg+xml" width="150" height="150">
    </object>
  </center>
  <figcaption>Fig-3</figcaption>
</figure>

## Workflow

使用默认输出格式会产生PostScript格式的图片，在Linux下可以用gnome中的evince查看。也可以使用`epstopdf`转化为PDF查看。

<figure>
  <center>
  <img src="https://i.stack.imgur.com/l1AeU.png" />
  </center>
  <figcaption>Image adapted from ref1</figcaption>
</figure>

## Primitives

### 变量类型

Metapost几个常见的类型：

- `pair`: (0,0) and (3,4)
- `path`: (0,0)--(3,4)
- `pen`: (implicit) pen for stroking

比如：
```mp
beginfig(0)
  u:=1cm;
  pair a,b; path p; pen mypen;
  a = (0,0); b = (3u,4u);
  p = a--b;
  mypen = pencircle scaled 1mm;
  pickup mypen;
  draw p;
endfig;
```

![](/img/posted/mpost/demo-0.svg)

All MetaPost variable types:

| Type      | Example                                      |
|-----------|----------------------------------------------|
| numeric   |  (default, if not explicitly declared)       |
| pair      | `pair a; a := (2in,3mm);                   ` |
| boolean   | `boolean v; v := false;                    ` |
| path      | `path p; p := fullcircle scaled 5mm;       ` |
| pen       | `pen r; r := pencircle;                    ` |
| picture   | `picture q; q := nullpicture;              ` |
| transform | `transform t; t := identity rotated 20;    ` |
| color     | `color c; c := (0,0,1);` (blue)              |
| cmykcolor | `cmykcolor k; k := (1,0.8,0,0);` (some blue) |
| string    | `string s; s := "Hello";                   ` |

## 弯曲控制

我们已经知道使用`..`可以让Metapost在两点之间画出平滑的曲线，尽管它画的很好（默认使用[贝塞尔曲线][1]），但有时候我们往往需要控制哪里该要陡一点，哪里平缓一点。对于这种需求，Metapost同样提供了精细粒度的控制方法。

```mp
beginfig(4);
  for i=0 upto 9:
    draw (0,0){dir 45}..{dir 10a}{6cm, 0};
  endfor
endfig;
```

<figure>
  <center>
    <object data="/img/posted/mpost/hello-4.svg" type="image/svg+xml" width="300"> 
    </object>
  </center>
  <figcaption>Fig-4</figcaption>
</figure>

可以看出，从图上起点（左边的点），对应坐标(0,0)，引出一族曲线，这些曲线在(0,0)处的左极限都是1，呈现出45度角。而在终点(6cm,0)处的入角从0度到90度变化，正如语句中描述的。

未完待续……

![](/img/posted/mpost/pics-19.svg)


## Reference

1. [Which Output file should I export from Metapost?][2]
2. [Metapost for Beginners][3]
3. [Learning METAPOST by Doing][4]
4. [Tutorial in MetaPost][5]

[1]: https://zh.wikipedia.org/zh-cn/%E8%B2%9D%E8%8C%B2%E6%9B%B2%E7%B7%9A
[2]: https://tex.stackexchange.com/questions/502533/which-output-file-should-i-export-from-metapost
[3]: https://meeting.contextgarden.net/2008/talks/2008-08-22-hartmut-metapost/mptut-context2008.pdf
[4]: https://staff.fnwi.uva.nl/a.j.p.heck/Courses/mptut.pdf
[5]: https://tex.loria.fr/prod-graph/heck-metapost2003.pdf
