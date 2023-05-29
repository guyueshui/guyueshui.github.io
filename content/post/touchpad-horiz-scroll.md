---
title: "Linux 笔记本触摸板水平滚动问题"
date: 2022-03-25T23:03:59+08:00
lastmod: 2022-03-25T23:03:59+08:00
keywords: []
categories: [linux]
tags: []
draft: false
mathjax: false

---

自打使用 linux 系统以来，触摸板这块的体验一只是个痛点：只支持基本的点击，双指垂直滚动。很久以来我就一直想要触摸板水平滚动的功能。今天终于实现了！

## Synaptics

其实很久以前就照抄过一份`xf86-input-synaptics`驱动程序的触摸板配置：
```bash
# file: /etc/X11/xorg.conf.d/70-synaptics.conf
Section "InputClass"
	Identifier "touchpad"
	Driver	"synaptics"
	MatchIsTouchpad "on"
		Option "TapButton1" "1"
		Option "TapButton2" "3"
		Option "TapButton3" "2"
		Option "VertEdgeScroll" "on"
		Option "VertTwoFingerScroll" "on"
		Option "HorizonEdgeScroll" "on"
		Option "HorizonTwoFingerScroll" "on"
		Option "EmulateTwoFingerMinZ" "40"
		Option "EmulateTwoFingerMinW" "8"
		Option "FingerLow" "30"
		Option "FingerHigh" "50"
		Option "VertScrollDelta" "-111"
		Option "HorizScrollDelta" "-111"
EndSection
```
但很奇怪，一直以来水平滚动一直没生效。其实想来也是乌龙，是我抄错了：
```sh
# 正确的应该是 Horiz 而非 Horizon
Option "HorizEdgeScroll" "on"
Option "HorizTwoFingerScroll" "on"
```
其实只要改正并重启一下，事情就完美解决了。可惜我一直没发现，还尝试研究为啥水平滚动不生效呢，他文档明明这么写了，难道是诓我？

`synclient`是用于实时更改 synaptics 驱动参数的命令行工具，使用
```bash
synclient HorizTwoFingerScroll=1
```
即可开启水平滚动。事情本应到此结束，但是我惊讶的发现 synaptics 驱动已经停止维护，archwiki 上已经推荐大家使用`libinput`了。

## Libinput

Cf. https://wiki.archlinux.org/title/Libinput

参考 archwiki 直接把触摸板输入驱动换成`libinput`，尤其值得注意，如果`/etc/X11/xorg.conf.d`中需要移除（最好先备份）之前的 synaptic driver 的配置文件，比如我的：
```bash
rm /etc/X11/xorg.conf.d/70-synaptics.conf
```
删除之后像这样：
```bash
yychi@/etc/X11/xorg.conf.d> ls -al
总用量 12
drwxr-xr-x 2 root root 4096  3月 26 00:23 ./
drwxr-xr-x 4 root root 4096  1月  3 20:53 ../
-rw-r--r-- 1 root root  337  3月 26 00:23 00-keyboard.conf
lrwxrwxrwx 1 root root   43  3月 25 23:23 40-libinput.conf -> /usr/share/X11/xorg.conf.d/40-libinput.conf
```
看下配置文件：
```bash
cat 40-libinput.conf
Section "InputClass"
        Identifier "touchpad"
        MatchIsTouchpad "on"
        Driver "libinput"
        Option "AccelerationProfile" "2"
        Option "Sensitivity" "0.1"
        Option "Tapping" "on"
        Option "ClickMethod" "clickfinger"
        Option "TappingButtonMap" "lrm"
        Option "NaturalScrolling" "on"
EndSection
```

**特别注意**

注意到文件夹中还有一个文件`00-keyboard.conf`，由于我们换了驱动，而 libinput 是所有输入的驱动，包括键盘，所以必须适当更改该文件，否则重启进来之后你会发现键盘失效！
```bash
ychi@/etc/X11/xorg.conf.d> cat 00-keyboard.conf
# Written by systemd-localed(8), read by systemd-localed and Xorg. It's
# probably wise not to edit this file manually. Use localectl(1) to
# instruct systemd-localed to update it.
Section "InputClass"
        Identifier "system-keyboard"
        MatchIsKeyboard "on"
        Driver "libinput"	# 这行必须指定 driver 为 libinput，否则重启后键盘无法输入
        Option "XkbLayout" "cn"
EndSection
```

配置完成后用`xinput`看看：
```bash
yychi@/etc/X11/xorg.conf.d> xinput
⎡ Virtual core pointer                    	id=2	[master pointer  (3)]
⎜   ↳ Virtual core XTEST pointer              	id=4	[slave  pointer  (2)]
⎜   ↳ ELAN2301:00 04F3:306B Touchpad          	id=11	[slave  pointer  (2)]
⎣ Virtual core keyboard                   	id=3	[master keyboard (2)]
    ↳ Virtual core XTEST keyboard             	id=5	[slave  keyboard (3)]
    ↳ Power Button                            	id=6	[slave  keyboard (3)]
    ↳ Video Bus                               	id=7	[slave  keyboard (3)]
    ↳ Video Bus                               	id=8	[slave  keyboard (3)]
    ↳ Sleep Button                            	id=9	[slave  keyboard (3)]
    ↳ XiaoMi USB 2.0 Webcam: XiaoMi U         	id=10	[slave  keyboard (3)]
    ↳ AT Translated Set 2 keyboard            	id=12	[slave  keyboard (3)]
    ↳ Wireless hotkeys                        	id=13	[slave  keyboard (3)]
yychi@/etc/X11/xorg.conf.d> xinput list-props 11	# 由上可知 id=11 为触摸板
Device 'ELAN2301:00 04F3:306B Touchpad':
	Device Enabled (189):	1
	Coordinate Transformation Matrix (191):	1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000
	libinput Tapping Enabled (327):	1
	libinput Tapping Enabled Default (328):	0
	libinput Tapping Drag Enabled (329):	1
	libinput Tapping Drag Enabled Default (330):	1
	libinput Tapping Drag Lock Enabled (331):	0
	libinput Tapping Drag Lock Enabled Default (332):	0
	libinput Tapping Button Mapping Enabled (333):	1, 0
	libinput Tapping Button Mapping Default (334):	1, 0
	libinput Natural Scrolling Enabled (335):	1
	libinput Natural Scrolling Enabled Default (336):	0
	libinput Disable While Typing Enabled (337):	1
	libinput Disable While Typing Enabled Default (338):	1
	libinput Scroll Methods Available (339):	1, 1, 0
	libinput Scroll Method Enabled (340):	1, 0, 0
	libinput Scroll Method Enabled Default (341):	1, 0, 0
	libinput Click Methods Available (342):	1, 1
	libinput Click Method Enabled (343):	0, 1
	libinput Click Method Enabled Default (344):	1, 0
	libinput Middle Emulation Enabled (345):	0
	libinput Middle Emulation Enabled Default (346):	0
	libinput Accel Speed (347):	0.000000
	libinput Accel Speed Default (348):	0.000000
	libinput Accel Profiles Available (349):	1, 1
	libinput Accel Profile Enabled (350):	1, 0
	libinput Accel Profile Enabled Default (351):	1, 0
	libinput Left Handed Enabled (352):	0
	libinput Left Handed Enabled Default (353):	0
	libinput Send Events Modes Available (312):	1, 1
	libinput Send Events Mode Enabled (313):	0, 0
	libinput Send Events Mode Enabled Default (314):	0, 0
	Device Node (315):	"/dev/input/event6"
	Device Product ID (316):	1267, 12395
	libinput Drag Lock Buttons (354):	<no items>
	libinput Horizontal Scroll Enabled (355):	1
	libinput Scrolling Pixel Distance (356):	15
	libinput Scrolling Pixel Distance Default (357):	15
	libinput High Resolution Wheel Scroll Enabled (358):	1
```
发现驱动已经成功更换为`libinput`，并且
```sh
	libinput Horizontal Scroll Enabled (355):	1
```
表明已成功开启水平滚动。

## Libinput-gestures

`libinput-gestures`是一个脚本工具，它可以接收`libinput`的 event 并作出相应的 action，进而达到手势操作的目地。具体可参考 3.


## References

1. [ArchWiki: Touchpad Synaptics][1]
2. [ArchWiki: Libinput][2]
3. [对 Linux 下触控板按键、加速和手势的优化（libinput）][3]
4. [Linux 下 MacBook 触摸板设置][4]


[1]: https://wiki.archlinux.org/title/Touchpad_Synaptics
[2]: https://wiki.archlinux.org/title/Libinput
[3]: https://www.eaimty.com/2020/09/optimize-touchpad-on-linux-with-libinput-driver.html
[4]: https://harttle.land/2019/05/01/linux-macbook-trackpad-settings.html