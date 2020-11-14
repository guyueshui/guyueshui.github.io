---
title: SICP Learning Notes
date: 2019-02-21 14:50:23
categories:
tags:
---

当我们考察一门语言时，主要看三点

1. primitives：元操作是什么
2. means of combinations：如何组合
3. means of abstraction：如何抽象，构造更复杂的程序

数据和过程之间没有本质的区别

在写完构造器（constrcutor）之后，记得写上选择器（selector）。

```
+---------+       rule          +--------+
| pattern +-------------------->+skeleton|
+----+----+                     +----+---+
     |                               |
     |                               |
     |match                          |instantiation
     |                               |
     v                               v
+----+-----+                    +----+-----+
|expression|                    |expression|
|  source  +------------------->+  target  |
+----------+                    +----------+
```

pattern match

foo -- matches exactly foo
(f a b) -- matches a list, whose first element is f, etc.
(? x) -- matches anything, call it x
(?c x) -- matches a constant, call it x
(?v x) -- matches a variable, call it x

skeletons

foo -- instantiates to itself
(f a b) -- instantiates to a 3-list, results of instatiating each of f, a, b
(: x) -- instatantiates to the value of x in the pattern matched


任何一个复杂的大程序都是由简单的小部分组成。纵然递归模式非常复杂，最重要的事情就是：**不去思考它**。如果取思考它的实际行为，大家就会迷惑。

Convince yourself something is right.

好的编程或设计方法就是你知道什么不用去思考！

Wishful thinking is crucial!

Lisp没有循环，靠递归的procedure实现迭代，这并不表示procedure展开的process也是递归的。区分递归和迭代的核心是是否需要辅助空间跟踪程序运行的状态。

**Case analysis is more powerful than you thought!** Trust me.
