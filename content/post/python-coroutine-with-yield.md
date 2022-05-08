---
title: "使用 Yield 实现 Python 协程"
date: 2022-03-20T20:44:58+08:00
keywords: []
categories: [tech]
tags: [python, coroutine]
draft: false
mathjax: false

---

考虑如下代码：
```python {hL_lines=23}
def async_call(it, ret_list=None):
    try:
        value = ret_list[0] if ret_list and len(ret_list) == 1 else ret_list
        arg_list = it.send(value)
    except StopIteration:
        return

    if type(arg_list) in (list, tuple):
        imp_func, args = arg_list[0], list(arg_list[1:])
    else:
        imp_func, args = arg_list, []

    callback = lambda *cb_args: async_call(it, cb_args)
    imp_func(*args, callback=callback)

def make_async(func):
    def _wrapper(*args, **kwargs):
        async_call(func(*args, **kwargs))
    return _wrapper

def fd(_idx, callback):
    print("fd(%s, %s)" % (_idx, callback))
    # return 'EOF'
    callback('fd:%s' % _idx)

@make_async
def fb(_idx, callback):
    print("fb(%s, %s)" % (_idx, callback))
    ret = yield fd, _idx
    callback('fb:%s' % ret)

def fc(_idx, callback):
    print("fc(%s, %s)" % (_idx, callback))
    callback('fc:%s' % _idx)

@make_async
def fa(*args, **kwargs):
    print("fa(%s, %s)" % (args, kwargs))
    for idx in range(2):
        if idx % 2 == 0:
            f = fb
        else:
            f = fc
        ret = yield f, idx
        print("%sth iteration: ret in fa is %s" % (idx, ret))

if __name__ == '__main__':
    fa()
```
以上代码的运行结果为：
```
fa((), {})
fb(0, <function async_call.<locals>.<lambda> at 0x7fb2070263b0>)
fd(0, <function async_call.<locals>.<lambda> at 0x7fb207026440>)
0th iteration: ret in fa is fb:fd:0
fc(1, <function async_call.<locals>.<lambda> at 0x7fb2070264d0>)
1th iteration: ret in fa is fc:1
```
试着分析上述输出：

1. `fa`本来是个generator，在decorator的作用下（decorator首先调用了`it.send(None)`）被激活，`fa.print`句输出
2. `fa`执行到yield，此时`f=fb`，于是程序跳转到`fb`，但`fb`也是个generator，没关系，同样在decorator的作用下被激活，于是`fb.print`句输出
3. `fb`执行到yield，程序跳转到`fd`(普通函数)，于是`fd.print`句输出
4. `fd`执行到callback，这个callback是啥呢，暂且相信它是`lambda *cb_args: async_call(it_of_fb, cb_args)`，所以`callback('fd:0')`展开为`async_call(it_of_fb, 'fd:0')`，然后`async_call`执行到`it_of_fb.send('fd:0')`，这就驱使generator `fb`从yield处（紧随其后）开始继续执行；然后控制流来到了`fb`中的`callback('fb:fd:0')`，这个callback是谁呢？暂且相信它是`lambda *cb_args: async_call(it_of_fa, cb_args)`，所以展开为`async_call(it_of_fa, 'fb:fd:0')`，这就驱使generator `fa`从yield处resume，`fa.print`句输出
5. `fa`再入循环，此时`idx=1, f=fc`，执行到yield，控制流跳转到`fc`(一个普通函数)，很好，于是`fc.print`句输出
6. `fc`执行到callback，很好，想必大家都知道这个callback是`lambda *cb_args: async_call(it_if_fa, cb_args)`，展开为`async_call(it_of_fa, 'fc:1')`，这就驱使generator `fa`从yield处resume，并接收到`ret='fc:1'`，`fa.print`句输出
7. 接着开始退栈，首先generator `fa`迭代结束，抛出异常被`async_call`捕获并结束；然后别忘了我们从何而来，我们从`fc.callback`而来，callback执行结束，`fc`退栈；而我们从哪里执行到`fc`的呢，我们从`fb`中的callback通过generator的控制流乱窜到`fc`，现在他执行完了，也就是说`fb.callback`执行完了，`fb`抛出异常被`async_call`捕获并结束；我们从哪里来到`fb.callback`呢，从`fd.callback`，于是`fd`结束，退栈。

可以看到，退栈顺序并不是按照进入顺序的逆序而来的。这是因为控制流在`yield`和`generator.send`之间反复横跳的缘故。

如果将23行（fd中return句）注释去掉，则运行结果为：
```
fa((), {})
fb(0, <function async_call.<locals>.<lambda> at 0x7fd1750b5ea0>)
fd(0, <function async_call.<locals>.<lambda> at 0x7fd1750b6050>)
```

试着分析一下：

1. 同上
2. 同上
3. 同上
4. 控制流来到`fd`，但这时，`fd`不走callback，而是直接return了。而我们是从哪里进到`fd`的呢，是从`fb`中的yield句，其实执行yield，会将控制流返回到`async_call`中的`it.send(value)`句（紧随其后），然后走到`async_call`的最后一句，开始执行`fd`，然后`fd`结束，然后`async_call`结束，然后上一层`async_call`结束，..., 接着整个程序结束。`fa`yield之后的代码根本不会执行到。因为底下人不配合它（不调用callback，进而引起上层函数调不到callback，进而引起generator无法驱动），程序看起来就像夭折了一样。

读者试着思考一下，是否能够模拟程序执行流程？（上面暂时看不懂没关系，看完下文，再回头看应该会更好理解一些。）

为了搞清楚这段代码的执行流程，我们必须先搞清楚一些概念。

## Generator简介

在python中，generator的通俗理解是：一个函数如果含有[yield语句][3]，则称这个函数是一个generator function，对该函数的调用生成一个generator.

Generator `it`生成之后，不会立刻执行，除非对其迭代（使用`next(it)`，`for`循环遍历等）。并且生成器每次执行到yield语句都会挂起，并将yield之后的表达式返回给调用者，直到再次迭代，会从yield语句之后继续执行。

更多概念参考: https://docs.python.org/3/glossary.html#term-generator


## Generator.send

Generator有一个重要的方法：`generator.send(value)`. 它可以恢复generator的执行并且给generator function内部发送一个value. 具体参见[相关文档][5]，注意`send`和`next`的区别。

下面给出一个例子：
```python
>>> def a():
...     i = 0
...     while i < 3:
...             x = yield i
...             i += 1
...             print("after yield: x=%s, i=%s" % (x, i))
... 
>>> it = a()
>>> it.send(None)
0
>>> it.send(11)
after yield: x=11, i=1
1
>>> it.send(22)
after yield: x=22, i=2
2
>>> it.send(33)
after yield: x=33, i=3
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
StopIteration
>>> 
```
官方描述`it.send(None)`等价于`next(it)`。且看上述代码，
```
第一次send(None)为激活generator，此时generator执行到yield，并将i(=0)返回
第二次send(11)，恢复generator的执行，并将11发送给generator function，赋值给x，于是打印出x=11, i=1
第三次send(22)，恢复generator的执行，并将22发送给generator function, 赋值给x，于是打印出x=22, i=2
第四次send(33)，恢复generator的执行，并将22发送给generator function, 赋值给x，于是打印出x=33, i=3，
但由于此时generator已经不会再产生新值，亦即正常退出，于是send函数抛出StopIteration异常
```
注意上述代码最后一次执行`it.send(33)`，可以看到，`print`函数成功打印出结果，此时`i=3`，不再进入循环，“函数正常”退出。但那仅仅是针对常规函数，对于generator，如果不再产生新值，会抛出一个`StopIteration`的异常。

[PEP 342][2]提到: The `send()` method returns the next value yielded by the generator, or raises `StopIteration` if the generator exits without yielding another value.

Generator及其send方法是我们读懂文首代码的两个基本点，其中所有控制流跳变的地方都有他俩的身影。猛击[此处](yield_chain.py)获取源文件。


## 利用generator和send实现的协程

to be continued...


## References

1. [Python doc: yield expressions][4]
2. [廖雪峰-协程][1]
3. [PEP 342 – Coroutines via Enhanced Generators][2]

[^a]: footnote1, are we choose a something

[1]: https://www.liaoxuefeng.com/wiki/1016959663602400/1017968846697824
[2]: https://peps.python.org/pep-0342/#specification-summary
[3]: https://docs.python.org/3/reference/simple_stmts.html#the-yield-statement
[4]: https://docs.python.org/3/reference/expressions.html#yield-expressions
[5]: https://docs.python.org/3/reference/expressions.html#generator.send