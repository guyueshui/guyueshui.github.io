---
title: 'LeetCode: Sum of Two Integers'
date: 2019-03-26 14:53:51
categories: ['Notes']
tags: ['cpp','leetcode',位运算]

---

记录一下LeetCode做的一道题。要求实现两个整数的加法，但不能使用内置的`+`或`-`. 原题地址：https://leetcode.com/problems/sum-of-two-integers/

我们来看一下答案：
```c++
class Solution {
public:
    int getSum(int a, int b) {
        return b == 0? a : getSum(a^b, (a&b)<<1);
    }
};
```

乍一看，似乎很难看，位运算毕竟不是很直观。重写一下，
```c++
class Solution {
public:
    int getSum(int a, int b) {
        int sum = a;
        while (b != 0) {
            sum = a^b; // sum w/o carry
            b = (a&b) << 1; // calculate the carry
            a = sum; // add this sum to next->a
        }
        return sum;
    }
}
```
or
```c++
class Solution {
public:
    int getSum(int a, int b) {
        int sum = a;
        if (b != 0) {
            sum = a^b;
            b = (a&b) << 1;
            return getSum(sum, b);
        }
        else {
            return sum;
        }
    }
}
```
除了将递归写成了迭代，其余部分都是照着第一段代码来的。重要的是为什么是这样？为什么会有
```
a + b == (a^b) + (a&b)<<1
```

现在我们挨个来看看`a^b`、`a&b`到底是啥？首先`a^b`，`^`是C++中的按位异或运算符，它的运算表为：

- 1^1 = 0
- 0^0 = 0
- 1^0 = 1
- 0^1 = 1

现在我们把它竖过来看，或许你会发现一点东西：
```
       1011  <---+ a   X           1011
     ^ 1010  <---+ b   X         + 1010
a^b= -------           X    a+b= -------
       0001            X          10101
```
这好像就是二进制的加法呀？除了没有进位！那么进位在哪里呢？我们把目光转向`a&b`，`&`是C++按位与运算符，它的运算表如下：

- 0&0 = 0
- 0&1 = 0
- 1&0 = 0
- 1&1 = 1

可以看到，与运算只有一种情况为1，这恰好对应着二进制加法中需要进位的情况。再加上进位需要向左边进一位，所以还应该左移一位加上之前的`a^b`，正好就是加法需要的结果。到这里你应该明白为什么`a+b == (a^b) + (a&b)<<1`.

接着，又有一个问题：随着程序的执行，b为什么会变成0？我们看看b是如何更新的，
```c++
sum = a^b;
b = (a&b) << 1; // b is updated
a = sum;
```
假设`a&b = 1010 0111`，那么b的值就会更新为：`1010 0111 => 0100 1110`，b的最低位每次都会引入一个0，而最高位被丢弃，这样的结果就是b中的1越来越少，0越来越多，最终一定会变成0. 而每次b中削减的值，全部间接通过sum被加到a中去了。如此以来，当b为0的时候，此时的a已经加到两者之和了。可以想象有两堆小球，每次迭代都将b这一堆的某些球挪到a中去，那么当b被挪完的时候，a中就有了全部的小球。

还有一个问题，目前我还没有解决。上述答案贴到LeetCode里面是不通过的，因为接受的参数是int型的，可以为负，而将负数左移是未定义的行为。来日有时间再看看...

## 小结

位运算牛逼！无奈本人没文化，只能喊出这样的口号了。另外在做题的过程中，搜到了CSDN上的一篇文章，总结了很多位运算的技巧：[here][4].

## References

1. [原题讨论帖][1]
2. [一人跟帖解释][2]
3. [又][3]

[1]: https://leetcode.com/problems/sum-of-two-integers/discuss/84305/Share-my-C++-solutionseasy-to-understand
[2]: https://leetcode.com/problems/sum-of-two-integers/discuss/84305/Share-my-C++-solutionseasy-to-understand/185730
[3]: https://leetcode.com/problems/sum-of-two-integers/discuss/84305/Share-my-C++-solutionseasy-to-understand/173690
[4]: https://blog.csdn.net/zmazon/article/details/8262185
