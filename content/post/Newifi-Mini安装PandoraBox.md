---
title: Newifi Mini 安装 PandoraBox
date: 2017-02-21 16:01:55
tags: [路由器,个性化,刷机]
categories: ['Techniques']
---

首先 Newifi mini 是一款很小巧美观的路由器，颜值即是正义嘛。再加上性价比高，易于刷写第三方系统，所以嘛，值得一买。

## 规格参数

- WAN(10/100Mbps)
- LAN(10/100Mbps)\*2
- 双频：2.4GHz:300Mbps+5GHz:867Mbps
- USB2.0接口
- 外置天线\*2
- 天线增益：3dBi
- 128MB内存

<!-- more -->

## 资源

- PandoraBox 下载源：[http://downloads.pandorabox.com.cn](http://downloads.pandorabox.com.cn/)
- 旧版(2015年1月)：[设备代号Lenovo-Y1_RY-1S](http://downloads.pandorabox.com.cn/pandorabox/Lenovo-Y1_RY-1S/)
- 新版(2017年1月)：[newifi-mini](http://downloads.pandorabox.com.cn/pandorabox-16-10-stable/targets/ralink/mt7620/PandoraBox-ralink-mt7620-newifi-mini-2017-01-03-git-6c24a7a-squashfs-sysupgrade.bin) 附[Changelog](http://downloads.pandorabox.com.cn/pandorabox-16-10-stable/changelog-16.10-stable.txt)

我用旧版安装shadowsocks时碰到很多问题，一时无解于是刷了新版，顺便说一下新版网页端是Material Design，很好看。

下面开始刷入PandoraBox：

1. 下载好相应固件
2. 通过有线连接路由器和PC，将PC端IP设置为192.168.1.254，子网掩码255.255.255.0，网关192.168.1.1
3. 拔下路由器电源，再次插上，迅速按下RESET键，若设备两个蓝灯连续闪烁，说明已经进入恢复模式
4. 在浏览器中输入192.168.1.1进入恢复模式页面，选择之前下好的固件开始刷入
5. 等候1-2分钟，将PC端IP设置为自动获取，在浏览器中输入192.168.1.1即可开始常规配置

## 配置路由器

- 配置SSH远程登录，默认配置允许，输入 `ssh root@<hostname>`以登录路由器
- 配置Samba文件共享，也可以在网页端配置，以便传输必要文件到路由器
- 配置opkg软件源，写下这篇文章时，以下源可用
```
dest root /
dest ram /tmp
lists_dir ext /var/opkg-lists
option overlay_root /overlay

src/gz 17.01_core http://downloads.pandorabox.com.cn/pandorabox/targets/ralink/mt7620/packages
src/gz 17.01_base http://downloads.pandorabox.com.cn/pandorabox/packages/mipsel_24kec_dsp/base
src/gz 17.01_lafite http://downloads.pandorabox.com.cn/pandorabox/packages/mipsel_24kec_dsp/lafite
src/gz 17.01_luci http://downloads.pandorabox.com.cn/pandorabox/packages/mipsel_24kec_dsp/luci
src/gz 17.01_mtkdrv http://downloads.pandorabox.com.cn/pandorabox/packages/mipsel_24kec_dsp/mtkdrv
src/gz 17.01_packages http://downloads.pandorabox.com.cn/pandorabox/packages/mipsel_24kec_dsp/packages
```

接下来安装SS：

- 远程登录路由器
- 执行 `opkg update`
- 执行 `opkg install shadowsocks-libev`
- 执行 `opkg install luci-app-shadowsocks`
- 浏览器中输入192.168.1.1，服务栏目里应该多了一个Shadowsocks

上述安装过程可能会报密钥校验不通过，此时可以在opkg里加强制选项绕过，还有些情况需要手动下载软件包上传到路由器进行本地安装，总之还有一些小问题没有提到的。未尽之处，尽力而为吧。

刷入步骤参考了LinuxToy网站的博客：[Newifi Mini 安装 OpenWrt](https://linuxtoy.org/archives/install-openwrt-on-newifi-mini.html)

如有侵权，请通知我，我会修改的0v0
