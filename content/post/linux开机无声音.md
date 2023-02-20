---
title: "Linux开机无声音"
date: 2022-03-26T18:45:16+08:00
lastmod: 2022-03-26T18:45:16+08:00
keywords: []
categories: [linux]
tags: []
draft: false
mathjax: false

---


问题描述：个人笔记本电脑长久以来都有一个问题，开机之后扬声器没声音，从应用层看毫无问题，所有音乐视频照常播放，能调音量，就是没声音。必须插一下耳机，耳机里有声音。然后再拔出耳机，外部扬声器也有声音了。因此使用起来并无大碍，只需要准备一个耳机，开机之后插拔一下即可。

但问题始终要解决的，我总不可能每次开机的时候旁边都有个有线耳机吧。所以要解决这个问题，可从以下两个路子着手：

1. 彻底解决这个问题，每次开机正常有声音，插入耳机，则声音通过耳机输出；
2. 退而求其次，能在开机之后不需要插拔耳机，也能将外部扬声器声音释放出来，比如一个shell命令激活。

目前我只做到了第二种，尚未完美解决。

记录一下排查问题的大致流程：

首先上网查了一下相关问题，怀疑是pulseaudio的问题，结果偶然某一次正常播放音频的时候，我发现杀掉pulseaudio的进程竟然毫无影响，因此可能不是它的问题。

然后查看alsamixer得知：

![](AlsaMixer.png)

可以看到有两张声卡，一个是`default`，一个是`HDA Intel PCH`，但其实我只有一张声卡
```bash
$ aplay -l
**** List of PLAYBACK Hardware Devices ****
card 0: PCH [HDA Intel PCH], device 0: ALC255 Analog [ALC255 Analog]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 0: PCH [HDA Intel PCH], device 3: HDMI 0 [HDMI 0]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 0: PCH [HDA Intel PCH], device 7: HDMI 1 [HDMI 1]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 0: PCH [HDA Intel PCH], device 8: HDMI 2 [HDMI 2]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 0: PCH [HDA Intel PCH], device 9: HDMI 3 [HDMI 3]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 0: PCH [HDA Intel PCH], device 10: HDMI 4 [HDMI 4]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
```

此时我观察到在无声音的状态下使用
```bash
yychi@~> speaker-test -c 2

speaker-test 1.2.6

Playback device is default
Stream parameters are 48000Hz, S16_LE, 2 channels
Using 16 octaves of pink noise
Rate set to 48000Hz (requested 48000Hz)
Buffer size range from 96 to 1048576
Period size range from 32 to 349526
Using max buffer size 1048576
Periods = 4
was set period_size = 262144
was set buffer_size = 1048576
 0 - Front Left
 1 - Front Right
^CTime per period = 10.942892
yychi@~> speaker-test -c 2 -D hw:0

speaker-test 1.2.6

Playback device is hw:0
Stream parameters are 48000Hz, S16_LE, 2 channels
Using 16 octaves of pink noise
Rate set to 48000Hz (requested 48000Hz)
Buffer size range from 64 to 1048576
Period size range from 32 to 524288
Using max buffer size 1048576
Periods = 4
was set period_size = 262144
was set buffer_size = 1048576
 0 - Front Left
 1 - Front Right
^CTime per period = 5.761266
```
测试扬声器的时候，指定device为`hw:0`总能够发出声音，此时便想到很可能是系统默认的播放设备（playback）不对，因此按照[archwiki上的教程][1]设置了默认声卡。其实就是新建一个文件然后重启：
```sh
# file: ~/.asoundrc

pcm.!default {
   type hw
   card PCH
}

ctl.!default {
   type hw
   card PCH
}
```

重启之后果然立刻就有声音了，正当我被折腾成功的喜悦包围之时，我试着将耳机插入耳机孔，tmd根本就没效果。这不完犊子了吗，修好了外放，耳机失效了。接着就是一顿找，
```bash
alsactl restore
```
拯救了耳机的输出，但没有完全拯救，因为这个时候耳机和外部扬声器都有声音。也就是说，他不会根据耳机的插拔而切换输出了，而是两方都有输出。

然而就是根据耳机插拔自动切换输出设备的功能，在我设置了默认声卡之后，一直得不到解决。此前，虽然需要插拔一下耳机，外部扬声器才能播放声音，好歹耳机的插拔还是能正常生效的。所以，我还是删掉了默认声卡的配置，转而寻求“开机后如何切换sound playback”。直到我找到[参考1][2].

其中提到"card-profile"这个概念，听起来像是声卡的情景模式，通过如下命令列出所有支持的card-profiles:
```bash
yychi@~> pacmd list-cards
1 card(s) available.
    index: 0
	name: <alsa_card.pci-0000_00_1f.3>
	driver: <module-alsa-card.c>
	owner module: 6
	properties:
		alsa.card = "0"
		alsa.card_name = "HDA Intel PCH"
		alsa.long_card_name = "HDA Intel PCH at 0xb4220000 irq 135"
		alsa.driver_name = "snd_hda_intel"
		device.bus_path = "pci-0000:00:1f.3"
		sysfs.path = "/devices/pci0000:00/0000:00:1f.3/sound/card0"
		device.bus = "pci"
		device.vendor.id = "8086"
		device.vendor.name = "Intel Corporation"
		device.product.id = "9d71"
		device.product.name = "Sunrise Point-LP HD Audio"
		device.form_factor = "internal"
		device.string = "0"
		device.description = "内置音频"
		module-udev-detect.discovered = "1"
		device.icon_name = "audio-card-pci"
	profiles:
		input:analog-stereo: 模拟立体声 输入 (priority 32833, available: unknown)
		output:analog-stereo: 模拟立体声 输出 (priority 39268, available: unknown)
		output:analog-stereo+input:analog-stereo: 模拟立体声双工 (priority 39333, available: unknown)
		output:hdmi-stereo: Digital Stereo (HDMI) 输出 (priority 5900, available: no)
		output:hdmi-stereo+input:analog-stereo: Digital Stereo (HDMI) 输出 + 模拟立体声 输入 (priority 5965, available: unknown)
		output:hdmi-surround: Digital Surround 5.1 (HDMI) 输出 (priority 800, available: no)
		output:hdmi-surround+input:analog-stereo: Digital Surround 5.1 (HDMI) 输出 + 模拟立体声 输入 (priority 865, available: unknown)
		output:hdmi-surround71: Digital Surround 7.1 (HDMI) 输出 (priority 800, available: no)
		output:hdmi-surround71+input:analog-stereo: Digital Surround 7.1 (HDMI) 输出 + 模拟立体声 输入 (priority 865, available: unknown)
		output:hdmi-stereo-extra1: Digital Stereo (HDMI 2) 输出 (priority 5700, available: no)
		output:hdmi-stereo-extra1+input:analog-stereo: Digital Stereo (HDMI 2) 输出 + 模拟立体声 输入 (priority 5765, available: unknown)
		output:hdmi-surround-extra1: Digital Surround 5.1 (HDMI 2) 输出 (priority 600, available: no)
		output:hdmi-surround-extra1+input:analog-stereo: Digital Surround 5.1 (HDMI 2) 输出 + 模拟立体声 输入 (priority 665, available: unknown)
		output:hdmi-surround71-extra1: Digital Surround 7.1 (HDMI 2) 输出 (priority 600, available: no)
		output:hdmi-surround71-extra1+input:analog-stereo: Digital Surround 7.1 (HDMI 2) 输出 + 模拟立体声 输入 (priority 665, available: unknown)
		output:hdmi-stereo-extra2: Digital Stereo (HDMI 3) 输出 (priority 5700, available: no)
		output:hdmi-stereo-extra2+input:analog-stereo: Digital Stereo (HDMI 3) 输出 + 模拟立体声 输入 (priority 5765, available: unknown)
		output:hdmi-surround-extra2: Digital Surround 5.1 (HDMI 3) 输出 (priority 600, available: no)
		output:hdmi-surround-extra2+input:analog-stereo: Digital Surround 5.1 (HDMI 3) 输出 + 模拟立体声 输入 (priority 665, available: unknown)
		output:hdmi-surround71-extra2: Digital Surround 7.1 (HDMI 3) 输出 (priority 600, available: no)
		output:hdmi-surround71-extra2+input:analog-stereo: Digital Surround 7.1 (HDMI 3) 输出 + 模拟立体声 输入 (priority 665, available: unknown)
		output:hdmi-stereo-extra3: Digital Stereo (HDMI 4) 输出 (priority 5700, available: no)
		output:hdmi-stereo-extra3+input:analog-stereo: Digital Stereo (HDMI 4) 输出 + 模拟立体声 输入 (priority 5765, available: unknown)
		output:hdmi-surround-extra3: Digital Surround 5.1 (HDMI 4) 输出 (priority 600, available: no)
		output:hdmi-surround-extra3+input:analog-stereo: Digital Surround 5.1 (HDMI 4) 输出 + 模拟立体声 输入 (priority 665, available: unknown)
		output:hdmi-surround71-extra3: Digital Surround 7.1 (HDMI 4) 输出 (priority 600, available: no)
		output:hdmi-surround71-extra3+input:analog-stereo: Digital Surround 7.1 (HDMI 4) 输出 + 模拟立体声 输入 (priority 665, available: unknown)
		output:hdmi-stereo-extra4: Digital Stereo (HDMI 5) 输出 (priority 5700, available: no)
		output:hdmi-stereo-extra4+input:analog-stereo: Digital Stereo (HDMI 5) 输出 + 模拟立体声 输入 (priority 5765, available: unknown)
		output:hdmi-surround-extra4: Digital Surround 5.1 (HDMI 5) 输出 (priority 600, available: no)
		output:hdmi-surround-extra4+input:analog-stereo: Digital Surround 5.1 (HDMI 5) 输出 + 模拟立体声 输入 (priority 665, available: unknown)
		output:hdmi-surround71-extra4: Digital Surround 7.1 (HDMI 5) 输出 (priority 600, available: no)
		output:hdmi-surround71-extra4+input:analog-stereo: Digital Surround 7.1 (HDMI 5) 输出 + 模拟立体声 输入 (priority 665, available: unknown)
		off: 关 (priority 0, available: unknown)
	active profile: <output:hdmi-stereo-extra1+input:analog-stereo>
	sinks:
		alsa_output.pci-0000_00_1f.3.hdmi-stereo-extra1/#0: 内置音频 Digital Stereo (HDMI 2)
	sources:
		alsa_output.pci-0000_00_1f.3.hdmi-stereo-extra1.monitor/#0: Monitor of 内置音频 Digital Stereo (HDMI 2)
		alsa_input.pci-0000_00_1f.3.analog-stereo/#1: 内置音频 模拟立体声
	ports:
		analog-input-mic: Microphone (priority 8700, latency offset 0 usec, available: unknown)
			properties:
				device.icon_name = "audio-input-microphone"
		analog-output-speaker: Speakers (priority 10000, latency offset 0 usec, available: unknown)
			properties:
				device.icon_name = "audio-speakers"
		analog-output-headphones: Headphones (priority 9900, latency offset 0 usec, available: no)
			properties:
				device.icon_name = "audio-headphones"
		hdmi-output-0: HDMI / DisplayPort (priority 5900, latency offset 0 usec, available: no)  # available: yes if headphone plugged
			properties:
				device.icon_name = "video-display"
		hdmi-output-1: HDMI / DisplayPort 2 (priority 5800, latency offset 0 usec, available: no)
			properties:
				device.icon_name = "video-display"
		hdmi-output-2: HDMI / DisplayPort 3 (priority 5700, latency offset 0 usec, available: no)
			properties:
				device.icon_name = "video-display"
		hdmi-output-3: HDMI / DisplayPort 4 (priority 5600, latency offset 0 usec, available: no)
			properties:
				device.icon_name = "video-display"
		hdmi-output-4: HDMI / DisplayPort 5 (priority 5500, latency offset 0 usec, available: no)
			properties:
				device.icon_name = "video-display"

```
接着
```bash
pacmd set-card-profile alsa_card.pci-0000_00_1f.3 output:analog-stereo+input:analog-stereo
```
设置声卡的情景模式，敲完之后外部扬声器就有声音了，而且耳机插拔也是正常生效的。值得注意的是，插入耳机后，上述注释处就变成yes了。

这个问题暂时解决到这里，等以后有时间看能否完全解决！

当天更新：重启之后发现不用重新再走一遍上述流程，可以看到"active profile: <output:hdmi-stereo-extra1+input:analog-stereo>"已经持久化改变了。那么这个问题就算解决啦！

## References

1. [How can I switch between different audio output hardware using the shell?][2]
2. [Archwiki: Advanced Linux Sound Architecture][1]
3. [[SOLVED] sound not working][3]


[1]: https://wiki.archlinux.org/title/Advanced_Linux_Sound_Architecture#Set_the_default_sound_card
[2]: https://unix.stackexchange.com/questions/62818/how-can-i-switch-between-different-audio-output-hardware-using-the-shell
[3]: https://bbs.archlinux.org/viewtopic.php?pid=981405#p981405/
