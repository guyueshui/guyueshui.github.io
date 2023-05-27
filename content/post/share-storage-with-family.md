---
title: "从零开始构建家庭共享存储"
date: 2023-03-14T09:24:57+08:00
keywords: []
categories: [tech]
tags: [webdav, 共享存储]
draft: false
mathjax: false

---

一切都要从前几天给手机刷新ROM，导致数据丢失说起。

前些日子，我的RedmiK40S MIUI13突然给我自动更新至MIUI14，这违背了我的意愿。但这还不至于让我动刷机的年头，毕竟年事已高，不再那么想折腾手机。可这次更新，不单单是MIUI版本的提升，更是Android 12到13的版本升级。这直接导致了我的钛备份闪退了，并且使用钛备份还原在a12上备份的应用，如果勾选还原应用数据，则必然导致对应应用闪退。应用备份出了问题我是无法接受的。于是，开始上XDA找ROM，随便下了几个，准备动手。

<!--more-->

我自觉这么多年刷机从未失手，再不济也能在recovery里面把数据迁移出来再进行格式化。不成想多年未刷机，出了个新名词"a/b slot". 一下子给我整懵了，在刷完rom之后的第一次启动卡logo. 然后再进recovery直接给我把data分区锁上了。换了几个recovery还是无法解锁data, 最后只能无情format data. **数据无价啊！**

后来翻了几篇帖子，弄弄a/b slot到底是啥意思，放在下面供以后参考吧：

1. [How A/B Partitions and Seamless Updates Affect Custom Development on XDA][1]
2. [How to fix unable to mount data internal storage 0mb in twrp permanently][2]
3. [A/B slots flashing in TWRP][3]

此外，这次踩坑在[此处](/post/android刷机的一般步骤/#ab-slot刷机)做了简单记录。折腾一宿加一天之后，终于用上了新ROM，贴几张美图：

<table><tr>
<td><img src=munch1.png border=0></td>
<td><img src=munch2.png border=0></td>
<td><img src=munch3.png border=0></td>
</tr></table>

---

言归正传，新ROM装好之后，发现钛备份在a12创建的备份，如果还原应用数据，统统都会闪退。感概一波钛备份的过时之后，我寻到了两个替代品：

1. [Neo Backup][4]
2. [Data Backup][5]

并且这次迎来了新的需求：在本地备份app数据之后，即时在移动硬盘上做一个备份。于是我想起来，我的小米路由器3具有一个USB接口。**有没有可能将移动硬盘插在路由器上，然后连接该路由器的设备都可以访问这个移动硬盘呢？**

然后兴冲冲的打开小米路由器的管理界面，发现文件共享需要下载他的软件，过于辣鸡了。一怒之下，给小米路由器3刷了OpenWrt[^a].

## 给路由器刷OpenWrt

这个网上教程很多，列举一下：

1. [小米路由3 刷 OpenWRT][6]
2. [小米路由器3刷机记录][7]
3. [[OpenWrt Wiki] Xiaomi Mi WiFi R3 (Mi Wifi Router 3 / MIR3 / MI3)][8]
4. [小米路由器3刷机潘多拉(Openwrt)以及刷回教程][9]

看这几篇应该够了，其中需要注意的点：

1. 用于开启ssh功能的U盘必须是fat文件系统；
2. 先刷开发版固件，再降级到miwifi_r3_all_55ac7_2.11.20.bin，2.11.20版本更容易打开ssh.

## OpenWrt路由器部署WebDAV服务器

刷好之后，打开网关地址进入管理界面，如下图所示：

![LuCI of X-Wrt](x-wrt-luci.png)

LuCI（Lua Configuration Interface）是OpenWrt的前端管理界面，默认基于uhttpd运行，而它不支持WebDAV，所以我们换一个支持的 -- [lighttpd][10].

下面是我安装的lighttpd的相关软件包，可以用luci前端安装，也可以ssh到路由器执行`opkg install lighttpd-xxx`.
```bash
root@X-WRT-27AD:~# opkg list-installed | grep lighttpd
lighttpd - 1.4.69-1
lighttpd-mod-auth - 1.4.69-1
lighttpd-mod-authn_file - 1.4.69-1
lighttpd-mod-cgi - 1.4.69-1
lighttpd-mod-openssl - 1.4.69-1
lighttpd-mod-webdav - 1.4.69-1
```

接下来就需要编辑配置文件了，lighttpd的配置文件位于`/etc/lighttpd`下。经过配置的目录结构如下：
```bash
root@X-WRT-27AD:/etc/lighttpd# ls -R
.:
certs          conf.d         lighttpd.conf  lighttpd.user  mime.conf

./certs:
lighttpd.pem

./conf.d:
20-auth.conf        30-cgi.conf         30-webdav.conf      99-luci.conf
20-authn_file.conf  30-openssl.conf     50-http.conf
```

Lighttpd采用模块化的配置方式，主配置文件为`lightttpd.conf`，其会自动将`conf.d`文件夹中的配置加载出来。所以我们对单模块做配置，只需要在conf.d文件夹中新增相关配置文件即可。

例如，conf.d中的30-webdav.conf就是WebDAV服务相关的配置：
```text
server.modules += ( "mod_webdav" )

$HTTP["url"] =~ "^/dav($|/)" {
  webdav.activate = "enable"
  webdav.sqlite-db-name = home_dir + "/webdav.db"

  ## add by yychi, see: https://openwrt.org/docs/guide-user/services/nas/webdav
  server.document-root := "/mnt/sda4/"  # 用作WebDAV存储的根目录
  auth.backend = "plain"
  auth.backend.plain.userfile = conf_dir + "/lighttpd.user"  # 用户&密码配置
  auth.cache = ("max-age" => "3600")  # 输入密码后的过期时间

  ## 用户路径配置
  auth.require := (
    "/dav/yychi" => ("method" => "basic", "realm" => "disk for yychi", "require" => "user=yychi|user=admin,
    "/dav/yukynn" => ("method" => "basic", "realm" => "disk for yukynn", "require" => "user=yukynn|user=admin,
    "/dav/" => ("method" => "basic", "realm" => "WebDAV Server", "require" => "valid-user"),
  )
}
```
其中重要的地方我都加了注释，猛击[这里][11]详细了解配置语法。简单说明下第三行是个[条件配置][12]，意思是url匹配后面这个正则表达式的话，scope里面的配置才生效。其中，home_dir和conf_dir这两个变量均来自于父文件夹的lighttpd.conf:
```bash
root@X-WRT-27AD:/etc/lighttpd# cat lighttpd.conf 
### Configuration Variables (potentially used in /etc/lighttpd/conf.d/*.conf)
var.log_root    = "/var/log/lighttpd/"
var.server_root = "/www/"
var.state_dir   = "/var/run/"
var.home_dir    = "/var/lib/lighttpd/"
var.conf_dir    = "/etc/lighttpd"
var.vhosts_dir  = server_root + "/vhosts"
var.cache_dir   = "/var/cache/lighttpd"
var.socket_dir  = home_dir + "/sockets"
...
```

接下来配置WebDAV的用户和密码，
```bash
echo yychi:123456 >> /etc/lighttpd/lighttpd.user
```
可以配置多个用户，以及简单的权限管理。比如我的配置`/dav/yychi`文件夹只能给用户yychi或admin访问，`/dav/yukynn`文件夹只能给yukyyn或admin访问。

> 这里认证方式是明文密码，其实还有其他方式，不过需要安装其他包，觉得太麻烦，而且是局域网比较安全所以就不管了。

配置到现在就差不多了，让我们启动一下：
```bash
service uhttpd stop  # 关闭uhttpd
service uhttpd disable  # 取消uhttpd的自启动
service lighttpd start
service lighttpd enable
```

用同一局域网下的手机连接验证一下：
![xplore-webdav](xplore-webdav.png)

Ok, 现在我们已经在路由器上部署好了WebDAV server.

## LuCI后端更改

如果你打开网关地址（X-Wrt默认是192.168.15.1），你会发现LuCI已经打不开了。当然了，因为我们关闭了LuCI的后端uhttpd，现在我们要把LuCI后端改为lighttpd，这一点[OpenWrt Wiki][13]上有很详细的教程，这里我们就简短概括一下。

主要使用lighttpd的cgi功能，使得当用浏览器访问网关地址时，重定向到luci启动的cgi脚本。
```bash
root@X-WRT-27AD:/www/cgi-bin# ls
cgi-backup    cgi-download  cgi-exec      cgi-upload    luci
```
这里的`luci`就是启动脚本。

具体配置参考这里：
```bash
root@X-WRT-27AD:/etc/lighttpd/conf.d# cat 99-luci.conf 
## Necessary LUCI configuration
## see: https://openwrt.org/docs/guide-user/luci/luci.on.lighttpd
cgi.assign += ( "/cgi-bin/luci" => "",
                "/cgi-bin/cgi-backup" => "",
                "/cgi-bin/cgi-download" => "",
                "/cgi-bin/cgi-exec" => "",
                "/cgi-bin/cgi-upload" => "" )

server.username := ""
server.groupname := ""
```

最后，
```bash
service lighttpd restart
```
重启lighttpd查看效果，现在访问网关地址应该可以打开LuCI了。

## Lighttpd 启用 HTTPS

到这一步为止，我们已经无痛在OpenWrt上搭建了一个WebDAV server，你可以插个移动硬盘上去，然后使用任意支持webdav协议的客户端去操作这块存储空间，LuCI也能访问了，很好。

然而偏偏有些应用，他不支持http，他强制让你使用https，确实，够安全。但对于局域网来说，难免有些多次一举。我说的就是[FolderSync][14]，这是个好应用，可以将本地文件夹与云端（OneDrive, DropBox, WebDAV等）文件夹进行双向同步，详询酷安#foldersync话题。但我确实恼他不支持http协议。

没办法，只好安排一下。由于我是局域网内使用，而FolderSync其实也开了个后门，他支持自签名证书。
![](foldersync-webdav-conf.png)

那我们就给他安排一下，参考这篇[wiki][15]，非常简单。

## 网页端访问

你是否想在浏览器中也能访问WebDAV server？Lighttpd自带一个简单的页面，可通过以下配置开启：
```
# Override the /dav/ folder configured in 30-webdav.conf
$HTTP["url"] =~ "^/dav($|/)" {
  # The root / is ovveriden by an alais in turris-root.conf so we must add another override
  alias.url = ( "/dav/" => "/srv/disk/dav/" )
  server.document-root := "/srv/disk/"
  auth.backend := "plain"
  auth.backend.plain.userfile := "/etc/lighttpd/webdav.shadow"
  auth.require := (""=>("method"=>"basic","realm"=>"webdav","require"=>"valid-user"))
  # (Optional) add a directory index to see files from a browser
  server.dir-listing := "enable"  # 这里
  dir-listing.encoding := "utf-8" # 和这里
  webdav.sqlite-db-name := "/etc/lighttpd/webdav_lock.db"
}
```
cf. https://gist.github.com/stokito/77c42f8aff2dade91621c1051f73e58c

加上上面两行配置，重启下lighttpd，然后打开 192.168.15.1/dav 即可访问webdav server：
![](lighttpd-webdav-browser.png)

这个界面只能读，不能写。

### 加载webdav-js

OpenWrt的[wiki][16]上提到一个方法可以让你在浏览器中访问webdav server，是通过在根目录创建一个index.html文件实现的。这个文件里面引入了[webdav-js][17]，作为一个精简的web client，他支持对webdav server的写入操作（包括上传文件，创建文件夹，复制，移动，重命名等）。所以我们在根目录创建一个这样的文件，就可以看到如下界面：
![](webdav-js-browser.png)

原本这中方法有个问题，wiki中也有提到：就是子文件夹中没有这个index.html，因此访问子文件夹就无法展示了。但加了lighttpd本身的网页前端之后，每个子文件夹都是可访问的，我猜想应该是开启dir-listing选项之后，访问的时候会自动生成index文件。而因为webdav-js缓存的缘故，跳转到子文件夹，只有里面包含index文件，就可以进行访问，即便子文件夹中的index文件没有加载webdav-js. 这样一来，就只需要在根目录添加一个加载了webdav-js的index文件，就能浏览任意子目录的效果。

## Alist文件共享服务

一路走来，我们在局域网搭建了一个WebDAV server, 实现了局域网内的文件共享。但是WebDAV client对于父母一辈的其实不太友好。而网页端也很简陋，如果他们想打开网页直接看视频什么的，还不够方便。

又忽然联想到家里还有一台旧笔记本躺在那里吃灰。于是翻将出来直接格式化，装了个archlinux，不过没装图形界面。由于路由器的性能毕竟吃紧，把移动硬盘接在旧电脑上做文件服务器才是正理。我准备在这台机器上部署一个[Alist][18]服务器，archlinux直接
```bash
yay -S alist
```
即可安装。也可以使用官方文档中的一键脚本进行安装，使用脚本安装之后的路径在：
```bash
yychi@dell-inspiron /opt/alist> ls
alist*  data/

yychi@dell-inspiron /opt/alist> ifconfig
enp2s0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.15.233  netmask 255.255.255.0  broadcast 192.168.15.255
        ...

# 运行alist server
yychi@dell-inspiron /opt/alist> ./alist server
INFO[2023-03-15 13:38:01] reading config file: data/config.json        
INFO[2023-03-15 13:38:01] load config from env with prefix: ALIST_     
INFO[2023-03-15 13:38:01] init logrus...                               
INFO[2023-03-15 13:38:01] start server @ 0.0.0.0:5244                  
INFO[2023-03-15 13:38:01] success load storage: [/disk], driver: [Local] 
INFO[2023-03-15 13:38:01] success load storage: [/home/yychi], driver: [Local] 
INFO[2023-03-15 13:38:01] Aria2 not ready.                             
INFO[2023-03-15 13:38:01] qbittorrent not ready.                       
INFO[2023-03-15 13:38:02] success load storage: [/Aliyunpan/来自分享], driver: [AliyundriveOpen] 
INFO[2023-03-15 13:38:02] success load storage: [/Aliyunpan/电影], driver: [AliyundriveOpen] 
INFO[2023-03-15 13:38:02] success load storage: [/Aliyunpan/动漫], driver: [AliyundriveOpen] 
INFO[2023-03-15 13:38:02] success load storage: [/Aliyunpan/电视剧], driver: [AliyundriveOpen] 
```

运行之后，就可以在浏览器输入 http://192.168.15.233:5244 打开alist界面了。
![](alist-webui.png)

上面是我配置之后的样子[^b]。更多关于alist的配置，网上多不胜数，我就不献丑了。

Alist支持文件交互，就像云盘一样，可以上传/下载文件，在线播放音视频图片等，也可以用作WebDAV server, 更可以挂载阿里云盘，总之功能多多，值得一玩。

## 一点体验优化

上面说到，我将废弃的笔记本（dell-inspiron）用作文件服务器，它需要7*24小时开机，妥妥的就是一个正经的服务器。那万一停电了，路由器重启了，就是服务器ip变了怎么办？我还得去路由器上或者服务器本身上面去看看ip, 这显然很麻烦。所以必须给dell-inspiron一个固定的ip. 使用OpenWrt很容易做到这一点。
![](dhcp-static-ip.png)

甚至可以做个主机名映射，不用再记烦人的ip.
![](name-map.png)
<figcaption>this is figcaption</figcaption>

这样就可以通过域名来访问文件服务。
![](alist-video.png)
![](alist-music.png)

## 总结

至此，我们就搭建了一个家庭共享存储。只要连上指定局域网，就可以访问并操作共享存储，而且可以基于Alist在线观看影视，十分方便。不过还有个痛点就是这个局域网其实是楼下路由器的子网，如果连楼下wifi，就无法访问了。本来可以通过配置静态路由实现，但楼下路由偏偏不支持配置，只能先搁置一下了。


[^a]:说是OpenWrt，其实是中文社区的fork，X-Wrt.
[^b]:你可能看到了https, 其实也是我为了使用FolderSync给加的自签名证书，仅限局域网内部用用。

[1]:https://www.xda-developers.com/how-a-b-partitions-and-seamless-updates-affect-custom-development-on-xda
[2]:https://forum.xda-developers.com/t/how-to-fix-unable-to-mount-data-internal-storage-0mb-in-twrp-permanently.3830897/
[3]:https://forum.xda-developers.com/t/a-b-slots-flashing-in-twrp.3887321/
[4]:https://f-droid.org/en/packages/com.machiav3lli.backup/
[5]:https://www.coolapk.com/apk/com.xayah.databackup
[6]:https://schaepher.github.io/2019/10/12/xiaomi-router-r3-openwrt/
[7]:https://blog.kidhero.club/p/%E5%B0%8F%E7%B1%B3%E8%B7%AF%E7%94%B1%E5%99%A83%E5%88%B7%E6%9C%BA%E8%AE%B0%E5%BD%95/
[8]:https://openwrt.org/toh/xiaomi/mir3#get_sshdropbear_access
[9]:https://www.awaimai.com/2852.html
[10]:https://redmine.lighttpd.net/projects/lighttpd/wiki
[11]:https://redmine.lighttpd.net/projects/lighttpd/wiki/Docs_Configuration
[12]:https://redmine.lighttpd.net/projects/lighttpd/wiki/Docs_Configuration#Conditional-Configuration
[13]:https://openwrt.org/docs/guide-user/luci/luci.on.lighttpd
[14]:https://foldersync.io/
[15]:https://redmine.lighttpd.net/projects/lighttpd/wiki/HowToSimpleSSL
[16]:https://openwrt.org/docs/guide-user/services/nas/webdav#browser_ui_for_the_webdav_share
[17]:https://github.com/dom111/webdav-js
[18]:https://github.com/Xhofe/alist
