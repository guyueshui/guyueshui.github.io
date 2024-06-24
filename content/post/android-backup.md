---
title: "Android 手机备份攻略"
date: 2024-03-26T22:33:43+08:00
keywords: []
categories: []
tags: [tech,android,backup,"备份"]
draft: false
mathjax: false

---

说起 Android 手机的备份，最先闯入眼帘的可能是 XX 搬机助手，某某手机搬家等一键式迁移手机数据的 APP，这些 APP 可以迁移的数据包括，联系人、通话记录、短信、应用（不包括应用数据）、照片视频、文件夹等，此外还包括一些系统设置例如 WIFI 密码[^a]。

<!--more-->

然而，这些 APP 存在以下几个缺点，

1. 它们必须索取很高的系统权限（用完即卸，倒也无所谓）；
2. 随着 APP 的流氓化，里面某些功能点可能要收费（不差钱，也无所谓）；
3. **无法备份应用数据或应用数据备份不完备**。

对于一个 Android 手机，备份的极致追求是丝滑的换机/刷机体验。即，当我换了一部手机或是我刷了一个新的 ROM，我可以通过备份恢复完全恢复到我换机/刷机之前的样子，并且应用数据得以保留[^b]。刷机暂且不论，因为媒体数据（存盘的照片、视频、文档等）一般不会丢失。但换机之后，希望原封不动的将想要的数据按照原始文件夹结构📁迁移到新手机。

为了达成以上目标，我摸索了一套 Android 手机的备份攻略。

一、全量媒体数据备份
--------------------

这一点可以使用命令行工具 tar 来完成。手机连上电脑或是装一个终端 APP（例如[Termux][1]），保证终端可以使用 tar 命令，然后准备一个纯文本文件，里面记录想要备份的文件夹路径或需要排除的文件夹路径。执行全量备份命令（其实就是将想要的文件打包），
```bash
#!/bin/bash
#
# 用于刷机前将媒体数据备份，防止刷坏需要格式化data分区。

SDCARD_DIR="/storage/emulated/0"
EXEC_DIR=$(cd $(dirname $0); pwd)

echo "EXEC_DIR=$EXEC_DIR\n"
echo "SDCARD_DIR=$SDCARD_DIR"

cd $SDCARD_DIR
tar --zstd \
    -cvf $EXEC_DIR/sdcard_backup_$(date +"%Y-%m-%d").tar.zst \
    --exclude="*/.*" \
    -T $EXEC_DIR/pull_file_list.txt
```

猛击[这里][2]获取备份和恢复脚本。

什么情况下需要做这一步？

1. 在刷机时如果你觉得很可能会丢失数据，需要全盘格式化，先执行一个备份操作，然后将备份数据包拷贝出来。
2. 在换机之后，将媒体数据整个打包迁移到新手机。

二、应用数据备份
----------------

应用数据备份一般需要借助专门的 APP，或是[备份脚本][3]。Android 9 还是 10 以前，钛备份作为备份界一哥，其地位无人撼动。然而随着 Android 版本的升高，钛备份却跟不上其升级速度，导致出现很多低版本 Android 备份的应用数据无法在高版本 android 系统中还原。无奈之下弃之，所幸遇到了新的替代品：[NeoBackup][4].

当然，凡是可以备份应用数据的都需要 root 权限，当今 android 手机刷个面具，弄个 root 还是很简单的。不要说 root 以后设备不安全之类的，root 只是一个权限，怎么使用还是看你——设备的拥有者。

NeoBackup 的使用在软件主页介绍的很详细。一般而言这些应用会有一个备份数据存放的文件夹（下称`backup_folder`），我们只要将这个文件夹备份好，那么在一个新手机上，先把这个备份文件夹还原过去，再装上 NeoBackup，即可在 APP 里面任意操作想要还原的应用。你可以还原一个或批量还原多个应用及其数据；也可以为一个已安装的应用，还原其数据；更可还原应用到以前的版本（应用降级）。

如此，将`backup_folder`作为一个媒体数据备份即可。

三、增量备份
------------

备份一事，虽说无需过于频繁，但刷机前忘记备份最新数据的事情却时有发生。想一想，你最近几天拍的照片、刚刚下载的一本小说、昨天从同事那儿接收的文件、便签 APP 里记录的备忘录和待办事项。手机中的数据常用常新，而我们在刷机前，很难做到每次都全量备份一遍。一是我半个月前全量备份的数据包和我现在的又差得了多少呢？而是全量备份一次实在耗时，我必须立马刷机。

鉴于此种种，一个增量备份的补充显得格外重要。定期备份全量数据的压缩包，短期增量备份指定的文件夹（媒体、文档等）。这样的备份才能给宝贵的数据多上一层保险。

增量备份的一个基本要求，就是文件的时间戳不能随意修改。我尝试过 xplore+webdav 的方案，发现文件同步之后时间戳会丢失，也就是被同步的文件的时间戳会更新为操作时间而非源文件本来的时间。所以想着有没有工具可以在同步的时候保留时间戳呢？

rsync 应该有这个功能。那么思路有二：

1. 手机端安装 Termux 使用 rsync，PC 端开 ssh server，手机端向 PC 端推；
2. 手机端开 ssh server，PC 端使用 rsync 从手机端拉数据。

显然后者更方便，因为手机上操作 rsync（操作命令行）显然不如电脑方便。再者说来，第二种方法是以手机为中心，任何时候，手机端开启 ssh server，那么任何电脑装一下 rsync 就能和手机同步数据。如果是电脑插上硬盘，那么随便换电脑，只要插上备份硬盘就可以一直保证同步的两端是一致的。

手机端安装 SSHelper（参考 https://askubuntu.com/a/343740），PC 上配置 ssh 免密登陆，
```bash
$ cat ~/.ssh/config
Host munch
    Hostname 192.168.6.13
    Port 2222

$ ssh munch
SSHelper Version 13.2 Copyright 2018, P. Lutus
client_input_hostkeys: received duplicated ssh-rsa host key
Redmi_K40S:4.19.261-HellFire-X//jlk09i902i3rj
u0_a299@localhost:~$
```
达到直接输入`ssh munch`就可以登陆的效果。

在备份盘对应手机用户根目录（对应手机目录通常为`/storage/emulated/0`）执行此脚本`rsync.sh`即可进行增量备份。

```bash
#!/bin/bash

cat << COMMENT
This script is used to backup some folders from mobile phone to here (the 
directory of a backup disk). To achieve this, you should

1. have \`rsync\` installed in your PC;
2. start a ssh server on your mobile phone, i.e., SSHelper;
3. config your ssh login via .ssh/config and ssh-copy-id such that you can
   login your mobile simply with \`ssh munch\`.

See: https://askubuntu.com/a/343740
COMMENT

set -e # exit when error

#exit 23

folers_to_sync=(
    Pictures
    Snapseed
    billing
    Books
    dictionary
    Download
    eudb_en
    Fonts
    GooglePinyinInput
    neo_backuped_data
    Music
    Movies
    )

sync_folder() {
    if [ ! -d $1 ]; then
        mkdir $1
    fi
    rsync -auh --progress \
        --size-only \
        --exclude=".*" \
        munch:SDCard/$1/ $1
}

notify() {
    echo "--- $1"
}


for folder in ${folers_to_sync[*]}; do
    notify "sync folder $folder"
    sync_folder $folder
    echo; echo # for two newlines
done
```
修改变量`folders_to_sync`来配置你的同步文件夹，如果文件夹里面没有新增，则此操作会很快。此操作仅会同步手机端新增的文件到 PC.


本段原帖参考我的[issue][5].

[1]: https://wiki.termux.com/wiki/Main_Page
[2]: https://github.com/guyueshui/backup_script/blob/dev/yychi/
[3]: https://github.com/YAWAsau/backup_script
[4]: https://github.com/NeoApplications/Neo-Backup
[5]: https://github.com/guyueshui/guyueshui.github.io/issues/20

总结
----

刷机一时爽，一直刷机一直爽。前提是做好备份哈～

[^a]: 在不同类型的 ROM 上迁移系统设置是一个灾难，非常不建议这么做。因为不同的 ROM 相当于不同的 APP，你用一个应用的设置去覆盖另一个应用，后果可想而知了。
[^b]: 即，应用是已经设置好的，打开之后不需要像新装一个应用一样重新设置，里面的使用记录也不会丢失。
