---
title: "Gnome应用启动缓慢"
date: 2020-04-01T23:01:36+08:00
lastmod: 2020-04-01T23:01:36+08:00
keywords: []
categories: [Notes]
tags: [折腾]
draft: false
mathjax: false

---

先看环境：
```
$ neofetch
                   -`                    yychi@MiBook-Air 
                  .o+`                   ---------------- 
                 `ooo/                   OS: Arch Linux x86_64 
                `+oooo:                  Host: TM1604 XMAKB3M0P0202 
               `+oooooo:                 Kernel: 5.5.13-arch2-1 
               -+oooooo+:                Uptime: 5 mins 
             `/:-:++oooo+:               Packages: 1153 (pacman) 
            `/++++/+++++++:              Shell: zsh 5.8 
           `/++++++++++++++:             Resolution: 1920x1080 
          `/+++ooooooooooooo/`           WM: i3 
         ./ooosssso++osssssso+`          Theme: Adwaita [GTK2] 
        .oossssso-````/ossssss+`         Icons: Adwaita [GTK2] 
       -osssssso.      :ssssssso.        Terminal: urxvt 
      :osssssss/        osssso+++.       Terminal Font: DejaVu Sans Mono for Powerline 
     /ossssssss/        +ssssooo/-       CPU: Intel i5-7200U (4) @ 3.100GHz 
   `/ossssso+/:-        -:/+osssso+-     GPU: NVIDIA GeForce MX150 
  `+sso+:-`                 `.-/+oso:    GPU: Intel HD Graphics 620 
 `++:.                           `-/+/   Memory: 1608MiB / 7881MiB 
 .`                                 `/
```

再看问题：Gnome系软件（gedit, baobab, nautilus等）启动龟速，通常需要等待10-30s.

思考：我看你就是在为难我，我压根不知道问题出在哪里。大概就是几天前更新系统的时候看到需要更新很多gnome的包，心想着我都不用gnome了，留这么多gnome的包干吗呢？于是删了很多，这一删我以往的经验就告诉我可能会出什么幺蛾子。果不其然，这些天有时候浏览器调用文件管理器（gnome家nautilus）的时候，非常之满，我一度以为死机。细看来又不是，等了十几秒文件窗口忽然蹦出来，怎么这么慢！

换做以前，应该是直接重装系统了。可是这次没时间这么折腾，加上年纪大了不想折腾，毕竟这个本子用了这么久了，积累了好多东西。于是死马当活马医，硬着头皮去google相关问题。循着蛛丝马迹，找到可能出问题的一些点。最后还是要看log！

```bash
$ journalctl --since=2020-3-25
...
...
```
最终我发现这几行有嫌疑：
```
4月 01 13:15:01 MiBook-Air xdg-desktop-portal-gtk[139187]: Unable to init server: 无法连接：拒绝连接
4月 01 13:15:01 MiBook-Air xdg-desktop-por[139187]: cannot open display: 
4月 01 13:15:01 MiBook-Air systemd[520]: xdg-desktop-portal-gtk.service: Main process exited, code=exited, status=1/FAILURE
4月 01 13:15:01 MiBook-Air systemd[520]: xdg-desktop-portal-gtk.service: Failed with result 'exit-code'.
4月 01 13:15:01 MiBook-Air systemd[520]: Failed to start Portal service (GTK+/GNOME implementation).
```
结果一查，果然查到一篇相关的帖子[^a]，我的问题和他一模一样。结果就解决了，就解决了，解决了，决了，了！

问题的原因其实我不太懂，谨此写下折腾记录。

[^a]: [Gnome applications slow start due to failing services][1]

[1]: https://bbs.archlinux.org/viewtopic.php?id=224787
