---
title: Useful Tricks
date: 2019-01-17 22:19:05
---

此页内容多为软件使用技巧，绝大部分内容来自互联网，如有侵权，请与[我](mailto:guyueshui002@gmail.com)联系。也有部分内容系自己使用软件所得的一些经验，仅供参考。

## FFmepg

### 转视频为gif

```bash
ffmpeg -i input.mkv out.gif
```
又：加速播放。假设原视频 60 fps，输出降到 30 fps，丢掉一半的帧。
```sh
ffmpeg -r 60 -i input.mkv -r 30 out.gif
```
又：不想丢帧。将输入扩大一倍，输出保留原样。
```sh
ffmpeg -r 120 -i input.mkv -r 60 out.gif
```
又：不想全转。从视频的第2秒开始，截取3秒转化为gif。
```sh
## 从视频中第二秒开始，截取时长为3秒的片段转化为 gif
ffmpeg -t 3 -ss 00:00:02 -i input.mkv out-clip.gif
```
又：控制转化质量。
```sh
## 默认转化是中等质量模式，若要转化出高质量的 gif，可以修改比特率
ffmpeg -i input.mkv -b 2048k out.gif
```

--------

## ImageMagick

### 图片转换

转换图片为指定分辨率。
```bash
convert -resize 1920x1080 src.jpg dst.jpg
```
又：按百分比转换大小。
```bash
convert -resize 50%x50% src.jpg dst.jpg
```
又：忽略原始宽高比。
```bash
convert -resize 300x300! src.jpg dst.jpg
```

--------

## Shell

### 行内操作

- `^a`: jump to BOL
- `^e`: jump to EOL
- `^u`: delete the line
- `^k`: delete to EOL
- `^w`: delete a word forward
- `alt+f`: jump a word forward
- `alt+b`: jump a word backward
- `^r`: search history
- `alt+.`: complete second parameter

### 任务控制

1. 执行`command`
2. 按`^z`挂起当前job
4. 按`bg`后台继续该job
3. 按`fg`召回前台

### 后台运行命令

```sh
command &
```
或者如果你不想看到任何输出，使用
```sh
command &> /dev/null &
```

- 如此你可以继续使用当前shell
- 使用`bg`查看是否有任务在后台运行
- 使用`jobs`查看后台任务
- 使用`fg`将任务召回前台
- 不能退出shell，否则进程会被杀掉
- **使用`disown`丢掉进程，可以退出shell**

又：
```sh
nohup command &> /dev/null &
```
等价于以上的操作。单纯的`nohup command`会在当前目录创建一个隐藏文件以写入命令的输出。以上命令将程序的输出重定向至比特桶丢弃。

--------------

## Command `find`

```bash
$ find --help
Usage: find [-H] [-L] [-P] [-Olevel] [-D help|tree|search|stat|rates|opt|exec] [path...] [expression]
```

前面的选项不常用，初级使用只需掌握
```bash
find [path...] [expression]
```

- `path` - search path
- `expression` - expands to `-options [-print -exec -ok]`
    + `-options`: 指定find常用选项
    + `-print`: 将匹配到的文件写入标准输出[默认]
    + `-exec`: 在匹配到的文件上执行一串命令。格式为`<command> {} \;`，注意 {} 和 \; 之间的空格。
        * `find . -size 0 -exec rm {} \;` - 删除当前目录下size为0的文件
        * `rm -i $(find . -size 0)` - 同上
        * `find . -size 0 | xargs rm -f &` - 同上
    + `-ok`: 同上，执行命令前会询问

**常用选项**

- name - 按照文件名查找
    + `find <dir> -name "*.cpp"`: 在目录dir下查找后缀为cpp的文件
- perm - 按照文件权限查找
- user - 按照文件所有者查找
- group - 按照文件所有组查找
- type - 按照文件类型查找
- size - 按照文件大小查找
- ...

**几个例子**

- `find . -name "*name*"` - 找出当前文件夹文件名包含“name”的文件
- `find . ! -type d -print` - 在当前目录查找非目录文件
- `find . -newer file1 ! file2` - 查找比file1新但比file2旧的文件

--------------

## Command `grep`

--------------

## Command `sed`

--------------

## Git

使用 `git log` 查看提交历史，但是输出冗杂。通常使用
```sh
git log --oneline --abbrev-commit --all --graph --decoreate --color
```
来获得更美观易读的输出。但是每次输入这么多肯定很烦人，使用
```sh
git config --global alias.graph "log --graph --oneline --decorate=short"
```
增加一个全局别名，这个别名对于任何地方的 `git` 都适用。如此一来，键入 `git graph` 会等效于
```bash
git log --graph --oneline --decorate=short
```
样例输出：
```sh
$ git graph

* 36f2d65 (HEAD -> master, origin/master, origin/HEAD) Forget it
* 9b4a6d7 Update ref list
* 3931d4d Using relative path for image
* ba18821 Upload pics
* ceca69a fixed reference
* be15df2 fixed picture address
* 97a36f3 Initial commit
```
**忽略已经添加的文件**
```bash
git rm --cached <somefiles>
```

## Command `g++`

自定义包含路径
```bash
g++ main.cpp -I/usr/local/include
```

自定义链接静态或动态库
```bash
g++ main.cpp -L/path/to/lib_file
g++ main.cpp -L/usr/lib64 -lcurl -lssl
```
上面第二个命令链接了`/usr/lib64/`目录下的`libcurl.so`和`libssl.so`两个动态库文件。静态库也是同样链接。说起来静态库，想起了最近折腾的一个东西，你可能会想把多个静态库合成一个静态库，想当然的直接用`ar`合并，但是不行，必须要把两个静态库全解压出来，再合并所有的object file. 参见：[here](https://www.cnblogs.com/fnlingnzb-learner/p/8127456.html)

生成机器码
```bash
g++ main.cpp -c
```

生成汇编代码
```bash
g++ main.cpp -S
```

------------

## Aria2c

[aria2c](https://aria2.github.io/) 是个好东西。

配置：参考 [aria2配置示例](https://binux.blog/2012/12/aria2-examples/)
webui:
- [YAAW](http://binux.github.io/yaaw/demo/)
- [ziahamza](https://ziahamza.github.io/webui-aria2/#)
- [AriaNg](http://ariang.mayswind.net/latest/)

Note: jsonrpc 地址格式为 `http://token:<rpc-secret>@hostname:port/jsonrpc`
令牌填写自己设置的 `rpc-secret`
<center>
<img src="https://i.loli.net/2018/12/28/5c263327c4214.png" width="500" />
</center>

`xxx` 替换为自己设置的 `rpc-secret`
<center><img src="https://i.loli.net/2018/12/28/5c263398854c3.png" width="500" /></center>

## HTML

给网页添加BGM。
```html
<embed src="bgm.mp3" autostart="true" loop="true" width="300" height="20" hidden="true">
```
又，添加可以控制播放的音乐。
```html
<audio autoplay="autoplay" controls="controls" loop="loop" preload="auto" src="music.mp3">Your browser doesn't support H5 audio flag!</audio>
```

--------

## 使用`xrandr`设置多屏显示

```bash
$ xrandr
Screen 0: minimum 320 x 200, current 1920 x 1080, maximum 8192 x 8192
eDP-1 connected primary 1920x1080+0+0 (normal left inverted right x axis y axis) 294mm x 165mm
   1920x1080     59.93*+
   1680x1050     59.95    59.88
   1400x1050     59.98
   1600x900      59.99    59.94    59.95    59.82
   1280x1024     60.02
   1400x900      59.96    59.88
   1280x960      60.00
   1440x810      60.00    59.97
   1368x768      59.88    59.85
   1280x800      59.99    59.97    59.81    59.91
   1280x720      60.00    59.99    59.86    59.74
   1024x768      60.04    60.00
   960x720       60.00
   928x696       60.05
   896x672       60.01
   1024x576      59.95    59.96    59.90    59.82
   960x600       59.93    60.00
   960x540       59.96    59.99    59.63    59.82
   800x600       60.00    60.32    56.25
   840x525       60.01    59.88
   864x486       59.92    59.57
   700x525       59.98
   800x450       59.95    59.82
   640x512       60.02
   700x450       59.96    59.88
   640x480       60.00    59.94
   720x405       59.51    58.99
   684x384       59.88    59.85
   640x400       59.88    59.98
   640x360       59.86    59.83    59.84    59.32
   512x384       60.00
   512x288       60.00    59.92
   480x270       59.63    59.82
   400x300       60.32    56.34
   432x243       59.92    59.57
   320x240       60.05
   360x202       59.51    59.13
   320x180       59.84    59.32
DP-1 disconnected (normal left inverted right x axis y axis)
HDMI-1 disconnected (normal left inverted right x axis y axis)
HDMI-2 connected 1920x1080+0+0 (normal left inverted right x axis y axis) 527mm x 296mm
   1920x1080     60.00*+  60.00    50.00    59.94
   1920x1080i    60.00    60.00    50.00    59.94
   1600x1200     60.00
   1280x1024     75.02    60.02
   1152x864      75.00
   1280x720      60.00    60.00    50.00    59.94
   1024x768      75.03    60.00
   800x600       75.00    60.32
   720x576       50.00    50.00
   720x576i      50.00    50.00
   720x480       60.00    60.00    59.94    59.94    59.94
   720x480i      60.00    60.00    59.94    59.94
   640x480       75.00    60.00    59.94    59.94
   720x400       70.08
```
观察输出可知，连接了两个显示器(eDP-1, HDMI-2)，其中eDP-1是主显示器。如果第二块屏幕无显示，执行下面的命令。
```bash
xrandr --output HDMI-2
```
又，指定分辨率为1920x1080，
```bash
xrandr --output HDMI-2 --mode 1920x1080
```
又，设置为右侧扩展屏，即光标向右可移动至第二块屏，
```bash
xrandr --output HDMI-2 --right-of eDP-1
```
又，连接上第二块屏，想关掉内置显示屏，（警告：不要随便关掉内置屏）
```bash
xrandr --output eDP-1 --off
```
又，开启内置屏。
```bash
xrandr --output eDP-1 --auto
```

## 网络

查看被监听端口
```bash
netstat -tulpn | grep LISTEN
```


# Reference

- [linux下视频转gif](https://kxp555.coding.me/2017/11/23/Linux%E4%B8%8B%E8%A7%86%E9%A2%91%E8%BD%ACgif/)
- [Running Bash Commands in the Background the Right Way [Linux]](https://www.maketecheasier.com/run-bash-commands-background-linux/)
