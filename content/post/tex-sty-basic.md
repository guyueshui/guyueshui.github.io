---
title: "一个really simple的LaTeX宏包"
date: 2020-04-26T09:25:09+08:00
lastmod: 2020-04-26T09:25:09+08:00
keywords: []
categories: [Notes]
tags: [排版,tex]
draft: false
mathjax: false

---

众所周知，LaTeX是一个高效易用的排版软件，基本上只要找到合适的模板，剩下的就只剩码字了。比起MS Word，简直不知道高到哪里去。就拿最近写论文的事来说，我先用TeX码好字，然后要投的那个刊需要用Word提交。转格式转了我一下午带一晚上，太痛苦了。深刻的体会到什么叫自以为是，MS Word自作聪明地给你调格式。当你敲下回车之后，天知道它又会自动帮你做些什么？！

好了，闲话少叙。这次主要是记录一下在使用LaTeX排版中文的时候，觉得每次都要定义字体很麻烦。于是干脆写成一个宏包的形式。之后的文档中如果需要排中文，直接导入这个包，就可以直接使用啦。说是宏包，实际上里面只包含自定义字体，惭愧惭愧，我并不是TeX专家。

一个TeX宏包大概长成下面这个样子：
```tex
% This package provides a zh_CN font customization for convinience.
% yychi (guyueshui002@gmail.com)
% 2019-09-25 10:10

\NeedsTeXFormat{LaTeX2e}[1994/06/01]
\ProvidesPackage{zhfont}[General zh_CN font setting for tex.]

\ifx\zhfontpath\undefined
  \newcommand{\zhfontpath}{/path/to/font}
\else
  \message{\string\zhfontpath\space is defined by some others.}
\fi

\RequirePackage{xeCJK}
\setCJKmainfont[Path=\zhfontpath, BoldFont=方正小标宋_GBK.ttf, ItalicFont=方正仿宋_GBK.ttf]{方正书宋_GBK.ttf}
\setCJKsansfont[Path=\zhfontpath]{方正黑体_GBK.ttf}
\setCJKmonofont[Path=\zhfontpath]{方正中等线_GBK.ttf}

%%% font alias
\setCJKfamilyfont{fzxbs}[Path=\zhfontpath]{FZXBSJW.TTF}
\setCJKfamilyfont{fzhei}[Path=\zhfontpath]{方正黑体_GBK.ttf}
\setCJKfamilyfont{fzkai}[Path=\zhfontpath]{方正楷体_GBK.ttf}
\setCJKfamilyfont{fzfs}[Path=\zhfontpath]{方正仿宋_GBK.ttf}

%% 使用ctex系document，这些字体已被定义，所以做个case
\ifx\songti\undefined
  \newcommand*{\songti}{\CJKfamily{fzxbs}}   % 宋体
\fi
\ifx\heiti\undefined
  \newcommand*{\heiti}{\CJKfamily{fzhei}}    % 黑体
\fi
\ifx\kaiti\undefined
  \newcommand*{\kaiti}{\CJKfamily{fzkai}}    % 楷体
\fi
\ifx\fangsong\undefined
  \newcommand*{\fangsong}{\CJKfamily{fzfs}}  % 仿宋
\fi

\endinput
% vim:ft=tex
```
通过例子来学习，不失为一个好方法。上面的就是我为自己自定义的字体配置的宏包，还包含了一定的控制流呢。<s>鬼知道我查这些关键字查了多久。</s>要想设置中文并成功排版出来，必须使用`xeCJK`红包。里面包含的三条主要设定及其意义如下：
```tex
\setCJKmainfont[Path=\zhfontpath,
                BoldFont=方正小标宋_GBK.ttf,
                ItalicFont=方正仿宋_GBK.ttf]
                {方正书宋_GBK.ttf}                     % 设置中文主字体
\setCJKsansfont[Path=\zhfontpath]{方正黑体_GBK.ttf}    % 设置中文无衬线字体
\setCJKmonofont[Path=\zhfontpath]{方正中等线_GBK.ttf}  % 设置中文等宽字体
```
上面三条命令就设定好了中文排版主字体，无衬线以及等宽字体。注意如果是已安装的字体，则不需要指定`Path`和文件名后缀。比如我列一下我已经安装的中文字体：
```bash
$ fc-list :lang=zh
/usr/share/fonts/wenquanyi/wqy-zenhei/wqy-zenhei.ttc: 文泉驿等宽正黑,WenQuanYi Zen Hei Mono,文泉驛等寬正黑:style=Regular
/usr/share/fonts/wenquanyi/wqy-microhei/wqy-microhei.ttc: 文泉驿微米黑,WenQuanYi Micro Hei,文泉驛微米黑:style=Regular
/usr/share/fonts/wenquanyi/wqy-microhei/wqy-microhei.ttc: 文泉驿等宽微米黑,WenQuanYi Micro Hei Mono,文泉驛等寬微米黑:style=Regular
/usr/share/fonts/wenquanyi/wqy-zenhei/wqy-zenhei.ttc: 文泉驿正黑,WenQuanYi Zen Hei,文泉驛正黑:style=Regular
```
则相应的字体设定为：
```tex
\setCJKmainfont[BoldFont=somefont,ItalicFont=somefont]{WenQuanYi Micro Hei}
\setCJKsansfont{WenQuanYi Zen Hei}
\setCJKmonofont{WenQuanYi Zen Hei Mono}
```
后面就是定义一些常用中文字体：宋体、黑体、楷体、仿宋等。注意在使用ctex系文档时，自定义的名字可能已被定义，比如使用`\documentclass{ctextart}`，`\songti`命令已被定义，如果使用了我们自定义的宏包`zhfont`，则会报错命令重复定义。此时可以用`\renewcommand`强制重新定义，也可以使用ctex默认的。总之，我这里加了条件主要是为了学一下TeX里面的控制流。

## Reference

- https://texfaq.org/FAQ-isdef
- https://stackoverflow.com/questions/1211888/is-there-any-way-i-can-define-a-variable-in-latex
- https://tex.stackexchange.com/questions/265809/if-elseif-and-else-conditionals-in-the-preamble
