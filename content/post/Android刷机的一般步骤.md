---
title: Android 刷机的一般步骤
date: 2018-09-18 23:00:05
categories: [tech]
tags: ['android', '刷机']

---

## 1. 事前准备

--------------

先想好为什么要刷机？想清楚了吗？真的想清楚了吗！好的，接下来我们要做的事应该是打开一堆网页，一堆对应自己机型的刷机教程帖，还要做好重要数据备份，确保“不成功，也不能成仁”。好的，那就开始吧：

**确定设备解锁状态**

设备锁，也称 Bootloader 锁（BL 锁），通常是厂家为了防止用户乱刷第三方系统设置的屏障，同时，它也是一些诸如「找回手机」、「抹除数据」等安全功能的基础。你应当时刻假设捡到你手机的人是一个专业人士，只要设备在他手里，那么人家就有一百种方法破解你的密码。但是一般人也就只能通过刷入 Recovery 来取缔你手机原有的 rec，进而在里面做文章（比如删除你的密码文件，这样再次开机时，密码就不复存在）。我们可以把 Recovery 想像成电脑的 Bios，于是只要设备在我手上，我想重装多少次系统都可以。也就是说我是可以使用你的设备的，并不像你想的那样：“我设了密码，你用不了。” 

而设备锁，恰恰就是一个安全保障，在对方想要取缔官方 rec 的时候，它出来阻拦：不让你换！而大多数官方的 rec 功能相对简单，并且有官方自己写的保护程序在里面。如果要强行刷机，至少也得先把数据丢了。这某种程度上说明，对方拿不到你的数据，即使他拥有了你的设备！所以对一些商务高层人士，这层防护显得尤为重要。

至此，你应当明白，解开设备锁的**风险**！那么如何判断手机是否已经解锁了呢？方法至少有两种，其一是进入 bootloader 界面（关于如何进入 BL 界面以及 adb 工具的设置请先自己解决，暂时没时间写），执行

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

这个就考验个人搜索能力了。一般而言在各自机型的官方论坛上找：一加论坛，MIUI 论坛都是不错的选择。

其次可以在 [XDA](https://forum.xda-developers.com/) 上找，这是个国外比较活跃的 Android 论坛，里面有很多大牛发各种第三方 Rom 包。一般热门机型都可以在 XDA 上找到自己满意的 Rom.

**下载合适的 Recovery**

推荐[TWRP](https://twrp.me/), 专门做第三方 Rec 的团队，首选！在这个网站上基本上可以下载到自己机型对应的 Rec.

## 2. 刷机

------------

其实事前准备做得足够好的话，刷机很简单，而且风险非常低。

可以使用 MTP 协议事先将刷机包拷贝到手机存储目录 (一般是`/storage/emulated/0/`，在 Rec 下的目录结构可能会发生改变`/sdcard`). 也可以在 Rec 下使用 `adb` 传输。但前提是你要有功能完备的 Rec. 一般官方的 Rec 非常简陋，没什么功能。所以我们首先得刷入第三方 Rec.

**刷入第三方 Recovery**

在确保手机与电脑正确（开启 USB 调试）连接下，在命令行敲
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
重启手机，然后同时按住`电源键 + 音量下键`（有些手机不一样，自行摸索）进入 rec. 也可以等开机后输入
```
$ adb reboot recovery
```
进入 rec.

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

**补丁（root 包，gapps 包）**

- Root：推荐 [Supersu](http://www.supersu.com/) 或者 [Magisk](https://www.xda-developers.com/how-to-install-magisk/)
- Gapps：推荐 [Opengapps](https://opengapps.org/). Google 大法好，不带 Google 框架的安卓不是 Android！
- Custom kernel

> Note: 注意刷包步骤：先 rom 包，后补丁包。不过还是建议刷完 rom 重启一次，再进 rec 刷补丁包比较稳妥。

### A/B slot 刷机

对于新版 A/B slot 机器，刷机步骤为：

1. 刷 rom（如果 rom 自带 recovery，会将 twrp 覆盖，此时需要立刻刷一遍 twrp，确保重启后的 recovery 是 twrp）
2. 重启到 recovery（twrp），这一步将会切到正确的 slot
3. 重启系统

参考：

1. https://forum.xda-developers.com/t/a-b-slots-flashing-in-twrp.3887321/
2. https://www.xda-developers.com/how-a-b-partitions-and-seamless-updates-affect-custom-development-on-xda/?newsletter_popup=1
3. https://forum.xda-developers.com/t/how-to-fix-unable-to-mount-data-internal-storage-0mb-in-twrp-permanently.3830897/

### 被迫刷机

2024 年 11 月 19 夜，由于 xplore（一款很好用的文件管理器，可称塞班时代的遗珠）卡顿，实际上算不上卡顿，我猜是触发了系统的 bug，哪哪都不对劲，具体表现为打开 xplore 卡死，连带大返回都卡，然后恢复正常，可以使用其他应用。强制关掉 xplore 重新开依然如此，而且我还发现开 SDMaid 虽然能开，但里面的扫描一直卡在 0%. 这种场景之前也有过，必须重启才能恢复，所以我想是系统的 bug, 毕竟第三方 ROM -- [PixelPlusUI](https://ppui.site/device/munch) ([XDA](https://xdaforums.com/t/closed-rom-13-munch-pixelplusui-official-aosp.4543117/)). 不过这个 ROM 已经算很稳定的了，自带 Google 套件，在稳定性和可定制性上做到了很好的折中。

重点来了，于是乎我就重启嘛。可能是太久没见 Recovery 的原因（这个 rom 已经稳定用了一年又九个月），我鬼使神差地重启进入 twrp recovery，然后心想着来都来了，清下缓存再重启把。本来勾一个 cache 分区就行了，再次鬼使神差地多勾选了一个 **meta** 分区（虽然不知道它是干嘛的）。结果清完之后直接重启卡 twrp 了，进不去系统了。而且进了 twrp 还 data 分区解密失败。玩球了，数据又要丢了。

其实在准备刷机前，要先把手机密码都清掉，防止 twrp 解密分区失败的，但我这次压根没想刷机。所以带着密码删了清了 meta 分区，结果再次进 twrp，data 分区已经解不出来了。杯具了 orz

本次刷机遇到以下问题

- 格式化 data 分区失败，因为挂载失败，data 分区（系统应用，用户应用及其数据）是加密状态，此时只能选更改文件系统，再改回来，改回来之后惊奇的发现 internal data 分区（文档、照片、音乐、视频等）也被清掉了，直接还给我一台新机！🌿
- 刷入 rom 之后，好几次还是卡 recovery，后来好了，不知道是不是操作步骤的问题。
- 刷入 rom 成功开机后，再次回到 recovery 刷 magisk，刷完继续卡 recovery，只能重刷。
- 重刷之后误操作切换了 slot，导致 `fastboot boot <twrp.img>` 执行失败（见 troubleshooting），这是真的惊悚，从来没遇到过，一度以为真的要成砖了，还好在 xda 找到了类似情况。
- adb/fastboot 设备无权限。

谨此记录。

### 总结

以前刷机，顶多是换 ROM 导致的系统设置数据冲突，此时需要清掉 data 分区，重新配置用户 app. 随着 android 版本提升，安全等级的提高，最近几次刷机过程中总会碰到 data 分区被锁的情况。一旦被锁，极难救回，往往不得不格式化 data 分区甚至 internal storage，面临丢失数据的痛苦。

![](https://cdn.appuals.com/wp-content/uploads/2024/10/twrp-unable-to-mount-storage-1536x864.png)

> What usually happens is that your data is automatically **encrypted by default**. This isn’t a a one-off case for a particular set of devices, since encrypting internal memory was mandated for devices launching with **Android 6.0**, or later.

> Why Does TWRP Require a Screen Lock to Decrypt Data?
>
> TWRP requires the screen lock before decrypting internal storage because of how Android handles device encryption. Android uses either full-disk encryption (FDE) or file-based encryption (FBE), and the decryption key for both of these systems is tied to your password, PIN, or pattern.
>
> For the recovery to access that encrypted data, it needs your screen lock. Without this lock, the decryption key isn't locked behind the authentication methods. This is why removing the screen lock may help in accessing your device's internal storage.

切记，如果要刷机，第一件事就是把屏幕锁去掉。


## 3. 技巧

### 提取当前 ROM 的 boot.img

From xda:

1. Go to recovery.
2. Open recovery terminal.
3. Enter: Code: `dd if=/dev/block/bootdevice/by-name/boot of=/sdcard/boot.img`.
4. Press enter to confirm the command.
5. Reboot to system.

如此即可在用户内存根目录（`/sdcard`）生成 boot.img.

注意：recovery 模式下，`/dev/block/bootdevice/by-name/`目录下才会有`boot`文件。而对于[a/b设备](https://source.android.com/docs/core/ota/ab)，它正是实际 slot 的软链接。

```shell
munch:/dev/block/bootdevice/by-name # file boot
boot: symbolic link to /dev/block/bootdevice/by-name/boot_b
```

任何模式下，可以通过下面的命令获取 active slot：
```shell
munch:/dev/block/bootdevice/by-name # getprop ro.boot.slot_suffix
_b
```
可见当前 active 的是 slot b.

也可以直接提取到电脑上，手机（开机状态或者 recovery 都行）连上电脑，adb 通的情况下，
```
adb pull /dev/block/bootdevice/by-name/boot_b boot.img
```
即可在当前文件夹提取 boot.img. 这里面包含 ramfs，更多请参考 ref #3.

From https://stackoverflow.com/a/21173939

> boot.img contains the kernel and ramdisk, critical files necessary to load the device before the filesystem can be mounted.

From reference #4,

> A *ramdisk* is basically a small filesystem containing the core files needed to initialize the system. It includes the critical init process, as well as init.rc, which is where you can set many system-wide properties.

### 如何查看你的手机会不会锁 data 分区

![abcadjustimg size](/img/posted/phone_encrypted.png "encrypted phone")

打开设置搜索“加密与凭据”如见“加密手机”选项显示“已加密”则表示你的 data 分区会被自动加密。


## 4. Troubleshooting

---------------------

**`adb` 或 `fastboot` 报错：insufficient permission / permission denied**

请按照 https://developer.android.com/studio/run/device 提示操作，唯一需要注意的是 USB 供应商 ID. 可以用 `lsusb` 来判断。

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

**`fastboot boot recovery.img`报错 FAILED (remote: 'Failed to load/authenticate boot image: Load Error')**

这是由于意外切换了a/b slot，即本来 active 的是 a slot，被误操作切换成 b 了，所以 fastboot 执行不下去，切回来就可以。执行

```
# try this
fastboot set_active a
# or
fastboot set_active b
```

see: https://xdaforums.com/t/troubles-reinstalling-twrp-failed-to-load-authenticate-boot-image-load-error.3926815/


## Reference

1. [在硬件设备上运行应用](https://developer.android.com/studio/run/device)
2. [fastboot and adb not working with sudo](https://stackoverflow.com/questions/27017453/fastboot-and-adb-not-working-with-sudo/28127944#28127944)
3. [Boot Image Extraction Guide](https://gist.github.com/gitclone-url/a1f693b64d8f8701ec24477a2ccaab87)
4. [HOWTO: Unpack, Edit, and Repack Boot Images | XDA Forums](https://xdaforums.com/t/howto-unpack-edit-and-repack-boot-images.443994/)
5. [How to Fix TWRP Unable to Mount Storage, Internal Storage 0MB](https://appuals.com/how-to-fix-twrp-unable-to-mount-storage-internal-storage-0mb/#h-why-can-t-twrp-access-my-internal-storage)
6. [How to disable Android Full Disk Encryption](https://jomo.tv/remove-android-device-encryption)
