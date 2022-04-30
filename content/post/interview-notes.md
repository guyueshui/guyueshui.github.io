---
title: 面试经历及笔记
date: 2019-07-08 20:14:17
lastmod: 2019-10-14
categories: ['Notes']
tags: ['interview']
mathjax: true

---

总结一下这几个月的面试经历中被问到的问题，虽说问得都很浅，但是，问深了我也不会呀！

## C++相关

Q: `std::vector` push_back 的复杂度是多少？
A: O(1), amortized constant.

Q: vector从1到n push n个元素，假设发生扩容时按两倍增长，写出复杂度关于n的表达式？
A: 不会。

假设第一次只分配一个元素的空间。那么发生扩容的点依次如下：
$$
1,2,4,8,16,..., 2^{\lfloor{\log_2 n}\rfloor}
$$
每次扩容都会copy之前内存中的所有元素，所以总共发生的拷贝次数为:
$$
1+2+4+\cdots+2^{\lfloor{\log_2 n}\rfloor}
$$
注意这里共有$\lfloor \log_2 n \rfloor$项相加，于是有
$$
1+2+4+\cdots+2^{\lfloor{\log_2 n}\rfloor} = O(\lfloor \log_2 n \rfloor \cdot
2^{\lfloor{\log_2 n}\rfloor}) = O(n\log n)
$$
加上push_back操作的次数n，所以有
$$
T(n) = O(n\log n + n) = O(n \log n)
$$

Q: 对于一个vector容器，删除元素后迭代器会失效吗？
A: 对于删除给定元素前的迭代器不会失效，被删除元素之后的迭代器全部失效。

> 向容器添加元素后：
> 
> - 如果容器是vector或string，且存储空间重新分配，则指向容器的迭代器、指针和引用都会失效。如果存储空间未重新分配，指向插入位置之前的迭代器、指针和引用仍有效，但指向插入位置之后元素的迭代器、指针和引用将会失效。
> - 对于deque，插入到除首尾元素以外的任何位置都会导致迭代器、指针和引用失效。如果在首尾位置添加元素，迭代器会失效，但指向存在元素的指针和引用不会失效。
> - 对于list和forward_list，指向容器的迭代器（包括尾后迭代器和首前迭代）、指针和引用都有效。
> 
> 当我们从一个容器中删除元素后，指向被删除元素的迭代器、指针和引用会失效，这应该不会令人惊讶。毕竟，这些元素已经被销毁了。当我们删除一个元素后：
> 
> - 对于list和forward_list，指向容器其他位置的迭代器（包括尾后和首前）、引用和指针仍有效。
> - 对于deque，如果在首尾之外的任何位置删除元素指向被删除元素外其他元素的迭代器、引用和指针也会失效。如果是删除deque的尾元素，则尾后迭代器也会失效，但其他迭代器、引用和指针不受影响；如果是删除首元素，这些也不会受影响。
> - 对于vector和string，指向被删除元素之前的元素迭代器、引用和指针仍有效。注意：当我们删除元素时，尾后迭代器总是会失效。
> <div style="text-align:right">──《C++ Primer》</div>

关于迭代器失效的问题，另参阅：https://blog.csdn.net/lujiandong1/article/details/49872763

Q: 对于使用hash函数组织的unordered_map，对于给定的hash函数，假设我总能构造一个集合，使得该集合内所有元素的hash值相同，即该集合内所有的key都映射到一个桶内。这种问题该如何解决？
A: 不会。

可以使用两个hash函数，例如h1和h2，然后将同一个key的hash值用某种方式连接起来，以此定义一个新的复杂hash函数。对于这个函数，碰撞的概率将会非常小，因此可以认为你设计不出这样的集合，使得集合内的元素都发生碰撞。

Q: new/delete和malloc/free有什么区别？
A: new/delete在C++中是运算符，但malloc/free是继承自C的内存管理函数。malloc只负责开辟指定大小的内存，并不负责初始化，而new及开辟内存，也会构造对象，如果要为自定义的类型申请动态内存，则必须使用new，new一个类型会调用该类型的构造函数。而delete和free的区别也是类似，delete调用类的析构函数，然后在释放内存，free仅释放内存。

Q: 以下调用哪个函数？
```c++
class base {
public:
    virtual void fun(int a) { cout << a << endl; }
};

class derived : public base {
public:
    void fun(int b) { cout << "derived" << endl; }
};

base* pb = new derived();
pb->fun(3);
```
A: derived. 虚函数的动态绑定，根据运行时类型调用对应的版本，虽然是基类指针，但实际上是派生类对象，所以调用派生类中的函数。动态绑定是C++支持多态的根本原因。关于动态绑定，参见：[here](https://www.learncpp.com/cpp-tutorial/122-virtual-functions/). 

另外，定义虚函数会增加空间开销，一旦定义了虚函数，就会生成虚函数表和虚指针，动态绑定实际上是通过查表来确定具体调用哪个版本的函数。另外构造函数不能声明为虚函数，析构函数可以，但析构函数不能声明为纯虚函数。

Q: 重载（overload）和重写（override）有什么区别？
A: 重载指函数签名（函数原型）不同的两个函数名字相同，重写是指子类覆盖（重写）基类的方法，签名必须相同。注意，返回值不算函数签名，const算重载！

另外，还涉及到隐藏的概念。所谓隐藏，其实就是子作用域如果出现和父作用域相同的名字，那么父作用域的该名字在子作用域下被隐藏，不可见，因为被子作用域同名覆盖掉了。派生类的成员将隐藏基类同名成员。请看下例：
```c++
#include <iostream>

using namespace std;

class Base {
public:
    virtual void f(int x) { cout << "Base::f(int)" << endl; }
    void g(float x) { cout << "Base::g(float)" << endl; }
};

class Derived : public Base {
public:
    void f(float x) { cout << "Derived::f(float)" << endl; }
    void g(float x) { cout << "Derived::g(float)" << endl; }
    void g(int x) { cout << "Derived::g(int)" << endl; }
};

// test
int main()
{
    Derived dobj;
    Base* pd = &dobj;
    pd->f(3);       // Base::f(int)
    pd->g(3.3f);    // Base::g(float)
    dobj.f(3.3f);   // Derived::f(float)
    dobj.g(3.3f);   // Derived::g(float)
    dobj.g(3);      // Derived::g(int)
    return 0;
}
```
子类中g发生了重载。而基类指针调用f时，发现是虚函数，会去查表（发生动态绑定），但子类中并没有相应的重写（override），子类中的f仅仅是另一个函数，所以查表得知还是调用基类的f; 基类指针调用g时，发现不是虚函数，直接调用基类的g. 此间，子类的两个g对基类的g都是隐藏！

Q：memcpy 和 memmove 的区别
A：memcpy不能应对内存重叠，memmove可以。详见man pages.

Q：为什么要内存对齐？
A：不会。

我们关注内存对齐不外乎下面两大原因：

1. 平台原因(移植原因)：不是所有的硬件平台都能访问任意地址上的任意数据的；某些硬件平台只能在某些地址处取
某些特定类型的数据，否则抛出硬件异常。（平台移植是驱动程序开发者经常需要考虑的问题）。
2. 性能原因：数据结构(尤其是栈)应该尽可能地在自然边界上对齐。原因在于，为了访问未对齐的内存，处理器需要作两次内存访问；而对齐的内存访问仅需要一次访问。

> 可以使用预编译指令`pragma pack(n)`来指定对齐系数，n=1,2,4,8,16. 结构体对齐将按照最大成员大小和n中的较小值来对齐。

## 算法相关

Q: 从一个数组中删除一个元素，复杂度是多少？如果不关心索引和值的对应关系。
A: O(1), 将要删除的元素与最后一个元素互换，将数组的长度减一。

注意：这里他说不关心数组的索引和值的对应关系。连续存储就是数组，只不过先前通过索引i获得的值，并不一定和删除后通过索引i获得的值相同。我答的是O(n),因为要删除一个元素，还得将删除元素之后的元素前移一位，这样才是我理解的删除的语义。但是面试官说不关心索引与值的对应关系，那么假设数组长度为n，删除元素位置为i，在互换A[i]和A[n]之后，删除后数组的A[i]变成了原先的A[n], 但一般认为删除后A[i]应该是原先的A[i+1], 这就是他说的不关心索引和值的对应，和我所理解的不一样。

Q: 生成50个[0, 50)间的随机整数，构成一个序列，要求不能重复？
A: 用一个长度为50的数组用作map，初始化全为0. 然后使用随机数发生器生成[0, 50)之间的整数，并在map对应索引位置+1. 依次生成随机整数，且判断其索引对应的值是否为0，等于0说明还未生成过，等于1说明已经生成过，应该换一个。但是这样不能保证收敛，也许它永远生成不满50个随机整数。

其实有O(n)的解法，延承自上一问。设有一副扑克牌，共50张，你怎样将它随机地分给排成一列的50个人？很简单，每次随机抽出一张给一个人，抽完了，也就分完了。现在你有一个随机数发生器，每次随机生成一个索引，你抽出该索引位置的牌（从数组中删除该元素），这个操作等价与将该索引的元素与数组最后一个元素互换。下一次，从[0, 49)里随机生成一个索引，纵然该索引与之前的可能一样，但对应位置的牌已经换了，所以不会抽出重复的牌。如此反复，抽完为止。这样你每删除一个元素的复杂度是O(1), 所以总共的复杂度就是O(n).

## 机器学习相关

Q: K-均值聚类中k如何选取，评价指标，他很不稳定，如何让它稳定一些。

评价指标：类间相似度低，类内相似度高。K-means的稳定性较差，可能每次随机选取的初始聚类中心不一样，而导致聚类的效果不一样。从某种程度上来说，K-means对数据较为敏感，无法识别离群点。传统聚类采用的距离度量通常为欧式距离，Kernel k-means将所有样本映射到另外一个特征空间中再进行聚类，就有可能改善聚类效果。

一种改进：K-means++，它的思想是在已经选定n个聚类中心后，选取第n+1个聚类中心时：距离当前n个聚类中心越远的点会有更高的概率被选为第n+1个聚类中心。在选取第一个聚类中心时同样使用随机的方法，这个改单简单有效。

另外，一个很重要的问题，K的值如何选取？在低维度时，可以将数据画出来看大致有几个类，而在面对高维和复杂数据时，这种方法难以使用。关于K的选取：ISODATA，迭代自组织数据分析法，它的思想是：当属与某个类别的样本数量过少时就把该类别去除；当属与某个类别的样本数量过多时，分散程度较大时，将该类别分裂为两个子类。

Q: 正则化如何克服过拟合？背后的原理是什么？

正则化控制模型的复杂度。正则系数越大，模型拟合能力越差（偏差大，方差小），复杂度越低，一定程度上克服了过拟合。考虑正则系数从小变大，一开始偏差较小，方差较大。因为模型足够复杂，可以很好的学到数据特征，但也容易过拟合，对特定的数据集很敏感，也许换一个数据集就会是不一样的结果，此时已经发生了过拟合。随着正则系数不断变大，偏差也跟着增加，但方差会随之减小，因为正则项事实上限制了模型的拟合能力，降低了模型的复杂度。牺牲了偏差（变大），换取了方差（变小）。而在有限的训练数据集上，方差过大就意味着过拟合，意味着模型对数据集敏感。这不是我们想要的。整个过程的泛化误差先减小（方差减小）后增大（偏差增大），先是方差主导，后是偏差主导。最佳的正则系数应该对应着最小的泛化误差。详见PRML p.151

Q: 有没有接触过其他的网络模型，CNN，RNN等？

没有。

Q: vae是生成网络吗？可不可以和infogan结合？了解一下vae？

是。

## 纽劢

- random forest 需要对特征做什么处理吗？
- 常用的特征选择方法有哪些？
- 主成分分析做特征选择有哪些缺点？
- l1 regularization 也可以做特征选择？
- 特征有离散有连续该怎么处理？ one-hot encoding

## 小米

**一面**

Q: 了解LRU缓存吗？
A: 没听说过。

这里说的缓存是一种广义的概念，在计算机存储层次结构中，低一层的存储器都可以看做是高一层的缓存。比如Cache是内存的缓存，内存是硬盘的缓存，硬盘是网络的缓存等等。

缓存可以有效地解决存储器性能与容量的这对矛盾，但绝非看上去那么简单。如果缓存算法设计不当，非但不能提高访问速度，反而会使系统变得更慢。

从本质上来说，缓存之所以有效是因为程序和数据的局部性（locality）。程序会按固定的顺序执行，数据会存放在连续的内存空间并反复读写。这些特点使得我们可以缓存那些经常用到的数据，从而提高读写速度。

缓存的大小是固定的，它应该只保存最常被访问的那些数据。然而未来不可预知，我们只能从过去的访问序列做预测，于是就有了各种各样的缓存替换策略。本文介绍一种简单的缓存策略，称为最近最少使用（LRU，Least Recently Used）算法。

Q: https加密方式？
A: 不知道啊。

Q: 输入网址到浏览器展示的过程？
A: 不知道。

HTTP的工作流程大致如下：

1. 地址解析
2. 封装HTTP请求。将访问信息以及本机的一些信息封装成一个HTTP请求数据包
3. 封装TCP包。建立 TCP 连接 , 也就是常说的"三次握手" . 由于HTTP位于最上层的应用层 , 所以HTTP在工作之前要由 TCP 和 IP 协议建立网络连接。
4. 客户端发送请求命令。在连接建立之后 , 客户端发送 HTTP 请求到服务端与请求相关的信息都会包含在请求头和请求体中发送给服务器端 .
5. 服务端响应。服务器端在收到请求之后 , 根据客户端的请求发送给客户端相应的信息 , 相关的响应信息都会放在响应头和响应体中 .
6. 关闭连接。服务器端在发送完响应之后 , 就会关闭连接 , 如果过客户端的请求的头部信息中有 `Connection: keep-alive` , 那么客户端在响应完这个请求之后不会关闭连接 , 知道客户端的所有请求都响应完毕 , 才会关闭连接 , 这样大大节省了带宽和 IO 资源 .

**二面**

(Sept. 6)

- 自我介绍，实习工作内容
- 局部静态对象和全局静态对象有什么区别
- 进程间通信的方式
- 有哪些同步原语
- 堆内存和栈内存的区别
- `int a, *b;`有什么区别？（考察指针默认不开辟内存）

## 58同城

(Sept. 20)

- 挑一个你最熟的项目说下？
- Pooling是怎么回事，有什么用？
- 二叉树序列化，空指针序列化为null，e.g., [1,2,3,4,null,null,5]
- CNN和DNN的区别？
- 卷积有什么作用？

一面面完之后，建议我转后端，我说好啊，然后二面面的后端，似乎是个leader，主要就是问问实习经历，然后让我等HR面。下午三点到的58，二面面完三点四五十，然后等HR等了大概40分钟，好像是好多人排队等HR面，后来我找人问情况，说我五点有事，能不能安排一下，然后就有一个看着像技术的HR，承担了我的HR面。面完等结果，说是择优录用。

## 网易游戏

**一面**
(Spet. 20)

面完58已经四点五十了，想着怎么着也赶不上网易面试了。所以下了大楼，就找了个人不多的地方，掏出电脑，席地而坐，打开手机热点，打开面试地址（这里真要吐槽一下，我是Linux系统，这次面试它没发邮件，只以短信形式发了面试链接，我电脑上又没有微信QQ，只好手敲网址，那时候已经要开始了，可把我急坏了，还敲错了几次，把大写的I误认为小写的l），就开始面试起来。

- 自我介绍
- static关键字有何作用
- const_cast是干嘛的
- 说一下c++多态
- 一个类有一个指针成员，拷贝构造函数的调用会造成什么问题？（拷贝构造函数只做指针的拷贝，所以新的对象并不拥有资源，可能原对象的资源已经释放，这就导致了空悬指针，而且如果在析构函数中释放资源的话，可能会造成二次释放）
- 如何解决这种问题？（std::shared_ptr）
- std::shared_ptr实现原理，循环引用怎么解决？（RAII，std::weak_ptr）
- 编程：手写memcpy（注意overlap，从后往前拷贝）
- map和hash map的区别？
- 红黑树的特性？
- 了解图形学吗？（不）
- 基本的渲染流程知道吗（不）
- 一个游戏服务端，出现了大量的TIME_WAIT，可能是什么原因？（不知道）
- TIME_WAIT知道吗？为什么又TIME_WAIT？（TCP四次挥手）
- 编程：实现一个接口，从M个玩家中随机选取N个发放奖品（数组shuffle，我当时有点紧张，写的很乱）
- 设计题：如果一个游戏，很多玩家同时登陆，需要排队，我想展示给玩家前方排队人数以及预计等待时间，怎么实现？（妈呀，不会，但是还是得扯）
  - 队列？
  - 随机访问怎么办？
  - 实现随机访问的接口
  - 玩家中途退出怎么办？
  - 用链表，节点中存有前面等待的人数，时间可以简单相乘
  - 中间玩家退出，后续节点都要更新？
  - 跳表，链表之上加个索引调表，这样既能很快计算前方等待人数，又方便更新（问到这里，他就没再问了，说时间差不多了，就到这里，希望给个二面）

**二面**
(Oct. 17)

还是盼来了二面，然而很那个，怎么说呢，感觉不是很擅长。全程问我怎么设计游戏，不太会。

- 自我介绍
- 为什么投网易游戏？
- 平时喜欢玩游戏吗？玩的最多的是什么游戏？
- 你说喜欢玩安琪拉，如果让你设计一个安琪拉，你会怎么设计？（一边瞎写，一边瞎扯）
- 你会添加哪些成员函数，和成员变量？
- 你说到了装备，如果让你设计一个装备系统，你会怎么做？
- 我们知道角色HP受很多因素影响，比方说装备，受到攻击，增益buf等，那么你是如何更新角色HP的呢？（说到了观察者模式）
- 谁是观察者，谁是被观察者？
- 我们知道装备的属性大部分是静态的，对于静态属性的也要用观察者模式订阅吗？
- 你说到了观察者模式，平时项目中有用到过哪些设计模式？
- 你是如何学习设计模式的？
- 说说你对protobuf的理解？
- 我们知道proto文件，使用proto文件有什么好处？
- 大概知道protobuf的压缩原理吗？比方说如何编码int32.
- 现在有一个老版本的protobuf序列化之后的字符串，但是后来又新加了一个变量。具体来说，
  ```
  required int32 hp;
  optional int32 lv;
  ===saved===

  optional int32 mp;
  ===readed===
  ```
  我们知道，proto是支持这种添加之后，仍然能够正确反序列化旧版本的字符串。你知道protobuf是怎么做的吗？
- 实现一个带max()函数的栈？
- 使用辅助栈，需要额外O(n)的空间，如果没有这么多空间给你，假设只有O(logn)，如何优化？（没答出来）
- 说说你对boost::asio的理解？
- 说说你实习中遇到的多线程问题？
- 学过哪些计算机基础课？（没有）
- 压力最大的一件事？
- 目前手上有offer吗？
- 方便说下哪几家吗？
- 期望薪资大概多少？
- 我这边差不多了，你有什么要问我的吗？

看样子网易平均50分钟，面的感觉一般吧，51分，希望给个三面！

原来没有三面，今天（Oct. 22）已经收到意向书，感动！

在定位并处理应用程序出现的网络问题时，了解系统默认网络配置是非常必要的。ipv4网络协议的默认配置可以在/proc/sys/net/ipv4/下查看，其中与TCP协议栈相关的配置项均以tcp_xxx命名。可以使用cat查看，也可以使用sysctl批量查看。

```bash
$ cat /proc/sys/net/ipv4/tcp_tw_reuse
2

$ whatis sysctl
sysctl (2)           - read/write system parameters
sysctl (8)           - configure kernel parameters at runtime

$ sysctl net/ipv4
net.ipv4.cipso_cache_bucket_size = 10
net.ipv4.cipso_cache_enable = 1
net.ipv4.cipso_rbm_optfmt = 0
net.ipv4.conf.all.accept_local = 0
...
```

## 白山云科技

(Sept. 20)

面完网易之后，已经下午六点了，又赶去了白山的宣讲会，还好还没结束，那边研发还有几个人在面。等了一会之后，可能面试官们已经累了，直接leader面的我，并且本来应该有三轮技术面，一轮HR面。可能我去的太晚了，leader面过之后就算作二面通过，等了一会儿之后，直接HR面了。顺利拿到offer，秋招第一个offer，感谢！听说本来研发是几个人一起面，和面试官坐在一个圆桌上，面试官挨个问问题，好可怕。

## 百度

(Sept. 25)

畅谈50分钟，反手挂！是我太菜，打扰了（这里吐槽一下百度选的垃圾酒店，太偏僻了，太难找了）面试官全程盯着简历问。

- 自我介绍
- 实习工作
- 说一下异步和同步以及各自的优缺点？
- 数据库了解吗？（不）
- 在项目中做过索引吗？（没）
- B树B+树了解吗？（不，一问三不知，笑）
- 链表和数组的区别？
- linux查找包含特定内容的文件？
- 如果还想查找当前目录的子目录呢？
- 查找一个文件中特定内容出现的总行数？
- 说一下TCP三次握手？
- 手写代码：求一个二叉树的高度？（当时用的层次遍历到一个矩阵，然后输出行数，很笨的方法）
- 说一下KNN？
- 那k-means呢？（怪我光准备后台了，算法没复习，这两个搅浑了，恐怕是导致反手挂的直接原因）

后面就没再问了，估计那时候面试官已经给我挂了，然后象征性的问我有没有问题问他，我也象征性的问了几个，然后就没有然后了。

## 上海银行？

(Sept. 25)

我是去搞笑的，约的面试时间是下午三点，面完百度开始往那赶，赶到哪里的时候三点一刻，还怕来不及。结果去了等了两个多小时，还没排上我！听面完回来的同学说，5个面试官，同时面3个同学，算是群面？然后这样一组要面40-50分钟。三人一组的去，面完一组按编号叫下一组。虽然我是迟到了，排到了101号，但是两个小时后，才面到85号。也就是说，还有15人，三组，120分钟！三点去，要等的七点才能面上！算了，银行都这么高冷，（让我想起找实习的时候面招行，12个人分两组，一起搭积木，不，是按要求搭积木，还要能扯，把你搭好的积木吹上天，关于技术问题，一个都不问！）我惹不起，等到五点半就溜了。

## 依图

(Sept. 27)

- 自我介绍
- 看到我实习里面有用过protobuf，问了一下protobuf的优点
- TCP协议？（感觉问了很多网络）
- 如何查看系统负载？各CPU负载？
- 如果你写了一个模块，上线后用户反映其他模块的相应变慢了，你如何确定是不是你的原因？排查步骤如何？
- 手撕代码：最大子序列和（leetcode原题，之前看到了，但是没做出来，然后不了了之，于是现场可想而知，虽然最后在讨论下写出来了，但是很糟糕，写的很乱，然后很慢，据说依图看重写代码的速度orz）
- 由于写代码花了太长时间，直接结束

（果然，凉凉）

## 招银网络科技

**电面** 
(Sept. 28)

忘得差不多了。

- 自我介绍
- sizeof 和 strlen 区别
- 如果字符串不以空字符结尾，会引发什么错误？（我说undefined behavior，他说invalid address）
- const 成员意义
- 数据库了解吗？（不，银行数据库还是比较重要的，这方面很弱势orz）
- 如何用两个栈模拟一个队列（剑指offer原题）

(Oct. 13) 现场
**一面**

- 自我介绍
- 有哪些进程间通信的机制？
- 如何避免死锁？
- 平时如何解决内存泄漏？（智能指针，少用动态内存）
- 说说几种智能指针的原理？
- 说说socket编程的基本步骤？
- 说说常见的I/O模型
- 知道epoll吗？
- epoll的两种出发模式ET和LT了解吗？（不）
- 异步I/O有什么优点？（提高吞吐量）
- 数据库了解吗？（不）
- 说说数据库事务有什么特性？（不会）
- 手撕代码：合并两个有序链表

**二面**

二面面试官看起来想速战速决，自我介绍都掠过了？

- 挑一个项目跟我介绍一下？
- 你说到异步，为什么要用异步？
- 异步是如何实现的，底层原理了解吗？（大概说了一下，可能不对）
- 你说到protobuf，为什么要用protobuf？
- protobuf的底层IO模型是什么？（？？？还有这个）
- 为什么要进行序列化？
- protobuf如何反序列化的？为什么能够反序列化？（我说按照一定方式编码，自然能按照一定规则解码鸭）
- 有两个小朋友A、B给其他小朋友派发水果，A给出两个苹果，B就得给出一个梨。如何实现这段逻辑？（用两个队列，一个放苹果，一个放梨，一个pop两次，一个pop一次；或者设一个flag，当为0或1，则A发苹果，当为2，则B发梨，再置为0）
- 如果让你设计一个死锁，你会怎么做？

**HR面**

应该是去现场的都会面完三轮，不过结果如何就不知道了。问了HR，说两周内出结果，求个offer。

## 新东方

(Oct. 11)

- 自我介绍
- 进程和线程的区别
- 进程间通信机制
- 说一下内存池和线程池？
- TCP和UDP的区别？
- 说一下数据库的主键、外键、和索引（一顿瞎说，他说知道思想就行）
- （后面记不得了）

面试官意外的好说话，全程笑嘻嘻，我还迟到了10分钟。这次体验很好，可惜base北京。

## 中移（苏州）软件研发中心

(Oct. 14)

**一面**

- 自我介绍
- scoket编程的基本步骤
- 说一下TCP四层模型？
- telnet在哪一层？
- telnet和ssh有什么区别？
- TCP和UDP的区别？
- 说一下TCP的三握四挥？
- TIME_WAIT的含义，为什么会有TIME_WAIT？
- 能大概说说TCP的协议头吗？
- PSH标志有什么作用？
- TCP的滑动窗口是干嘛用的？
- 有什么方法可以查看socket状态？
- 你说对linux比较熟悉，比如一个磁盘快被占满了，如何得知是哪些文件占用了磁盘？（df -h, du -hd 1）
- 有一个实时更新的日志文件，如何查看该文件的动态更新？（这个不知道）
- 如何去掉一个文件中的空行？你能想到几种方法？
- 如何替换文件中的某个字符串？（sed）
- 排序算法有了解吗？
- 写个快排吧（紧张，没在规定时间内写出来，然后就说了下思路）
- 我们这边没什么问得了，你有什么想问的吗？

一面两个面试官轮流夹击，我一度十分惊慌。

**二面**

人格面试什么的最不擅长。

**三面**

等了很久，三面面试官似乎出去办事去了。以至于面试的时候，面试官似乎想快点结束。

- 自我介绍一下？
- 有哪些稳定的排序算法？（插入、冒泡、归并）
- 快排为什么不稳定？
- poll/epoll的区别是什么？
- 这些东西你是怎么学的，看书还是看博客？（看man pages，面试官眼睛就亮了）
- 手上有几个offer？
- 挺好，我觉得你很不错，基础很扎实（#手动滑稽）
- 很好，今天就面到这里，你回去等消息吧。

事实上我连自我介绍都没说完，就被打断了，然后也就问了几个问题，不到10分钟就结束了。希望给个offer吧！

## 米哈游

(Oct. 17)

- 自我介绍
- C++多态
- 动态绑定的原理
- 虚函数原理
- 虚函数表是一个对象一个还是一个类一个？（不会）
- 说一下C++四个智能指针以及各自用法？
- STL了解吗？
- map的底层实现使用的什么数据结构？
- 红黑树的插入、删除、查找的平均和最坏复杂度是多少？（O(logn)和O(n)）
- vector底层实现？
- vector push_back 和 pop_back 的复杂度
- 操作系统的大端序和小端序知道吗？
- 写一个程序判断某个机器是大端序还是小端序？（不会：https://www.cnblogs.com/yooyoo/p/4717709.html）
- 写一个程序判断某个机器是32位还是64位？（不会，32位指针占4字节，64位指针占8字节）
- 如果起了一个进程，该进程使用tcp连接绑定了一个端口，如何查看这个端口是多少？（netstat -tp）
- 如何查看一个进程所占用的内存？（htop）
- htop/top会显示很多个内存，哪个才是你要的？
- 有一个基本有序的数组，用什么排序算法比较好？（答了希尔排序，错的，插入排序）
- 讲一下希尔排序？（推广的插入排序）
- 对于有序数组，插入排序的时间复杂度是多少？（答了O(n^2)，没救了，面试官已经告诉我答案了，我居然还没发现！O(n)）
- 快排的最好最快复杂度是多少？（问排序问崩了，脑子已经糊了，答了O(n)和O(n^2)，实际上快排最好也就O(nlogn)）
- 快排在什么情况下性能最差？（答了在倒序的时候，尼玛正序的时候也是啊）
- 那什么情况下最好呢？（答了正序的时候，尼玛快把这个沙雕拖出去！应该是每次划分正好左右两边平衡的时候，这样生成的递归树最平衡，复杂度最低）
- 你实习都干了啥？看你写了Asio，你说说你实习的时候网络模型是什么样的，就是网络和业务的对接？（没接触业务）
- （针对我实习时候protobuf部分的内容问了很多，但是我都没说清楚，有点忘了）
- 为什么投游戏行业？
- 平时玩游戏吗？（玩了很久的崩坏3）
- 多少级？（满级，80）
- 哇，80级大佬！（后来把号卖了）
- 卖了？（肝不动啊！）
- 我这边问完了，你有什么想问的？（问了针对岗位的建议）
- 应届生还是应该注重基础：数据结构、算法、网络、高并发等等。

层次分明：语言+操作系统+算法+简历，感觉米忽悠的面试官水平挺高的。

## References

1. [大量TIME_WAIT的终极详解和解决方案][1]

[1]: https://blog.csdn.net/bingqingsuimeng/article/details/52064841