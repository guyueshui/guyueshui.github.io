---
title: "小内存机器的自我救赎"
date: 2020-03-12
keywords: []
categories: []
tags: [tools, tiny, apps, tool-list, software-list]
draft: false
mathjax: false

---

在此记录一下我自己用过的非常棒的小软件。

## 下载

- [aria2c][2]: 命令行下载工具，支持下载种子、磁力等。有 RPC 模式，配合 WebUI 使用更佳。参考[简介](/tricks/#aria2c)。

## 多媒体

- [mpv][3]: 命令行多媒体播放器，拥有较强的扩展性和自定义的空间，另外我自己体验上来看比 mplayer 要流畅，mplayer 在我的机子上有丢帧，而 mpv 无明显丢帧。
- [mpd/mpc][9]: 音乐播放，没有界面。mpd 作为服务端，mpc 作为客户端，占用内存非常低。

## 文档

- [zathura][8]: A vim-like pdf reader. vim 系快捷键，小而轻，但功能也相对较少。

## 截图

- [flameshot][1]: gnome-screenshot 的替代品，支持截图后标记，复制到剪贴板；平台：Linux
    - `flameshot gui`: 直接打开截屏功能，更多参考`flameshot -h`.
- [peek][11]: 小巧易用的录屏软件，支持录制 gif, mp4, webm 等格式。

## 效率

- [xpad][4]: 小而轻的桌面便签。
- [Taskwarrior][5]: A command-line todo manager，不要因为它的强大而忘记使用它的初衷。
- [ranger][7]: File manager in terminal，三页分栏显示文件树，支持文件预览（需安装对应依赖），支持自定义命令，书签等。
- [rofi][10]: dmenu 替代品，窗口切换，应用启动器，简约大方，纯文本构成。
- [Everything][12]: windows 平台，免费且简单易用的全局搜索器，该有的都有。
- [QTTabBar][13]: 众所周知，windows 文件管理器十分难用，尤其是不支持 tab，所以，它来了。

## 学习

- [GoldenDict][6]: 离线词典，支持在线页面查词，接有道，维基等，可以看做是 Linux 上的 Eudic，支持多种离线字典格式，支持自定义快捷键查找剪贴板中的单词。

## VSCode 插件

```bash
$ code --list-extensions
bungcip.better-toml
tomoki1207.pdf
huacnlee.autocorrect                   # 修正中英混合排版的问题
huizhou.githd                          # git history, blame on single file
mhutchie.git-graph                     # git graph
KylinIDETeam.cmake-intellisence
llvm-vs-code-extensions.vscode-clangd  # c++ dev
twxs.cmake                             # cmake syntax support
vadimcn.vscode-lldb                    # c++ debug
vscodevim.vim
```

See: https://zhuanlan.zhihu.com/p/566365173.

> 首先，当把鼠标停在某个函数，然后点击右键，会发现它多出了非常熟悉的选项。
> 
> 接着来试一下符号跳转，按住 Control，然后鼠标左键，就可以对函数进行跳转。
> 
> 它也可以对文件进行跳转，使用 Control+P，打开标识符搜索框。
> 
> 原来这个标识符搜索框是只可以搜索文件的，但现在可以搜索符号了，使用 @ ，是在当前文件夹下搜索一个标识符。
> 
> 这里比较少，就只有 main，可以多加两个函数：int fun1(){} 和 Void fun2(){}。再试试，就会发现它这里就有了三个标识符。
> 
> 除了能在当前文件中搜索外，还可以使用 # 来在全局搜索：Control+P，输入 #print 可以搜索 print，选择后，可以来到 studio 这个文件下。

[1]: https://flameshot.js.org/#/
[2]: https://aria2.github.io
[3]: https://mpv.io
[4]: https://launchpad.net/xpad
[5]: https://taskwarrior.org/
[6]: http://goldendict.org/
[7]: https://github.com/ranger/ranger
[8]: https://pwmt.org/projects/zathura/
[9]: https://www.musicpd.org/
[10]: https://github.com/davatorium/rofi
[11]: https://github.com/phw/peek
[12]: https://www.voidtools.com/zh-cn/
[13]: http://qttabbar.wikidot.com/
