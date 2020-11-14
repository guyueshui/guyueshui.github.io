---
title: "C++ 学习笔记"
date: Wed Aug 28 2019
lastmod: 2019-08-28T22:52:32+08:00
keywords: []
categories: [Notes]
tags: [cpp]
mathjax: false

---

诚如是，Life is too short to learn c++. 此篇记录一些我在学习cpp过程中遇到的一些知识点，仅作记录并梳理之效。里面可能会有大量参考其他网络博客，如有侵权，请联系我删除之。

## Reactor v.s. Proactor

- epll/wait: reactor模式，不停轮询，发现有事做，就做！
- asio: proactor模式，先注册好事件，如果事情发生了，通过回调函数处理。

## 几个常用的宏

- `__func__`: name of an function, exists in C99/C++11 (`__FUNCTION__` is non standard)
- `__LINE__`: line number of the code
- `__FILE__`: filename of the file
- `__DATE__` and `__TIME__`: as you wish

## 不要在ctor里调用虚函数

总结来说：基类部分在派生类部分之前被构造，当基类构造函数执行时派生类中的数据成员还没被初始化。如果基类构造函数中的虚函数调用被解析成调用派生类的虚函数，而派生类的虚函数中又访问到未初始化的派生类数据，将导致程序出现一些未定义行为和bug。

ctor应该设计的尽量简单，确保对象可以被正确构造。在ctor中调用本类的非静态成员都是不安全的，因为他们还没被构造，而有些成员是依赖对象的，而此时对象还没有被成功构造。

## ctor不能是虚函数

1. 从存储空间角度：虚函数对应一个vtable（虚函数表），这大家都知道，可是这个vtable其实是存储在对象的内存空间的。问题出来了，如果构造函数是虚的，就需要通过 vtable来调用，可是对象还没有实例化，也就是内存空间还没有，无法找到vtable，所以构造函数不能是虚函数。

2. 从使用角度：虚函数主要用于在信息不全的情况下，能使重载的函数得到对应的调用。构造函数本身就是要初始化实例，那使用虚函数也没有实际意义呀。所以构造函数没有必要是虚函数。
虚函数的作用在于通过父类的指针或者引用来调用它的时候能够变成调用子类的那个成员函数。而构造函数是在创建对象时自动调用的，不可能通过父类的指针或者引用去调用，因此也就规定构造函数不能是虚函数。

3. 构造函数不需要是虚函数，也不允许是虚函数，因为创建一个对象时我们总是要明确指定对象的类型，尽管我们可能通过实验室的基类的指针或引用去访问它。但析构却不一定，我们往往通过基类的指针来销毁对象。这时候如果析构函数不是虚函数，就不能正确识别对象类型从而不能正确调用析构函数。

—————————————————— 
版权声明：本文为CSDN博主「cainiao000001」的原创文章，遵循CC 4.0 by-sa版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/cainiao000001/article/details/81603782

## 虚函数的工作原理

https://zhuanlan.zhihu.com/p/60543586

C++ 规定了虚函数的行为，但将实现方法留给了编译器的作者。不需要知道实现方法也可以很好的使用虚函数，但了解虚函数的工作原理有助于更好地理解概念。

通常，编译器处理虚函数的方法是：给每个对象添加一个隐藏成员。隐藏成员中保存了一个指向函数地址数组的指针。

这种数组称为虚函数表（Virtual Function Table, vtbl）。

虚函数表是一个数组，数组的元素是指针，指针指的是虚函数的地址。

具有虚函数的类的实例，都会在头部存一个指向虚函数表的指针。

## 常见类型所占空间大小

| TYPE             | Bytes |
| ---------------- | ----: |
| (unsigned) int   |     4 |
| (unsigned) short |     2 |
| (unsigned) long  |     8 |
| float            |     4 |
| double           |     8 |
| long double      |    16 |
| (unsigned) char  |     1 |
| bool             |     1 |

指针占几个字节 指针即为地址，指针几个字节跟语言无关，而是跟系统的寻址能力有关，譬如以前是16为地址，指针即为2个字节，现在一般是32位系统，所以是4个字节，以后64位，则就为8个字节。

## 静态成员的初始化

当一个类包含静态成员时，最好的做法是在类中声明，在类外初始化。由于静态成员是所有对象共享的，如果在类内初始化，则每个对象构造时，都要执行一遍静态成员的初始化，这无疑是一种浪费。

```cpp
struct A
{
  static int a;
  int b;
  void fun();
  ...
};

int A::a = 233;

class B
{
public:
  void fun();
  ...
private:
  static string str_;
  bool done_;
};

string B::str_ = "hello, i am static";
```

## 析构函数的调用时机

The destructor is called whenever an object's lifetime ends, which includes

- program termination, for objects with static storage duration
- thread exit, for objects with thread-local storage duration
- end of scope, for objects with automatic storage duration and for temporaries whose life was extended by binding to reference
- delete-expressin, for objects with dynamic storage duration
- end of the full expression, for nameless temporaries
- stack unwinding (栈回溯), for objects with automatic storage duration when an exception escapes their block, uncaught.

c.f. https://en.cppreference.com/w/cpp/language/destructor

## 内存布局

### 结构体

C++规范在“结构”上使用了和C相同的，简单的内存布局原则：成员变量按其被声明的顺序排列，按具体实现所规定的对齐原则在内存地址上对齐。

```cpp
struct S {
    char a;     // memory location #1
    int b : 5;  // memory location #2
    int c : 11, // memory location #2 (continued)
    char  : 0,
    int d : 8;  // memory location #3
    struct {
        int ee : 8; // memory location #4
    } e;
} obj; // The object 'obj' consists of 4 separate memory locations
```

- 类的静态成员不占用类的空间，静态成员在程序数据段中。

## 模板

### 重载与特化
从编译到函数模板的调用，编译器必须在非模板重载、模板重载和模板重载的特化间决定。

```cpp
template< class T > void f(T);              // #1 ：模板重载
template< class T > void f(T*);             // #2 ：模板重载
void                     f(double);         // #3 ：非模板重载
template<>          void f(int);            // #4 ： #1 的特化

f('a');        // 调用 #1
f(new int(1)); // 调用 #2
f(1.0);        // 调用 #3
f(1);          // 调用 #4
```
注意只有非模板和初等模板重载参与重载决议。特化不是重载，且不受考虑。只有在重载决议选择最佳匹配初等函数模板后，才检验其特化以查看何为最佳匹配。

```cpp
template< class T > void f(T);    // #1 ：所有类型的重载
template<>          void f(int*); // #2 ：为指向 int 的指针特化 #1
template< class T > void f(T*);   // #3 ：所有指针类型的重载

f(new int(1)); // 调用 #3 ，即使通过 #1 的特化会是完美匹配
```
即重载的优先级要高于特化。

关于模板函数重载的更多内容，参考[function_template][1]。

## References

[1]: https://en.cppreference.com/w/cpp/language/function_template
