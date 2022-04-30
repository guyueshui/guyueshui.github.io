---
title: "Archlinx重置keyring"
date: 2022-05-01T00:25:52+08:00
keywords: []
categories: [notes,linux]
tags: []
draft: false
mathjax: false

---

今天pacman安装一个软件包的时候，突然提示XX作者的GPG key不受信任，网上一查[^a]，原来是GPG存的key需要更新信息了。由于
```bash
pacman-key --refresh-keys
```
执行过程漫长，我新开了一个窗口直接`pacman -Syu`了。果不其然，看起来一切都好了。然后回头发现还在更新keyring，心想：我都完活了，你还没执行完，遂直接杀了进程。

<!--more-->

一切看起来相安无事，但当我下次执行`pacman`相关指令的时候，会频繁报错，keyring有问题，然后我再想像之前那样刷新的时候呢，gpg报了一大堆看不懂的错误。这下糟了，看起来我是把所有key都弄坏了。于是一不做二不休，直接重置算了。

重置过程参考[此处][2]，摘要如下
```bash
rm -rf /etc/pacman.d/gnupg
pacman-key --init
pacman-key --populate
pacman -Syu
```

## References

1. [GnuPG-2.1 与 pacman 密钥环][2]

[^a]: [Archlinux 长时间未更新报错][1]：containerd: 来自 "Santiago Torres-Arias <santiago@archlinux.org>" 的签名是未知信任的

[1]:https://www.jianshu.com/p/1db80e403cca
[2]:https://www.archlinuxcn.org/gnupg-2-1-and-the-pacman-keyring/