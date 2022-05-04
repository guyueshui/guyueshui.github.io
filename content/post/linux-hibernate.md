---
title: "Linux的休眠"
date: 2020-07-13T22:44:33+08:00
keywords: []
categories: [linux]
tags: [hibernate]
draft: false
mathjax: false

---

先区分一下两个名词：睡眠（sleep）和休眠（hibernate）。

- 睡眠：将工作镜像写入内存（RAM），以便快速恢复。内存读写很快，所以睡眠的特点就是“睡得快”和“醒得快”。对于笔记本来说，合上盖子就睡了，打开盖子你的工作区间即刻就能恢复，很是方便。但是睡眠有一个缺点，就是要给内存供电，一旦断电，你的镜像数据就会丢失，工作区间将不复存在。当然这来自于内存的固有特点，建议百度RAM。
- 休眠：将工作镜像写入硬盘（disk，ROM），这样你也可以恢复工作区间。只是睡下去和醒过来的时间比内存慢不少。但是，它有一个好处就是断电了也不会丢失数据。当你再次开机，系统就会从硬盘里面读取镜像，恢复你的工作区间。

<!--more-->

作为一个不求甚解的小白，我用linux这么些年，一直都只用过睡眠，每天晚上合上笔记本的盖子，第二天早上打开，工作区间即刻恢复，其实也是非常方便的，再也不用忍受关机开机的痛苦。这样一夜下来，大概要耗费7-8%的电量，还可以接受不是=。= 但是一旦你很长时间没用电脑，比如说放长假回家了，好久没碰电脑，那么笔记本的电池是会耗尽的，此时你的工作区间就丢了。（当然，这样的情况并不多见）

其实我以前也是鼓捣过linux休眠的，大概3-4年前，刚接触linux那会儿，在网上一通乱搜，一顿瞎试，未果。现在想来，失败的原因一是当时太菜，而是当时那个电脑太老旧了。据我所知，GPT分区下搞休眠的坑是比较多的。现在的电脑大都是EFI分区，更加简单易用。

总体来说，休眠还是值得折腾的，因为支持断电！而且现在普遍使用固态硬盘，休眠和恢复的速度也并不是很慢。还有一个很重要的原因，笔记本电池的寿命很短，我的本子买了3年了，现在电池容量已经缩水2/3了！

好了，闲话少叙，进入正题。

## 确保swap分区足够大

拟使用swap分区作为写入镜像的目标分区。

一般建议swap分区为本机内存的一半，不过我认为有条件的还是将swap分区设置的略大于内存。此处，由于睡眠是将镜像写到内存，要确保swap分区能够容得下这个镜像，就必须将swap分区设置的大于内存。这并不是说swap小于内存就无法休眠了[^a]，具体还是要看工作区间的镜像大小了。我现在的swap就只有本机内存的一半，但还是休眠成功了。

## 查看`fstab`

```bash
$ cat /etc/fstab
# <file system>             <mount point>  <type>  <options>  <dump>  <pass>
# /dev/nvme0n1p5
UUID=547054ce-bb1b-40e4-a38d-24507d31d5ca   /           ext4        rw,relatime   0 1

UUID=6E76-7D08          /boot/efi   vfat        rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=iso8859-1,shortname=mixed,utf8,errors=remount-ro   0 2

# /dev/nvme0n1p7
UUID=4227170f-0a4f-4a8e-a4fd-0d91f46f54af   none        swap        defaults,pri=-0 0
```
系统启动时会读取该文件，按照其中的描述挂载对应的分区。默认生成的`fstab`中，swap分区的类型是`swap`，将它改为`none`.

以下命令均可以查看分区信息：
```bash
$ lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda           8:0    0 223.6G  0 disk 
├─sda1        8:1    0   110G  0 part /home/yychi/EXTRA
└─sda2        8:2    0 113.6G  0 part 
nvme0n1     259:0    0 238.5G  0 disk 
├─nvme0n1p1 259:1    0   100M  0 part /boot/efi
├─nvme0n1p2 259:2    0    16M  0 part 
├─nvme0n1p3 259:3    0 119.5G  0 part 
├─nvme0n1p4 259:4    0   798M  0 part 
├─nvme0n1p5 259:5    0    65G  0 part /
├─nvme0n1p6 259:6    0    49G  0 part /home
└─nvme0n1p7 259:7    0   4.1G  0 part [SWAP]

$ sudo blkid -o list
device           fs_type  label     mount point          UUID
----------------------------------------------------------------------------------------------
/dev/nvme0n1p1   vfat     ESP       /boot/efi            6E76-7D08
/dev/nvme0n1p2                      （未挂载）      
/dev/nvme0n1p3   ntfs     OS        （未挂载）      CADC772DDC7712C5
/dev/nvme0n1p4   ntfs               （未挂载）      624AD5CA4AD59B5D
/dev/nvme0n1p5   ext4     ROOT      /                    547054ce-bb1b-40e4-a38d-24507d31d5ca
/dev/nvme0n1p6   ext4     HOME      /home                1e23c2e3-6b73-465a-bd60-355b1bc4060b
/dev/nvme0n1p7   swap               [SWAP]               4227170f-0a4f-4a8e-a4fd-0d91f46f54af
/dev/sda1        ext4     DATA      /home/yychi/EXTRA    e66f87ee-33d8-4aaa-bff0-400df2276ef7
/dev/sda2        ntfs               （未挂载）      07B60D0A64472B59
```

## 添加恢复分区的内核参数

```bash
# 查看当前内核启动命令
$ cat /proc/cmdline
\\boot\vmlinuz-linux ro root=/dev/nvme0n1p5 rw resume=/dev/nvme0n1p7 initrd=boot\initramfs-linux.img
```
可以看到，内核的启动参数中`resume=/dev/nvme0n1p7`这一项就指定了从该分区恢复，而该分区正是swap分区。

那么如何修改内核的命令行参数呢？找到你所使用的boot manager（启动引导）程序，更改相应的配置。我使用的是[rEFInd][8]，需要做的更改为：
```conf
# file: /boot/refind_linux.conf
"Boot with standard options"  "ro root=/dev/nvme0n1p5 rw resume=/dev/nvme0n1p7"
"Boot to single-user mode"    "ro root=/dev/nvme0n1p5 single"
```
直接在第一行最后的参数列表里加上`rw resume=/dev/nvme0n1p7`即可。Ubuntu默认使用grub作为引导，这个网上教程更为详尽，此处就不再复制粘贴了。

## 重新生成启动镜像

作完更改之后，使用
```bash
$ mkinitcpio -P
```
重新生成启动镜像，使更改生效，最后重启系统。

重新进入系统之后，
```bash
$ cat /proc/cmdline
\\boot\vmlinuz-linux ro root=/dev/nvme0n1p5 rw resume=/dev/nvme0n1p7 initrd=boot\initramfs-linux.img
```
如果参数列表里有`resume=/dev/nvme0n1p7`则说明设置成功。你可以打开一个程序，然后
```bash
systemctl hibernate
```
令系统休眠，然后再按下电源开关，系统会自动恢复之前的工作环境。

今天先这样，写的不够详细，改日再完善吧~

---

## Re: hibernation

万万没想到，今日（2022-05-04 00:14），我又为了休眠的事儿排查了两天之久。

自文章写完之后，一年多来，休眠一直工作的很好。直到这次五一，我准备解决一下之前一直悬而未决的[屏幕撕裂](../记一次重装linux#intel集成显卡滚动屏幕出现撕裂现象)问题。在此过程中，我尝试了启用笔记本的独显NVIDIA Corporation GP108M [GeForce MX150], 也为此做了很多工作，甚至从Nvidia官网下载了驱动进行安装，就是这个过程，安装报错了，然后我打算放弃，执行了卸载，卸载也报错了。最后实现的效果，确实X和picom都运行在独显上了，但是进入X之后，屏幕一片漆黑。彼时夜已深，我就打算放弃了。直接电脑休眠，而我去睡觉了。

第二天打开电脑，才发现大事不妙。直接变成开机了，之前的工作状态并未还原。思来想去这期间干了什么呢？尝试安装独显驱动，解决屏幕撕裂，archlinux-keyring损坏并重置，进行了系统全量更新（内核升级到5.17.5-arch1-1）, 很难排查到底是什么原因导致的。只能打开journal细细排查可能的原因，
```bash
$ journalctl -b
...
5月 04 00:01:11 MiBook-Air kernel: ACPI BIOS Error (bug): Could not resolve symbol [\_PR.PR00._CPC], AE_NOT_FOUND (20211217/psargs-330)
5月 04 00:01:11 MiBook-Air kernel: ACPI Error: Aborting method \_PR.PR01._CPC due to previous error (AE_NOT_FOUND) (20211217/psparse-529)
5月 04 00:01:11 MiBook-Air kernel: ACPI BIOS Error (bug): Could not resolve symbol [\_PR.PR00._CPC], AE_NOT_FOUND (20211217/psargs-330)
5月 04 00:01:11 MiBook-Air kernel: ACPI Error: Aborting method \_PR.PR02._CPC due to previous error (AE_NOT_FOUND) (20211217/psparse-529)
5月 04 00:01:11 MiBook-Air kernel: ACPI BIOS Error (bug): Could not resolve symbol [\_PR.PR00._CPC], AE_NOT_FOUND (20211217/psargs-330)
5月 04 00:01:11 MiBook-Air kernel: ACPI Error: Aborting method \_PR.PR03._CPC due to previous error (AE_NOT_FOUND) (20211217/psparse-529)
...
```
第一个疑似的原因就是这个，但经过一番搜索，他也仅仅是个内核的bug[^b]，并不能证明他和休眠失败有直接关系。

接着我直接找到这段时间的系统日志，一行一行的查看，凡是有疑似的都搜索之，未果。期间我发现，之前正常休眠恢复的日志序列大概是下面这个样子：
```bash
4月 28 23:59:06 MiBook-Air systemd-sleep[515989]: Entering sleep state 'hibernate'...
4月 28 23:59:06 MiBook-Air kernel: PM: hibernation: hibernation entry
4月 29 19:48:53 MiBook-Air kernel: Filesystems sync: 0.004 seconds
4月 29 19:48:53 MiBook-Air kernel: Freezing user space processes ... (elapsed 0.001 seconds) done.
4月 29 19:48:53 MiBook-Air kernel: OOM killer disabled.
4月 29 19:48:53 MiBook-Air kernel: PM: hibernation: Marking nosave pages: [mem 0x00000000-0x00000fff]
4月 29 19:48:53 MiBook-Air kernel: PM: hibernation: Marking nosave pages: [mem 0x00058000-0x00058fff]
4月 29 19:48:53 MiBook-Air kernel: PM: hibernation: Marking nosave pages: [mem 0x0009e000-0x000fffff]
4月 29 19:48:53 MiBook-Air kernel: PM: hibernation: Marking nosave pages: [mem 0x71d1c000-0x71d1cfff]
4月 29 19:48:53 MiBook-Air kernel: PM: hibernation: Marking nosave pages: [mem 0x71d48000-0x71d48fff]
4月 29 19:48:53 MiBook-Air kernel: PM: hibernation: Marking nosave pages: [mem 0x725dc000-0x725dcfff]
4月 29 19:48:53 MiBook-Air kernel: PM: hibernation: Marking nosave pages: [mem 0x725ec000-0x725ecfff]
4月 29 19:48:53 MiBook-Air kernel: PM: hibernation: Marking nosave pages: [mem 0x7312f000-0x73130fff]
4月 29 19:48:53 MiBook-Air kernel: PM: hibernation: Marking nosave pages: [mem 0x75388000-0x75c87fff]
4月 29 19:48:53 MiBook-Air kernel: PM: hibernation: Marking nosave pages: [mem 0x7c026000-0x7c02bfff]
4月 29 19:48:53 MiBook-Air kernel: PM: hibernation: Marking nosave pages: [mem 0x8be9e000-0x8cffdfff]
4月 29 19:48:53 MiBook-Air kernel: PM: hibernation: Marking nosave pages: [mem 0x8cfff000-0xffffffff]
4月 29 19:48:53 MiBook-Air kernel: PM: hibernation: Basic memory bitmaps created
4月 29 19:48:53 MiBook-Air kernel: PM: hibernation: Preallocating image memory
4月 29 19:48:53 MiBook-Air kernel: PM: hibernation: Allocated 676076 pages for snapshot
4月 29 19:48:53 MiBook-Air kernel: PM: hibernation: Allocated 2704304 kbytes in 0.38 seconds (7116.58 MB/s)
4月 29 19:48:53 MiBook-Air kernel: Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
4月 29 19:48:53 MiBook-Air kernel: printk: Suspending console(s) (use no_console_suspend to debug)
```
可以看到，日志从4月28日23:59:06一下子跳到4月29日19:48:53，也就是说我在28日晚上发起了休眠，在29日晚上再度打开电脑，成功恢复了工作区。

而在休眠失败后日志是下面这样：
```bash
5月 01 02:13:41 MiBook-Air systemd[1]: Reached target Sleep.
5月 01 02:13:41 MiBook-Air systemd[1]: Starting Hibernate...
5月 01 02:13:41 MiBook-Air kernel: PM: Image not found (code -16)
5月 01 02:13:41 MiBook-Air dhcpcd[463]: wlp2s0: old hardware address: f8:63:3f:4d:a1:8e
5月 01 02:13:41 MiBook-Air dhcpcd[463]: wlp2s0: new hardware address: 66:34:25:c7:18:31
5月 01 02:13:41 MiBook-Air systemd-sleep[13740]: Entering sleep state 'hibernate'...
5月 01 02:13:41 MiBook-Air dhcpcd[463]: wlp2s0: old hardware address: 66:34:25:c7:18:31
5月 01 02:13:41 MiBook-Air dhcpcd[463]: wlp2s0: new hardware address: f8:63:3f:4d:a1:8e
5月 01 02:13:41 MiBook-Air kernel: PM: hibernation: hibernation entry
-- Boot a60e8709e7b945abbcdb13a477011e7b --
5月 01 18:43:13 MiBook-Air kernel: Linux version 5.17.5-arch1-1 (linux@archlinux) (gcc (GCC) 11.2.0, GNU ld (GNU Binutils) 2.38) #1 SMP PREEMPT Wed, 27 Apr 2022 20:56:11 +0000
5月 01 18:43:13 MiBook-Air kernel: Command line: ro root=/dev/nvme0n1p5 rw resume=/dev/nvme0n1p7 initrd=boot\initramfs-linux.img
5月 01 18:43:13 MiBook-Air kernel: x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
5月 01 18:43:13 MiBook-Air kernel: x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
5月 01 18:43:13 MiBook-Air kernel: x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
5月 01 18:43:13 MiBook-Air kernel: x86/fpu: Supporting XSAVE feature 0x008: 'MPX bounds registers'
5月 01 18:43:13 MiBook-Air kernel: x86/fpu: Supporting XSAVE feature 0x010: 'MPX CSR'
5月 01 18:43:13 MiBook-Air kernel: x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
5月 01 18:43:13 MiBook-Air kernel: x86/fpu: xstate_offset[3]:  832, xstate_sizes[3]:   64
5月 01 18:43:13 MiBook-Air kernel: x86/fpu: xstate_offset[4]:  896, xstate_sizes[4]:   64
5月 01 18:43:13 MiBook-Air kernel: x86/fpu: Enabled xstate features 0x1f, context size is 960 bytes, using 'compacted' format.
```
同样在时间跳跃节点看，此前的日志看起来是休眠成功了，此后竟然直接走了boot流程！因此我猜测肯定是恢复（resume）过程出了问题，休眠（hibernation）是正常工作的。

我尝试过将内涵参数中的`resume=/dev/xxx`改为`resume=UUID=xxx-xxxx-xx`，也还是不行。最让人无奈的是，到现在没有发现问题所在，一直在摸黑尝试。

后来看到两篇文章（其实就是Ref2中提及的）:

1. [Debugging hibernation and suspend][10]
2. [BEST PRACTICE TO DEBUG LINUX* SUSPEND/HIBERNATE ISSUES][11]

开始对休眠过程进行更具针对性的debug，推荐从第一篇文章开始。经过一番debug，发现我的休眠功能确实没啥问题，恢复功能也没问题，即第一篇文章提到的：

> That test can be used to check if failures to resume from hibernation are
related to bad interactions with the platform firmware.  That is, if the above
works every time, but resume from actual hibernation does not work or is
unreliable, the platform firmware may be responsible for the failures.

但即便知道了可能是硬件问题，我也看不出来是哪里的问题啊（太菜了orz）。无奈之下尝试第二篇的debug方法，在鼓捣了一对内核参数之后，日志确实更详尽了，但其中暴露出的问题，google都没有搜索结果。我哪看得懂啊？最后带着快要放弃的心情，再次翻开了ArchWiki（再次高呼，ArchWiki YYDS！）上的一篇文章（Ref7）, 其中提到：

> The kernel parameters will only take effect after rebooting. To be able to hibernate right away, obtain the volume's major and minor device numbers from [lsblk](https://wiki.archlinux.org/title/Lsblk "Lsblk") and echo them in format `*major*:*minor*` to `/sys/power/resume`. If using a swap file, additionally echo the resume offset to `/sys/power/resume_offset`.[\[2\]](https://www.kernel.org/doc/html/latest/power/swsusp.html)

我就试探性的照做了，
```bash
yychi@~> lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda           8:0    0 223.6G  0 disk 
├─sda1        8:1    0   110G  0 part /home/yychi/EXTRA
└─sda2        8:2    0 113.6G  0 part 
nvme0n1     259:0    0 238.5G  0 disk 
├─nvme0n1p1 259:1    0   100M  0 part /boot/efi
├─nvme0n1p2 259:2    0    16M  0 part 
├─nvme0n1p3 259:3    0 119.5G  0 part 
├─nvme0n1p4 259:4    0   798M  0 part 
├─nvme0n1p5 259:5    0    65G  0 part /
├─nvme0n1p6 259:6    0    49G  0 part /home
└─nvme0n1p7 259:7    0   4.1G  0 part [SWAP]
yychi@~> echo 259:7 > /sys/power/resume
```
以及[此处][13]提及
- When an [initramfs](https://wiki.archlinux.org/title/Initramfs "Initramfs") with the `base` hook is used, which is the default, the `resume` hook is required in `/etc/mkinitcpio.conf`. Whether by label or by UUID, the swap partition is referred to with a udev device node, so the `resume` hook must go *after* the `udev` hook. This example was made starting from the default hook configuration:
```
HOOKS=(base udev autodetect keyboard modconf block filesystems **resume** fsck)
```
Remember to [regenerate the initramfs](https://wiki.archlinux.org/title/Regenerate_the_initramfs "Regenerate the initramfs") for these changes to take effect.
- When an initramfs with the `systemd` hook is used, a resume mechanism is already provided, and no further hooks need to be added.

总结一下：就是往`/sys/power/resume`里写入正确的数值，以及在`/etc/mkinitcpio.conf`里加上`resume`hook，重新`mkinitcpio -P`，然后**休眠恢复就成功**了！

### 小尝试

经过尝试，把`/etc/mkinitcpio.conf`中HOOKS中的resume去掉，再`mkinitcpio -P`，再次休眠后就无法恢复，直接走boot流程了。并且启动后`/sys/power/resume`的值丢失了（恢复默认）:
```bash
$ cat /sys/power/resume
0:0
```

而将HOOKS中的resume加上之后，再`mkinitcpio -P`生效之，重启后
```bash
$ cat /sys/power/resume
259:7
```
有值了，而且休眠之后可以成功恢复。

看起来就是这里的原因了，恢复的时候由于找不到swap分区导致fallback到boot流程，而resume hook就是起到告诉kernel swap分区的标识，因此才能成功恢复。但有一个问题，之前我没有动过这些，也能休眠并恢复成功。从[ArchWiki上的描述][13]来看，HOOKS中使用了`systemd`的，不需要加`resume`；使用了`base`的，需要加`resume`。看来是某些操作改了我的`/etc/mkinitcpio.conf`？

## Bonus: 使用sleep hook在休眠时上锁

此前使用休眠的场景是这样的：terminal里面敲`systemctl hibernate`，等待休眠成功，合上盖子，time flies, 打开盖子，启动电源，恢复工作区。这个过程没有涉及到用户验证，所以如果此间别人拿了你的电脑，自然能一窥你的裙底风光。所以，合理的做法应该是休眠时顺便锁个屏。

其实ArchWiki也有提到[^c][^d]，利用`systemd`管理的service可以做到。具体说来，可以创建如下文件：
```ini
# /etc/systemd/system/suspend@.service
# see: https://wiki.archlinux.org/title/Power_management#Sleep_hooks

[Unit]
Description=User suspend actions
Before=sleep.target

[Service]
User=%I
Type=simple
Environment=DISPLAY=:0
ExecStart=/usr/bin/slock
ExecStartPost=/usr/bin/sleep 1

[Install]
WantedBy=sleep.target
```
形如`xxx@.service`的文件称为template service，它可以带一个参数拼接成一个instantiated service文件，比如`xxx@username.service`，具体可参考`man 5 systemd.service`. 上述我创建了一个`suspend@.service`，然后我们启用（enable on boot）一个instantiated service
```bash
$ systemctl enable suspend@yychi.service
```
接着reload一下使其立刻生效，
```bash
$ systemctl daemon-reload
```
然后调用`systemctl hibernate`看看效果，果然在挂起、恢复之后，出现了锁屏界面[^e]。

热心观众可能发现，上述service对`systemctl suspend`同样生效，其原因是suspend和hibernate同样都在`sleep.target`之后，而我们的service定义了`Before=sleep.target`，说明`suspend@yychi.service`要在`sleep.target`之前执行。因此无论是sleep还是hibernate都能用上。印证如下：
```bash
yychi@/etc/systemd/system> systemctl cat suspend.target                                21:15
[Unit]
Description=Suspend
Documentation=man:systemd.special(7)
DefaultDependencies=no
Requires=systemd-suspend.service
After=systemd-suspend.service
StopWhenUnneeded=yes

yychi@/etc/systemd/system> systemctl cat systemd-suspend.service                       21:37
[Unit]
Description=System Suspend
Documentation=man:systemd-suspend.service(8)
DefaultDependencies=no
Requires=sleep.target
After=sleep.target  # 注意此处

[Service]
Type=oneshot
ExecStart=/usr/lib/systemd/systemd-sleep suspend

yychi@/etc/systemd/system> systemctl cat hibernate.target                              21:37
[Unit]
Description=System Hibernation
Documentation=man:systemd.special(7)
DefaultDependencies=no
Requires=systemd-hibernate.service
After=systemd-hibernate.service
StopWhenUnneeded=yes

yychi@/etc/systemd/system> systemctl cat systemd-hibernate.service                     21:38
# /usr/lib/systemd/system/systemd-hibernate.service
[Unit]
Description=Hibernate
Documentation=man:systemd-hibernate.service(8)
DefaultDependencies=no
Requires=sleep.target
After=sleep.target  # 注意此处

[Service]
Type=oneshot
ExecStart=/usr/lib/systemd/systemd-sleep hibernate
```

关于休眠，暂时探索至此...


## References

1. [Is Hybrid Sleep the same in Linux as in Windows?][1]
2. [How can I hibernate on Ubuntu 16.04?][2]
3. [How do I use pm-suspend-hybrid by default instead of pm-suspend?][3]
4. [Kernel parameters][4]
5. [Error resume: no device specified for hibernation][5]
6. [Hibernation: Resume Can't Find Swap][6]
7. [Power management/Suspend and hibernate - ArchWiki][9]

[^a]: See [Arch wiki][7]
[^b]: [ACPI BIOS Error (bug)][12]: Could not resolve symbol \[\\_PR.PR00._CPC\]
[^c]: [Suspend/resume service files][14]
[^d]: [Slock - lock on suspend][15]
[^e]: 此处我用的是[slock][15]，X下一个非常简单轻巧的锁屏工具。简单到什么程度呢？它连配置文件都没有，想要自定义，必须改`config.h`然后重新编译！

[1]: https://superuser.com/questions/1124966/is-hybrid-sleep-the-same-in-linux-as-in-windows
[2]: https://askubuntu.com/questions/768136/how-can-i-hibernate-on-ubuntu-16-04/821122#821122
[3]: https://askubuntu.com/questions/145443/how-do-i-use-pm-suspend-hybrid-by-default-instead-of-pm-suspend/781957#781957
[4]: https://wiki.archlinux.org/index.php/kernel_parameters#rEFInd
[5]: https://forum.manjaro.org/t/error-resume-no-device-specified-for-hibernation/119074
[6]: https://bbs.archlinux.org/viewtopic.php?id=156497
[7]: https://wiki.archlinux.org/index.php/Power_management/Suspend_and_hibernate#About_swap_partition.2Ffile_size
[8]: https://wiki.archlinux.org/index.php/REFInd
[9]: https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate
[10]: https://www.kernel.org/doc/Documentation/power/basic-pm-debugging.txt
[11]: https://01.org/blogs/rzhang/2015/best-practice-debug-linux-suspend/hibernate-issues
[12]: https://github.com/intel/linux-intel-lts/issues/22
[13]: https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Configure_the_initramfs
[14]: https://wiki.archlinux.org/title/Power_management#Sleep_hooks
[15]: https://wiki.archlinux.org/title/Slock#Lock_on_suspend