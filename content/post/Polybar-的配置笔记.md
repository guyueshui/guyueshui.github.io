---
title: Polybar 的配置笔记
date: 2019-01-16 21:33:17
categories: ['Techniques']
tags: ['polybar']
---

前略。

今年早些时候，从 Gnome 换到 i3，原因是因为原来的 gnome 被我弄崩溃了。一时难以解决，又想到之前好几次隐约感觉到 gnome 的不稳定，一气之下决定换一个轻量，稳定的，可定制的窗口管理工具。至于为什么换 i3？去知乎吸收一下各个管理器间的哲学就知道了。以前从 Windows 转 Linux，也是这么过来的，知乎真是个好地方！

换成 i3 之后，经过一番配置，桌面终于有点样子了。但是看了一眼 i3 默认的状态栏，emmm...，有点不堪入目。几经搜索之下，发现了这款名为 polybar 的状态栏工具。起初，我被他的描述深深吸引了：

> [Polybar][1]: A fast and easy-to-use status bar.

事实上它并不是那么 easy-to-use，至少对我这个一开始接触它的人来说。我甚至不知道如何开启它（可能我真的太笨了:(）。然后我开始在网上寻找一些现成的配置，结果不是报错，就是乱码。那些看着好看的配置，你拿过来却用不了。这很气人，然后就告一段落了。我顶着简陋的 i3bar 用了好几个月。直到最近闲下来，要想起来这位老朋友，这才拿出来叙叙旧。

> 有些事情，你当时攻不下来。那就先放一放，择日再战有奇效。

<!-- more -->

## 由浅入深

这次呢，我从一个最简单的例子入手。从[这里][2]找到一个既好看，又简约的模板：

![Image adapted from ref](https://forum.archlabslinux.com/uploads/default/original/1X/13132e9654f0c10ed9c696caa501a40acc7e62fe.png)

我将对应的配置复制到我自己的配置文件（`~/.config/polybar/config`）中:
```ini
[bar/bar]
background = #D93d3c3b
foreground = #b6a49b
width                    = 24%
height                   = 70
radius                   = 15
line-size                = 0
bottom                   = true
border-bottom-size       = 0
padding-left             = 0
padding-right            = 0
#module-margin-left       = 1
#module-margin-right      = 1

fixed-center = true
font-0 = San Francisco Display Regular:size=24;1
font-1 = unifont:fontformat=truetype:size=24:antialias=false;0
font-2 = "MaterialIcons:size=24:antialias=false;1"
font-3 = "icomoon-extended-ultra:size=24:antialias=false;1"
font-4 = "Ubuntu Nerd Font:size=24:antialias=false;1"
font-5 = FontAwesome:size=24;1

modules-left = 
modules-center =
modules-right = date volume eth poweroff 
module-margin = 2

;left - center - right - none
tray-position = none
tray-maxsize = 24
tray-detached = false
tray-transparent = false
tray-padding = 2
tray-scale = 1.0


override-redirect = true
offset-x = 2900
offset-y = 20

padding = 0

wm-name = bar

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

[module/date]
type = internal/date
interval = 60
date = %a %d %b
time = %l:%M %p
label =    %date%      %time%
;label =  %time%
format-padding = 1

[module/volume]
type = internal/volume
format-volume =   <ramp-volume>  <label-volume>
format-muted = 0% 
ramp-volume-0 = 
ramp-volume-1 = 
ramp-volume-2 =  

[module/poweroff]
type = custom/script
exec = echo "  "
click-left = rofi -modi run,drun,window -show drun
click-right = i3lock-fancy -pg &
click-middle = /usr/bin/rofi-logout
format-padding = 1

[module/rofi]
type = custom/script
exec = echo "  "
click-left = rofi -modi run,drun,window -show drun
format-padding = 1

[module/eth]
type = internal/network
interface = enp2s0
interval = 3.0
format-connected = <label-connected>
format-connected-prefix = "  "
format-connected-prefix-foreground = #b6a49b
label-connected = %downspeed:9%
format-disconnected = <label-disconnected>
label-disconnected = not connected
label-disconnected-foreground = #66ffffff
format-padding = 1
```
<div style="text-align:center"><small>Code adapted from ref</small></div>

可以看到，配置文件前半部分为 bar 本身的配置：位置，大小，颜色等等。后半部分则是对应模块的配置。其中，我们看到的一些字符未显示，那是由于我的本地并没有可以显示它的字体。其中的乱码主要是 [Font Awesome][3] 字体，首先我们得安装该字体。看看这个 bar 到底能不能如预期一样正常显示。

执行
```sh
polybar bar
```
来运行配置文件中的 bar，其中“bar”为自定义的名字，在上面的配置文件中，这个 bar 的名字就是 “bar”。（参见`[bar/bar]`）

不知道是什么原因，运行没有报错，但是我却看不见 bar 在哪里。╮(╯_╰)╭ 可能是它画在了屏幕之外的地方。于是我就将上面的参数改了改，终于，我看到了着个可爱又迷人的 bar 出现在我的桌面上。不过还是有几处乱码，可能是我安装的 Font Awesome 支持的字符不完整吧。

然后就开始了漫长的折腾过程，循着错误信息去改对应的地方，然后看效果。再微调，再看效果，直到满意为止。

下面是我调整完成的样子：
![kSXd9s.png](https://s2.ax1x.com/2019/01/16/kSXd9s.png)

## 了解构造

其实通过配置文件，我们可以学到很多东西。当然，前提是要有一个好的蓝本给你看。这就不得不提 polybar 的 [wiki][4]，以及作者给出的一些[示例][5]了。

好了，现在蓝本已经有了。我想添加一个新的模块：比如现在的 Wi-Fi 模块只有下行速度，我要加一个上行速度，并且加上下行箭头。参照 wiki 中的 network 模块，我们可以修改如下：
```ini
[module/wlan]
type = internal/network
interface = wlp2s0
interval = 3.0
format-connected = <label-connected>
format-connected-prefix = " "
format-connected-prefix-foreground = #b6a49b
label-connected = %upspeed:5% %downspeed:5%
format-disconnected = <label-disconnected>
label-disconnected = not connected
label-disconnected-foreground = #66ffffff
format-padding = 0
```
可以看到，被改动的实际上只有一行：
```ini
; before
label-connected = %downspeed:9%
; after
label-connected = %upspeed:5% %downspeed:5%
```
这样就完成了所期望的改变。

> Note: 要输入 Font Awesome 字符，可以打开官网的字符集 [cheatsheet][6]，然后直接复制到编辑器中。
![kpFFm9.png](https://s2.ax1x.com/2019/01/17/kpFFm9.png)
> 例如，通过浏览器搜索找到上行箭头，复制之。
>
> 另外如果使用 vim，可以直接输入对应的十六进制编码来完成字符的输入。比如，我要输入上行箭头（fa-arrow-up），它的十六进制码为 `f062`（在 cheatsheet 中可查）：
> 1. 按 `i` 进入插入模式
> 2. 按 <kbd>Ctrl</kbd> + <kbd>v</kbd>
> 3. 按 `u` 进入十六进制输入模式
> 4. 输入 `f062`
> 5. 按 <kbd>Esc</kbd> 返回正常模式
>
> inputing... <i class="fa fa-arrow-up"> </i>

> 另，`:help i_CTRL-V_digit`
> In insert-mode, type control+V followed by
> - `a` decimal number
> - `x` then a hex number
> - `u` then a 4-hexchar unicode sequence
> - `U` then an 8-hexchar unicode sequence

## 摄入取景

好了，通过上面的一点小小的改动，我们已经大致了解 polybar 的配置方式了。现在，通过一步一步加模块，我们会更进一步的了解它的工作方式。建议每添加一个模块前，先读一读 wiki 上对应模块的设置。然后找一个不错的模板进行改动。

### 内存和 CPU 模块

```ini
;;; CPU usage {{{
[module/cpu]
type = internal/cpu

; Seconds to sleep between updates
; Default: 1
interval = 3.0
; Available tags:
;   <label> (default)
;   <bar-load>
;   <ramp-load>
;   <ramp-coreload>
format = <label><ramp-load>

; Available tokens:
;   %percentage% (default) - total cpu load averaged over all cores
;   %percentage-sum% - Cumulative load on all cores
;   %percentage-cores% - load percentage for each core
;   %percentage-core[1-9]% - load percentage for specific core
label = CPU %percentage%%
;label-font = 3

; Spacing between individual per-core ramps
ramp-coreload-spacing = 1
ramp-coreload-0 = ▁
ramp-coreload-1 = ▂
ramp-coreload-2 = ▃
ramp-coreload-3 = ▄
ramp-coreload-4 = ▅
ramp-coreload-5 = ▆
ramp-coreload-6 = ▇
ramp-coreload-7 = █

; ramps for ramp-load
ramp-load-0 = ▁
ramp-load-1 = ▂
ramp-load-2 = ▃
ramp-load-3 = ▄
ramp-load-4 = ▅
ramp-load-5 = ▆
ramp-load-6 = ▇
ramp-load-7 = █
; colors for each ramp
ramp-load-0-foreground = #aaff77
ramp-load-1-foreground = #aaff77
ramp-load-2-foreground = #aaff77
ramp-load-3-foreground = #aaff77
ramp-load-4-foreground = #fba922
ramp-load-5-foreground = #fba922
ramp-load-6-foreground = #ff5555
ramp-load-7-foreground = #ff5555
;;; }}}
```
首先看到输出的格式为`format = <label><ramp-load>`，说明它会输出`<label>`的值以及`<ramp-load>`的值。好的，那我们先看一眼`<label>`是啥？
```ini
label = CPU %percentage%%
```
顾名思义，它会输出CPU加一个变量，这个变量是一个百分比，就是当前CPU的平均使用率。可选的变量已经在 wiki 中给出。想要什么自己替换就行。

再来看看第二部分，
```ini
ramp-load-0 = ▁
ramp-load-1 = ▂
ramp-load-2 = ▃
ramp-load-3 = ▄
ramp-load-4 = ▅
ramp-load-5 = ▆
ramp-load-6 = ▇
ramp-load-7 = █
```
`ramp-load`共有7个值，他会根据CPU使用率选择合适的值。简而言之，就是将100分成7个等级，使用率越高，就选用等级越高的图案显示。整合起来的效果就是随着百分比增加，显示的高度越高，类似一个性能监视窗，上下浮动。

这还不够，我们还可以做一点微小的工作。请看
```ini
ramp-load-0-foreground = #aaff77
ramp-load-1-foreground = #aaff77
ramp-load-2-foreground = #aaff77
ramp-load-3-foreground = #aaff77
ramp-load-4-foreground = #fba922
ramp-load-5-foreground = #fba922
ramp-load-6-foreground = #ff5555
ramp-load-7-foreground = #ff5555
```
这里我们定义了每个等级展示字符的前景色。等级越高，颜色越红，表示警告CPU使用快超标了！这样整个变化就有了颜色相伴，更加直观！最后完成的效果如下：
![kpVXGt.gif](https://s2.ax1x.com/2019/01/17/kpVXGt.gif)

内存模块也是类似的。先看一下配置，
```ini
[module/memory]
type = internal/memory

; Seconds to sleep between updates
; Default: 1
interval = 3.0
; Available tags:
;   <label> (default)
;   <bar-used>
;   <bar-free>
;   <ramp-used>
;   <ramp-free>
;   <bar-swap-used>
;   <bar-swap-free>
;   <ramp-swap-used>
;   <ramp-swap-free>
format = <label><ramp-used>

; Available tokens:
;   %percentage_used% (default)
;   %percentage_free%
;   %gb_used%
;   %gb_free%
;   %gb_total%
;   %mb_used%
;   %mb_free%
;   %mb_total%
;   %percentage_swap_used%
;   %percentage_swap_free%
;   %mb_swap_total%
;   %mb_swap_free%
;   %mb_swap_used%
;   %gb_swap_total%
;   %gb_swap_free%
;   %gb_swap_used%

label = RAM %percentage_used%%
;label-font = 3

; Only applies if <bar-used> is used
bar-used-indicator =
bar-used-width = 50
bar-used-foreground-0 = #55aa55
bar-used-foreground-1 = #557755
bar-used-foreground-2 = #f5a70a
bar-used-foreground-3 = #ff5555
bar-used-fill = ▐
bar-used-empty = ▐
bar-used-empty-foreground = #444444

; Only applies if <ramp-used> is used
ramp-used-0 = ▁
ramp-used-1 = ▂
ramp-used-2 = ▃
ramp-used-3 = ▄
ramp-used-4 = ▅
ramp-used-5 = ▆
ramp-used-6 = ▇
ramp-used-7 = █
ramp-used-0-foreground = #aaff77
ramp-used-1-foreground = #aaff77
ramp-used-2-foreground = #aaff77
ramp-used-3-foreground = #aaff77
ramp-used-4-foreground = #fba922
ramp-used-5-foreground = #fba922
ramp-used-6-foreground = #ff5555
ramp-used-7-foreground = #ff5555

; Only applies if <ramp-free> is used
ramp-free-0 = ▁
ramp-free-1 = ▂
ramp-free-2 = ▃
ramp-free-3 = ▄
ramp-free-4 = ▅
ramp-free-5 = ▆
ramp-free-6 = ▇
ramp-free-7 = █
;;; }}}
```
配置出来的效果见[上图](#group-4)。

### 电池模块

同理可参考 wiki 配置电池模块。
```ini
;;; battery {{{
[module/battery]
type = internal/battery
full-at = 98

format-charging = <animation-charging> <label-charging>
format-discharging = <ramp-capacity> <label-discharging>
format-full = %{F#666}%{F#ccfafafa} <label-full>
#label-charging-font = 3
#label-discharing-font = 3

ramp-capacity-0 = 
ramp-capacity-1 = 
ramp-capacity-2 = 
; low power alert
ramp-capacity-0-foreground = #ff5555

; it will display over the three pattern when charing
; at a framerate 750
; and each has a foreground color
animation-charging-0 = 
animation-charging-1 = 
animation-charging-2 = 
animation-charging-2-foreground = #aaff77
animation-charging-1-foreground = #fba922
animation-charging-0-foreground = #ff5555
animation-charging-framerate = 750
;;; }}}
```
可以看到电池的显示类型共有三个，
```ini
format-charging = <animation-charging> <label-charging>
format-discharging = <ramp-capacity> <label-discharging>
format-full = %{F#666}%{F#ccfafafa} <label-full>
```
第一个控制了充电时的显示，第二个控制了非充电时的显示，第三个则是满电时的显示。配置语言通俗易懂，比如，充电的时候会显示一个充电动画和电池电量（`<label-charing>`），其他的可以依次类推。

```ini
animation-charging-0 = 
animation-charging-1 = 
animation-charging-2 = 
animation-charging-2-foreground = #aaff77
animation-charging-1-foreground = #fba922
animation-charging-0-foreground = #ff5555
animation-charging-framerate = 750
```
上面这段配置定义了充电时的动画，当你插上电源，电池图标会依次按照0、1、2的图案切换。然后每个图案都有各自的前景色，切换的速率是 750. 完成后的效果如下：
![kpQbCQ.gif](https://s2.ax1x.com/2019/01/17/kpQbCQ.gif)

### MPD 模块

[MPD][7] 全称 Music Player Daemon. 

> MPD (music player daemon) is an audio player that has a server-client architecture. It plays audio files, organizes playlists and maintains a music database, all while using very few resources. In order to interface with it, a separate client is needed.
> <div style="text-align:right">──adpted from archwiki</div>

MPD是一个轻量的本地音乐播放框架。需要和客户端（mpc）一起使用。大致分为几步：

1. `$ mpd` 启动 mpd 进程
2. `$ mpc add <MusicDir>` 添加本地音乐文件夹
3. `$ mpc play` 开始播放

如我们所见，非常轻量。但是 mpc 是命令行工具，使用起来难免有些不顺手。好在 polybar 已经内置了 mpd 模块，我们只需要改改样式就可以了。
```ini
;;; mpd config {{{
[module/mpd]
type = internal/mpd

; format-online = <label-song>  <label-time>  <bar-progress>  <icon-prev> <icon-seekb> <icon-stop> <toggle> <icon-seekf> <icon-next>  <icon-repeat> <icon-random>
format-online = <toggle> <label-song> <icon-next>
format-offline = <label-offline>
format-offline-foreground = #66
label-offline = mpd is off

label-song-maxlen = 20
label-song-font = 8

icon-prev = 
icon-seekb = 
icon-stop = stop
icon-play = 
icon-pause = 
icon-next = 
icon-seekf = 

icon-random = 
icon-repeat = 

toggle-on-foreground = #2278ff
toggle-off-foreground = #66

bar-progress-width = 15
bar-progress-indicator = 
bar-progress-indicator-foreground = #bb
bar-progress-fill = ─
bar-progress-fill-foreground = #bb
bar-progress-fill-font = 3
bar-progress-empty = ─
bar-progress-empty-foreground = #44
bar-progress-empty-font = 3

label-time-foreground = #55
label-time-font = 8
;;; }}}
```
配置好我们需要的样式就大功告成啦，看一下效果：
![kpgZLt.gif](https://s2.ax1x.com/2019/01/17/kpgZLt.gif)


## 总结

一路折腾下来，发现 polybar 其实很友好。配置逻辑也非常清晰，有点怀疑自己当初为什么没有配置好它，反而觉得很难用。所以啊，作者写这个软件也不是为了刁难人的，一开始的时候也并没有这么复杂。我们入手呢，就要从作者一开始写出来的那样，能用出最基础的功能就好了。然后需求都是后来加上去的。有用户提，作者考虑做，或者作者自己想到的功能，才会在后面一步步添加上去。最终成为一个功能相对完善的软件。每个东西都有它的学习曲线，我们可能已经适应了平缓的山坡，突然面对一个陡峭的山峰之时，便不好应对了。但是千里之行，始于足下！我们始终要抓住它们最初的样子，或者说雏形，然后想一想它们是如何发展过来的，顺着这条线路走下去，自然觉得一切合情合理，也有勇气和信心去学了！然后当我们学会一个又一个软件之后，或许会发现它们可能有异曲同工之妙。那便是学到了！

## Reference

- [Polybar wiki][4]
- [Polybar example][5]
- [How to get polybar icons working](https://www.reddit.com/r/unixporn/comments/5pikkd/how_to_get_polybar_icons_working/)
- [Show Us Your Polybar - Artwork / Polybar & Tint2 Configs - ArchLabs Linux][2]

[1]: https://github.com/jaagr/polybar "Polybar"
[2]: https://forum.archlabslinux.com/t/show-us-your-polybar/159/10
[3]: https://fontawesome.com/how-to-use/on-the-desktop/setup/getting-started
[4]: https://github.com/jaagr/polybar/wiki
[5]: https://github.com/jaagr/dots/tree/master/.config/polybar/testing
[6]: https://fontawesome.com/cheatsheet?from=io
[7]: https://www.musicpd.org/
