---
title: "Swap扩容"
date: 2023-02-24T21:07:16+08:00
keywords: []
categories: [tech, linux]
tags: []
draft: false
mathjax: false

---


<!--
由于涉及到磁盘分区，一般来说swap分区在安装系统的时候就要确定。一般建议为总内存大小的一半。

可以通过如下步骤设置一个swap分区：
```bash
mkswap /dev/swap_partition
swapon /dev/swap_partition
```
-->

先前安装系统的时候，swap分区给小了（机器内存的一半）。我的笔记本内存8G，swap给了4G，当系统已用内存超过4G，会导致无法[休眠](/post/linux-hibernate#确保swap分区足够大)。如果swap给的和本机内存一样大，那么就不会存在swap放不下当前工作镜像的问题。但重新分区追加swap显然不现实，所以只能让两块swap拼凑一下，达到总体有8G可用swap的效果。

<!--more-->

> 像我之前，每当要休眠的时候，都要清一下系统内存，保证已用内存在4G以下再休眠。十分繁琐。现在的我建议，[swap分区至少和机器内存相当](/post/记一次重装linux#安装-archlinux)。

无论是新建一块swap分区，抑或是创建一个swapfile，都能达到上述效果。下面介绍一下如何创建一个swapfile作为追加swap使用。

当前，本机swap只有4G：
```bash
$ free -h
            total        used        free      shared  buff/cache   available
内存：      7.7Gi       754Mi       6.0Gi       189Mi       978Mi       6.5Gi
交换：      4.1Gi          0B       4.1Gi
```

创建一个swapfile：
```bash
# 创建一个4G大小的文件
dd if=/dev/zero of=/tmp/swapfile bs=1M count=4096

# 格式化为swap格式
mkswap /tmp/swapfile

# 启用swapfile
swapon /tmp/swapfile

# 查看当前可用swap
free -h
               total        used        free      shared  buff/cache   available
内存：      7.7Gi       822Mi       5.9Gi       189Mi       981Mi       6.5Gi
交换：      8.1Gi          0B       8.1Gi

# 关闭swap
swapoff /tmp/swapfile

# 查看已使用swap分区的摘要
swapon -s
Filename                                Type		Size		Used		Priority
/dev/nvme0n1p7                          partition   4323648         0		      -2
/home/yychi/EXTRA/swapfile              file        4194300         0		      -3
```

这样一来，就完成了swap扩容。但是，你会发现上述工作每次重启都会丢失，所以还要将swapfile写进fstab，保证每次启动都会加载这块swap.

```bash
$ cat /etc/fstab
# /dev/nvme0n1p7
UUID=4227170f-0a4f-4a8e-fads-jasdfkjaskf	none      	swap      	defaults,pri=-2	0 0
# extra swapfile
/home/yychi/EXTRA/swapfile                  none        swap        defaults,pri=-1 0 0
```

另，使用`swapon -p <priority> <swap_partition>`为指定swap分区设置优先级。
