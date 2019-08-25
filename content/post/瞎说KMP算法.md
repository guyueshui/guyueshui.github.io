---
title: 瞎说 KMP 算法
date: 2019-04-04 00:05:41
categories: ['Learning Notes']
tags: ['algorithm', 'pattern match']
---

前天做百度笔试，没想到居然出往年的题！哼！更惨的是出了我也不会！我以为只是一个简简单单的字符串匹配，没想到要动用这么难懂的算法。说起来算法导论上也有，只是之前没看到那里。所以，总结一下：我本有好多次机会学习它，然而一次都没有把握。:(

所以这次，拿出来好好研究一波，做点笔记，以备日后之用。说起来网络上关于该算法的博文一大堆，我也不说能比它们都好，每个人都有适合自己的理解，我这里就是瞎谈一番罢了。

在开始之前，强烈建议先读[Jake Boxer][1]的文章，它从无到有，讲得浅显易懂，介绍了 how it works！我这篇文章，也是在看了好多中文博客未解之后，开始看了那个外文博文。在理解的基础上，加一点自己的描述。

## 背景

长长的博文一大堆，相信你也很珍惜时间，我就长话短说（偷懒找个借口:p）。**这个算法是干嘛的？**它解决的问题是，给定一个字符串，我们称之为主角K，然后你要在一个比它长的配角Z中找到我们的主角。翻译一下：在父串中寻找给定的子串，返回匹配索引。比如说`K = king`，`Z = zookingmonkey`，很显然，Z中有与K相同的子串，返回索引`4`.

## 常规方法

沿用Jake Boxer的例子，设`K = abababca`，`Z = bacbababaabcbab`. 常规的方法是从头开始比较，比如
```
/* 
 * `|` denotes a match
 * `x` denotes a dismatch
 */

(1):
bacbababaabcbab
x
abababca

(2):
bacbababaabcbab
 |x
 abababca

(3):
bacbababaabcbab
  x
  abababca

(4):
bacbababaabcbab
   x
   abababca

(5):
bacbababaabcbab
    |||||x
    abababca

(6):
bacbababaabcbab
     x
     abababca

(7):
bacbababaabcbab
      |||x
      abababca

(8):
bacbababaabcbab
       x
       abababca

(9):
bacbababaabcbab|
               |
        abababca

---> return NOT FOUND!
```
以上就是正常思考的方法，维护一个指针`p`，指向第一次开始比的位置，然后依次比下去， 跟踪匹配的位数 ，如果全部匹配，返回`p`，如果有一个不匹配，直接右移一位，`p = p+1`. 接着如法炮制，从第一个字符依次比下去。设父串Z的长度为 `n`，子串K的长度为`m`，那么上述方法最坏情况下要比较`m*n`次，时间复杂度为`O(mn)`.

KMP算法要做的事情的，就是根据子串K的特征，在**移位**和**比较**的时候实现一个跳步！减少了比较次数。

但是要根据子串K的特征，哪又是什么样的？该如何刻画呢？这就要说到下面的 partial match table 了。

## Partial Match Table

KMP有一个很重要的表，叫做 Partial Match Table (PMT)，翻译过来叫做部分匹配表。它有多重要呢？就像理想对于你的那种重要。KMP什么时候能跳步，跳多少，都是由它决定的！

先来看看它如何产生的吧，关于它的生成，许多博文讲得很清楚了。其中大多是用前缀集、后缀集的概念描述。设有字符串`str = ababba`, 它的长度`length(str) = 6`,

- **前缀集**：去掉字符串尾部 1-5 个字符得到的所有子串。记作 `P(str)` = {a, ab, aba, abab, ababb}.
- **后缀集**：去掉字符串头部 1-5 个字符得到的所有子串。记作 `S(str)` = {a, ba, bba, abba, babba}.

该字符串`str = ababba`对应的 partial mathch value (PMV) 计算方式：
$$
v = \max_{i\in S(\texttt{str}) \cap P(\texttt{str})} \text{length}(i) := f(\texttt{str})
$$
于是，给定一个字符串`str`，我们的`f(str)`就能返回它的PMV. 现在有请我们的主角`K = abababca`上场，我们来看看如何构建它的PMT.

> Note: 为了防止我自定义的术语让你感到很吃力，先给你洗个脑。
> PMT 是一个表（table）， PMV 是一个值（value）。PMT中的元素就是PMV.
> PMT 是一个表（table）， PMV 是一个值（value）。PMT中的元素就是PMV.
> PMT 是一个表（table）， PMV 是一个值（value）。PMT中的元素就是PMV.

先用一句话简要说明一下：对K的前缀集的每个字符串再加上K本身，计算它们的PMV，按从短到长的顺序将它们排成一行。再用程序语言表达一下：
```python
def buildPMT(K):
    # 假设 S(K) 返回的列表按子串的长度从小到大排序
    PMT = [f(substr) for substr in S(K)]
    PMT.append(f(K))
    return PMT
```
那么我们计算得到的`K = abababca`的 partial match table 如下：

str | a | b | a | b | a | b | c | a
---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---:
value | 0 | 0 | 1 | 2 | 3 | 4 | 0 | 1
index | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7

记住这个表，它很重要！或者讲到跳转的时候再过来查看。这一部分基本上是转述了Jake Boker的话，不过表达的可能不如他。感谢Jake Boxer.

### 又

下面讲讲我理解的PMT的计算方式。因为PMV (partial match value) 是最大公共子串的长度，哪两个公共？前缀集和后缀集！那么我们比较的时候肯定要分别在两个集合中找字符串长度一致的两个串，考察它们是否相等。依次从长度为1，2，3...这么一直找下去，如果有更长的公共串，就更新PMV。

具体来说，给我一个字符串`str = ababa`，我可以这样来计算它的PMV. 想象有一块木板插空该字符串，
```
a|baba => a, baba
ab|aba => ab, aba
aba|ba => aba, ba
abab|a => abab, a
```
每次插空，我都可以得到一个前缀和一个后缀。从上面的结果来看，产生的次序还有一定的对称性。那么我计算它的PMV时，直接这样比较：
```
(1). a|baba <=> abab|a ---> PMV = 1
(2). ab|aba <=> aba|ba ---> PMV = 3
( ). aba|ba <=> ab|aba ---> it returns to step (2)
( ). abab|a <=> a|baba ---> it returns to step (1)

---> return PMV = 3
```
即每次划分之后，我直接考察它对称的划分，然后比较前缀后缀是否相等，进而更新PMV.

## PMT 怎么用

实际上这一段也算是转述Jake Boxer的话，再次感谢！

> KMP算法要做的事情的，就是根据子串K的特征，在**移位**和**比较**的时候实现一个跳步！减少了比较次数。

之前提到KMP的主要思想就是跳步，现在是时候来看看它是怎么个跳法了。同样的父串`Z = bacbababaabcbab`，子串`K = abababca`.
```
/*
 * `|` denotes a match
 * `x` denotes a dismatch
 * `~` denotes a jump
 */

(1):
bacbababaabcbab
x
abababca

(2):
bacbababaabcbab
 |x
 abababca

(3):
bacbababaabcbab
  x
  abababca

(4):
bacbababaabcbab
   x
   abababca

(5):
bacbababaabcbab
    |||||x
    abababca
!ATTENTION! I'LL JUMP

(6):
bacbababaabcbab
    ~~|||x
      abababca
!JUMP AGAIN!

(7):
bacbababaabcbab|
      ~~       |
        abababca

---> return NOT FOUND!
```
为什么你跳得这么兴奋？为什么可以这么跳？我想应该有人和我当初一样，虽然你跳的很好，但是我一脸懵逼(＃°Д°). 

我们把来看step5到step6的跳步拎出来看看，
```
(5):
bacbababaabcbab
    |||||x
    abababca

(5.1):
****ababa******
    |||||x
    ababa***
```
从step5到step5.1我什么也没干，只是把一些碍眼的东西替换成了`*`号。我们可以看到的是，step5匹配了5个字符，匹配的是K的开头向后5个字符。让我们回头看看这个子串的PMV，查表得知`f("ababa")=3`. 这个“3”代表着什么？它代表了子串`ababa`的长度为3的前缀一定等于长度为3的后缀，因为这就是PMV的物理意义啊，同志们！所以我可以跳步！直接将前缀`abc`挪到与后缀`abc`对齐！
```
aba|ba <=> ab|aba

---> jump:

ababa
~~|||
  ababa
```
我不但可以跳步2，我还知道后面的3个字符比都不用比，肯定和父串match，所以我直接从第4个字符开始比。
```
(5):
bacbababaabcbab
    |||||x
    abababca

(5.1):
****ababa******
    |||||x
    ababa***

(6):
bacbababaabcbab
    ~~|||x
      abababca
         |
         start point for comparison
```
如果将PMT存在一个数组里，数组下表从0开始的话，那么每次跳步的长度就可以用一个公式来刻画：

<div style="text-align:center">
    <code>
        jump_chars = PML - PMT[PML-1]
    </code>
</div>
其中，PML 表示 partial match length，代表当前匹配长度，比如step5的匹配长度 `PML=5`.

Q: PMT是什么？它为什么这么屌？凭什么它这么屌？它是干嘛的呢？
A: 可以说PMT就是待匹配字符串的本体了。

## 复杂度分析

来日在填(╬ Ò ‸ Ó)

## C++实现

## Reference

1. [The Knuth-Morris-Pratt Algorithm in my own words][1]


[1]: http://jakeboxer.com/blog/2009/12/13/the-knuth-morris-pratt-algorithm-in-my-own-words/
