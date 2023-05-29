---
title: "Python Iterables"
date: 2021-02-21T22:26:30+08:00
lastmod: 2021-02-21T22:26:30+08:00
keywords: []
categories: [notes]
tags: [python]
draft: false
mathjax: false

---


Python 的迭代器（iterator）、生成器（generator）、可迭代对象（iterable），虽是老生常谈，但我毕竟要记录一下自己的见解，因有此篇。

## Iterable 和 Iterator

为了理解 generator，必须先搞清楚 iterable 和 iterator[^a]。

> - An **iterable** object is an object that implements `__iter__`, which is expected to return an iterator object.
> - An **iterator** is an object that implements `__next__`, which is expected to return the next element of the iterable object that returned it, and raise a StopIteration exception when no more elements are available.

讲真，iterable 和 iterator 的定义就是这么的朴实无华。但要彻底理解，还需费些功夫。先来看个例子：

```python
class MyIterator(object):
    def __init__(self, data):
        self.data = data
        self.cur = 0

    def __next__(self):
        if self.cur < len(self.data):
            self.cur += 1
            return self.data[self.cur - 1]
        else:
            raise StopIteration


class MyIterable(object):
    data = [4,3,2,1]
    def __iter__(self):
        return MyIterator(self.data)

my_iterable = MyIterable()
for x in my_iterable:
    print(x)

>>> 4
>>> 3
>>> 2
>>> 1
```

上面实现了一个 iterable 和 iterator，iterable 必须实现`__iter__`方法，并返回一个 iterator，在上面的例子中我返回了自己实现的一个 iterator。当然也可以这样写：


```python
class MyIterable(object):
    data = [4,3,2,1]
    cur = 0
    def __iter__(self):
        return self

    def __next__(self):
        if self.cur < len(self.data):
            self.cur += 1
            return self.data[self.cur - 1]
        else:
            raise StopIteration

my_iterable = MyIterable()
for x in my_iterable:
    print(x)

>>> 4
>>> 3
>>> 2
>>> 1
```

此时`MyIterable`既是 iterable 又是 iterator。那既然能够写在一起，为什么聪明的人们要把这两个概念区分开呢？以下[^b]给出了部分解释：

> Iterators and iterables can be separate objects, but they don’t have to. Nothing is holding us back here. If you want, you can create a single object that is both an iterator and an iterable. You just need to implement both `__iter__` and `__next__`.
>
> So why did the wise men and women building the language decide to split these concepts? It has to do with keeping state. An iterator needs to maintain information on the position, e.g. the pointer into an internal data object like a list. In other words: it must keep track of which element to return next.
>
> If the iterable itself maintains that state, you can only use it in one loop at a time. Otherwise, the other loop(s) would interfere with the state of the first loop. By returning a new iterator object, with its own state, we don’t have this problem. This comes in handy especially when you’re working with concurrency.


## For 循环

Python 中的`for x in y`要求`y`为 iterable，具体地，以下两段代码效果相同：

```python
for x in y:
    print(x)

# <==>

it = iter(y)
try:
    a = next(it)
    print(a)
except StopIteration:
    break
```

以上遗漏一点：

> Python expects iterable objects in several different contexts, the most important being the for statement. In the statement `for X in Y`, `Y` must be an iterator or some object for which iter() can create an iterator. These two statements are equivalent:
> ```python
> for i in iter(obj):
>     print(i)
> 
> for i in obj:
>     print(i)
> ```

Note that you can only go forward in an iterator; there’s no way to get the previous element, reset the iterator, or make a copy of it. Iterator objects can optionally provide these additional capabilities, but the iterator protocol only specifies the `__next__()` method. Functions may therefore consume all of the iterator’s output, and if you need to do something different with the same stream, you’ll have to create a new iterator.

## Generator Expressions and List Comprehensions

生成器表达式和列表推导式是 Python 中常用的两个语法。列表推导式生成一个列表，生成表达式生成一个 iterator。看下面的例子：
```python
def test2():
    lst = [1, -2, 3, -4]
    ge = (abs(x) for x in lst)
    lc = [abs(x) for x in lst]
    print(ge, type(ge))
    print(lc, type(lc))
    print(next(ge), iter(ge))
    print(ge.__next__(), ge.__iter__())
    for x in ge:
        print(x)
    for x in ge:
        print(x)

>>> <generator object test2.<locals>.<genexpr> at 0x7f5221c61f90> <class 'generator'>
>>> [1, 2, 3, 4] <class 'list'>
>>> 1 <generator object test2.<locals>.<genexpr> at 0x7f5221c61f90>
>>> 2 <generator object test2.<locals>.<genexpr> at 0x7f5221c61f90>
>>> 3
>>> 4
```
可以看到，列表推导式直接生成一个列表，而生成表达式则是返回一个 iterator，并且它也是一个 iterable。值得注意的是：

- 列表推导式使用`[]`包围
- 生成表达式使用`()`包围
- generator 是 iterator
- iterator 只能遍历一次，当元素耗尽，再次遍历直接抛出 StopIteration

> 可将 iterator 理解为只能遍历一次的 iterable。

特别地，以下代码等价：
```python
( expression for expr in sequence1 if condition1
             for expr2 in sequence2 if condition2
             ...
             for exprN in sequenceN if conditionN )

# <==>
for expr1 in sequence1:
    if not (condition1):
        continue   # Skip this element
    for expr2 in sequence2:
        if not (condition2):
            continue   # Skip this element
        ...
        for exprN in sequenceN:
            if not (conditionN):
                continue   # Skip this element
            # Output the value of the expression.
```

## Generator Function

pass, to be continued...

[^a]: [Iterator][1]
[^b]: [Python iterator basics (how they work + examples)][2]

[1]: https://wiki.python.org/moin/Iterator
[2]: https://python.land/deep-dives/python-iterator
