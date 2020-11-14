---
title: 快速自定义 LaTeX 排版字体
date: 2019-03-08 15:41:10
categories: ['Techniques']
tags: ['排版','latex','字体']
---

## 字体设置

在导言区引入`fontspec`包：`\usepackage{fontspec}`

使用如下命令自定义字体：
```tex
% 西文默认字体，排版主字体
\setmainfont{}

% 西文无称线字体
\setsansfont{}

% 西文等宽字体
\setmonofont{}

% 数学公式字体
\setmathfont{}

% 中文主字体
\setCJKmainfont[
    Path = fonts/zh_cn/ ,
    BoldFont = HYQiHei-70S.ttf ,
    ItalicFont = HYKaiTiS.ttf ,
    SmallCapsFont = HYQiHei-70S.ttf
    ]{HYQiHei-45S.ttf}
```
<!-- more -->
> Note: 
>
> - 使用`fc-list`查看系统字体
> - 使用`fc-list: lang=zh`查看中文字体

**直接使用字体文件**

LaTeX可以直接使用未安装的字体文件进行排版，但要指定字体文件的位置等信息。
```tex
\setCJKmainfont[
    Path = ./fonts/zh_cn/ , % specify the file location
    Extension = .ttf , % specify the file suffix [opt]
                       % or add them manually
    BoldFont = HYQiHei-70S.ttf, % '.ttf' can be dropped if 
                                % 'Extension' is specified
    ItalicFont = HYKaiTiS.ttf,  % similarly
]{HYQiHei-45S.ttf}              % set default font to 汉仪旗黑
```
![](https://s2.ax1x.com/2019/03/11/ACHzeH.png)
![](https://s2.ax1x.com/2019/03/11/ACbE6S.png)
从上面两张图可以看出，中文字体不像西文，是没有对应的斜体和粗体的。所以只能用其他字体替代，通过改变字体的方式达到伪斜体，伪粗体的效果。

**设置字体别名**

```tex
\setCJKfamilyfont{zhsong}{HYZhongSongS}
\setCJKfamilyfont{zhhei}{WenQuanYi Micro Hei}
%\setCJKfamilyfont{zhfs}{Adobe Fangsong Std}
%\setCJKfamilyfont{zhkai}{Adobe Kaiti Std}
%\setCJKfamilyfont{zhli}{LiSu}
%\setCJKfamilyfont{zhyou}{YouYuan}

\newcommand*{\songti}{\CJKfamily{zhsong}}   % 宋体
\newcommand*{\heiti}{\CJKfamily{zhhei}}     % 黑体
%\newcommand*{\kaishu}{\CJKfamily{zhkai}}   % 楷书
%\newcommand*{\fangsong}{\CJKfamily{zhfs}}  % 仿宋
%\newcommand*{\lishu}{\CJKfamily{zhli}}     % 隶书
%\newcommand*{\youyuan}{\CJKfamily{zhyou}}  % 幼圆
```
以上为对应的字体设定了我们较为习惯的别名，使用方式如下：
```tex
{\zhsong 这段文字使用宋体字。}
{\zhhei 这段使用黑体。}
```


## LaTeX 字体样式相关命令

**字体大小**

COMMAND | SIZE
:-------|------:
`\tiny` | 5pt
`\scriptsize` | 7pt
`\footnotesize` | 8pt
`\small` | 9pt
`\normalsize` | 10pt
`\large` | 12pt
`\Large` | 14pt
`\LARGE` | 18pt
`\huge` | 20pt
`\Huge` | 24pt

**字体样式**

COMMAND | STYLE
--------|------
`\textbf` | 粗体
`\textit` | 斜体
`\textsl` | slanted斜体
`\textsc` | 小体大写文本
`\underline` | 下划线
`\texttt` | 打字机字族，调用`\setmonofont{}`所设置的字体
`\textsf` | 无称线字族，调用`\setsansfont{}`所设置的字体
`\textrm` | 罗马字族，调用m`\setmainfont{}`所设置的字体

## 扩展包

**ulem 宏包**

在导言区引入：`\usepackage{ulem}`

COMMAND | STYLE
--------|------
`\uline` | 下划线
`\uuline` | 双下划线
`\uwave` | 波浪线
`\sout` | 删除线
`\xout` | 斜删除线
