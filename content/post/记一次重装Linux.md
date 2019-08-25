---
title: 记一次重装 Linux
date: 2018-08-13 10:07:05
categories: ['Linux'] 
---

放假回家，因故将笔记本电池弄到枯竭。结果再次开启，发现 `startx` 启动 gnome-session 失败。几经解决未果，只好重装！

<!-- more -->

## 安装 Archlinux

基本安装步骤都是按照 ArchWiki 上的 [Installation Guide](https://wiki.archlinux.org/index.php/Installation_guide_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)) 以及简书上的一篇文章 [虚拟机安装Archlinux的简易步骤](https://www.jianshu.com/p/82a40aac52aa).

安装过程主要可以分为以下几个步骤：

**1.分区**

一般而言只需要分 3 个区：根（`/`），用户主目录(`/home`) 以及 `swap` 交换。贴一下我的分区图
![分区信息](https://s2.ax1x.com/2019/01/18/kpjHnx.png)

可以看到，一块磁盘 (disk) 被分成很多的分区 (partition) . 其中，稍微现代一点的电脑主板都启用了 [UEFI](https://wiki.archlinux.org/index.php/Unified_Extensible_Firmware_Interface_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))，所以在磁盘第一个分区是 [ESP](https://wiki.archlinux.org/index.php/EFI_system_partition_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)) 分区。这个分区中就包含了所有可启动系统的启动文件。在没有安装 Linux 之前，它里面只包含有 Windows 自带的启动文件。在安装完成 Linux 后，由于有两个可启动的系统，所以需要一个引导程序([rEFInd](https://wiki.archlinux.org/index.php/REFInd), Grub 等)来将选择权交给用户。

上图中的最后三个分区即为 Linux 系统的分区。分区大小的划分事实上很讲究，我根据之前的经验，`/home` 分 50GB 够用了，如果不放什么大型视频和音频文件的话。swap 分区的大小一般为已安装内存的一半，比如我的系统内存 8GB，swap 就分 4GB.

**2.格式化分区**

Linux 文件系统一般是 ext4，使用如下命令格式化分区
```sh
mkfs.ext4 /dev/nvme0n1p5
mkfs.ext4 /dev/nvme0n1p6
mkfs.ext4 /dev/nvme0n1p7
```

**3.挂载目录**

将各目录挂载到对应的分区，例如
```sh
mount /dev/nvme0n1p5 /mnt
mount /dev/nvme0n1p6 /mnt/home
# boot分区其实应该单独分出来
# 但是我们已经有了 esp 分区
# 要和原来的 Windows 兼容
# 只需要将该 esp 分区挂载到 /boot/efi 目录下
# 之后安装 bootloader 时会把 Linux 的启动文件放到 esp 分区
mount /dev/nvme0n1p1 /mnt/boot/efi
```

开启 swap 分区以便之后生成 fstab 时检测
```sh
swapon /dev/nvme0n1p7
```

**4.执行安装**

核心命令为：
```sh
pacstrap -i /mnt base base-devel net-tools
```
其余细节参考 ArchWiki. 值得一提的是，`base` 组里面包含的程序包有限，所以追加了 `base-devel` 和网络配置工具包 `net-tools`.  注意执行安装命令前，对 `/etc/pacman.d/mirrorlist` 进行相关修改，把中国的镜像放在前面，使得下载速度更快。还有几个有用的网络工具包也一并装了 `iw, wpa_supplicant, dialog`.

**5.后续步骤**

后续就是 arch-chroot 到新安装系统中进行相关设置：hostname，hosts，时区，locale 等。这些在 Installation Guide 中均有提及，不再赘述。

**6.小结**

以上，一个新的 Archlinux 就安装完成了。不过这只是一个简陋的系统，还没有进行配置，只能用终端输命令的那种。后续配置参考简书那篇文章。

这次安装，我的最大的一个收获就是学会了如何在命令行中连接 WiFi. 需要的工具有

| Package        | Command                         | Note             |
| -------------- | ------------------------------- | --------- |
| dialog         | `wifi-menu`                     | WiFi 直连        |
| net-tools      | `ifconfig`                      | 查看网络状态     |
| wpa_supplicant | `wpa_supplicant, wpa_passphrase` | 连接 WiFi        |
| dhcpcd         | `dhcpcd`                        | 动态 IP 地址获取 |

**获取无线接口名称**

![](https://s2.ax1x.com/2019/01/18/kpjqHK.png)

好了，现在知道了，是 `wlp2s0`. 一般也可能是 `wlan0`. 然后确认该接口的状态是 up，如图所示。

**扫描可用网络**
```sh
iw wlp2s0 scan
```
确定你要连接的无线网络名称 (SSID)，假设是 shiki.

**生成配置文件**
```sh
wpa_passphrase shiki > ~/shiki.conf
```

**连接 WiFi**
```sh
wpa_supplicant -B -i wlp2s0 -c ~/shiki.conf
```

**获取 IP 地址**
```sh
dhcpcd wlp2s0
```

**查看连接状态**

```sh
iw wlp2s0 link
```

---------------------

另外，还有一种更加简单的方法，直接敲命令 `wifi-menu` 可以进行交互式 WiFi 连接，体验和图形界面一样。

## 安装 Gnome

来日在填

## 系统美化

### 字体

如何在 Linux 上安装喜欢的[字体](https://fonts.google.com/)呢？只需要将对应的字体文件复制到相应的字体目录，再执行几个命令就 OK 了。

**下载字体**

英文字体的话，[Google Fonts](https://fonts.google.com/) 基本可以完全搞定。

关于中文字体，目前推荐的只有两个：[文泉驿](wenq.org)，[文鼎](http://www.arphic.com.tw/)。

例如要将下载好的 Alegreya.zip 字体安装到系统，只需要将其解压：
![](https://s2.ax1x.com/2019/01/18/kpjOAO.png)

可以看到里面的字体文件。挑几个解释一下
```
Alegreya-Regular.ttf    # 常规字体
Alegreya-Italic.ttf    # 斜体
Alegreya-Bold.ttf    # 粗体
Alegreya-BoldItalic.ttf    # 粗斜体
```
一般而言，虽然一个字体包里面可能有很多字体文件，很多变体（粗体，特粗，细，特细等），我们只需要安装以上四种变体基本上就足够了。在 TeXLive 中，如果指定了字体族，那么其中的 `\emph` 和 `\textbf`命令会自动寻找相应的变体来排版。

**复制到指定目录**

将这四个文件复制到系统字体文件夹
```
# 用户字体目录
~/.local/share/fonts

# 系统字体目录
/usr/share/fonts
```
为了便于管理，可以在系统字体目录下新建一个文件夹存放用户后续安装的字体，例如
```sh
mkdir /usr/share/fonts/userfonts
```
将需要安装的字体文件复制到上述文件夹，然后

**执行安装命令**

```sh
mkfontdir
mkfontscale

fc-cache -fv  #刷新系统字体缓存

```

**确认安装是否成功**

```sh
fc-list | grep userfonts
```
![](https://s2.ax1x.com/2019/01/18/kpvPDP.png)

如图所示，可以看到在指定目录下的字体已经安装成功！

**卸载字体**

删除相应字体文件，刷新系统字体缓存即可

**查看已安装字体**
```sh
fc-list :lang=zh # 查看支持中文的字体
```
