---
title: 初尝 C++ 类设计
date: 2019-04-02 21:31:40
categories: ['Notes']
tags: ['cpp']
---

最近在准备笔试，于是在各种网站上刷题嘛。期间做了百度某年的一道[编程题][1]。

> 小B最近对电子表格产生了浓厚的兴趣，她觉得电子表格很神奇，功能远比她想象的强大。她正在研究的是单元格的坐标编号，她发现表格单元一般是按列编号的，第1列编号为A，第2列为B，以此类推，第26列为Z。之后是两位字符编号的，第27列编号为AA，第28列为AB，第52列编号为AZ。之后则是三位、四位、五位……字母编号的，规则类似。
>
> 表格单元所在的行则是按数值从1开始编号的，表格单元名称则是其列编号和行编号的组合，如单元格BB22代表的单元格为54列中第22行的单元格。
>
> 小B感兴趣的是，编号系统有时也可以采用RxCy的规则，其中x和y为数值，表示单元格位于第x行的有第y列。上述例子中的单元格采用这种编码体系时的名称为R22C54。
>
> 小B希望快速实现两种表示之间的转换，请你帮忙设计程序将一种方式表示的坐标转换为另一种方式。

> 输入 | 输出
> ---- | -------
> 输入的第一行为一个正整数T，表示有T组测试数据（`1<=T<=10^5`）。随后的T行中，每行为一组测试数据，为一种形式表示的单元格坐标。保证所有的坐标都是正确的，且所有行列坐标值均不超过10^6 | 对每组测试数据，单独输出一行，为单元格坐标的另一种表示形式。
> 2 <br> R23C55 <br> BC23 | BC23 <br> R23C55

写这道题目的时候，正好复习了C++的类，于是居然鬼使神差的想设计一个类来实现它。C++的核心思想是面向对象，而此处的单元格正好有显著的对象特征。一个单元格，应该有座标，以及其中的内容。这是很自然的，当初看C++ Primer的时候，书中也是以书本销量作为引入，介绍并阐述类的设计。

## Definitions

闲话少说，现在就来看看如何实现这个类。
```c++
// Unit/Unit.h

class Unit {
private:
    using pos = unsigned int;
    pos rowIdx;
    pos colIdx;

public:
    // constructors
    Unit(pos _r, pos _c) : rowIdx(_r), colIdx(_c) { }
    // constructor2
    Unit(string);
};
```
先看这么多，我希望每个单元个有两个属性，一个行索引`rowIdx`一个列索引`colIdx`. 而且我定义了两个构造函数，一个是直接将行列索引传入，另一个则是通过读取一个字符串，来解析出其中的行列索引的值。这里有一个问题，因为不同类型的字符串解析的方式不一样，所以需要一个指示变量来指明传入的字符串到底是哪个类型：`BC23`还是`R23C55`？除此之外，我还需要一个可以转换不同类型表示的函数，给了我表示类型1，我可以直接调用一个函数，输出表示类型2. 需求先大致到这里，来改进一下之前的类。
```c++
// Unit/Unit.h

#ifndef _UNIT_H_
#define _UNIT_H_

#include<string>

class Unit {
private:
    using pos = unsigned int; // type alias
    pos rowIdx;
    pos colIdx;
    bool isRC; // is the type `R23C55`?
    void getIdx_RC(std::string); // build index for type 'R23C55'
    void getIdx_NRC(std::string); // for type 'BC23'

public:
    // constructor1
    Unit(pos _r, pos _c) : rowIdx(_r), colIdx(_c) { }
    // constructor2
    Unit(std::string);

    // selectors
    pos getRow() { return rowIdx; }
    pos getCol() { return colIdx; }

    // modifiers
    void setRow(pos _r) { rowIdx = _r; }
    void setCol(pos _c) { colIdx = _c; }

    // utilties
    void printer(void);
    void convertor(void);
};
#endif
```
这里先不要纠结定义了很多不知道要干嘛的函数，往下看类的实现，你会慢慢明白为什么需要它们。

## Implementions

类的头文件中只定义了类，除少数内联函数外，大多数函数仍未实现。按照模块化的哲学，新开一个文件写类的实现。

### 构造函数的实现

```c++
// Unit/Unit.hpp

#include "Unit.h"

// implement constructor2
Unit::Unit(string _s) {
    // wishful thinking 
    isRC = typeInfer(_s);
    if (isRC) {
    /*
     * wishful thinking: suppose i have the function
     * that helps me do this job
     */
        getIdx_RC(_s);
    } else {
    // again wishful thinking
        getIdx_NRC(_s);
    }
}
```
好了，现在我们实现了第二个构造函数，它接受一个`string`对象，从中解析出行列索引的值，然后初始化`rowIdx`和`colIdx`. 

但是，我们想当然的调用了一些我们还没有实现的函数。这里要特别注意一点：在写程序的时候，这种想法很有用！以下思想来自我学习[SICP][2]一段时间以后的自我体会：程序往往会包含很多的函数，为什么？因为有时候一个稍微复杂的问题，并不是一个函数就能解决的，所以需要多个函数相互协调，相互调用才能共同完成或是解决一项工作。如果你费尽心思把它们都写在一个函数里，可能你觉得很好，但是一旦程序报错，你将无从下手，很难定位到错误发生在哪里。这也是程序设计讲究模块化的理由。将复杂的功能抽象成一个一个的互不干涉的模块（子程序），在每一个小模块里尽可能的将代码写好，使得它只完成并且高效准确地完成这一项任务。那么当所有模块相互协同起来，将会使难以想象的高效，且不容易出错，即便是出错了，也能很快定位到错误发生的地点，便于调试。

这样做的好处还有一个，就是你在写程序的时候变得更加轻松。为什么？因为我不用考虑所有的细节，只是调用了一些函数，而实现这些函数很可能不是我们要干的活。<q>Oh, that's cool! George will do for me.</q> 你甚至可以去喝杯咖啡。但是现在，让我们短暂的充当以下 George 的角色。就拿`Unit`类的设计来说，我现在想要实现第二个构造函数，根据题目的意思，我可能接受两个代表不同表示方法的`string`，我要将它们解析成行列索引。让我们回头看看这个函数的实现，它先判断输入的是那个类型，然后分情况做不同的事（调用不同的函数）。这里我用到了3个wishful thinking：

1. 我希望有一个叫`typeInfer()`的函数，我给它一个字符串，它告诉我这属于哪个类型的表示方法。
2. 如果是`RxCy`型，我希望有一个函数`getIdx_RC()`能够处理这种类型的输入，解析出行列索引。
3. 如果是`BC23`型，我希望有一个函数`getIdx_NRC()`能够处理这种类型的输入，解析出行列索引。

这样一来，我们不容易犯错。为什么？因为这个构造函数的逻辑足够简单，仅仅是分两个情况做不同的事。做的事也很简单：仅仅是调用一个函数！如果你能保证所调用的函数不犯错，那么整个过程也不会出错。既简单，又robust！

还有我个人认为的好处就是，写程序变得简单了。我到每一步的时候，需要什么，想象一下，假设它已经有了，我该怎么写，怎么去调用它。这样你就对为什么要有这个函数，以及这个函数要干什么，心知肚明了。然后上层建设好之后，我再去考虑如何实现那些想象！现在，我们来看看，之前想当然的几个函数如何实现。
```c++
// Unit/Unit.hpp

#include "Unit.h"
#include <string>

/*
 * Predefined things...
 */

bool typeInfer(std::string _s) { // infer the representation type
    if (_s[0] == 'R' && std::isdigit(_s[1]))
        return true;
    else
        return false;
}

void Unit::getIdx_RC(std::string _s) {
    /*
     * build the row/col index for
     * type 'R23C55'
     */
    _s.erase(0, 1); // remove first 'R'
    
    // find where 'C' is
    std::string::size_type c_pos = 0;
    for (; c_pos != _s.size(); ++c_pos) {
        if (_s[c_pos] == 'C') break;
    }
    auto s1 = _s.substr(0, 0 + c_pos); // s1 = "23"
    auto s2 = _s.substr(c_pos + 1, _s.size()); // s2 = "55"
    // set index
    rowIdx = std::stoi(s1);
    colIdx = std::stoi(s2);
}

void Unit::getIdx_NRC(std::string _s) {
    /*
     * build the row/col index for
     * type 'BC23'
     */

    // find the first num
    std::string::size_type n_pos = 0;
    for (; n_pos != _s.size(); ++n_pos) {
        if (std::isdigit(_s[n_pos]))
            break;
    }

    auto s1 = _s.substr(0, n_pos); // s1 should be "BC"
    auto s2 = _s.substr(n_pos, _s.size()); // s2 should be "23"
    rowIdx = std::stoi(s2);
    colIdx = letter2pos(s1);
}
```
> Note: 注意到`getIdx_RC()`和`getIdx_NRC()`需要访问类内私有变量，所以应该声明成类的成员函数。

好了，看了上面的实现，我又想当然的引入了几个函数。但是通过上下文，你可以很明显的看出来我引入这个函数实干嘛用的。正是因为这个时候我需要有一个函数帮我去干这个事情，而我又不想把这些复杂的工作都写到一个函数里面（因为容易出错，且很难调试）。所以我引入了它们：

1. `letter2pos()`接受一个字符串，返回解析出来的数值索引。

好吧，居然只引入了一个(╬ Ò ‸ Ó)，再来看看它的实现。
```c++
// Unit/Unit.hpp

/*
 * Predefined things...
 */

// return the corresponding num for a given string
int letter2pos(const std::string& _s) {
    auto len = _s.size();
    int res = 0;
    for (; len != 0; --len) {
        res = res*26 + alph2num(_s[_s.size() - len]);
        // std::cout << "res: " << res << std::endl;
    }
    return res;
}

// return the corresponding string for a given num
std::string pos2letter(int _p) {
    if (_p <= 26){
        char c[1] = {num2alph(_p)};
        std::string s(c);
        return s;
    }

    std::string res;
    int r = 0;
    while (_p > 26) {
        r = _p%26;
        res += num2alph(r);
        _p /= 26;
    }
    res += num2alph(_p);
    std::reverse(res.begin(), res.end());
    // cout << "res: " << res << endl; 
    return res;
}
```
哈哈，我又想象了几个不存在的函数。它们的作用很容易通过上下文得知。`letter2pos()`和`pos2letter()`是一对相反的函数，它们的作用是完成`BC<->55`的映射。至于`alph2num()`和`num2alph()`，其实也是一对相反的函数，用于检索26个字母对应的数值。
```c++
// Unit/Unit.hpp

// global map for quick search
char MAP[26] = {'A','B','C','D','E','F','G',
                'H','I','J','K','L','M','N',
                'O','P','Q','R','S','T',
                'U','V','W','X','Y','Z'};

// return a num for the given char
int alph2num(char _c) {
    int idx = 0;
    for (; idx != 26; ++idx) {
        if (MAP[idx] == _c)
            return idx + 1;
    }
    std::cerr << _c << "Not found!" << std::endl;
    return 0;
}

// return a char for the given num
char num2alph(int _i) { return MAP[_i - 1]; }
```

### 转换函数的实现

基于上面的工作，转换函数的实现就显得格外清晰简单。所谓转换函数，就是当我输入的是类型1的字符串，它输出转换之后的类型2的字符串，由此达到一个转换单元格表示方法的效果。
```c++
// Unit/Unit.hpp

/*
 * Predefined things...
 */

void Unit::convertor() {
    if (isRC) {
        std::cout << pos2letter(colIdx)
            + std::to_string(rowIdx) << std::endl;
    } else {
        std::cout << "R"
            + std::to_string(rowIdx)
            + "C"
            + std::to_string(colIdx) << std::endl;
    }
}

void Unit::printer() {
    std::cout << "row index: " << rowIdx
        << "\ncol index: " << colIdx << std::endl;
}
```
最后附加一个`printer()`方便打印信息。至此，整个类的设计大概就完了。值得注意的是，最后的`convertor()`之所以能够如此简单地写出来，是因为我们合理将一些工作模块化，这样带来的好处就是可以重复利用，易于维护。

## 总结

我之前写代码，总是不注意模块化，不注意抽象化。能一个函数完成的事为什么要写两个函数？然而，最后只能自食其果。一旦报错，一步步地定位错误，从下往上调试，陷入苦海。也有的时候，因为函数过于复杂，把自己绕糊涂，陷入一个圈子里想不通，弄不懂，出不来。这些结果都以失败告终！而且会打击自信心，感觉别人写代码是写代码，我写代码就纯粹是写bug啊！

好在前段时间看了点SICP，B站上有视频的，我自己也在对着书看，真的是非常好的课程。循着书中传递的思想，慢慢就这么写着，发现有的问题可以写出来了，得益于代码结构的改变，调试错误也比以前稍微轻松一些。到这次写这道编程题，要是在考试中这么写，我肯定来不及的。但是我在课余花了不少时间构思，终于用面向对象的思想将它初步实现。虽然这个类设计的很简单，也有很多瑕疵：

1. 异常输入的处理
2. 类结构的优化以及完备性检查
3. 代码细节的优化

但是和以前半途而废相比，起码完成了类的实现，虽然很粗糙。谨以此文记录一下！


**附赠：SICP的学习资源**

1. [B站视频][a]
2. [在线电子书][b]
3. [习题答案][c]
4. [p2pu sicp solutions][d]

<font color="red">感谢SICP视频翻译工作者，感谢B站up主的搬运，感谢开源社区！</font>

[1]: http://exercise.acmcoder.com/online/online_judge_ques?ques_id=3821&konwledgeId=40
[2]: https://mitpress.mit.edu/sites/default/files/sicp/index.html

[a]: https://www.bilibili.com/video/av8515129
[b]: https://sarabander.github.io/sicp/
[c]: http://community.schemewiki.org/?SICP-Solutions
[d]: https://github.com/sarabander/p2pu-sicp
