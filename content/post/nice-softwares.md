---
title: "小内存机器的自我救赎"
date: Thu Mar 12 2020
lastmod: 2020-03-12T09:46:54+08:00
keywords: []
categories: [应用推荐]
tags: []
draft: false
mathjax: false

---

在此记录一下我自己用过的非常棒的小软件。

## 下载

- [aria2c][2]: 命令行下载工具，支持下载种子、磁力等。有RPC模式，配合WebUI使用更佳。参考[简介](/tricks/#aria2c)。

## 多媒体

- [mpv][3]: 命令行多媒体播放器，拥有较强的扩展性和自定义的空间，另外我自己体验上来看比mplayer要流畅，mplayer在我的机子上有丢帧，而mpv无明显丢帧。
- [mpd/mpc][9]: 音乐播放，没有界面。mpd作为服务端，mpc作为客户端，占用内存非常低。

## 文档

- [zathura][8]: A vim-like pdf reader. vim系快捷键，小而轻，但功能也相对较少。

## 截图

- [flameshot][1]: gnome-screenshot的替代品，支持截图后标记，复制到剪贴板；平台：Linux

## 效率

- [xpad][4]: 小而轻的桌面便签。
- [Taskwarrior][5]: A command-line todo manager, 不要因为它的强大而忘记使用它的初衷。
- [ranger][7]: File manager in terminal, 三页分栏显示文件树，支持文件预览（需安装对应依赖），支持自定义命令，书签等。
- [rofi][10]: dmenu替代品，窗口切换，应用启动器，简约大方，纯文本构成。

## 学习

- [GoldenDict][6]: 离线词典，支持在线页面查词，接有道，维基等，可以看做是Linux上的Eudic，支持多种离线字典格式，支持自定义快捷键查找剪贴板中的单词。

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
