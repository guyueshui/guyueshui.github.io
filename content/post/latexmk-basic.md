---
title: "Latexmk基础用法"
date: 2020-04-13T23:50:55+08:00
lastmod: 2020-04-13T23:50:55+08:00
keywords: []
categories: []
tags: []
draft: false
mathjax: false

---

怎么想到用latexmk的呢？写论文呗！

本来呢，我一直习惯于使用命令行手敲
```bash
pdflatex someting.tex
```
千万别小看这种重复劳动，它不仅帮你加深记忆，还有最完整的输出，让你一窥Tex排版系统的内裤（→_→，一本正经胡说八道中……）。还记得Archlinux的哲学名言吗？--Keep it simple and stupid (KISS)--说得太对了呀！

但是啊说到写论文，肯定要有引用文献的啦，这就麻烦了，每次更新参考文献和交叉引用都需要四步走：
```bash
pdflatex a.tex  # 生成aux文件，下一步bibtex才能知道需要引用哪几个文献
bibtex a        # 生成bbl文件，及将.bib里面的元数据展开成符合tex语法的bibitem
pdflatex a.tex  # 刷新引用，可能残留一些问号
pdflatex a.tex  # 产生最终结果，所有引用正确显示
```
这就忍不了了吧？其实我还是能忍的，因为不是每次更新文献就重新编译，可以写一大段再更新一次，这就省事儿多了。真正原因是我像用VS code写latex，下了一个插件叫Latex Workshop，它默认使用pdflatex编译，但我写中文必须要用xelatex编译，而且必须要完成自动化。

我看到可以用latexmk，所以就去简单研究了下，下面进入正题。

## 命令行使用

```bash
latexmk
```
默认情况下会自动编译当前文件夹下所有tex文件，默认使用pdflatex引擎。

如果想编译得到PDF文件，则直接加上选项：
```bash
latexmk -pdf
```

如果想编译单个文件：
```bash
latexmk single_file.tex
```

要删除临时文件：
```bash
latexmk -c
latexmk -C ## 删除（包含输出文件）
```

## 配置文件

- `~/.latexmkrc`：用户全局配置
- `$PWD/latexmkrc`：局部文件夹配置

一个简单的配置文件：
```perl
$dvi_previewer = 'start xdvi -watchfile 1.5';
$ps_previewer  = 'start gv --watch';
$pdf_previewer = 'start evince';

$pdf_mode = 1;                              # tex -> pdf
# $pdf_mode = 2;                            # tex -> ps -> pdf
# $pdf_mode = 5;                            # use xelatex, see `man latexmk`
$postscript_mode = 1;                       # tex -> ps
@defalut_files = ('main.tex', 'niam.tex');  # 指定要编译的文件

$pdflatex = 'pdflatex -interaction=nonstopmode -synctex=1 %O %S';
$xelatex = 'xelatex -no-pdf -interaction=nonstopmode -synctex=1 %O %S';
```

## References

- [Using Latexmk][1]
- [Make latexmk 4.54c use synctex with xelatex][2]

[1]: https://mg.readthedocs.io/latexmk.html
[2]: https://ipfs-sec.stackexchange.cloudflare-ipfs.com/tex/A/question/408783.html
