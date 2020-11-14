---
title: 位域结构体简介
date: 2019-08-06 20:43:02
categories: ['Notes']
tags: [cpp, 结构体, 位运算]

---

最近实习接触到一个新的知识点，C/C++的位域结构体。

以下开始摘抄自：[here][1]

位段(bit-field)是以位为单位来定义结构体(或联合体)中的成员变量所占的空间。含有位段的结构体(联合体)称为位段结构。采用位段结构既能够节省空间，又方便于操作。

位段的定义格式为:
```
type [var]: digits
```
其中type只能为int，unsigned int，signed int三种类型(int型能不能表示负数视编译器而定，比如VC中int就默认是signed int，能够表示负数)。位段名称var是可选参数，即可以省略。digits表示该位段所占的二进制位数。

举个例子，你可以这样定义一个位域结构体：
```c++
// sizeof(A): 4
struct A
{
  uint32_t a: 12;
  uint32_t b: 10;
  uint32_t c: 10;
};

// sizeof(B): 12
struct B
{
  uint32_t a;
  uint32_t b;
  uint32_t c;
};
```
`uint32_t`实际上是`unsigned int`的别名，并且指定了用4个字节存储int类型的数据，而 1byte = 8bits, 4个字节共计32bits，结构体A使用了位域的方式，指定了每个成员所占用的bit数。可以看到，A中三个成员总共占用的比特数为32，也就是4个字节。所以结构体A所占用的空间就是4字节，而B没有使用位域，则3个成员各占4个字节，共计12字节。说白了，位域就是将结构体的成员在比特位上编排的更紧凑，更节省空间。

以下开启一段摘抄：

关于位域结构体有以下几点说明：(以下“位段就是位域”，c.f. [ref1][1])

1. 位段的类型只能是int，unsigned int，signed int三种类型，不能是char型或者浮点型；
2. 位段占的二进制位数不能超过该基本类型所能表示的最大位数，比如在VC中int是占4个字节，那么最多只能是32位；
3. 无名位段不能被访问，但是会占据空间；
4. 不能对位段进行取地址操作；
5. 若位段占的二进制位数为0，则这个位段必须是无名位段，下一个位段从下一个位段存储单元(这里的位段存储单元经测试在VC环境下是4个字节)开始存放；
6. 若位段出现在表达式中，则会自动进行整型升级，自动转换为int型或者unsigned int。
7. 对位段赋值时，最好不要超过位段所能表示的最大范围，否则可能会造成意想不到的结果。
8. 位段不能出现数组的形式。

对于位段结构，编译器会自动进行存储空间的优化，主要有这几条原则:

1. 如果一个位段存储单元能够存储得下位段结构中的所有成员，那么位段结构中的所有成员只能放在一个位段存储单元中，不能放在两个位段存储单元中；如果一个位段存储单元不能容纳下位段结构中的所有成员，那么从剩余的位段从下一个位段存储单元开始存放。(在VC中位段存储单元的大小是4字节).
2. 如果一个位段结构中只有一个占有0位的无名位段，则只占1或0字节的空间(C语言中是占0字节，而C++中占1字节)；否则其他任何情况下，一个位段结构所占的空间至少是一个位段存储单元的大小；

```c++
#include <iostream>

using namespace std;

// sizeof(A): 4
struct A {
  uint32_t a: 4;
  uint32_t b: 3;
  uint32_t c: 1;
};

// sizeof(B): 12
struct B {
  uint32_t a;
  uint32_t b;
  uint32_t c;
};

// sizeof(C): 8
struct C {
  uint32_t a: 1;
  uint32_t : 0;
  uint32_t c: 2;  // 不会和a凑在一起，新开一个字节存
};

// sizeof(D): 12
struct D {
  uint32_t a: 1;
  uint32_t: 0;    // 隔断
  uint32_t: 6;    // 开启新的位域存储单元
  uint32_t d: 32; // 前一个位域不够放，开启新的存放单元
};

// sizeof(E): 4
// 内存分布简图
// 0000 0000 0000 0000
// a--- b--- cd-------
struct E {
  uint32_t a: 1;
  char b;        // 隔断
  uint32_t c: 1; // 在下一个存储单元
  uint32_t d: 15; // 四个成员刚好占用32bits，即4个字节
};

template <typename T>
void Print(const T&)
{
  std::cout << sizeof(T) << std::endl;
}

// test
int main()
{
  A a;
  B b;
  C c;
  D d;
  E e;
  Print(a); // 4
  Print(b); // 12
  Print(c); // 8
  Print(d); // 12
  Print(e); // 4
  return 0;
}
```

以下测试用法：
```c++
#include <iostream>
#include <cstdio>

using namespace std;

// sizeof: 4
struct TcpMsgHead {
  uint32_t length: 16;
  uint32_t flags: 8;
  int      num: 8;
};

void Print(const TcpMsgHead& msg)
{
  printf("length: %8d\n", msg.length);
  printf("flags:  %8d\n", msg.flags);
  printf("num:    %8d\n", msg.num);
}

// test
int main()
{
  TcpMsgHead head;
  head.length = 0xffff; // 2^16 - 1 = 65535
  head.flags = 0xff;    // 2^8 - 1 = 255
  head.num = 0xff;
  Print(head);
  return 0;
}
```
上述程序的输出为：
```
length:    65535
flags:       255
num:          -1
```
解释一下为什么num成员的值为-1：
首先num设置的比特位为8，而num的类型为int，是有符号的。对于有符号的整数，计算机内部使用补码表示的。
0xff 换成二进制
1111 1111
这正好是-1的补码。

其实，Ycm给出的提示已经很明确了：
![tr1](tr1.png)
Ycm提示这里发生了隐式截断。255被截断成了-1. 如果换成 0x11 也就是二进制的 0001 0001, 则不会发生截断，因为8比特足够描述0x11，符号位是0，表示正数，所以这很符合我们的预期。但是如果再加一个2呢？
![tr2](tr2.png)
可以看到Ycm提示发生截断，
529被截断成了17, 即
0010 0001 0001 被截断成了 0001 0001
也就是说，我结构体定义的时候已经确定了num只有8比特位可以存。高于8比特的数据全都截断。如果最高位是1，则会被转成负数，这可能和你的预期不符。所以一定不要设置超过容量的数据。

## Reference

1. [浅谈C语言中的位段][1]

[1]: https://www.cnblogs.com/dolphin0520/archive/2011/10/14/2212590.html
