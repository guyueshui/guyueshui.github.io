---
title: 札记
date: 2018-12-14 13:59:49
comment: false

---

## 2022 年 10 月

大喜：喜得一女。
![xiaoxiaoshang](shiang_origin.jpg)

## 2022 年 9 月

愈发觉得个人博客，还是要多些原创内容。抄的学习笔记，发布出来自己都不会看的。只有自己动手写的，费心整理的，日后回顾才有记忆。

## 2022 年 5 月

shell字符串截取: http://c.biancheng.net/view/1120.html

--------------------

hugo起本地服时，偶尔会出现本地文件已经修改，但预览网站还是未更改的状态（多次重新关闭/启动服务都不好使），此时可采用
```bash {linenos=false}
$ hugo server --config even-config.toml --gc
```

---

The memory that a program uses is typically divided into a few different areas, called segments:

-   The code segment (also called a text segment), where the compiled program sits in memory. The code segment is typically read-only.
-   The bss segment (also called the uninitialized data segment), where zero-initialized global and static variables are stored.
-   The data segment (also called the initialized data segment), where initialized global and static variables are stored.
-   The heap, where dynamically allocated variables are allocated from.
-   The call stack, where function parameters, local variables, and other function-related information are stored.

The heap has advantages and disadvantages:

-   Allocating memory on the heap is comparatively slow.
-   Allocated memory stays allocated until it is specifically deallocated (beware memory leaks) or the application ends (at which point the OS should clean it up).
-   Dynamically allocated memory must be accessed through a pointer. Dereferencing a pointer is slower than accessing a variable directly.
-   Because the heap is a big pool of memory, large arrays, structures, or classes can be allocated here.

The stack has advantages and disadvantages:

-   Allocating memory on the stack is comparatively fast.
-   Memory allocated on the stack stays in scope as long as it is on the stack. It is destroyed when it is popped off the stack.
-   All memory allocated on the stack is known at compile time. Consequently, this memory can be accessed directly through a variable.
-   Because the stack is relatively small, it is generally not a good idea to do anything that eats up lots of stack space. This includes passing by value or creating local variables of large arrays or other memory-intensive structures.



Cf. https://www.learncpp.com/cpp-tutorial/the-stack-and-the-heap/

## 2022 年 4 月

Posix扩展正则表达式: https://imliuda.com/post/16

## 2020 年 11 月

给老婆买了一加8T，性价比太高了吧！内存翻一倍只加300块！

## 2020 年 10 月

月初干了一件惊天地，泣鬼神的大事儿：我结婚啦！老婆很漂亮，我很爱她，她也爱我！希望以后可以辛福美满，步步高升～

--------------------

**collections.deque v.s. Queue.Queue** in python

`Queue.Queue` and `collections.deque` serve different purposes. `Queue.Queue` is intended for allowing different threads to communicate using queued messages/data, whereas `collections.deque` is simply intended as a datastructure. That's why `Queue.Queue` has methods like `put_nowait()`, `get_nowait()`, and `join()`, whereas `collections.deque` doesn't. `Queue.Queue` isn't intended to be used as a collection, which is why it lacks the likes of the in operator.

It boils down to this: if you have multiple threads and you want them to be able to communicate without the need for locks, you're looking for `Queue.Queue`; if you just want a queue or a double-ended queue as a datastructure, use `collections.deque`.

Finally, accessing and manipulating the internal deque of a `Queue.Queue` is playing with fire - you really don't want to be doing that.

--------------------

> 如无必要，勿增实体。

see: https://stackoverflow.com/a/717261

## 2020 年 9 月

mini自闭中...，大作业还未完成！

## 2020 年 8 月

mini开发中...

## 2020 年 7 月

在LaTeX里面排表格真是件苦差事，送你一个相见恨晚的网站： https://tablesgenerator.com

## 2020 年 6 月

How to close GUI on Ubuntu?

```bash
sudo /etc/init.d/lightdm stop
```
see: https://segmentfault.com/q/1010000000369635


## 2020 年 5 月

2020年5月20日，Yukynn说：昨晚我做梦了，梦到你打电话把我叫醒，说买了车票来看我。她说着，脸上还带着笑，明明早上还有些失落。我实在太惭愧了，自己有拖延症，前期浪费时间，后期疯狂弥补，导致没有足够的时间陪她。懒惰，是我最大的原罪。忏悔，从来只是对过往的无奈。改变，始于当下！

## 2020 年 4 月

即便是内心再强大的女生，都有脆弱的时候。我的未婚妻，在我看来她已经是个非常独立、自强的人了，比我早步入社会，阅历比我丰富一些。但是在工作的重压、减肥的营养不良、未婚夫的淘气重重打击之下，再坚实内心防线也会在积水蓄满之时决堤。这时候就是体现我作用的时候了，我的安慰，我的体贴，能够最大限度的让她安心，让她平静。在这种时候，我知道该怎么做，即便我们之前还因为一些小矛盾闹别扭。但是在她哭的一瞬间，什么都不重要了，什么都化为乌有。内心只有心疼！还有什么比两个人携手一起走更重要的呢？互相搀扶，走向明天！

## 2020 年 3 月

近日跟朋友聊到搭建个人网站的事情，又看到[谢益辉][31]关于搭建个人网站重要性的描述，于是极力向Q君推荐：“赶紧搭建一个属于自己的网站吧。” Q君以前是写公众号的，我说公众号平台毕竟不够自由，十年后会是什么样子也不知道。万一哪天出台个政策劝退又当如何呢？反观自己的网站，虽然没有那么大的流量，但自己的始终是自己的。自己可以写自己想写的东西，无论精华还是糟粕，只要你想将它写下来，都可以！十年后，二十年后它都在那里，那时候在回忆起来，无论你是什么感受，但总比没有回忆的强。

这么说着，果然Q君这两天搭建起了个人网站。我看他将以前写的文章诗词也都迁移上来，看过之后觉得挺好，起码算个见证，见证以前的自己，了解自己的成长吧。自我搭建网站以来，也迁移了一些以前写的东西，但是大部分还是比较惭愧，写的不知道是个啥，也就不好意思弄上来。但是今天忽然脸皮厚了，决定全部给他搬上来，看官如果觉得不适，那我也没有办法。

[31]: https://yihui.org/cn/2019/07/inner-peace/

--------------------

业生，于江湖，我固为池鱼。是大道无谓，大业不毕 。
<div style="text-align:right">——易之于本科毕业（2017/6/9）</div>


## 2020 年 2 月

为什么总是把最爱的人弄哭呢？常听一句话：你也就只能伤害爱着你的人了！这是多么可悲的评价，我似乎也在逐渐演变成自己讨厌的样子，悲上加悲！眼高手低，高估自己，却被现实啪啪打脸，到最后发现自己什么都不如别人。顶着村里人的谬赞，自娱自乐，玩物丧志，最后发现连自己擅长的也比不过别人了。为什么会陷入这样一种状态？我现在如果能认识到，就该能走出来了。

再谈到未婚妻，明明那么好一个人。脾气上是有点小倔强，却是居家过日子的小能手。外表刚强，内心柔软，只有走进她内心的人才能伤害到她，我很惭愧经常把她弄哭。或许我自己身上的毛病比我自知的还要多，我也不知道什么时候能够成熟到让她放心依靠，但是我是真的不想伤害她，我有时候意识不到自己的错误，很惭愧，我已经如此迟钝了。

应该吾日三省吾身：

1. 今天主动关心她了吗？
2. 今天让她伤心了吗？
3. 今天知道哪里做得不够好了吗？

千万不要执着于吵架纠纷，不要陷入口水战，要跳脱，抄近路，近路其实早已经铺好了。你我在恋爱之前都明白的事，只有局中人自己蒙在鼓里：尊重、诚意、关爱、可供依靠！当然抄完近路别忘了反省自己，下不为例，如果下次再犯同样的错误，会伤人更深。只有不断修正，才能成为真正可以依靠的男人！

## 2020 年 1 月

一年又过去了，都没有好好总结，我开始了刷游戏的生活！今天有份作业要交了，但是
之前压根没花多少心思在上面，导致现在犯难做不出来。然后网上各种找博客，又翻到几
个不错的博客，顺着望过去，人家本科就已经有培养自己的意识，并且对未来规划的十分
明晰。他们的生活过得十分充实，反观自己，却是一事无成。论文实验效果不行，想不出
新的idea，培训作业不花心思，导致现在焦头烂额，呵，瞧瞧自己这怂样！还想早点回家
看牙齿，P嘞，这样下去吃枣药丸！

## 2019 年 12 月

Python字符串格式化输出：
```python
# @number 小数点前占3位，小数点后占4位
print('This is a string {:3.4f}'.format(number))
print('This is left aligned {:<}'.format(var))
print('This is right aligned {:>}'.format(var))
print('This is center aligned {:^}'.format(var))
print('This is placeholder of 10 char {:>10s} and right aligned'.format(var))
```

--------------------

时至今日看到小孩子们成群结队的活动，还是会回想起当初我也是个小孩子的时候。看到他们，就好像看到希望。以前不能够理解孩子是祖国的花朵，现在，结合身边的事情，以及以往的见闻。确实能够明白这句话是多么正确了！

大人的表情千篇一律，但小孩的表情却千变万化，而且更加纯粹。这让以前同样纯粹的大人们看见，会不由得勾起对以往的怀念。我们小时候也是这样天真烂漫，三五成群，一起上学，一起吃饭，一起上课，一起玩耍。当初觉得一切来的自然，我也接受的自然。可是今天我却看到了背后的力量。有些孩子有家长陪同，有些孩子成群有老师陪同。我想，孩子们能参加一次像样的活动，背后总离不开家长和老师的付出。家长各不相同，家长的生活方式也各不相同，能力也各不相同，但他们努力挣钱养家的意愿是一样的。富有富的活法，自不必说；穷也有穷的活法，也会尽力给孩子提供良好的生长环境。这种共性让人肃然起敬！大人们在外打拼不易，也有苦有乐，乐自不必说，支撑他们在苦中作乐的很大一部分来自孩子。孩子须依托大人才能生存，大人也能从孩子身上看到希望，寄托精神。这算是抱团取暖吧。思来想去，人的一生，不就是在传火吗！

于是，大人要在外打拼供养生活。孩子的教育很大一部分落到了老师身上，文化教育自不必说，价值观与人性的教育也是需要老师带领的。小时候有一个良师，那将是受用终身的好事。启蒙老师就是这么一回事儿吧，他带你看到一个点，然后你就逐点成线；又好像是授人以渔，教育你对待某类事情的看法和处理方式；又好像是一个你很想要模仿的朋友，你朴素的期望着：我也想变得和你一样kilakila～ 想到这里，不得不感叹教育工作者的伟大！教书育人，无论哪个都是个重担子啊。教育的重要性，从最近的香港事件中可见一斑。孩子是很纯粹的，你怎么教，他很大程度就会变成什么样！所以文化入侵，精神入侵这种攻击比冷热兵器的影响更加久远深长，一个字，脏！老师所教给学生的，除了科学文化知识，还有寻求真相的本领，如果寻不到真相，也不要轻易听信谣言，即使听到了谣言，也要有自己的判断！这一整套的框架，是从小到大培养出来的，非一人之功，非一师之过。

希望所有接触孩子的老师都能明白：你的教育，往大了说，影响着祖国的未来；往小了说，也影响着自己的孩子。

小有感想，无他，写将出来罢了。

## 2019 年 11 月

又开启了新的一月，秋招应该要结束了，就差收个尾了。总体来说，我的战线还是挺长的，从8中旬开始陆续笔试，9月更是一大波笔试和面试，然而大部分公司，都是笔试过后就没有消息。9月底有幸收获两个offer，白山云是第一个，心里真的很感激，曾经一度认为我可能找不到工作了。然后就是小米，base南京，之所以能拿到小米的offer，可能是因为没有笔试，因为笔试的基本全部没有音讯。小米的两面到发offer经历的时间也是挺长的，南京也确实很好，就是待遇稍微和期望的差了一点吧。然后步入10月，拿到盛趣游戏的转正offer，给的比前面两个要高一点。之后就是网易互娱的offer，base杭州，有幸能拿到网易的offer，我已经相当高兴了。虽然给的是白菜价，岗位也是新手岗，但是毕竟平台大，成长空间应该也很大，努力奋斗几年后应该就会好些了。10月就是各种面试，就连很久之前笔试过的公司，也过来捞人去面试，可能是因为那些大佬拒了offer，然后补招吧。总之10月的笔试相对就轻松多了，基本上只要参加了，都有面试机会。其中不巧的一点就是新东方了，当时只是无意海投，也没注意看地点，结果阴差阳错拿到了offer，可惜只有北京的工作机会，给的也还挺高的，也不加班，但是在北京，待遇还不足以让我放弃很多东西去北漂。然后今天又收到了58同城的offer，可惜要转java，给的很低，虽然早就听说58给的低。

不过能收到人家的offer，也表明人家对我的认同，心里还是高兴的，至少我并不是一无是处啊！如今秋招已进入尾声，好好收个尾，然后专心搞毕业的事情吧！

--------------------

在信息化的现代，我愈发觉得人们接受的信息远远多于自己所需。人的一天本来可以有更多的休息时间，却被大量不必要的信息填充。各大视频网站，新闻APP，不可一世的推荐算法，轰炸式，瀑布流的一个接着一个，你只要动动手指，它们就一个一个跳入你的眼中，占用了本来用于休息的时间。我知道大多数人将这种活动本身当成一种休息，但是休息的形式很多，可以去运动，可以去睡觉，这种刷视频刷文章的休息方式实在不是最佳之选。况《道德经》有言：少则得，多则惑。就我自身体会，这句确实太妙了！接触的东西太多，反而会使人迷惑。每个人都有自己的个性，对同一件事会有不同的看法。

君可曾见，一件事情发生了，社会舆论一边倒，于是你也有些人云亦云。简单了解了一下该事件的始末，你也得出了类似的结论。随着该事件的发酵，后续出现了惊天反转，先前的舆论被证明不恰当，此时的你，可能会有些尴尬：要是我早知道这一点，肯定也能做出恰当的评论。其实不然，人很容易受环境影响，所以阅读了他人的想法之后，便很难再做出属于自己的那份评价了。

再退一步，这一来一回，你有何收获？其实大部分时候，我们浏览网上那些所谓大事件，然后翻评论，然后吃瓜，然后简单了解事情原委，然后自己再发个评论。这一顿操作还挺费时间的，但是却并没有什么实质性的收获。而且，有些事情在网上根本无法求证，有句话说的好：你所看到的，只是有心人士希望你看到的。真假亦无法求证，更别说这来回折腾还有什么意义了。所谓少则得，就是一个人知道自己需要做的事，把需要自己做的每一个部分做好，然后享受闲暇就好了。我想我很久没有享受过闲暇了，有也只是偷来的，以后还得还的。

繁华的闹市里，就像一锅煮沸的什锦汤，世事翻腾。如果你的介入起不了什么作用，不如做好自己的一隅，所谓达则兼济天下，穷则独善其身。举个栗子，小猫爱吃鱼，有人喜欢猫，有人给小猫送食。我觉得吧：如果不能一直授之以鱼，那就授之以渔，如果连这个也做不到的话，那就别去打扰它的世界。所谓天地不仁，以万物为刍狗，皆是如此。

写着写着，好像跑偏了。

--------------------

同学M获得了A厂的offer，日前就获得另外两家大厂的offer，果然运气也是能力的一
部分啊。据说是M的男友介绍的岗位，但是M桑好歹通过了几轮面试，还是相当有能力
的。反观我自己，心中难免有不甘。找工作也找了很久，但是始终没有找到能给到期
望薪水的公司。正在觉得自己可能也就这样了的时候，M桑又跳出来，拿到一个如此
nice的offer，不甘很正常。但是更让我感到害怕的是，心中居然起了妒火，嫉妒M桑
有一个如此给力的男友？不，显然是对自己无能的一种逃避。几经辗转我最后选择了
N厂的offer，但是传闻最近N厂疯狂裁员，而且还裁应届生。这让我一度感到十分
为难：好不容易找到工作，还要担心被裁！

其实我早已隐约察觉到，自己变得越来越浮躁。心境不如以前稳定，对事物的把控也
没有以前那样张弛有度。我一度以为这是在上海这样快节奏的生活中熏陶出来的。曾
经我的腿受伤，走路走不快，从宿舍到实验室的那段路，也觉得十分难走。为什么？
因为你旁边的人都在以风一般的速度前行，大家都在争分夺秒。而只有我自己在慢慢
走路的话，难免会觉得自己是不是掉队了？在这样的大环境下，优胜劣汰，我可不允
许自己就这样被人家甩在后面呀！说是夸张了点，但是这确实折射出我在上海生活的
压力。

究竟为何变得越来越浮躁，我现在不得而知，可能和周围的快节奏生活环境有一点
干系，所以我不太想留在上海这样的大都市了。我很讨厌这样的自己，贪嗔痴恶欲等
无名之火油然而起，我并不喜欢这样。人需要约束，需要自律，需要节制！

## 2019 年 10 月

今年十一算是比较特殊的，因为，我订婚了。似乎有点快，但也是必将发生的事，女票成为了未婚妻，感情一直很好，虽然谈了不到两年，但是我们从初中开始就认识，家又离得近，有十几年的感情基础，相互之间十分信任。说给同学听也都纷纷表示支持和羡慕！人生嘛，有妻如此，夫复何求。所以啊，10月求一个高薪offer！

--------------------

C++生成随机字符串

```cpp
#include <ctime>

char* rand_str(char* str, const int len)
{
  srand(time(NULL));
  for (int i = 0; i < len; ++i)
  {
    switch (rand() % 3)
    {
      case 1: str[i] = 'A' + rand() % 26; break;
      case 2: str[i] = 'a' + rand() % 26; break;
      default: str[i] = '0' + rand() % 10; break;
    }
  }
  // NOTE: please ensure @str[len] is in valid memory range.
  str[len] = '\0'; // terminate flag
  return str;
}
```

--------------------

被人嘲笑也没关系，默默做好自己该做的事。人间很浮躁，很容易就飘了，你要做的就是把底盘打牢，不要被人家左右。有自己的思想，并为之努力就好。

## 2019 年 9 月

C++静态函数有什么不同？

- 静态函数具有单文件作用域，不能被其他文件所用
- 不会和其他文件中的同名函数冲突
- 静态函数分配在程序的静态内存区，对于频繁调用的函数，声明成静态可以避免调用函数时压栈出栈，速度快很多

--------------------

递归lambda表达式写法

```cpp
#include <iostream>
#include <functional>

int main()
{
  std::function<int(int)> fact =
      [&fact](int n)
      {
        if (n == 1) return 1;
        else return n * fact(n-1);
      };
  std::cout << fact(4);
  return 0;
}
```

--------------------

忙碌的9月终于过了，整个9月一直处在秋招的洪流之中：改简历、投简历、做笔试、在线面试、现场面试。可能还是能力不够，很多公司做了笔试都没有消息了，有的公司甚至简历被刷。真的是“书到用时方恨少”，等到找工作的时候才知道学少了，要是当初多学一些就好了。奈何不是科班出身，自学毕竟有限，所以到处碰壁。只能针对专门的知识点快速学习一遍，既缺乏实践，又缺乏理解，所以了解的都不深入。吃饭的家伙，还是得系统的学习一遍比较好啊。10月加油！

![September](sept.png)

## 2019 年 8 月

8月的第一周，就惹我家领导生气了。问题还蛮严重的，第一次感觉到，原来感情真的很脆弱，就像鸡蛋壳一样。一不小心，就容易捅破。好的感情需要用心经营，很明显是我经营不善，我必须自食其果。这种问题都是常见的问题，但是还是会犯，明明听过很多前车之鉴，但自己就是犯贱，偏要以身试法。何苦来！跳脱不开，陷于苦海，即便早该明白的，也早已经明白的道理，没有切身的感受，终究不能领悟，不知代价。人之一物，可能大都是这样的。

1. 不要跟气头上的女人讲道理。
2. 遇到女人生气，一个字，让！
3. 女人生气的时候是最感性的时候，所以千万不要跟她讲道理。
4. 女人往往更在乎你对她的态度，而不是事件的对错。
5. 如果你发现女人难懂了，那说明你这段时间对她的关注度不够。
6. 爱护女票，从我做起！（不要只是嘴上说说，行动起来！）

--------------------

关于移位操作的几个注意事项：

1. char类型移位前务必先做类型转换（转为unsigned char），默认先转成int再移位，如果原来的char是unsinged int转来的，可能会和你预期的不符
2. 移位一般只针对无符号类型，有符号类型的移位往往和你预期不符
3. 移位超过32位要先转换成long类型

--------------------

![ASCII](yellow_ascii1.jpg)

![ASCII Ext](yellow_ascii2.jpg)

--------------------

C++计算程序运行时间

```c++
#include <iostream>
#include <time.h>

int main()
{
  clock_t start_time = clock();
  {
    // tested block
  }
  clock_t end_time = clock();
  double elapsed_time = 
    static_cast<double>(end_time-start_time) / CLOCKS_PER_SEC * 1000;

  cout << "Running time is: " << elapsed_time << "ms" << endl;
  return 0;
}
```

--------------------

C++对象析构顺序
```cpp
#include <iostream>

using namespace std;

struct A {
  A() { cout << __FUNCTION__ << endl; }
  ~A() { cout << __FUNCTION__ << endl; }
};

struct B
{
  B() { cout << __FUNCTION__ << endl; }
  ~B() { cout << __FUNCTION__ << endl; }
};

struct C
{
  C() { cout << __FUNCTION__ << endl; }
  ~C() { cout << __FUNCTION__ << endl; }
};

struct D
{
  D() { cout << __FUNCTION__ << endl; }
  ~D() { cout << __FUNCTION__ << endl; }
};

struct E
{
  E() { cout << __FUNCTION__ << endl; }
  ~E() { cout << __FUNCTION__ << endl; }
};


void func() { static D d; }

static A a;

int main()
{
  B b;
  C c;
  func();
  func();
  func();
  static E e;
  return 0;
}
```
输出：
```
A
B
C
D
E
~C
~B
~E
~D
~A
```
从这个输出中可以看出，对于局部对象，先构造后析构。全局静态对象最后析构，局部静态对象的析构顺序不定，但总体保持先构造者后析构的规律。可以看到，无论`func()`调用几次，静态对象只在第一次调用时构造。

--------------------

感觉最近很忙，但又不知道忙什么。感觉有忙不完的事情，但又不知道从何忙起。细想来，其实就两件事：一个毕业，一个工作。踏踏实实干吧！

## 2019 年 7 月

- 一个虚基类（纯虚函数构成的接口类，abstract type）不能生成实例，所以不需要定义构造函数。就算定义了，也无法通过构造函数生成对象。
- 构造函数不需要、也不能够声明为虚函数。[here](https://blog.csdn.net/zhang2531/article/details/51218149)
- 析构函数可以声明为虚函数，而且作为基类的类建议声明虚析构函数。但析构函数不能声明为纯虚函数。

--------------------

任何一门语言都有三要素：

1. Primitives
2. Means of combination
3. Means of abstraction

<div style="text-align:right">──SICP</div>

--------------------

出现死锁的条件：

1. 资源互斥，某个资源在某一时刻只能被一个线程持有（hold）；
2. 吃着碗里的，还看锅里的，持有一个以上的互斥资源的线程在等待被其它进程持有的互斥资源；
3. 不可抢占，只有在互斥资源的持有线程释放了该资源之后，其它线程才能去持有该资源；
4. 环形等待，有两个或两个以上的线程各自持有某些互斥资源，并且各自在等待其它线程所持有的互斥资源。

--------------------

v2ray配置小结：

- [TLS证书](https://toutyrater.github.io/advanced/tls.html)
- [配置文件生成](https://www.veekxt.com/utils/v2ray_gen)
- [配置模板](https://github.com/KiriKira/vTemplate)
- [测试vps是否被ban的网站](http://port.ping.pe)

**关于防火墙**

centos的防火墙默认使用firewalld，使用
```bash
systemctl start/stop firewalld
```
来开启或关闭。

常用命令，
```bash
## 查看已开放端口
firewall-cmd --zone=public --list-ports
## 添加开放端口
firewall-cmd --zone=public --add-port=80/tcp --permanent
#允许udp
firewall-cmd --permanent --add-port=12345/udp
#重新载入防火墙以使配置生效
firewall-cmd --reload
```
或编辑`/etc/firewalld/zones/public.xml`.

**添加到system unit**

```
[Unit]
Description=V2Ray Service
After=network.target
Wants=network.target

[Service]
# This service runs as root. You may consider to run it as another user for security concerns.
# By uncommenting the following two lines, this service will run as user v2ray/v2ray.
# More discussion at https://github.com/v2ray/v2ray-core/issues/1011
# User=v2ray
# Group=v2ray
Type=simple
PIDFile=/run/v2ray.pid
Environment=V2RAY_LOCATION_ASSET=/etc/v2ray
ExecStart=/usr/bin/v2ray -config /etc/v2ray/config.json
Restart=on-failure
# Don't restart in the case of configuration error
RestartPreventExitStatus=23

[Install]
WantedBy=multi-user.target
```
添加完毕后即可使用如下命令开启/关闭服务
```bash
systemctl start/stop v2ray.service  # on/off
systemctl status v2ray.service      # status
systemctl enable v2ray.service      # on-boot start
```

--------------------

读取两行整数，每一行放入一个vector
```c++
#include <iostream>
#include <vector>
#include <sstream>

using namespace std;

int main()
{
  vector<int> v1, v2;
  for (int i = 0; i != 2; ++i)
  {
    string line;
    std::getline(cin, line);
    istringstream is(line);
    if (i == 0)
    { // use implicit conversion
      for (int val; is >> val; v1.push_back(val)) { }
    }
    else
    { // or use std::stoi
      for (string val; is >> val; v2.push_back(std::stoi(val))) { }
    }
  }

  for (auto e : v1) cout << e << " ";
  cout << endl;
  for (auto e : v2) cout << e << " ";

  return 0;
}
```

## 2019 年 6 月

6月1号是儿童节，但是却遇到了一对小人！没想到在文明的社会还会有这样的人存在，没办法，只能敬而远之，穷则独善其身。可怜了我家领导，要受这么大的气！

--------------------

**Static members**

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

--------------------

使用`stringstream`分割字符串
```c++
#include <iostream>
#include <sstream>

using namespace std;

int main() {
    stringstream ss("i,love, you");
    string token;
    while (getline(ss, token)) { /* mark */
        cout << token << endl;
    }
    return 0;
}
```
[getline](https://en.cppreference.com/w/cpp/string/basic_string/getline)可以传入额外的分割符参数，类型为`const char*`，默认是换行符`\n`. 上面的代码片段mark处可变：

`while (getline(ss, token))` 输出
```
i,love, you
```
`while (getline(ss, token, ' '))` 输出
```
i,love,
you
```
`while (getline(ss, token, ','))` 输出
```
i
love
 you
```

--------------------

这算是我上大学以来第一次回家过端午节。以前总是看着别人在空间或者朋友圈里晒吃粽子，自己在外面却因为粽子太贵而不愿去买一个来吃，想想还是有点心酸。回家发现，奶奶又老了，听力更加不如以前了，感觉嗓子也有点沙哑了。岁月总是那么不饶人，新陈代谢不会因为任何人的感情而改变步伐。总想着自己可以早点出来挣钱，证明给他们看，这个人没白养活，可以自己挣钱了。也想着，总是拿家里的，什么时候可以自己挣钱给家里用呢？和女朋友异地，什么时候从能在一起呢？等我出来了，还要养家糊口，偏偏在最缺钱的时候，最需要钱！这个社会也不知道是怎么了，风气流转的近乎诡异。

--------------------

迷茫，真的很迷茫。自从开始找工作以来，就无法静下心来搞科研了，看论文的事情优先级一直排在最后。有点空余时间，自学C++，都不想去碰论文的事。然而自学的东西，依旧是基础的算法和数据结构，以及一些基础的语言特性，还是不知道项目中，工程中如何使用c++. 一直想找一个锻炼的机会，实践的机会。无奈实习一直没有着落，今年的算法岗实在是供远远大于求，众人同挤独木桥，毕竟还是干不过科班出生的那些cs大佬。于是转后台，自学c++，说起来一直对c++有执念。这次实习也是一心想找c++的岗。但我自知c++并不是这么简单的东西，从写玩具代码，到写出真正有意义的工程代码，我还要很长的路要走。哎，好想要offer啊，好想看看工程中大家是怎么做的，好想见识见识世界啊，好想挣钱啊！

--------------------

> How to write comments in your code?
> 
> - At the library, program, or function level, use comments to describe *what*.
> - Inside the library, program, or function, use comments to describe *how*.
> - At the statement level, use comments to describe *why*.
>
> <div style="text-align:right">──<a href="https://www.learncpp.com/cpp-tutorial/comments/">learncpp.com</a></div>

--------------------

前段时间给《千与千寻》补了票，真的是小时候看的是志怪，奇妙，瑰丽的想象，长大后看的是内在。之前一直都不太明白无脸男在剧中的作用，觉得这个角色可有可无。后来上豆瓣看了一些影评，少许获得了一点感知。但是今天的重点不是无脸男，而是油屋工作的那些忘了自己名字的劳动者。说句实在的，劳动换报酬，这无可厚非，甚至还可以通过劳动实现自己的价值。但是油屋那些劳动者们，事实上是被剥夺了名字，再也找不回来了。我们可以把名字，理解成真名、本心。从小到大，绝大多数人都走上了既定的轨道，就像油屋的劳动者们。很多人小时候有着单纯的梦想，却随着接触越来越多的大人而慢慢被同化，这个世界不劳作只有消失，不劳作就会被淘汰。我们认认真真把自己打扮成一个个劳动者，去到一个个劳动单位，生怕人家不要，生怕被淘汰。有的时候甚至意识到，有些东西小时候都懂，到现在反而忘记了，作为一个大人，反而忘记了原本已经懂得的那些单纯美好的意识，这是社畜所不需要的，所以在成长的过程中，注定被抹消。但是你偶尔又会回忆起，或是在深夜辗转反侧的时候，或是看到影视作品中类似情节的时候，回忆起小时候踌躇满志的单纯的自己。你可能会慨然长叹：这么久了，我得到了什么？又失去了什么呢？

最惨的是当你意识到这些，却发现无可奈何。生活还是会啪啪的打脸：“你的问题在于做得太少，而想得太多”。然后第二天，继续回到油屋上班吧！可是，有的人做着做着，会麻木的啊。他们渐渐不再动脑，不再有各种奇妙的想法，每天的思维都是固定的几个圈。这无异于行尸走肉。所以，我们需要这样的醍醐灌顶，需要精神食粮。这也是为什么有一大堆哲学家天天吃饱饭没事做在那瞎悟，人家的工作就是化几年甚至几十年的光阴，悟到一瞬的真谛。但是也没用，这传达不了给我们。我们只能听到他们说的话，阅读他们留下的文字，却不能体会他们的体会。这并不具有传递性，想要拥有，只能自己去经历，自己去感受，自己去领悟！

--------------------

> 莫道君行早，更有早行人。

--------------------

Best practice?

- Use `exit(__status__)` in `main()`
- Use `throw` in other modules

## 2019 年 5 月

说起来已经很久没更新了。实在是没什么可以写的，这段时间的状态很差，如咸鱼一般。昨天（25日）去听了花碳的live，也实在是想体验一下这种事情。毕竟曾经涉足宅圈，也费劲心思上过N站，看喜欢的唱见。曾经那么如痴如醉的追番，看弹幕，听op、ed，追专辑，从动画开始，饭起它的周边一切，最后居然延伸到了日剧。文化入侵说的就是这么回事儿吧。而今，没那么多时间看了，也时过境迁，不比当时。谨以此次live怀念一下逝去的青春罢。

关于live，花碳的形象和我想象中的有一点出入，不过也是情理之中，毕竟人家声音那么有张力，高音炮那么稳，颤音也控制得很好，一个萝莉身材也做不到这些呀。然后就是《笹舟》现场不是花碳本人唱的，有点遗憾。live一点开始，花碳两点二十就打算溜了，而且这一个多小时也没唱几首歌，有pokato的配合，以及山崎的演奏，加上中间的互动和对话，真的没唱几首。虽然说现场确实是稳，但到那时为止，经典曲目《心做し》、《自傷無色》、《ロミオとシンデレラ》等一首没唱。好在后来大家一起喊“Encore”才又回来唱了几首，包括以上两首（让人感觉像是安排好的，爱演？这样不太好吧）。不得不说花碳现场还是很强的，唱《ロミオとシンデレラ》的时候我打call打的快飞起来了(\*/ω＼\*)，第一次这么激烈的打call。然后观众打call好像很有讲究，我看不明白，就随便一顿乱挥。总的来说，还是比较不错的一次经历，毕竟live不必演唱会，可以近距离看到想看的人，甚至和他们互动。真棒，以上。

![hanatan](hanatan.jpg)

## 2019 年 4 月

4月，希望能找到一份实习。

--------------------

经历了很多失败，但是也要坚强。与其有时间和别人吐槽自己的经历，不如多花点时间充实自己，提升自己。

--------------------

> override是重写（覆盖）了一个方法，以实现不同的功能。一般是用于子类在继承父类时，重写（重新实现）父类中的方法。
> 重写（覆盖）的规则：
>
> 1. 重写方法的参数列表必须完全与被重写的方法的相同,否则不能称其为重写而是重载.
> 2. 重写方法的访问修饰符一定要大于被重写方法的访问修饰符（public>protected>default>private）。
> 3. 重写的方法的返回值必须和被重写的方法的返回一致；
> 4. 重写的方法所抛出的异常必须和被重写方法的所抛出的异常一致，或者是其子类；
> 5. 被重写的方法不能为private，否则在其子类中只是新定义了一个方法，并没有对其进行重写。
> 6. 静态方法不能被重写为非静态的方法（会编译出错）。
>
> overload是重载，一般是用于在一个类内实现若干重载的方法，这些方法的名称相同而参数形式不同。
> 重载的规则：
>
> 1. 在使用重载时只能通过相同的方法名、不同的参数形式实现。不同的参数类型可以是不同的参数类型，不同的参数个数，不同的参数顺序（参数类型必须不一样）；
> 2. 不能通过访问权限、返回类型、抛出的异常进行重载；
> 3. 方法的异常类型和数目不会对重载造成影响；

覆盖和隐藏又是两码事: [here](https://www.cnblogs.com/zhangjxblog/p/8723291.html)

--------------------

- 类的常量成员：常量对象只能访问常量成员
```cpp
class A {
public:
    int fun(void) const; // const member
};
```
- `this` is const pointer

更多请访问：[cpp-tutorial](http://www.cplusplus.com/doc/tutorial/pointers/), cplusplus对cxx的特性描述的通俗易懂，而且划分结构简明，是一份不可多得的参考材料，要是说实在有什么缺点的话，屏幕太小，看得伤眼睛。

---------------------

使用`istringstream`对象分割字符串：
```c++
#include <iostream>
#include <sstream>

using namespace std;

int main(int argc, const char* argv[]) {
    istringstream iss;
    iss.str("abc def haha a e i ou");
    string c;
    while (iss >> c) {
        cout << c << endl;
    }
    return 0;
}

//--- outputs: ---//
// abc            //
// def            //
// haha           //
// a              //
// e              //
// i              //
// ou             //
//----- end ------//
```

---------------------

Python中with的用法：[IBM docs](https://www.ibm.com/developerworks/cn/opensource/os-cn-pythonwith/index.html)

- **上下文管理协议（Context Management Protocol）**：包含方法 `__enter__()` 和 `__exit__()`，支持该协议的对象要实现这两个方法。
- **上下文管理器（Context Manager）**：支持上下文管理协议的对象，这种对象实现了 `__enter__()` 和 `__exit__()` 方法。上下文管理器定义执行 with 语句时要建立的运行时上下文，负责执行 with 语句块上下文中的进入与退出操作。通常使用 with 语句调用上下文管理器，也可以通过直接调用其方法来使用。
- **运行时上下文（runtime context）**：由上下文管理器创建，通过上下文管理器的 `__enter__()` 和 `__exit__()` 方法实现，`__enter__()` 方法在语句体执行之前进入运行时上下文，`__exit__()` 在语句体执行完后从运行时上下文退出。with 语句支持运行时上下文这一概念。
- **上下文表达式（Context Expression）**：with 语句中跟在关键字 with 之后的表达式，该表达式要返回一个上下文管理器对象。
- **语句体（with-body）**：with 语句包裹起来的代码块，在执行语句体之前会调用上下文管理器的 `__enter__()` 方法，执行完语句体之后会执行 `__exit__()` 方法。

with的语法格式：
```python
with context_expression [as target(s)]:
    with-body
```
这里 context_expression 要返回一个上下文管理器对象，该对象并不赋值给 as 子句中的 target(s) ，如果指定了 as 子句的话，会将上下文管理器的 `__enter__()` 方法的返回值赋值给 target(s)。target(s) 可以是单个变量，或者由“()”括起来的元组（不能是仅仅由“,”分隔的变量列表，必须加“()”）。
```python
with open(r'somefileName') as somefile:
    for line in somefile:
        print(line)
        # ...more code
```
等价于
```python
somefile = open(r'somefileName')
try:
    for line in somefile:
        print(line)
        # ...more code
finally:
    somefile.close()
```

-------------------

学习的本质就是降熵，但我觉得，熵降到极点又何尝不失一片混沌呢。什么都知道和什么都不知道其实同样难以实现，去拒绝一些非常简单的知识和去挖掘一些非常困难的知识拥有同样的难度。每个人究其一生所能做的也只是维持一个平衡，已知与未知的平衡。如果把一个人比作一张白纸，他学到一个知识，就在白纸上用黑笔画一个节点，那么随着人的成长，白纸上的黑点会越来越多，知识之间相互联系，点与点之间形成网络。随着知识的积累，网络越来越复杂，越来越密集，到最后白纸几乎变成了黑纸。那么请问：白纸和黑纸究竟又有什么区别呢？新生的婴儿和将死的老者有什么区别呢？早上刚醒的你和晚上即将睡着的你有什么区别呢？人生于世，我想追求的不是极致，而是平衡，是中间。随手画一个圆，你知道中间在哪吗？你不知道就对了，因为你将用一生去追寻它。

## 2019 年 3 月

Python中的`__future__`包可将高版本中的特性引入低版本的解释器中。比如`print`在python3+是一个内置函数，而在python2.x是特殊关键词。
```python
#! /usr/bin/python2
from __future__ import print_function
from __future__ import absolute_import

import string

# use `print` as a function in python2!
print("I am using python2.x!")
```
上述的`absolute_import`意为绝对路径导入，python导包默认在当前路径下搜索，然后在标准库里搜索，如果当前目录下有自定义版本的`string`包，则会优先导入自定义版本的`string`包。加了`absolute_import`之后，除非指定自定义包名的路径，否则优先导入标准库里的同名包。

-------------------

出来混，迟早要还的。
现在轻松就意味着将来某段时间可能会忙成狗。现在加把劲儿，以后可能就会轻松很多。

-------------------

仪式感还是要有。“生活需要仪式感！” -- 某伟人
即便我对此还差一点点感知。

-------------------

虽然之前就看过类似的言论：博客最重要的是“写”！然而迟迟不能体会，而今总算有点领悟，格式什么的真的不重要，最重要的还是看你怎么写，怎么表达。过早的优化格式，优化排版是很无谓的工作。说到这里又想起一位伟人的话：

> We should forget about small efficiencies, say about 97% of the time: premature optimization is the root of all evil. <div style="text-align:right">──Donald Kunth，1974</div>

-------------------

程序员的软技能：

1. 沟通能力（写文档、代码注释，邮件等）
2. 代码规范（coding style）
3. 模块化抽象
  - 看书（设计模式等）
  - 读开源代码（如何设计，如何抽象，如何模块化）
  - 实战
4. 对业务的理解能力（选择最合适业务背景的技术框架）

基于场景做抽象，预留扩展空间，交付最小集。
https://study.163.com/topics/tongxueqingjin
<div style="text-align:right">──网易笑招组</div>

## 2019 年 2 月

放假回家还是啥也没干orz

-------------------

现在大部分学到的东西，都缺乏及时整理。导致模糊不清， 无法构建一个很清晰的系统架构。只能靠不断地堆砌素材，达到模糊的一知半解。但是，要深究每个细节，又没有这么多的时间。很矛盾，现代的生活节奏太快了，如果没办法改变，那就只能适应了。


## 2019 年 1 月

离放假还有一个月，是时候该做点什么了。不要玩物丧志！

-------------------

最近沉迷折腾，并没怎么学习。所幸将自己近期折腾的内容都梳理了一遍，整理成文，方便自己查阅，日后再用也能快速上手了。有一句话说得好：<q>输出是最好的输入！</q>

-------------------

愧为人念，愧受师恩！我有愧，愧对所有关照我的人，愧对所有我能伤害的人。

亲君子，远小人。在儒为小人，在鬼谷为圣人。盖儒之鄙于鬼谷者，排除异己也。此小人行径，亦当为己所疏。鬼谷追于道，避亡趣存，不拘儒教。故常言“离经叛道”，敢问小人所离何经，所叛何道？原是教条固步自封，匪我叛也。

-------------------

有时候争论真的没有意义！忌贪嗔痴，不争则无尤，则不失理智，能从容处事。

-------------------

> 我一哭眼睛就肿了，太阳穴就疼。头昏脑胀的呜呜～
> 我今天做梦了梦到你了。梦里你特别温柔，比我成熟，特别宠我。总是搂着我的肩，我生气了，你三两句话就把我哄好了，逗笑了。
> 我希望找一个能包容我让着我的男朋友。
> <div style="text-align:right">──Yukynn</div>



## 2018 年 12 月

今天，12月14日，我的个人博客终于上线了。在折腾了几天之后，依托 [Github](https://github.com) 爸爸的助力，以及 [Hexo](https://hexo.io) 引擎以及 [Melody](https://github.com/Molunerfinn/hexo-theme-melody) 主题的驱动，终于将个人主页打扮的有模有样了。可以出来见见世面啦！

以后会在这里写很多随笔、学习笔记、以及一些折腾记录以便后续查阅，就酱～～～～

-------------------

最近似乎有些沉迷博客美化了，沉迷到耽误功课！其实原本的搭配就不难看了，但是还是在那里不知道折腾个什么劲儿。有时候甚至为了一个头图选壁纸选半个小时，还有一些图标的配置啊等等。已经三天没做功课了╮(╯▽╰)╭，这样下去可还得了！住手，你的作业还没改完，要不要给你列一列你的 TODO 清单？

-------------------

切记，女生就是会反复确认她在你心里的位置。即便有些事情她很确信，不要说 “我对你的感情你还不清楚吗” 这种傻瓜的话。当她来确认的时候，让她明白，她就是最重要的人！

> 女人，第一需要的是尊重。
> 女人，第二需要的是诚意。
>
> <div style="text-align:right">──《秦时明月》花影</div>

--------------

1. 公共场合注意言谈举止
2. 吃饭不要啧啧啧
3. 不要做奇怪的表情
4. 不予试图劝服其接受反感的内容
5. 发消息不回让人没有安全感
6. 女生大部分时候不喜欢动脑子，所以先为她做好决定，不要问来问去
7. 珍惜眼前人
8. 首先提高自己的工作效率，多匀出时间去见她，胜过千言
9. 我回去了，我下班了=打电话给我

--------------

**关于不相关和独立的一些言论**

> 相关性反应的实际上是一种线性关系，而独立性则反映的是更为一般的线性无关性。
> 比较好的例子是正态分布关于正态分布的条件期望是那些正太分布的线性组合，而正态分布完全可由二阶矩决定，因此正态分布不相关等价于独立
>
> <div style="text-align:right">──知乎-竺毅纯</div>

> 题主，相关（这里指皮尔逊）是用矩定义的，独立是用分布定义的，你可以想象一下是谁强谁弱了吧？唯有正态分布两者等价。
>
> <div style="text-align:right">──知乎-jiesheng si</div>

> 感觉都没说到关键的地方，相关是说的covariance为0，covariance 是由X和Y的二阶矩算出来的，和XY的一阶矩E[XY]，这本身就缺失了很多信息，并不能得出所有的的信息。最常见的例子就是，正态分布与自己的平方。而独立的定义是在sigma algebra上面，通过sigma algebra可以得到一个事件的全部信息，这是比是否相关强得多概念。

> 作者：匿名用户
> 链接：[短链](https://www.zhihu.com/question/26583332/answer/242335235)
> 来源：知乎
> 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

**[正态分布中不相关等价于独立](https://math.stackexchange.com/questions/609732/jointly-gaussian-uncorrelated-random-variables-are-independent)**

--------------

儒、道、释：入世、出世、弃世。

--------------

大芹菜烧法：切好后拍一拍，切成丝或片状，少以盐渍，沥水，片刻下锅翻炒

-------------

为什么用 Hexo，本意是为了更好地专注写作。不成想花这么多时间折腾主题美化之类的事情。可谓是本末倒置了！

-------------

> 我最讨厌你们这帮男生明知道我生气，却不来哄我，晾着我，越晾越生气，再晾心就凉了。很多事情明明都是当时就能哄好，非要怄气不说好话！
>
> 还有，我最讨厌你们这帮男生明知道我生气，却不说重点，打擦边球：吃饭了吗？吃的啥呀？睡觉了吗？谁要听你说这些？上来跟我表态度，说重点，问题解决了再说别的！
>
> <div style="text-align:right">──边思梦</div>

------------

要学的还有很多，任重而道远。昨日看到好友 Q 君发表了年度总结，感慨万千。猛然回顾，仍是一事无成。人要善于总结，但往往败于懒惰。<q>但是人不是生来要被打败的</q>，所以还是战斗吧，和一切的一切！

------------

Q: 为什么使用 `hexo deploy` 老是提示输入用户名和密码。
A: [here](https://help.github.com/articles/why-is-git-always-asking-for-my-password/) and [here](https://stackoverflow.com/questions/7773181/git-keeps-prompting-me-for-password).

Q: 如何后台运行命令？
A: [here](https://www.maketecheasier.com/run-bash-commands-background-linux/)

----------

言多必失，不如娴静少言提高自身修养。