---
title: "A point of python metaclass"
date: 2021-12-12T12:55:45+08:00
lastmod: 2021-12-12T12:55:45+08:00
keywords: [metaclass]
categories: [Notes]
tags: [python]
mathjax: false

---

## Create `class` dynamically

Python doc says:
> By default, classes are constructed using `type()`. The class body is executed in a new namespace and the class name is bound locally to the result of `type(name, bases, namespace)`.

That's means, a `class` statement is equivalent to the call of `type` method with three arguments:

- name: name of the class
- bases: tuple of the parent class (for inheritance, can be empty)
- attrs: dictionary containing attributes names and values.

For example, the following classes are identical:
```py
class A(object):
    def __init__(self):
        self.a = 1

tmp = type('A', (object,), {'a': 1})
A = tmp
```
as verified by the picture below：
![meta-demo1](demo1.png "a, b两个对象结构一致")

The [`type` function][2] is special:

> With one argument, return the type of an object. The return value is a type object and generally the same object as returned by `object.__class__`.
>
> With three arguments, return a new type object. This is essentially a dynamic form of the `class` statement. The name string is the class name and becomes the `__name__` attribute. The bases tuple contains the base classes and becomes the `__bases__` attribute; if empty, `object`, the ultimate base of all classes, is added. The dict dictionary contains attribute and method definitions for the class body; it may be copied or wrapped before becoming the `__dict__` attribute.

In other words, `type` is the factory method creating python classes.


## The class creation process

The class creation process can be customized by passing the `metaclass` keyword argument in the class definition line, or by inheriting from an existing class that included such an argument. In the following example, both `MyClass` and `MySubclass` are instances of `Meta`:
```py
class Meta(type):
    pass

class MyClass(metaclass=Meta):
    pass

class MySubclass(MyClass):
    pass
```
Any other keyword arguments that are specified in the class definition are passed through to all metaclass operations described below.

When a class definition is executed, the following steps occur:

- MRO entries are resolved;
- the appropriate metaclass is determined;
- the class namespace is prepared;
- the class body is executed;
- the class object is created.


Here comes our leading role: metaclass, **the following is captured from [what are metaclasses in python][3]**:

Metaclasses are the 'stuff' that creates classes.

You define classes in order to create objects, right?

But we learned that Python classes are objects.

Well, metaclasses are what create these objects. They are the classes' classes, you can picture them this way:
```py
MyClass = MetaClass()
my_object = MyClass()
```
You've seen that type lets you do something like this:
```py
MyClass = type('MyClass', (), {})
```
It's because the function `type` is in fact a metaclass. `type` is the metaclass Python uses to create all classes behind the scenes.

Everything, and I mean everything, is an object in Python. That includes integers, strings, functions and classes. All of them are objects. And all of them have been created from a class:

```py
>>> age = 35
>>> age.__class__
<type 'int'>
>>> name = 'bob'
>>> name.__class__
<type 'str'>
>>> def foo(): pass
>>> foo.__class__
<type 'function'>
>>> class Bar(object): pass
>>> b = Bar()
>>> b.__class__
<class '__main__.Bar'>
```
Now, what is the `__class__` of any `__class__` ?
```py
>>> age.__class__.__class__
<type 'type'>
>>> name.__class__.__class__
<type 'type'>
>>> foo.__class__.__class__
<type 'type'>
>>> b.__class__.__class__
<type 'type'>
```
So, a metaclass is just the stuff that creates class objects.

You can call it a 'class factory' if you wish.

`type` is the built-in metaclass Python uses, but of course, you can create your own metaclass.


## Use metaclass

First we see an example:
```python
class MyMeta(type):
    # __new__ is the method called before __init__
    # it's the method that creates the object and returns it
    # while __init__ just initializes the object passed as parameter
    # you rarely use __new__, except when you want to control how the object
    # is created.
    # here the created object is the class, and we want to customize it
    # so we override __new__
    # you can do some stuff in __init__ too if you wish
    # some advanced use involves overriding __call__ as well.
    def __new__(cls, cls_name:str, bases:tuple, attrs:dict, **kwargs):
        new_attrs = {}
        for k, v in attrs.items():
            if not k.startswith('__'):
                key = k.upper()
                print('modify attr: %s -> %s' % (k, key))
                new_attrs[key] = v
            else:
                new_attrs[k] = v
        return type.__new__(cls, cls_name, bases, new_attrs)

    def __call__(self, *args, **kwds) -> Any:
        new_args = [x * x for x in args]
        return super().__call__(*new_args, **kwds)


class D(object, metaclass=MyMeta, foo=1, bar=2):
    aaa = 1
    bbb = 2
    def __init__(self, a, b) -> None:
        self.a = a
        self.b = b


if __name__ == '__main__':
    d = D(3, 4)
    print(d)
```
we see the memory when hit the following breakpoint,
![demo2](demo2.png)

From the picture we see:

1. the class name 'D' is passed as parameter `cls_name` of `MyMeta.__new__`,
1. the class variables of `D` is passed as parameter `attrs` of `MyMeta.__new__`,
2. the keyword arguments of `D` -- `foo` and `bar` are passed as keyword arguments of `MyMeta.__new__`.

The next breakpoint:
![demo3](demo3.png)
gives

1. the `self` variable passed to `MyMeta.__call__` is just the class `D`,
2. the `D(3, 4)` pass 3, 4 to parameter `args` of `MyMeta.__call__`.

The last breakpoint gives the memory of instance `d`,
![demo4](demo4.png)

1. the class `D` has class attributes 'AAA' and 'BBB', which are converted to uppercase in `MyMeta.__new__`,
2. the instance `d` has instance attributes 'a=9' and 'b=16', which are processed in `MyMeta.__call__`,
3. console outputs the log of uppercase conversion.

Last word: i highly recommend you to read the document of [`obj.__new__`][5] and [`obj.__init__`][6], and to be continued...


## References

1. [What are metaclasses in python][3]
2. [Python documents][1]
3. [Class customizations][4]


[1]: https://docs.python.org/3/reference/datamodel.html#metaclasses
[2]: https://docs.python.org/3/library/functions.html#type
[3]: https://stackoverflow.com/questions/100003/what-are-metaclasses-in-python
[4]: https://docs.python.org/3.9/reference/datamodel.html#special-method-names
[5]: https://docs.python.org/3.9/reference/datamodel.html#object.__new__
[6]: https://docs.python.org/3.9/reference/datamodel.html#object.__init__
