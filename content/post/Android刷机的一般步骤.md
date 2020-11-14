---
title: Android 刷机的一般步骤
date: 2018-09-18 23:00:05
categories: ['Techniques']
tags: ['android', '刷机']

---

## 1. 事前准备

--------------

先想好为什么要刷机？想清楚了吗？真的想清楚了吗！好的，接下来我们要做的事应该是打开一堆网页，一堆对应自己机型的刷机教程帖，还要做好重要数据备份，确保“不成功，也不能成仁”。好的，那就开始吧：

**确定设备解锁状态**

设备锁，也称 Bootloader 锁（BL 锁），通常是厂家为了防止用户乱刷第三方系统设置的屏障，同时，它也是一些诸如「找回手机」、「抹除数据」等安全功能的基础。你应当时刻假设捡到你手机的人是一个专业人士，只要设备在他手里，那么人家就有一百种方法破解你的密码。但是一般人也就只能通过刷入 Recovery 来取缔你手机原有的 rec，进而在里面做文章（比如删除你的密码文件，这样再次开机时，密码就不复存在）。我们可以把 Recovery 想像成电脑的 Bios，于是只要设备在我手上，我想重装多少次系统都可以。也就是说我是可以使用你的设备的，并不像你想的那样：“我设了密码，你用不了。” 

而设备锁，恰恰就是一个安全保障，在对方想要取缔官方 rec 的时候，它出来阻拦：不让你换！而大多数官方的 rec 功能相对简单，并且有官方自己写的保护程序在里面。如果要强行刷机，至少也得先把数据丢了。这某种程度上说明，对方拿不到你的数据，即使他拥有了你的设备！所以对一些商务高层人士，这层防护显得尤为重要。

至此，你应当明白，解开设备锁的**风险**！那么如何判断手机是否已经解锁了呢？方法至少有两种，其一是进入 bootloader 界面（关于如何进入BL界面以及adb工具的设置请先自己解决，暂时没时间写），执行

```
$ fastboot oem get-bootinfo
    1. Bootloader Lock State : UNLOCKED => 表示已经解锁，可以刷机
    2. Bootloader Lock State : LOCKED => 表示未解锁，自行百度设备解锁方法
```

其二，如果手机还是可用的。进入开发者选项查看，下图是一个已解锁的例子：

<img src="https://i.loli.net/2019/01/06/5c30ebe291246.png" width="300" alt="手机开发者模式" />

如果未解锁，请自行搜索自己设备对应的解锁方法。一般来说小米、一加等厂商较为开放，可在官网申请解锁，可能需要等待 2~3 天的时间。

<!-- more -->

**数据备份**

- 建议使用[钛备份](https://www.coolapk.com/)：可对逐个应用以及系统数据（包括 WIFI 信息，系统设置，短信，联系人，另外还有版本控制）进行备份，root 备份首选。
- Adb 备份
- TWRP 备份

**配置电脑 Android 调试环境**

打开一个终端，敲 `adb` 或者 `fastboot`，如果未显示异常，则说明已经配置好。如下：
```
$ adb --version
Android Debug Bridge version 1.0.40
Version 9.0.0_r3
Installed as /usr/bin/adb
```
若没有配置，安装软件包：`pacman -S android-tools` (Arch Linux ver.) Windows 下载对应的工具包，解压即可。不过需要配置一下路径，或者直接把所有的文件都弄到解压的文件夹下操作。

另说一下驱动，在 Linux 和 Mac OS 下，均不需要考虑驱动的问题。在 Windows 下，需要在网上找到相应设备的驱动，安装好之后，才可以用 `adb` 进行刷机。这里一个显式的标志是：
> 右键开始菜单 => 设备管理器 => ADB interface

如果有这个 ADB 设备，则说明设备驱动已经安装好。

**下载刷机包**

这个就考验个人搜索能力了。一般而言在各自机型的官方论坛上找：一加论坛，MIUI论坛都是不错的选择。

其次可以在 [XDA](https://forum.xda-developers.com/) 上找，这是个国外比较活跃的 Android 论坛，里面有很多大牛发各种第三方 Rom 包。一般热门机型都可以在 XDA 上找到自己满意的 Rom.

**下载合适的 Recovery**

推荐[TWRP](https://twrp.me/), 专门做第三方 Rec 的团队，首选！在这个网站上基本上可以下载到自己机型对应的 Rec.

## 2. 刷机

------------

其实事前准备做得足够好的话，刷机很简单，而且风险非常低。

可以使用 MTP 协议事先将刷机包拷贝到手机存储目录 (一般是`/storage/emulated/0/`，在 Rec 下的目录结构可能会发生改变`/sdcard`). 也可以在 Rec 下使用 `adb` 传输。但前提是你要有功能完备的 Rec. 一般官方的 Rec 非常简陋，没什么功能。所以我们首先得刷入第三方 Rec.

**刷入第三方 Recovery**

在确保手机与电脑正确（开启USB调试）连接下，在命令行敲
```
$ adb devices
    xxxxxx device
```
会列出所有已连接的 Android 设备。在高版本的 Android 系统中应该会弹出一个对话框询问是否允许电脑调试本机，点击一律允许即可。

确保手机已经解锁，开机状态连接电脑。在命令行输入
```
$ adb reboot bootloader
```
手机会重启进入 bootloader，也就是 fastboot 模式。

确保执行目录里面有之前下载的 `twrp-xxx.img` 文件，命令行输入
```
$ fastboot flash recovery twrp-xxx.img
```
即完成第三方 Rec 的刷入。
> Note: 此时也可以选择 fastboot boot twrp-xxx.img 临时从第三方 rec 启动

**进入第三方 Recovery**

在命令行输入
```
$ fastboot reboot
```
重启手机，然后同时按住`电源键 + 音量下键`（有些手机不一样，自行摸索） 进入 rec. 也可以等开机后输入
```
$ adb reboot recovery
```
进入rec.

**刷机**

Twrp 的 rec 界面十分友好，可以设置语言时区等等。刷机之前先要清理（**特别提醒：这里已经默认你做好备份了**）。我们经常清理的有四个分区
```
system                  # 系统分区
data                    # 数据分区：应用数据（设置，帐号，习惯等）
cache/davik cache       # 缓存分区：应用缓存，系统缓存
internal storage        # 个人资料存储：包含照片视频音乐等所有个人资料
```
一般 `internal storage` 是不会动的，把其他三个分区清掉。

然后安装刷机包，找到事先放好的刷机包位置，刷入，重启！
> Note: 或者事先没有拷贝的话，确保命令执行目录中有你的刷机包，使用
> `adb push aex-xxx-rom.zip /sdcard`
> 即可将刷机包拷贝至手机存储目录。
> 
> 再或者，使用 ADB sideload 功能边传文件边刷。具体操作在 rec 中：高级 => ADB sideload
> 然后再命令行输入
> `adb sideload aex-xxx-rom.zip`
> 即可开始刷机

完了！一般重启需要一些时间，请耐心等待一下。

**补丁（root包， gapps包）**

- Root：推荐 [Supersu](http://www.supersu.com/) 或者 [Magisk](https://www.xda-developers.com/how-to-install-magisk/)
- Gapps：推荐 [Opengapps](https://opengapps.org/). Google 大法好，不带 Google 框架的安卓不是 Android！
- Custom kernel

> Note: 注意刷包步骤：先 rom 包，后补丁包。不过还是建议刷完 rom 重启一次，再进 rec 刷补丁包比较稳妥。

## 3. Troubleshooting

---------------------

**`adb` 或 `fastboot` 报错：insufficient permission / permission denied**

请按照 [https://developer.android.com/studio/run/device](https://developer.android.com/studio/run/device) 提示操作，唯一需要注意的是USB供应商ID. 可以用 `lsusb` 来判断。

连接手机之前：
```
$ lsusb
Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 001 Device 004: ID 8087:0a2b Intel Corp. 
Bus 001 Device 003: ID 04f3:0c1a Elan Microelectronics Corp. 
Bus 001 Device 002: ID 04f2:b5a3 Chicony Electronics Co., Ltd 
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
```
连接手机之后：
```
$ lsusb
Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 001 Device 004: ID 8087:0a2b Intel Corp. 
Bus 001 Device 003: ID 04f3:0c1a Elan Microelectronics Corp. 
Bus 001 Device 002: ID 04f2:b5a3 Chicony Electronics Co., Ltd 
Bus 001 Device 041: ID 2717:ff48  
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
```
这样就可以判断该设备的供应商 ID 为 **2717**.

然后重启 `udev` 服务： `udevadm control --reload`（Arch Linux ver.）

拔掉手机线重新插入，再用 `adb devices` 列举一遍，就应该可以了。

> Note: 另外可以尝试使用 root 权限执行命令： `sudo adb` 和 `sudo fastboot`


## Reference

- [在硬件设备上运行应用](https://developer.android.com/studio/run/device)
- [fastboot and adb not working with sudo](https://stackoverflow.com/questions/27017453/fastboot-and-adb-not-working-with-sudo/28127944#28127944)
