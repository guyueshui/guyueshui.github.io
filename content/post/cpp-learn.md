---
title: "C++ 学习笔记"
date: 2019-08-28
lastmod: 2022-03-16
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

literal `5.0`类型为`double`，`5.0f`类型为`float`。不加`f`后缀默认`double`.

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

cf. https://en.cppreference.com/w/cpp/language/destructor

## 常量

### Literal constants

字面值常量
Cf. https://www.learncpp.com/cpp-tutorial/literals/


### Symbolic constants

符号常量
Cf. https://www.learncpp.com/cpp-tutorial/const-constexpr-and-symbolic-constants/

1. Const variables must be initialized
2. Function parameters for arguments passed by value should not be made const.
3. Don’t use const with return by value.

**Runtime vs compile-time constants**

Runtime constants are constants whose initialization values can only be resolved at runtime (when your program is running). The following are examples of runtime constants:
```cpp
#include <iostream>

void printInt(const int x) // x is a runtime constant because the value isn't known until the program is run
{
    std::cout << x;
}

int main()
{
    std::cout << "Enter your age: ";
    int age{};
    std::cin >> age;

    const int usersAge { age }; // usersAge is a runtime constant because the value isn't known until the program is run

    std::cout << "Your age is: ";
    printInt(age);

    return 0;
}
```

Compile-time constants are constants whose initialization values can be determined at compile-time (when your program is compiling). The following are examples of compile-time constants:
```cpp
const double gravity { 9.8 }; // the compiler knows at compile-time that gravity will have value 9.8
const int something { 1 + 2 }; // the compiler can resolve this at compiler time
```
Compile-time constants enable the compiler to perform optimizations that aren’t available with runtime constants. For example, whenever gravity is used, the compiler can simply substitute the identifier gravity with the literal double 9.8.

To help provide more specificity, C++11 introduced the keyword `constexpr`, which ensures that a constant must be a compile-time constant.

> Any variable that should not be modifiable after initialization and whose initializer is known at compile-time should be declared as `constexpr`.
> 
> Any variable that should not be modifiable after initialization and whose initializer is not known at compile-time should be declared as `const`.

Note that literals are also implicitly constexpr, as the value of a literal is known at compile-time.

A **constant expression** is an expression that can be evaluated at compile-time. For example:
```cpp
#include <iostream>
int main()
{
	std::cout << 3 + 4; // 3 + 4 evaluated at compile-time
	return 0;
}
```
In the above program, because the literal values 3 and 4 are known at compile-time, the compiler can evaluate the expression 3 + 4 at compile-time and substitute in the resulting value 7. That makes the code faster because 3 + 4 no longer has to be calculated at runtime.

Constexpr variables can also be used in constant expressions:
```cpp
#include <iostream>
int main()
{
	constexpr int x { 3 };
	constexpr int y { 4 };
	std::cout << x + y; // x + y evaluated at compile-time
	return 0;
}
```
In the above example, because x and y are constexpr, the expression x + y is a constant expression that can be evaluated at compile-time. Similar to the literal case, the compiler can substitute in the value 7.

### Object-like preprocessor macros v.s. symbolic constants

Object-like macro has the form:
```cpp
#define identifier substitution_text
```
Whenever the preprocessor encounters this directive, any further occurrence of *identifier* is replaced by *substitution_text*. The identifier is traditionally typed in all capital letters, using underscores to represent spaces.

> Avoid using #define to create symbolic constants macros. Use const or constexpr variables instead.

Macros can have naming conflicts with normal code. For example:
```cpp
#include "someheader.h"
#include <iostream>

int main()
{
    int beta { 5 };
    std::cout << beta;

    return 0;
}
```
If someheader.h happened to #define a macro named beta, this simple program would break, as the preprocessor would replace the int variable beta’s name with whatever the macro’s value was. This is normally avoided by using all caps for macro names, but it can still happen.

### Using symbolic constants throughout a multi-file program

Cf. https://www.learncpp.com/cpp-tutorial/sharing-global-constants-across-multiple-files-using-inline-variables/

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

### 对齐

Cf. https://www.learncpp.com/cpp-tutorial/object-sizes-and-the-sizeof-operator/#comment-563585

Cf. http://www.catb.org/esr/structure-packing/


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


## 预编译

Cf. https://www.learncpp.com/cpp-tutorial/introduction-to-the-preprocessor/

### `#include`

When you #include a file, the preprocessor replaces the #include directive with the contents of the included file. The included contents are then preprocessed (along with the rest of the file), and then compiled.

### Macro defines

The #define directive can be used to create a macro. In C++, a macro is a rule that defines how input text is converted into replacement output text.

There are two basic types of macros: *object-like macros*, and *function-like macros*.
Object-like macros can be defined in one of two ways:

```cpp
#define identifier
#define identifier substitution_text
```

### Object-like macros don’t affect other preprocessor directives

结论：宏展开在预编译指令(Preprocessor directives)无效。

```cpp
#define PRINT_JOE
#ifdef PRINT_JOE    // 此处会否将'PRINT_JOE'替换为空呢？
// ...
```
Macros only cause text substitution for normal code. Other preprocessor commands are ignored. Consequently, the PRINT_JOE in #ifdef PRINT_JOE is left alone.

For example:
```cpp
#define FOO 9 // Here's a macro substitution

#ifdef FOO // This FOO does not get replaced because it’s part of another preprocessor directive
    std::cout << FOO; // This FOO gets replaced with 9 because it's part of the normal code
#endif
```
In actuality, the output of the preprocessor contains no directives at all -- they are all resolved/stripped out before compilation, because the compiler wouldn’t know what to do with them.

### The scope of defines

Once the preprocessor has finished, all defined identifiers from that file are discarded. **This means that directives are only valid from the point of definition to the end of the file in which they are defined**. Directives defined in one code file do not have impact on other code files in the same project.

宏定义仅在本文件有效，一旦预编译阶段结束，所有宏都将失效。因为，预编译就是将所有的预编译指令都处理掉，该替换的替换（宏展开），该选择的选择，该丢弃的丢弃（条件编译），然后交给编译器去编译，谨记：编译器是读不懂预编译指令的！

Consider the following example:

function.cpp:
```cpp
#include <iostream>

void doSomething()
{
#ifdef PRINT
    std::cout << "Printing!";
#endif
#ifndef PRINT
    std::cout << "Not printing!";
#endif
}
```
main.cpp:
```cpp
void doSomething(); // forward declaration for function doSomething()

#define PRINT

int main()
{
    doSomething();
    return 0;
}
```
The above program will print:

```
Not printing!
```
Even though PRINT was defined in main.cpp, that doesn’t have any impact on any of the code in function.cpp (PRINT is only #defined from the point of definition to the end of main.cpp). This will be of consequence when we discuss header guards in a future lesson.


## Header files

Cf. https://www.learncpp.com/cpp-tutorial/header-files/

对于多文件项目，文件是单独编译的。要想调用一个自定义函数，linker必须能找到这个函数在哪里定义。

```cpp
int add(int, int);  // forward declaration

int main()
{
    // add(3, 5);
    return 0;
}
```
上述文件是可以编译通过的，因为没有发生对`add`的调用，所以linker不会去找`add`的定义（当然如果要找也找不到）。

但是如果某处发起了对`add`的调用（例如去掉注释），那么上述程序在link阶段会报错：
```shell
yychi@~> clang test_linker.cpp
/usr/bin/ld: /tmp/test_linker-e1bb8b.o: in function `main':
test_linker.cpp:(.text+0x1a): undefined reference to `add(int, int)'
clang-13: error: linker command failed with exit code 1 (use -v to see invocation)
```

在多文件编程时，往往需要forawrd declaration，这些前置声明必须在其他某个地方被定义且只被定义一次。这样，linker才能正确的完成链接。任何重复定义或未定义都会在link阶段报错。

考虑如下例子：

add.cpp:
```cpp
int add(int x, int y)
{
    return x + y;
}
```

main.cpp:
```cpp
#include <stdio.h>

int add(int, int);

int main()
{
    int x = 1, y = 2;
    int z = add(x, y);
    printf("z=%d\n", z);
    return 0;
}
```
在编译main.cpp的时候，因为有`add`的前置声明，所以可以通过。但为了link的时候能够找到`add`的定义，add.cpp必须也被编译，所以正确的编译方式应该是：
```shell
$ clang main.cpp add.cpp
```

### Use of header files

从上面的论述我们隐约可见，在多文件编程中，我们可能会大量的使用前置声明（forward declaration），一旦文件多起来，这将非常枯燥。所以头文件的出现就是为了解决这个问题：把所有的声明放在一起。

Let’s write a header file to relieve us of this burden. Writing a header file is surprisingly easy, as header files only consist of two parts:

1. A header guard.
2. The actual content of the header file, which should be the forward declarations for all of the identifiers we want other files to be able to see.

add.h:
```cpp
// 1) We really should have a header guard here, but will omit it for simplicity (we'll cover header guards in the next lesson)

// 2) This is the content of the .h file, which is where the declarations go
int add(int x, int y); // function prototype for add.h -- don't forget the semicolon!
```

main.cpp:
```cpp
#include "add.h" // Insert contents of add.h at this point.  Note use of double quotes here.
#include <iostream>

int main()
{
    std::cout << "The sum of 3 and 4 is " << add(3, 4) << '\n';
    return 0;
}
```

add.cpp:
```cpp
#include "add.h" // Insert contents of add.h at this point.  Note use of double quotes here.

int add(int x, int y)
{
    return x + y;
}
```
When the preprocessor processes the `#include "add.h"` line, it copies the contents of *add.h* into the current file at that point. Because our *add.h* contains a forward declaration for function *add*, that forward declaration will be copied into *main.cpp*. The end result is a program that is functionally the same as the one where we manually added the forward declaration at the top of *main.cpp*.

Consequently, our program will compile and link correctly.
![](https://www.learncpp.com/images/CppTutorial/Section1/IncludeHeader.png?ezimgfmt=rs:647x377/rscb2/ng:webp/ngcb2)

### Two wrong cases

![header has function definition](wrong_header.png)

如上图所示，会产生一个重复定义的错误。由于add.h中包含了函数定义，而非前置声明。编译main.cpp的时候，add.h中的代码插入到main.cpp中，产生一次`add`函数的定义。同理，编译add.cpp的时候也定义了一次`add`函数。link阶段会发生歧义，以致报错。

此时如果不编译add.cpp其实是可行的：
![compile main.cpp only](header2.png)

但谁又能保证只有一个文件`#include "add.h"`呢？所以头文件中应该只包含声明，而不应该包含实现。

> The primary purpose of a header file is to propagate declarations to code files.

Key insight: Header files allow us to put declarations in one location and then import them wherever we need them. This can save a lot of typing in multi-file programs.

Header files should generally not contain function and variable definitions, so as not to violate the one definition rule. An exception is made for symbolic constants (which we cover in lesson [4.15 -- Symbolic constants: const and constexpr variables](https://www.learncpp.com/cpp-tutorial/const-constexpr-and-symbolic-constants/)).

**标准库自动链接**

> 注意：clang不会自动链接，需要手动链接
> `clang main.cpp -lstdc++`

When it comes to functions and variables, it’s worth keeping in mind that header files typically only contain function and variable declarations, not function and variable definitions (otherwise a violation of the one definition rule could result). std::cout is forward declared in the iostream header, but defined as part of the C++ standard library, which is automatically linked into your program during the linker phase.

![cout](cout.png)


**The #include order of header files**

Cf. https://www.learncpp.com/cpp-tutorial/header-files/  for "the #inclue order of header files".

## A view of memory and fundamental data types in cpp

Cf. https://www.learncpp.com/cpp-tutorial/introduction-to-fundamental-data-types/

The smallest unit of memory is a binary digit (also called a bit), which can hold a value of 0 or 1. You can think of a bit as being like a traditional light switch -- either the light is off (0), or it is on (1). There is no in-between. If you were to look at a random segment of memory, all you would see is …011010100101010… or some combination thereof.

Memory is organized into sequential units called memory addresses (or addresses for short). Similar to how a street address can be used to find a given house on a street, the memory address allows us to find and access the contents of memory at a particular location.

Perhaps surprisingly, in modern computer architectures, each bit does not get its own unique memory address. This is because the number of memory addresses are limited, and the need to access data bit-by-bit is rare. Instead, each memory address holds 1 byte of data. A byte is a group of bits that are operated on as a unit. The modern standard is that a byte is comprised of 8 sequential bits.

**Data types**

Because all data on a computer is just a sequence of bits, we use a data type (often called a “type” for short) to tell the compiler how to interpret the contents of memory in some meaningful way. You have already seen one example of a data type: the integer. When we declare a variable as an integer, we are telling the compiler “the piece of memory that this variable uses is going to be interpreted as an integer value”.

When you give an object a value, the compiler and CPU take care of encoding your value into the appropriate sequence of bits for that data type, which are then stored in memory (**remember: memory can only store bits**). For example, if you assign an integer object the value 65, that value is converted to the sequence of bits 0100 0001 and stored in the memory assigned to the object.

Conversely, when the object is evaluated to produce a value, that sequence of bits is reconstituted back into the original value. Meaning that 0100 0001 is converted back into the value 65.

Fortunately, the compiler and CPU do all the hard work here, so you generally don’t need to worry about how values get converted into bit sequences and back.

All you need to do is pick a data type for your object that best matches your desired use.

谨记：内存只能存bit，只能寻址寻到byte这一层，如果数据按内存边界对齐，寻址会更快（一次读）。

由于内存地址空间有限，且按bit寻址的场景很少，所以寻址单位一般是byte。A byte is a group of bits that are operated on as a unit. The modern standard is that a byte is comprised of 8 sequential bits.

### 移位

```cpp
#include <cstdint>
#include <iostream>
using namespace std;

static void print(int32_t a, uint32_t b, size_t n_shift)
{
    cout << "a=" << a << "; b=" << b << endl;

    cout << "left shift " << n_shift << " bit(s) of a is: " << (a << n_shift) << endl;
    cout << "left shift " << n_shift << " bit(s) of b is: " << (b << n_shift) << endl;
    cout << "right shift " << n_shift << " bit(s) of a is: " << (a >> n_shift) << endl;
    cout << "right shift " << n_shift << " bit(s) of b is: " << (b >> n_shift) << endl;
}

int main()
{
    int32_t a = 0xffffffff;
    uint32_t b = 0xffffffff;
    print(a, b, 1);
    cout << "------------\n";
    print(0xbfffffff, b, 1);
    return 0;
}

/**
 * Output on my machine:

a=-1; b=4294967295
left shift 1 bit(s) of a is: -2
left shift 1 bit(s) of b is: 4294967294
right shift 1 bit(s) of a is: -1
right shift 1 bit(s) of b is: 2147483647
------------
a=-1073741825; b=4294967295
left shift 1 bit(s) of a is: 2147483646
left shift 1 bit(s) of b is: 4294967294
right shift 1 bit(s) of a is: -536870913
right shift 1 bit(s) of b is: 2147483647

 */
```
从内存连续bit来看，a和b都是存了4 byte的1，区别仅仅是data type不一样，导致了截然不同的结果。

**移位操作**

1. 右移
   1. 无符号右移，低位丢失高位补0
   2. 有符号右移，低位丢失，高位补符号位（正为0, 负为1）
2. 左移：高位丢失，低位补0

a和b左移一位都得到：
```
0xfffffffe: 如果是int解释为-2, unsigned int解释为4294967294=2^32 - 2
```
a右移一位得到
```
0xffffffff: 注意负数右移，高位补1，int解释为-1
```
b右移一位得到
```
0x7fffffff: 高位补0, unsigned int解释为2147483647=2^31-1
```
注意，负的可能左移成正的，因此，有符号的移位是不安全的。

```cpp
#include <iostream>

int main()
{
    signed int s { -1 };
    unsigned int u { 1 };

    if (s < u) // -1 is implicitly converted to 4294967295, and 4294967295 < 1 is false
        std::cout << "-1 is less than 1\n";
    else
        std::cout << "1 is less than -1\n"; // this statement executes

    return 0;
}
```

NOTE:

1. 注意无符号数相减得负数会导致溢出
2. usigned和`--`运算符，可能减至负数溢出
3. 除非确定变量值非负，否则尽量避免使用unsigned
4. 切忌不要在数学计算中混用unsigned和signed，此时signed会隐式转换为unsigned
5. unsigned numbers are preferred when dealing with bit manipulation
6. `std::int8_t`和`std::uint8_t`可能知识`char`和`unsigned char`的别名，可能有坑（参考：https://www.learncpp.com/cpp-tutorial/introduction-to-type-conversion-and-static_cast/）

**Best practice**

Favor signed numbers over unsigned numbers for holding quantities (even quantities that should be non-negative) and mathematical operations. Avoid mixing signed and unsigned numbers.

### 字节序

```cpp
/**
 * This file test the endian of your machine:
 * big-endian or little-endian, by visiting
 * the memory sequentially byte by byte of
 * a intendly constructed integer.
 */

#include <cstdint>
#include <stdio.h>
#include <iostream>

using namespace std;

static void print(void* ptr, size_t size)
{
    // convert to char* so we can visit the memory byte by byte
    unsigned char* _ptr = static_cast<unsigned char*>(ptr);
    // print the value of each byte in ptr
    for (size_t i = 0; i < size; ++i)
        cout << static_cast<int>(_ptr[i]);
    cout << endl;
}

int main()
{
    uint32_t a = 0x01020304;
    /*
     * if it prints 4321, indicates 低位在前，对应little-endian
     * it it prints 1234, indicates 高位在前，对应big-endian
     */
    print(&a, 4);
    return 0;
}

/**
 * Output on my machine
4321
 */
```
字节序就是计算机存储数据的时候将低位数据存在低位地址还是高位地址。举个例子，数值0x2211使用两个字节储存：高位字节是0x22，低位字节是0x11。

- 大端字节序：高位字节在前，低位字节在后，这是人类读写数值的方法。
- 小端字节序：低位字节在前，高位字节在后，即以0x1122形式储存。

如果太多记不住，至少要记住：

1. 字节序的概念: 读一段内存从低位向高位读（从左往右），先读到高位字节还是低位字节
2. 符合人类读写数值的方法是大端序（big-endian）

既然如此，我们要判断一台机器是big-endian还是little-endian，只需要构造一端内存，按字节从低位地址向高位地址访问，看看低位地址存的是高位字节，还是低位字节即可。

且看上述代码，构造了一个整数0x01020304，然后通过将首地址转成`char*`的方式去按字节读取内存中的值（这样做的目的是，`char*`可以逐字节的读取内存；而`int*`一次指针移动会移动`sizeof(int)`个字节）。读出来如果是符合书写习惯的1234, 则表明机器是big-endian, 反之little-endian.

这也是一段内存的两种不同的解释方式，recall that **Because all data on a computer is just a sequence of bits, we use a data type (often called a “type” for short) to tell the compiler how to interpret the contents of memory in some meaningful way**.

## 链接（Linkage）

Cf. https://www.learncpp.com/cpp-tutorial/internal-linkage/

Identifiers have another property named `linkage`. An identifier’s **linkage** determines whether other declarations of that name refer to the same object or not.

Local variables have `no linkage`, which means that each declaration refers to a unique object.

Global variable and functions identifiers can have either `internal linkage` or `external linkage`.

An identifier with **internal linkage** can be seen and used within a single file, but it is not accessible from other files (that is, it is not exposed to the linker). This means that if two files have identically named identifiers with internal linkage, those identifiers will be treated as independent.

To make a non-constant global variable internal, we use the static keyword.
```cpp
static int g_x; // non-constant globals have external linkage by default, but can be given internal linkage via the static keyword

const int g_y { 1 }; // const globals have internal linkage by default
constexpr int g_z { 2 }; // constexpr globals have internal linkage by default

int main()
{
    return 0;
}
```

To see it, we take

a.cpp:
```cpp
int g_x = 22;
const int g_y = 33;
constexpr int g_z = 44;
```

main.cpp:
```cpp
#include <stdio.h>

int g_x = 222;
const int g_y = 333;
constexpr int g_z = 444;

int main()
{
    printf("glabal variable (g_x, g_y, g_z) is (%d, %d, %d)", g_x, g_y, g_z);
    return 0;
}
```

if we compile only main.cpp, it works fine and outputs:
```
glabal variable (g_x, g_y, g_z) is (222, 333, 444)
```

But if we compile both, it gets
```bash
$ clang main.cpp a.cpp
/usr/bin/ld: /tmp/a-ea4f54.o:(.data+0x0): multiple definition of `g_x'; /tmp/main-c44eb4.o:(.data+0x0): first defined here
clang-13: error: linker command failed with exit code 1 (use -v to see invocation)
```

As we sligtly modify main.cpp:
```cpp
#include <stdio.h>

extern int g_x;
const int g_y = 333;
constexpr int g_z = 444;

int main()
{
    printf("glabal variable (g_x, g_y, g_z) is (%d, %d, %d)", g_x, g_y, g_z);
    return 0;
}
```
it's compiled and linked properly with the output:
```
glabal variable (g_x, g_y, g_z) is (22, 333, 444)
```
noting that the `g_x` has the value 22 which is defined in a.cpp, we find out the global non-const variable has external linkage. And the properly compilation and linking show that global const has internal linkage.

## References

1. [理解字节序][2]

[1]: https://en.cppreference.com/w/cpp/language/function_template
[2]: https://www.ruanyifeng.com/blog/2016/11/byte-order.html
