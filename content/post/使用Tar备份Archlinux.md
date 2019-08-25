---
title: 使用 Tar 备份 Archlinux
date: 2016-09-10 19:00:57
categories: ['Linux']
tags: ['备份', 'tar']
---

Linux 需要备份吗？本身 Linux 系统的稳定性就是一流，文件系统也不易产生碎片，只要不是硬盘突然崩掉了，你可以有 100 种方法来修复系统的各种问题而不用重装系统。但是恰好我不是多么熟练的 Linux 使用者，每次出问题也是自己在网上边查边解决，有时候也会遇到那种查了几天也没能解决的问题，所以重装 Linux 这样的情景也会时常发生。那么，如果事先做了备份，这时候就能起到很大的作用了。

<!-- more -->

## Tar 备份

创建exclude列表，排除不需要备份的文件。一个样例：
```
#vi /excl
/proc/*
/dev/*
/sys/*
/tmp/*
/mnt/*
/media/*
/run/*
/var/lock/*
/var/run/*
/var/lib/pacman/*
/var/cache/pacman/pkg/*
/lost+found
```

- 准备一个liveCD，也就是安装arch的u盘。
- 插入u盘，进入bios，设置u盘为优先启动。
- 进入u盘系统，挂载好原系统的分区。一个样例：

```bash
mount /dev/sda2 /mnt
mkdir /mnt/{boot,home}
mount /dev/sda1 /mnt/boot
mount /dev/sda3 /mnt/home
```
挂载之后就可以执行chroot进入要备份的系统了。
```bash
arch-chroot /mnt /usr/bin/bash
```

进去之后，执行
```bash
tar cvpjf backup20160910.tar.bz2 --exclude-from=/excl /
```
> - 这里excl是一开始创建的过滤列表，若它不在tar命令的执行路径内，则应将路径写完整。
> - 这里建议tar的执行路径不包含在需要打包的路径内，即tar的执行路径最好放在excl列表中的某个文件夹内，只是为了防止递归备份。
> - 最后，当然要保证磁盘空间充足。

这样，整个系统就被打包好了。在tar的执行路径下，应该可以看到备份文件了。

## Tar 还原

备份好的包可以用来还原，迁移系统。

首先，插u盘进入liveCD。规划好分区，格式化啥的，参见archwiki的[Beginner's Guide](https://wiki.archlinux.org/index.php/Installation_guide_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)). 同样的，挂载好分区。一个样例：
```bash
mount /dev/sda2 /mnt
mkdir /mnt/{boot,home}
mount /dev/sda1 /mnt/boot
mount /dev/sda3 /mnt/home
```

当然，需要挂在备份包的存储分区。一个样例：
```bash
mkdir /backup
mount /dev/sda4 /backup
```

其中，备份包的存储位置是sda4，这里插一句，大家是怎么分辨sdax对应哪块空间的？反正我是根据大小啦=。=

创建临时目录/backup作为sda4的挂载点。最后执行：
```bash
cd /mnt
tar xvpjf /backup/backup20160910.tar.bz2
```

将备份包解压到对应的位置。然后生成fstab：
```bash
genfstab -U -p /mnt >> /mnt/etc/fstab
```

执行完成后建议检查一下/etc/fstab的正确性。接着进入恢复好的系统：
```bash
arch-chroot /mnt /bin/bash
```

重新配置启动引导：
```bash
grub-mkconfig -o /boot/grub/grub.cfg
```
这样，备份包就恢复好了。

退出chroot，卸载目录，重启，应该可以进入系统了，还是熟悉的面孔。
```bash
exit
umount -R /mnt
reboot
```

## 后话

咦呀，我是第一次写博客，而且是博客园这样大的平台，写到这里还是惊魂未定0v0。我也有自知之明，一开始申请写博客权限的时候也写明了：借园子这样的好地方，边学习，边记录。事实上，我也是刚刚接触linux，今年6月份端午的时候。折腾了三个月，一直在折腾，因为它总是冒出莫名其妙的问题，有的解决了，有的没能解决。事后观之，在折腾的过程中，虽说没学到啥实质性的技术，但至少了解了一些处理问题的框架模式，自己也能动手解决一些小问题了，对自己还是很有帮助的。

事实上，本文写的事情uqi已经折腾了三四次了。一开始打算装着玩，linux这边分的空间太少了。期间加过一两次，加上这次的大改，重新划了分区表。每次操作都重新找教程，于是这次自己把它写下来，方便以后查看，O(∩\_∩)O哈哈~

好了，就这样，我第一次写博客，希望看官手下留情啊，任何意见我都会听的。谢谢～
