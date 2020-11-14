---
title: 使用Git管理配置文件
date: 2018-11-16 10:32:19
lastmod: 2020-03-16
tags: [git]
categories: ['Techniques']

---

对于Linux用户，在 `$HOME` 文件夹下，一般都有大量的隐藏文件，形如`.conf`,`.xxxrc`等，这些都是程序的配置文件。很多人也许花了一个下午，一天，甚至一个星期，折腾某某程序的配置文件。如果这些轻易丢失了，那就是浪费生命了！所以，如何将这些文件备份，成了很多人必须要问的一个问题。

之前我就一直没有备份的意识。结果无论是重装系统，还是转移机器，都十分煎熬，很多软件都需要重新配置！这可是一个浩大的工程，费时费力还费心。于是终于想起来应该把苦心经营（大部分都是来自网络资源，然后自己改改）的配置文件给备份一下。

<!-- more -->

于是在网上搜索了一下，发现很多人都用[Github][1]备份自己的配置文件。于是便尝试如下：

常规操作是将所有需要备份的配置文件单独拎出来，放到一个专用文件夹`MyConf`下，该文件夹就作为 git repo 的根目录。然后将配置文件链接到需要原本需要它们的文件夹下。这应该是个比较不错的解决方案了，但是有的人可能不喜欢创建软链，很强迫症○|￣|\_

于是就有了接下来的方法：主要思想是使用家目录`$HOME`下的一个文件夹存储一个 Git bare repository [^a]. 然后使用命令别名去添加，删除，修改配置文件，这样做的好处是不需要在家目录下创建 `.git/` 目录，否则会干扰其他子目录的 git 操作。

## 1. 新建 bare 仓库

在`$HOME`文件夹下新建一个文件夹用来存放 git 版本树。然后初始化为 bare 仓库。

```
mkdir ~/.mydotfiles
git init --bare ~/.mydotfiles
```

## 2. 创建命令别名

接下来需要创建一个命令别名来进行git的各种操作。直接在家目录运行git命令肯定是不行的，因为家目录不是一个 git repo，不包含 .git 文件夹。所以甚至命令别名如下：
```
alias config='/usr/bin/git --git-dir=$HOME/.mydotfiles/ --work-tree=$HOME'
```
像这样定义别名，是一种临时的方式。想要使它每次都生效，可以将其写入 `.bashrc` 或 `.zshrc`.
```
echo "alias config='/usr/bin/git --git-dir=$HOME/.mydotfiles/ --work-tree=$HOME'" >> $HOME/.bashrc
```
如此一来，每次进入shell，都可以使用这个别名。可以敲一个 `config status`看看效果。

## 3. 使用`.gitignore`

现在我们的工作目录是整个家目录，如果要把整个目录全备份的话，那就太可怕了。家目录一般动辄十几甚至几十个Gb，没有哪家免费服务可以让你把整个家目录都备份的。所以我们需要一个 `.gitignore` 文件。Git 会主动忽略`.gitignore`中所匹配的那些文件。在家目录中创建（如果没有）`.gitignore` 文件：
```
#! $HOME/.gitignore

#----[ ignore all ] -----
*
#---[ consider list ]---
!*.[Xx]resources
!*.conf
!*config*
!*[a-zA-Z]*rc
!.config/
!.config/*
#---[ ignore list ]---
```
上面的文件告诉 git 默认忽略所有文件及文件夹，然后反向添加我们想要考虑的那些文件或文件夹[^b]。另外[gitignore.io][4]可以根据要求生成不同的 `.gitignore` 文件。

**忽略特定文件**

Permanently ignore changes to a file

1. Add the __file__ in your __.gitignore__.
2. Run the following: __git__ rm \-\-cached <**file**>
3. Commit the removal of the __file__ and the updated __.gitignore__ to your repo.

> 来自谷歌搜索，巨婴家Doc.

## 4. 常规 git 操作

现在你可以用`config add -A`来添加所有匹配到的文件。如之前的配置，可以匹配大部分的配置文件。如有遗漏，可以用`config add -f <file>` 来强制添加。然后可以 `config commit -m "initial git"` 来提交更改。最后连接 github 远程仓库。

首先在github网站新建一个同名仓库。比如本地仓库为`.mydotfiles`, 那就新建一个同名的远程仓库。然后
```
config remote add origin git@github.com:<username>/<repo_name>
config push -u origin master
```
就可以把本地仓库推送到远程，完成同步。

## 5. 在新系统上还原配置文件

同理，设置别名
```bash
alias config='/usr/bin/git --git-dir=$HOME/.mydotfiles/ --work-tree=$HOME'
```
将`.mydotfiles`加入`.gitignore`以免递归克隆
```bash
echo .mydotfiles >> .gitignore
```
克隆备份好的配置文件
```bash
git clone --bare <git-repo-url> $HOME/.mydotfiles
```
检出克隆下来的配置文件
```bash
config checkout
```


## Reference

- [Using Git and Github to Manage Your Dotfiles][5]
- [Dotfiles][6]
- [The best way to store your dotfiles: A bare Git repository][7]
- [How to use gitignore command in git - Stack Overflow][8]
- [Gitignore doc][9]

[^a]: [What is a bare git repository?][2]
[^b]: 关于该文件的匹配规则参见：[explain gitignore pattern matching - Stack Overflow][3]

[1]: https://github.com
[2]: http://www.saintsjd.com/2011/01/what-is-a-bare-git-repository
[3]: https://stackoverflow.com/questions/33189437/explain-gitignore-pattern-matching
[4]: https://www.gitignore.io
[5]: http://blog.smalleycreative.com/tutorials/using-git-and-github-to-manage-your-dotfiles/
[6]: https://dotfiles.github.io/
[7]: https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/
[8]: https://stackoverflow.com/questions/12501324/how-to-use-gitignore-command-in-git
[9]: https://git-scm.com/docs/gitignore
