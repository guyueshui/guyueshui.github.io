---
title: "Texlive 精简安装"
date: 2026-03-24T22:30:28+08:00
keywords: []
categories: [tech]
tags: [tex]
draft: false
mathjax: false

---

时隔多年，竟然需要再次安装 Texlive 了。上一次装还是上学那会儿，在中科大镜像网站下载 texlive-xxxx.iso，挂载到本地进行安装。当时就是完全安装，也不知道哪个可以不装，不装会否影响使用等等。所以一股脑全量安装，装完大概占用小 10GB 空间吧，还是很重量级的！好在前段时间搜索教程发现可以精简安装，遂决定动手试试。

<!--more-->

其实 texlive 官方提供的安装脚本已经非常好用。精简安装其实就是根据自己的使用场景，去掉一些不太可能用得上的包。这次选择了网络安装，而非下载 iso 文件。其实网络安装就是将安装脚本下载下来，然后运行脚本，根据 TUI 的配置，然后后台连接指定镜像网站下载选中的包。配置本身并不复杂，而且选好之后可以将配置保存成一个叫`texlive.profile`的文件，安装脚本支持从这个文件中读取配置，进行安装。

```bash
# 读取profile中的配置进行安装
./install-tl --profile texlive.profile
```

细化步骤
---

```shell
curl -LO https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
tar -zxvf install-tl-unx.tar.gz
cd install-tl-*  # 目录具体名称包含日期

# 指定镜像、安装目录、不安装src tree
./install-tl --repository=https://mirrors.shanghaitech.edu.cn/CTAN/systems/texlive/tlnet --texdir=~/.texlive --no-src-install
```

然后进入 tui 界面，直接按 C 进入 collection 选择模式，取消勾选下列选项[^a]

```
deghijkstuvwxyznoABCEHIKLMNS
```

按`I`进行安装。最后一步将可执行文件链接到系统目录可能要提权，安装完后可以执行

```bash
# 在系统path中创建软链接，通常是/usr/local/bin
sudo TEXLIVE_INSATLL_PATH/bin/tlmgr path add
tmlgr option showall # 查看相关信息
```

安装完成后空间占用~1.3GB，比起全量安装小太多了。

```shell
$ cd ~/.texlive
$ du -hd1
197M    ./bin
967M    ./texmf-dist
35M     ./tlpkg
8.0K    ./texmf-config
33M     ./texmf-var
116K    ./texmf-local
1.3G    .
```


Tips
----

安装完成后，安装目录`~/.texlive`中会包含，

- install-tl.log：安装日志，里面包含启动命令，texlive 环境变量，及所有安装的宏包信息，非常有用。可以指导下次安装。
- tlpkg/textlive.profile：之前提到的安装配置，如果有这个文件，直接运行`./install-tl -profile texlive.profile`即可安装（镜像链接还是要额外指定的），无需进入 tui 界面。

后续如果有升级，装包，卸载，备份的需求，均可以使用自带的包管理器`tlmgr`实现。详询

```shell
tlmgr --help | less
```

附录
---

### texlive.profile

```
# texlive.profile written on Thu Mar 19 14:05:24 2026 UTC
# It will NOT be updated and reflects only the
# installation profile at installation time.
selected_scheme scheme-custom
TEXDIR /home/yychi/.texlive
TEXMFCONFIG ~/.texlive2026/texmf-config
TEXMFHOME ~/texmf
TEXMFLOCAL /home/yychi/.texlive/texmf-local
TEXMFSYSCONFIG /home/yychi/.texlive/texmf-config
TEXMFSYSVAR /home/yychi/.texlive/texmf-var
TEXMFVAR ~/.texlive2026/texmf-var
binary_x86_64-linux 1
collection-basic 1
collection-bibtexextra 1
collection-binextra 1
collection-fontsrecommended 1
collection-langchinese 1
collection-langcjk 1
collection-langenglish 1
collection-latex 1
collection-latexrecommended 1
collection-mathscience 1
collection-pictures 1
collection-plaingeneric 1
collection-xetex 1
instopt_adjustpath 1
instopt_adjustrepo 1
instopt_letter 0
instopt_portable 0
instopt_write18_restricted 1
tlpdbopt_autobackup 1
tlpdbopt_backupdir tlpkg/backups
tlpdbopt_create_formats 1
tlpdbopt_desktop_integration 1
tlpdbopt_file_assocs 1
tlpdbopt_generate_updmap 0
tlpdbopt_install_docfiles 0
tlpdbopt_install_srcfiles 0
tlpdbopt_post_code 1
tlpdbopt_sys_bin /usr/local/bin
tlpdbopt_sys_info /usr/local/info
tlpdbopt_sys_man /usr/local/man
tlpdbopt_w32_multi_user 1
```

### 常用宏包

使用 tlmgr 单独安装的，会在日志文件[^b]中留下记录。

```shell
$ grep install texmf-var/web2c/tlmgr.log | awk '{print $NF}'
graphbox
wrapfig
makecell
titlesec
tcolorbox
multirow
fontawesome
realscripts
enumitem
```

References
----------

- [北京理工大学社区论文模板教程](https://bithesis.bitnp.net/guide/getting-started.html#%E7%B2%BE%E7%AE%80%E5%AE%89%E8%A3%85%E5%86%85%E5%AE%B9)
- 谢益辉的安装脚本：https://gist.github.com/yihui/7ae1144e45063c4957e5c1f6f67039f4
- https://tug.ctan.org/info/install-latex-guide-zh-cn/install-latex-guide-zh-cn.pdf
- 主要参考：https://www.cnblogs.com/eslzzyl/p/17358405.html

[^a]: https://www.cnblogs.com/eslzzyl/p/17358405.html
[^b]: 通常是 `~/.texlive/texmf-var/web2c/tlmgr.log`