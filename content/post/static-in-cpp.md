---
title: "C++ 中的 static 关键字"
date: 2022-04-21T23:52:04+08:00
lastmod: 2022-04-21T23:52:04+08:00
keywords: []
categories: [Notes]
tags: [cpp,]
draft: false
mathjax: false

---

## Static members

```c++
class A {
public:
    // non-static member (i.e., `data` is not visible in `fun1`
    static fun1();
    fun2();
private:
    int data;
    static int sata;
};

A a;
a.fun1();   // valid, equivalent to the following
A::fun1();
```
1. 静态成员不能访问非静态成员（因为静态成员独立与类的实例（即对象）而存在，为了在没有对象被创建的情况下，静态成员还是可以使用，所以不能访问非静态成员。）
2. 同理，类的任何对象不包含静态数据成员
3. 静态成员不与对象，不与`this`指针发生交互，作为结果，静态成员函数不能声明为`const`
4. 可以通过类的对象调用静态成员函数，但此调用跟对象的状态并无关系，也就是说换个对象来调用是等价的，都等价于使用类名加域作用符来调用
3. 静态成员一般定义在类的外部，因为每个对象都共享静态成员，避免多次定义
4. View static member as a normal function that has nothing to do with the class, except you must use `::` to access static members

<!--more-->

test for *emphsize 中文*, 再来一次..强调中文..

<iframe allow="autoplay *; encrypted-media *; fullscreen *" frameborder="0" height="175" style="width:100%;max-width:660px;overflow:hidden;background:transparent;" sandbox="allow-forms allow-popups allow-same-origin allow-scripts allow-storage-access-by-user-activation allow-top-navigation-by-user-activation" src="https://embed.music.apple.com/us/album/come-alive/1323997788?i=1323998083&theme=light"></iframe>


## Static local variables

Function parameters, as well as variables defined inside the function body, are called **local variables**.

Much like a person’s lifetime is defined to be the time between their birth and death, an object’s **lifetime** is defined to be the time between its creation and destruction. Note that variable creation and destruction happen when the program is running (called runtime), not at compile time. Therefore, lifetime is a runtime property.

A variable’s **storage duration** (usually just called **duration**) determines what rules govern when and how a variable will be created and destroyed. In most cases, a variable’s storage duration directly determines its lifetime.

Local variables have **automatic duration**, which means they are created at the point of definition and destroyed at the end of the block they are defined in. For example:
```cpp
int main()
{
    int i { 5 }; // i created and initialized here
    double d { 4.0 }; // d created and initialized here

    return 0;
} // i and d are destroyed here
```
For this reason, local variables are sometimes called **automatic variables**.

Global variables are created when the program starts, and destroyed when it ends. This is called **static duration**. Variables with static duration are sometimes called **static variables**.

In C++, variables can also be declared outside of a function. Such variables are called **global variables**.
Unlike local variables, which are uninitialized by default, static variables are zero-initialized by default.

> *Scope* determines where a variable is accessible. *Duration* determines where a variable is created and destroyed. *Linkage* determines whether the variable can be exported to another file or not.

Here comes the word: <u>using the `static` keyword on a local variable changes its duration from automatic duration to static duration</u>. This means the variable is now created at the start of the program, and destroyed at the end of the program (just like a global variable). As a result, the static variable will retain its value even after it goes out of scope!

Automatic duration (default):
```cpp
#include <iostream>

void incrementAndPrint()
{
    int value{ 1 }; // automatic duration by default
    ++value;
    std::cout << value << '\n';
} // value is destroyed here

int main()
{
    incrementAndPrint();
    incrementAndPrint();
    incrementAndPrint();

    return 0;
}

/**
 * Outputs:
 * 2
 * 2
 * 2
 */
```
Each time incrementAndPrint() is called, a variable named value is created and assigned the value of 1. incrementAndPrint() increments value to 2, and then prints the value of 2. When incrementAndPrint() is finished running, the variable goes out of scope and is destroyed.

Static duration (using static keyword):
```cpp {linenos=table,hl_lines=[8,"15-17"],linenostart=199}
#include <iostream>

void incrementAndPrint()
{
    static int s_value{ 1 }; // static duration via static keyword.  This initializer is only executed once.
    ++s_value;
    std::cout << s_value << '\n';
} // s_value is not destroyed here, but becomes inaccessible because it goes out of scope

int main()
{
    incrementAndPrint();
    incrementAndPrint();
    incrementAndPrint();

    return 0;
}

/**
 * Outputs:
 * 2
 * 3
 * 4
 */
```
Static local variables that are zero initialized or have a constexpr initializer can be initialized at program start. Static local variables with non-constexpr initializers are initialized the first time the variable definition is encountered (the definition is skipped on subsequent calls, so no reinitialization happens). Because `s_value` has constexpr initializer `1`, `s_value` will be initialized at program start.

When `s_value` goes out of scope at the end of the function, it is not destroyed. Each time the function incrementAndPrint() is called, the value of `s_value` remains at whatever we left it at previously.

Generating a unique ID number is very easy to do with a static duration local variable:
```cpp
int generateID()
{
    static int s_itemID{ 0 };
    return s_itemID++; // makes copy of s_itemID, increments the real s_itemID, then returns the value in the copy
}
```
The first time this function is called, it returns 0. The second time, it returns 1. Each time it is called, it returns a number one higher than the previous time it was called. You can assign these numbers as unique IDs for your objects. Because `s_itemID` is a local variable, it can not be “tampered with” by other functions.

Static variables offer some of the benefit of global variables (they don’t get destroyed until the end of the program) while limiting their visibility to block scope. This makes them safer for use even if you change their values regularly.

> Best practice: Initialize your static local variables. Static local variables are only initialized the first time the code is executed, not on subsequent calls.

Q: What effect does using keyword `static` have on a global variable? What effect does it have on a local variable?

A: When applied to a global variable, the static keyword defines the global variable as having internal linkage, meaning the variable cannot be exported to other files.

When applied to a local variable, the static keyword defines the local variable as having static duration, meaning the variable will only be created once, and will not be destroyed until the end of the program.


## Static global variables

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
Thus, when applied to a local variable, the static keyword defines the local variable as having static duration, meaning the variable will only be created once, and will not be destroyed until the end of the program.

To be continued...


## References

1. [6.10 — Static local variables][1]

[1]: https://www.learncpp.com/cpp-tutorial/static-local-variables/