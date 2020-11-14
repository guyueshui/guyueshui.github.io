---
title: "Linux的休眠"
date: 2020-07-13T22:44:33+08:00
lastmod: 2020-07-13T22:44:33+08:00
keywords: []
categories: [linux]
tags: [hibernate]
draft: false
mathjax: false

---

先区分一下几个名词：睡眠（sleep）和休眠（hibernate）。

- 睡眠：将工作镜像写入内存（RAM），以便快速恢复。内存读写很快，所以睡眠的特点就是“睡得快”和“醒得快”。对于笔记本来说，合上盖子就睡了，打开盖子你的工作区间即刻就能恢复，很是方便。但是睡眠有一个缺点，就是要给内存供电，一旦断电，你的镜像数据就会丢失，工作区间将不复存在。当然这来自于内存的固有特点，建议百度RAM。
- 休眠：将工作镜像写入硬盘（disk，ROM），这样你也可以恢复工作区间。只是睡下去和醒过来的时间比内存慢不少。但是，它有一个好处就是断电了也不会丢失数据。当你再次开机，系统就会从硬盘里面读取镜像，恢复你的工作区间。

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

## References

1. [Is Hybrid Sleep the same in Linux as in Windows?][1]
2. [How can I hibernate on Ubuntu 16.04?][2]
3. [How do I use pm-suspend-hybrid by default instead of pm-suspend?][3]
4. [Kernel parameters][4]
5. [Error resume: no device specified for hibernation][5]
6. [Hibernation: Resume Can't Find Swap][6]

[^a]: See [Arch wiki][7]

[1]: https://superuser.com/questions/1124966/is-hybrid-sleep-the-same-in-linux-as-in-windows
[2]: https://askubuntu.com/questions/768136/how-can-i-hibernate-on-ubuntu-16-04/821122#821122
[3]: https://askubuntu.com/questions/145443/how-do-i-use-pm-suspend-hybrid-by-default-instead-of-pm-suspend/781957#781957
[4]: https://wiki.archlinux.org/index.php/kernel_parameters#rEFInd
[5]: https://forum.manjaro.org/t/error-resume-no-device-specified-for-hibernation/119074
[6]: https://bbs.archlinux.org/viewtopic.php?id=156497
[7]: https://wiki.archlinux.org/index.php/Power_management/Suspend_and_hibernate#About_swap_partition.2Ffile_size
[8]: https://wiki.archlinux.org/index.php/REFInd
