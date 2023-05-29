---
title: "C++ 中的默认参数简介"
date: 2022-09-14T13:23:39+08:00
keywords: []
categories: [tech]
tags: [cpp, default-argument, 默认参数]
draft: false
mathjax: false

---

## Minimal example

```cpp
int foo(int x, int y=1) { return x + y; }

int main()
{
    cout << foo(5);  // call foo(5, 1)
    return 0;
}
```

## 分离编译带来的隐患

如果函数声明和定义分离，此时就有一个 pitfall。由于默认参数可以定义在函数声明（declaration）中，也可以定义在函数定义（definition）中。

###  Default argument in function **definition**

```cpp
// foo.h
int foo(int x, int y);

// foo.cpp
#include "foo.h"
int foo(int x, int y=1) { return x + y; }

// main.cpp
#include <iostream>
#include "foo.h"

int main()
{
    std::cout << foo(3);  // error
}
```

如果改写 main.cpp:
```cpp
#include <iostream>
int foo(int x, int y=2);

int main()
{
    std::cout << foo(3);
}
```
使用命令行编译
```
g++ foo.cpp main.cpp
```
运行之，猜一下结果？4 or 5？（答案 5）

很违背直觉是吗？这就是默认参数所带的一系列副作用。所以，在实际工程中，除非特别简单的情况，否则不建议使用默认参数。

我目前没看过底层原理，只作个简单猜想。这其实是函数定义的不一致，但由于这两个文件是分离编译的，编译器无法处理两个文件中不一致的声明，因为编译器是一个文件一个文件处理的。处理一个丢一个。所以，上述代码可以通过编译，并能成功链接（foo.cpp 中提供了 foo 的定义，main.cpp 中提供了 foo 的前置声明，二者函数原型是一样的，因此也能链接上）。但最后输出的结果，在调用 foo(5) 是，编译器查找默认参数的时候，优先使用了本文件（main.cpp）函数声明中定义的默认参数，而非其他文件（foo.cpp）中函数定义中定义的默认参数。

如果继续改写 main.cpp
```cpp
#include <iostream>
int foo(int x, char y=2);

int main()
{
    std::cout << foo(3);
}
```
你会发现此时链接器就报错了，说找不到 int foo(int, char) 的定义。
```bash
$ g++ foo.cpp main.cpp
/usr/bin/ld: /tmp/ccdz0bAH.o: in function `main':
main.cpp:(.text+0xf): undefined reference to `foo(int, char)'
collect2: 错误：ld 返回 1
```
这也印证了，上一个例子确实是函数声明中对默认参数的定义不一致，但编译器无法察觉。

### Default arguments in function **declaration**

```cpp
// foo.h
int foo(int x, int y=1);

// foo.cpp
#include "foo.h"
int foo(int x, int y) { return x + y; }

// main.cpp
#include <iostream>
#include "foo.h"

int main()
{
    std::cout << foo(3);  // ok, call foo(3, 1)
}
```

此时在 main.cpp 中可以省略默认参数，因为编译 main.cpp 的时候，先将 foo.h 插入（预处理），此时当走到 foo(3) 的时候，编译器能拿到默认参数的定义，所以可以成功调用。

如果改写 foo.cpp：
```cpp
#incldue "foo.h"
int foo(int x, int y=2) { return x + y; }
```
此时使用 g++ 可以编译成功，运行结果为 4（使用的 foo.h 中函数声明中定义的默认参数）。

但使用 clang 时，无法通过编译，会报一个 redefinition of default argument 的错误：
```bash
$ clang++ main.cpp foo.cpp
foo.cpp:3:20: error: redefinition of default argument
int foo(int x, int y=2)
                   ^ ~
./foo.h:4:20: note: previous definition is here
int foo(int x, int y=1);
                   ^ ~
1 error generated.
```
需要说明的是，这是合理的结果，clang 的做法无疑是更科学的。

https://godbolt.org/z/Wfcz7dsrE

## 与虚函数结合带来的隐患

```cpp
struct Cat {
    virtual void speak(const char *s = "meow")
        { printf("%s.\n", s); }
};
struct Tiger : public Cat {
    void speak(const char *s = "roar") override
        { printf("%s!!\n", s); }
};

Cat c;       c.speak();  // "meow."
Tiger t;     t.speak();  // "roar!!"
Cat *p = &t; p->speak(); // "meow!!"
```

可以看到，当用基类指针调虚函数时，默认参数使用的是基类中提供的那个，是不是又违反直觉了？因为默认参数是编译时确定的，而动态绑定是运行时确定的。在编译完成时，默认参数已经根据静态类型（因为是基类指针，所以是基类类型）进行了填充，运行时发生动态绑定调用派生类的方法这没问题，但是参数传的是基类默认参数。

更多 pitfall 参见 ref1，其中提到了默认参数的种种罪恶，并奉劝大家不要使用默认参数！

## References

1. https://quuxplusone.github.io/blog/2020/04/18/default-function-arguments-are-the-devil/
2. https://www.geeksforgeeks.org/default-arguments-and-virtual-function-in-cpp/
