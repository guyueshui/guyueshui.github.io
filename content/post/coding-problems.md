---
title: A collection of some coding problems 
date: 2019-04-07 19:31:59
categories: ['Learning Notes']
tags: ['algorithm','dynamic programming','coding problems']
mathjax: true
---

## 题一：最高得分

一个长度为$N$的序列，玩家每次只能从头部或尾部拿数字，不能从中间拿。拿走的数字依次从左到右排列在自己面前。拿完$N$个数字之后，游戏结束。此时$N$个数字在玩家面前组成一个新的排列，这个数列每相邻两个数字之差的绝对值之和为玩家最终得分。假设玩家前面的$N$个数字从左到右标号为 $n_1,n_2, \dots, n_N$，则最终得分$S$的计算方式如下：
$$
S = \text{abs}(n_1-n_2) + \text{abs}(n_2-n_3) + \cdots + \text{abs}(n\_{N-1} - n_N).
$$

请计算玩家在以上游戏规则中把所有数字拿完可以获得的最大得分。

> 思路：拿到这个问题，感觉像是动态规划。得想办法把子问题拆出来。但是一般情况下，并不是这么好拆的。所以从最简单的用例开始。假设只有两个数，这很简单，无论怎么拿，得分都一样。再加一个数呢？你就要考虑从哪里先拿，然后再从哪里先拿的问题。假设现在有三个数，你从前端拿了一个数，则下一步你得考虑从哪里拿的增益比较大。从前端拿得到一个front_gain, 从末端拿得到一个back_gain. 你得比一比哪个会让你的得分最大化。然后下一步继续这样考虑，这就形成了一个递归步。就是说你已经拆出来了！专业店说就是你找除了递推关系式。
> 题外话：Case analysis is more powerful than you thought!

```c++
#include<iostream>
#include<vector>
#include<cmath>

using namespace std;

/**
 * @breif Calculate the max score of the given array.
 * @param arr     The origin array.
 * @param beg     The begining of the range.
 * @param end     The end of the range.
 * @param isFront Is the last taken from the front or not.
 * @return        The max score in a paticular setting.
 *
 * Note that the @c arr is the origin array, and [beg, end)
 * range is considered from the second step, with @c isFront.
 * For example:
 *   Suppose @c arr.size() = 5
 *   If @c isFront = true, means the last taken is from the front,
 *   then [beg, end) = [1, 5).
 *   If @c isFront = false, means the last taken is from the back,
 *   then [beg, end) = [0, 4).
 */
int opt(const vector<int>& arr, int beg, int end, bool isFront) {
    // base cases
    if (beg >= end) return 0;
    if (end - beg == 1) {
        if (isFront)
            return abs(arr[beg] - arr[beg-1]);
        else
            return abs(arr[beg] - arr[end]);
    }

    // ELSE
    int front_gain = 0; // the gain if take front at current step
    int back_gain = 0;  // the gain if take back at current step
    
    if (isFront)
    {
        front_gain = abs(arr[beg] - arr[beg-1]);
        back_gain = abs(arr[end-1] - arr[beg-1]);
    }
    else
    {
        front_gain = abs(arr[beg] - arr[end]);
        back_gain = abs(arr[end-1] - arr[end]);
    }
    return max(
            front_gain + opt(arr, beg+1, end, true),
            back_gain + opt(arr, beg, end-1, false));
}


int main()
{
    int N = 0;
    cin >> N;
    vector<int> arr;
    for (int i=0; i!=N; ++i)
    {
        int tmp;
        cin >> tmp;
        arr.push_back(tmp);
    }

    int maxwin = max(
            opt(arr, 1, arr.size(), true),
            opt(arr, 0, arr.size()-1, false));
    cout << maxwin;

    return 0;
}
```

## 题二：最少硬币

> 2019腾讯实习生笔试题

小Q去商场购物，经常会遇到找零钱的问题。小Q现在手上有$n$种不同面值的硬币，每种面值的硬币有无限多个。为了方便购物，小Q希望带尽量少的硬币，并且要能组合出$1$到$m$之间（包含$1$和$m$）的所有面值。

输入描述：
第一行包含两个整数$m, n ~(1 \le n \le 100, ~1 \le m \le 10^9)$，含义如题所述。
接下来$n$行，每行一个整数，每$i+1$行的整数表示第$i$种硬币的面值。

输出描述：
输出一个整数，表示最少需要携带的硬币数量。如果无解，则输出$-1$.

示例输入：
```
20 4
1
2
5
10
```
示例输出：
```
5
```

> 思路：一拿到就让人联想到动态规划。但其实不是，因为它的条件是要构成所有1到m之间的面值。所以就得从1到m慢慢凑出来。假设当前选择的硬币已经可以构成[1, i], 那么我当然下次在选面值的之后，会很理想的去寻找一个面值为i+1的硬币。这样我可以使我构造的最大面值尽可能的大。如果这个面值大于m了，那我们就完事儿了。这是贪心的思想。具体来说，比方已选的硬币可以构造出1到5之间的任何面值，那我在选择一个面值为6的硬币，就可以构造出1到11之间的任何面值。所以我们从面值为1的开始加，记录当前可以构造的最大面值max_constructed，在选择下一个硬币的时候，优先选择面值<=max_constructed+1的硬币。
> 参考：https://blog.csdn.net/MOU_IT/article/details/89057036


```c++
#include <iostream>
#include <vector>
#include <algorithm>

using namespace std;

int MinimalCoin(const vector<int>& coins, int amount)
{
  if (coins.empty())
    throw std::invalid_argument("empty coins");
  if (coins[0] != 1)
    return -1;

  int max_constructed = 0;
  int cnt = 0;
  do
  {
    for (int n = coins.size() - 1; n >= 0; --n)
    {
      if (coins[n] <= max_constructed + 1)
      {
        max_constructed += coins[n];
        ++cnt;
        break;
      }
    }
    
  } while (max_constructed < amount);

  return cnt;
}

int main()
{
  // address input
  int n, m;
  cin >> m >> n;

  int val;
  vector<int> coins;
  for (int i = 0; i != n; ++i)
  {
    cin >> val;
    coins.push_back(val); 
  }

  std::sort(coins.begin(), coins.end());
  cout << MinimalCoin(coins, m);

  return 0;
}
```

## 题三：进制转换

> 2019哈罗单车实习生笔试题

将一个10进制整数转换成36进制的数，可以用0-9A-Z表示0-35.

```c++
/** 
 *  Hellobike 2019 interview.
 */
#include <iostream>
#include <string>

using namespace std;

class Solution {
public:
    string itob36(int n) {
        int r = 0; // remainder of n mod 36
        string tmp;
        // iteratively divde by 36 to get each digit
        while (n) {
            r = n % 36;
            tmp += MAP[r];
            n /= 36;
        }
        // reverse tmp to ret
        string ret;
        cout << "tmp is " << tmp << endl;
        for (auto iter = tmp.rbegin(); iter != tmp.rend(); ++iter)
            ret.push_back(*iter);
        return ret;
    }
private:
    string MAP[36] = {"0", "1", "2", "3", "4", "5",     \
                      "6", "7", "8", "9", "A", "B",     \
                      "C", "D", "E", "F", "G", "H",     \
                      "I", "J", "K", "L", "M", "N",     \
                      "O", "P", "Q", "R", "S", "T",     \
                      "U", "V", "W", "X", "Y", "Z"};
};

// test
int main() {
  int number = 12345;
  cout << Solution().itob36(number);
  return 0;
}
```

## 题四：舞会

> 链接：https://www.nowcoder.com/questionTerminal/9efe02ab547d4a9995fc87a746d7eaec
> 来源：牛客网

今天，在冬木市举行了一场盛大的舞会。参加舞会的有n 位男士，从 1 到 n 编号；有 m 位女士，从 1 到 m 编号。对于每一位男士，他们心中都有各自心仪的一些女士，在这次舞会中，他们希望能与每一位自己心仪的女士跳一次舞。同样的，对于每一位女士，她们心中也有各自心仪的一些男士，她们也希望能与每一位自己心仪的男士跳一次舞。在舞会中，对于每一首舞曲，你可以选择一些男士和女士出来跳舞。但是显然的，一首舞曲中一位男士只能和一位女士跳舞，一位女士也只能和一位男士跳舞。由于舞会的时间有限，现在你想知道你最少需要准备多少首舞曲，才能使所有人的心愿都得到满足？

input:
第一行包含两个整数n,m，表示男士和女士的人数。1≤n,m≤ 1000
接下来n行，
第i行表示编号为i的男士有ki个心仪的女生
然后包含ki个不同的整数分别表示他心仪的女士的编号。
接下来m行，以相同的格式描述每一位女士心仪的男士。

output:
一个整数，表示最少需要准备的舞曲数目。

示例输入：
```
3 3
2 1 2
2 1 3
2 2 3
1 1
2 1 3
2 2 3
```
示例输出：
```
2
```
说明：
```
对于样例2，我们只需要两首舞曲，第一首舞曲安排（1,1），（2,3），（3,2）；第二首舞曲安排（1,2），(2,1)，（3,3）。
```

> 思路：乍一看好象很难，不知道怎么处理。其实只要仔细看清楚题目要求：要求每个刃都能得到满足！这很重要，即便还有一个我喜欢的人没跟我跳，就得再放一首歌让我跳！了解到这个需求之后，问题就变的简单了，只要统计出每个人心仪人的数量，以及被心仪的数量，对所有人求一个最大值就行了。
> 参考：https://www.nowcoder.com/questionTerminal/9efe02ab547d4a9995fc87a746d7eaec

```c++
#include <iostream>
#include <vector>

using std::vector;

int main()
{
  // read input and built heartbeat matrix
  int num_men, num_women, num_likes, val;
  std::cin >> num_men >> num_women;
  int total_num = num_men + num_women;
  // the heartbeat matrix
  vector<vector<int> > mat(total_num, vector<int>(total_num, 0));

  for (int i = 0; i != total_num; ++i)
  {
    std::cin >> num_likes;
    while (num_likes--)
    {
      std::cin >> val;
      if (i < num_men)  // man to woman
        mat[i][val+num_men-1] = 1;
      else // woman to man
        mat[i][val-1] = 1;
    }
  }
  // done
  
  // count for each persons hearbeats
  int songs_needed = 0;
  for (int i = 0; i != total_num; ++i)
  {
    int cnt = 0;
    if (i < num_men)  // counting for each man
    {
      for (int j = num_men; j != total_num; ++j)
      {
        if (mat[i][j] == 1) // man i like woman j
          ++cnt;
        else if (mat[j][i] == 1) // man i is liked by woman j
          ++cnt;
      }
    }
    else
    {
      for (int j = 0; j != num_men; ++j)
      {
        if (mat[i][j] == 1)
          ++cnt;
        else if (mat[j][i] == 1)
          ++cnt;
      }
    }
    if (songs_needed < cnt) songs_needed = cnt; // update songs if needed
  }
  
  std::cout << songs_needed;
  return 0;
}
```

## 题五：输出数组的全排列

给定一个数组，求其全排列。

> Idea: pick one element as prefix, then add to the permutations of the rest n-1 elems.
> Reference: https://www.cnblogs.com/ranjiewen/p/8059336.html

```c++
#include <iostream>
#include <iterator>
#include <algorithm>

void Permute(int arr[], int beg, int end)
{
  if (beg == end)
  {
    std::copy(arr, arr + end, std::ostream_iterator<int>(std::cout));
    std::cout << std::endl;
  }

  for (int i = beg; i != end; ++i)
  {
    std::swap(arr[i], arr[beg]);
    Permute(arr, beg + 1, end);
    std::swap(arr[i], arr[beg]);
  } 
}

int main()
{
  int arr[] = {0,1,2,3,4,5,6,7,8,9};
  Permute(arr, 0, 5);
  return 0;
}
```

## 题六：斜线填充

给定n x m的矩阵，按照从右上往左下的斜线填充 1 到 n*m 的值。
例如，对于一个3x3的矩阵,
```
1 2 4
3 5 7
6 8 9 (3x3)

1  2  4  7
3  5  8 10
6  9 11 12  (3x4)
```

> 思路：干就完了。先填充左上角的三角区域，再填充右下角的三角区域。注意边界条件，无论行或列到达边界，记得跳转。

```c++
#include <iostream>
#include <vector>

using namespace std;

class Solution {
public:
    Solution(int n, int m)
    {
        // fill with 0
        for (int i = 0; i != n; ++i)
            mat.push_back(vector<int>(m, 0));
    }

    void skewFill(int n, int m)
    {
        int cnt = 1;
        // fill the up-left triangle
        for (auto col = 0; col != m; ++col)
        {
            for (auto i = 0, j = col; i != n && j >= 0; ++i)
                mat[i][j--] = cnt++;
        }
        // fill the bottom-right triangle
        for (auto row = 1; row != n; ++row)
        {
            for (auto j = m-1, i = row; i != n && j >= 0; ++i)
                mat[i][j--] = cnt++;
        }
    }

    /// print the matrix
    void printer()
    {
        for (auto &row : mat)
        {
            for (auto &col : row)
                printf("%3d ", col);
            cout << endl;
        }
    }

private:
    vector<vector<int>> mat;
};

// test
int main()
{
    int n = 0, m = 0;
    cin >> n >> m;
    Solution s(n, m);
    s.skewFill(n, m);
    s.printer();
    return 0;
}
```

## 题七：螺旋矩阵

按顺时针填充螺旋填充矩阵。例如：
```
9 8 7
2 1 6
3 4 5 (3x3)

12 11 10 9
 3  2  1 8
 4  5  6 7 (3x4)
```

> Idea: Imagine there are for borders that surround the matrix. We walk through the mat, and once achieve a border, we change the direction. Each time we finished a circle, we will shrink our border, and start next circle. After we fill (row * col) elems in the matrix, we are done!
> 
> Note: this solution is the most elegant in my opinion, for it's simple boundray case.

```c++
#include <iostream>
#include <vector>

using std::vector;

class Solution
{
public:
  Solution(int rows, int cols)
    : mat_(rows, vector<int>(cols, 0))
  {
  }

  void BuildMat()
  {
    // 4 border
    int top = 0;
    int bot = mat_.size() - 1;
    int left = 0;
    int right = mat_[0].size() - 1;

    int N = (bot + 1) * (right + 1);
    for (int i = 0, j = 0; N != 0; --N)
    {
      // make sure fill exactly one element at each loop
      mat_[i][j] = N;

      if (i == top)
      {
        if (j < right) ++j;       // go right
        else if (j == right) ++i; // checkpoint
      }
      else if (j == right)
      {
        if (i < bot) ++i;         // go down
        else if (i == bot) --j;
      }
      else if (i == bot)
      {
        if (j > left) --j;        // go left
        else if (j == left) --i;
      }
      else if (j == left)
      {
        if (i > top + 1) --i;     // go up
        else if (i == top + 1)
        {
          ++j;
          // shrink borders
          ++top, --bot, ++left, --right;
        }
      }
      else
      {
        throw std::runtime_error("not behaved expectedly");
      }
    }
  }

  void Print()
  {
    for (auto &r : mat_)
    {
      for (auto &c : r)
        printf("%2d ", c);
      std::cout << std::endl;
    }
  }

private:
  vector<vector<int> > mat_;
};

// test
int main()
{
  Solution so(3, 4);
  so.BuildMat();
  so.Print();
  return 0;
}
```

## 题八：点击窗口的索引

> 网易雷火游戏2019校招

本题需要让你模拟一下在Windows系统里窗口和鼠标的点击操作，具体如下：

1. 屏幕分辨率为3840x2160，左上角坐标为(0, 0)，右下角坐标为(3839, 2159).
2. 窗口是一个矩形的形状，由左上角坐标(x, y), 和宽高(w, h)四给数字来定位。左上角坐标为(x, y), 右下角坐标为(x+w, y+h). 其中左上角坐标一定会在屏幕范围内，其他一些部分可能会超过屏幕范围。
3. 窗口的点击和遮挡规则同Windows，但是不考虑关闭窗口、最大化、最小化和强制置顶的情况。即，
  1. 如果发生重叠，后面打开的窗口会显示在前面打开的窗口上面
  2. 当鼠标发生一次点击的时候，需要判断点击到了哪个窗口，如果同个坐标有多个窗口，算点击到最上层的那个
  3. 当一个窗口被点击的时候，会浮动到最上层

输入描述：
每个测试输入包含1个测试用例。第一行为2个整数N，M。其中N表示打开窗口的数目，M表示鼠标点击的数目，其中$0<N,M < 1000$.
接下来N行，每一行四个整数$x_i, y_i, w_i, h_i$, 分别表示第i个窗口（窗口id为i，从1开始计数）的左上角坐标以及宽高，初始时窗口是按输入的顺序依次打开。其中$0 \le x_i < 3840$, $0 \le y_i < 2160$, $0 < w_i < 3840$, $0 < h_i < 2160$.
再接下来有M行，每一行两个整数$x_j, y_j$, 分别表示接下来发生的鼠标点击坐标。其中$0 \le x_j < 3840, ~0 \le y_j < 2160$

输出描述：
对于每次鼠标点击，输出本次点击到的窗口id。如果没有点击到窗口，输出-1.

示例输入：
```
2 4
100 100 100 100
10 10 150 150
105 105
180 180
105 105
1 1
```

示例输出：
```
2
1
1
-1
```

```c++
#include <iostream>
#include <algorithm>
#include <vector>

using namespace std;

// global const
enum {
  WIDTH = 3840,
  HEIGHT = 2160
};

// abstraction for 2D point
struct Pos
{
  int x;
  int y;
  Pos(int xx, int yy): x(xx), y(yy)
  {
  }
};

// abstraction for window
struct Window
{
  int id;
  Pos point;
  int width;
  int height;
  Window(int idx, int x, int y, int w, int h)
    : id(idx), point(x, y), width(w), height(h)
  {
  }
};

/// is the point @c p in the window @c w
bool IsInWindow(const Window& w, const Pos& p)
{
  int left = w.point.x;
  int right = 
    (left + w.width < WIDTH) ? (left + w.width) : WIDTH-1;
  int top = w.point.y;
  int bot = 
    (top + w.height < HEIGHT) ? (top + w.height) : HEIGHT-1;

  if (p.x >= left && p.x <= right)
  {
    if (p.y >= top && p.y <= bot)
      return true;
  }
  return false;
}

///  which window do i click on
int ClickWhich(vector<Window>& windows, const Pos& click)
{
  // 窗口叠放次序，从上层到下层
  for (int i = windows.size() - 1; i >= 0; --i)
  {
    if (IsInWindow(windows[i], click))
    {
      int ret = windows[i].id + 1;
      windows.push_back(windows[i]);
      windows.erase(windows.begin() + i);
      return ret;
    }
  }
  return -1;
}

int main()
{
  int num_open_windows, num_clicks;
  cin >> num_open_windows >> num_clicks;
  // read windows
  vector<Window> windows;
  for (int i = 0, x,y,w,h; i != num_open_windows; ++i)
  {
    cin >> x >> y >> w >> h;
    windows.emplace_back(i, x, y, w, h);
  }
  // read clicks
  vector<Pos> clicks;
  for (int i = 0, x,y; i != num_clicks; ++i)
  {
    cin >> x >> y;
    clicks.emplace_back(x, y);
  }
  // io done
  
  for (auto &e : clicks)
  {
    cout << ClickWhich(windows, e) << endl;  
  }

  return 0;
}
```

## 题九：Stern-Brocot Tree

> 网易雷火游戏2019校招

The Stern-Brocot tree is an infinite complete binary tree in which the verices correspond one-for-one to the positive rational numbers, whose values are ordered from the left to the right as in a search tree.

![Stern-Brocot Tree](sb-tree.png)

Figure above shows a part of the Stern-Brocot tree, which has the first 4 rows. The value in the node is the mediant of the left and right fractions. The mediant of two fractions A/B and C/D is defined as (A+C)/(B+D).

To construct the Stern-Brocot tree, we first define the left fraction of the root node is 0/1, and the right fraction of the root node is 1/0. So the value in the root node is the mediant of 0/1 and 1/0, which is (0+1)/(1+0)=1/1. Then the value of root node becomes the right fraction of the left child, and the left fraction of the right child. For example, the 1st node in row2 has 0/1 as its left fraction and 1/1(which is the value of its parent node) as its right fraction. So the value of the 1st node on row2 is (0+1)(1+1)=1/2. For the same reason, the value of the 2nd node in row2 is (1+1)/(1+0)=2/1. This construction progress goes on infinity. As a result, every positive rational number can be found on the Stern-Brocot tree, and can be found only once.

Give a rational nunmber in form P/Q, find the position of P/Q in the Stern-Borcot tree.

Input description:
Input consists of two integers, P and Q (1<=P,Q <= 1000), which represent the rational number P/Q. We promise P and Q are relatively prime.

Output description:
Output consists of two integers, R and C. R indicates the row index of P/Q in the Stern-Brocot tree, C indicates the index of P/Q in that row.
Both R and C are base 1. We promise the position of P/Q is always in the first 12 rows of the Stern-Brocot tree, which means R<=12.

Sample input:
```
5 3
```

Sample output:
```
4 6
```

> Idea: tree structure is natural for recursion.

```c++
#include <iostream>
#include <vector>
#include <algorithm>
#include <utility>

using namespace std;

// build Rat abstraction
typedef std::pair<int, int> Rat;  // the rational numbers

Rat operator+(const Rat& lhs, const Rat& rhs)
{
  // 事实上这里需要化简使得分子分母互素
  // 不过下面我判断等于的时候是交叉相乘判断的，故不影响结果
  return std::make_pair(
      lhs.first + rhs.first,
      lhs.second + rhs.second);
}

bool operator<(const Rat& lhs, const Rat& rhs)
{
  return (lhs.first * rhs.second)
       < (rhs.first * lhs.second);
}

bool operator>(const Rat& lhs, const Rat& rhs)
{
  return !(lhs < rhs);
}

bool operator==(const Rat& lhs, const Rat& rhs)
{
  return (lhs.first * rhs.second)
      == (rhs.first * lhs.second);
}

void Printer(const Rat& r)
{
  cout << r.first << "/" << r.second << endl;
}
// done

struct SBTreeNode
{
  Rat LF; // left fraction
  Rat val;
  Rat RF; // right fraction
  SBTreeNode(Rat l, Rat v, Rat r)
    : LF(l), val(v), RF(r)
  {
  }
};

/// search the SBTree for target, return the row and col index
void SearchOnTree(
    SBTreeNode& root, const Rat& target, int* prow, int* pcol)
{
  // base case
  if (target == root.val) return;
  
  // 可以看到Stern-Brocot树具有二叉排序树的特征
  // left-child < parent < right-child
  if (target < root.val)
  { // go left
    root.RF = root.val;
    root.val = root.val + root.LF;
    ++(*prow);
    *pcol = (*pcol) * 2 - 1;
    SearchOnTree(root, target, prow, pcol);
  }
  else if (target > root.val)
  { // go right
    root.LF = root.val;
    root.val = root.val + root.RF;
    ++(*prow);
    (*pcol) *= 2; // 注意列索引的增量，仔细看规律
    SearchOnTree(root, target, prow, pcol);
  }
}

int main()
{
  Rat query;
  cin >> query.first >> query.second;
  SBTreeNode root(Rat(0,1), Rat(1,1), Rat(1,0));
  // root.RF = root.val;
  // root.val = root.val + root.LF;
  // cout << "LF "; Printer(root.LF);
  // cout << "val "; Printer(root.val);
  // cout << "RF "; Printer(root.RF);

  int row = 1, col = 1;
  SearchOnTree(root, query, &row, &col);
  cout << row << " " << col << endl;
  return 0;
}
```

## 题十：解码字符串

> 腾讯2019校招

小Q想要给他的朋友发送一个神秘的字符串，但是他发现字符串过长了，于是小Q发明了一种压缩算法对字符串中重复的部分进行了压缩，对于字符串中连续的m个相同的字符串S将会压缩为[m|S]（m为一个整数且1<=m<=100），例如字符串ABCABCABC将会被压缩为[3|ABC]，现在小Q的同学收到了小Q发送过来的字符串，你能帮助他进行解压缩么？

输入描述：
```
输入第一行包含一个字符串S，代表压缩后的字符串。
S的长度<=1000;
S仅包含大写字母、[、]、|;
解压缩后的字符串长度不超过100000;
压缩递归层数不超过10层;
```

输出描述：
```
输出一个字符串，代表解压后的字符串。
```

输入示例：
```
HG[3|B[2|CA]]F
```

输出示例：
```
HGBCACABCACABCACAF
```
说明：
```
HG[3|B[2|CA]]F ->
HG[3|BCACA]F ->
HGBCACABCACABCACAF
```

> 个人觉得我的解法很烂，而且太繁琐，但是目前还想不出更好的。代码也写的比较乱orz. 主要想法是遍历一遍字符串，如果不是特定的压缩模式，直接添加到结果中就好，如果遇到了特殊模式（[3|AB]），将该模式提取出来交给另一个函数解码，模式可能递归存在，所以使用一个栈确保提取出正确的模式。

```c++
#include <iostream>
#include <string>
#include <stack>

using namespace std;

// decode pattern like "[3|abc]"
// note: end is included
string PatternDecode(const string& s, size_t beg, size_t end)
{
  // the minmal len: [3|a]
  // beg=0, end=4
  if (end - beg >= 4)
  {
    string ret;
    auto pos_delimiter = s.find('|', beg);
    int num_repeats = std::stoi(s.substr(beg+1, pos_delimiter-beg-1));
    {
      auto pos_left = s.find('[', pos_delimiter);
      if (pos_left < end) // has sub-pattern
      {
        ret += s.substr(pos_delimiter+1, pos_left-pos_delimiter-1);
        auto pos_right = s.rfind(']', end-1);
        ret += PatternDecode(s, pos_left, pos_right);
        ret += s.substr(pos_right+1, end-pos_right-1);
      }
      else  // has not sub-pattern
      {
        ret += s.substr(pos_delimiter+1, end-pos_delimiter-1);
      }
    }
    string res;
    while (num_repeats--)
      res += ret;

    return res;
  }
  else
  {
    throw std::invalid_argument("range too small");
  }
}

void Decode(const string& s, string* o)
{
  if (s.empty())
    throw std::invalid_argument("empty coded string");

  stack<size_t> stk;
  for (size_t i = 0; i != s.size(); ++i)
  {
    if (stk.empty() && std::isalpha(s[i]))
    {
      o->push_back(s[i]);
    }
    else if (s[i] == '[')
    {
      stk.push(i);
    }
    else if (s[i] == ']')
    {
      // if the stk has only one elem, then the last ']' of
      // a pattern is determined, we shall first decode this
      // pattern before going on.
      if (stk.size() == 1)
      {
        size_t pattern_beg = stk.top();
        o->append(PatternDecode(s, pattern_beg, i));
      }
      stk.pop();
    }
  }
}

int main()
{
  // io
  string input;
  cin >> input;
  string output;
  Decode(input, &output);
  cout << output;
  return 0;
}
```

## 题十一：重排并计算逆序数

> 腾讯2019校招

作为程序员的小Q，它的数列和其他人的不太一样，他有$2^n$个数。老板问了小Q一共m次，每次给出一个整数$q_i$ (1<=i<=m)，要求小Q把这些数每$2^{q_i}$分为一组，然后把每组进行翻转，小Q想知道每次操作后整个序列中的逆序对个数是多少呢？

例如：
对于序列1 3 4 2，逆序对有(4,2), (3,2)总数量为2.
翻转之后为2 4 3 1，逆序对有(2,1), (4,3), (4,1), (3,1)总数量为4.

输入描述：
第一行一个数n（0<=n<=20）
第二行$2^n$个数，表示初始序列（1<=初始序列<=$10^9$）
第三行一个数m（1<=m<=$10^6$）
第四行m个数表示$q_i$ (0<=$q_i$<=n)

输出描述：
m行每行一个数表示答案

输入示例：
```
2
2 1 4 3
4
1 2 0 2
```

输出示例：
```
0
6
6
0
```
说明：
初始序列2 1 4 3
$2^{q_1} = 2$ -> 第一次：1 2 3 4 -> 逆序对数0
$2^{q_2} = 4$ -> 第二次：4 3 2 1 -> 逆序对数6
$2^{q_3} = 1$ -> 第三次：4 3 2 1 -> 逆序对数6
$2^{q_4} = 4$ -> 第四次：1 2 3 4 -> 逆序对数0

> 首先如何计算逆序数，常用的方法是归并排序，可以顺带计算逆序数。但是由于我一开始用的是开销较大的归并，频繁的构造，复制vector，导致运行超时。后来改成了inplace的归并，速度明显提高很多。

```c++
#include <iostream>
#include <vector>
#include <algorithm>
#include <time.h>

using namespace std;

// combine two sorted subseqs
vector<int> merge(vector<int>& a, vector<int>& b, int* invcount)
{
  vector<int> res; // result seq
  vector<int>::iterator i = a.begin();
  vector<int>::iterator j = b.begin();
  while(i != a.end() && j != b.end())
  {
    if (*i <= *j) res.push_back(*(i++));
    if (*i > *j)
    {
    	res.push_back(*(j++));
    	(*invcount) += (a.end() - i);
    }
  }
	
  // tail appending ...
  if (i == a.end())
  {
    for(auto iter = j; iter != b.end(); ++iter)
      res.push_back(*iter);
  }
  if (j == b.end())
  {
    for(auto iter = i; iter != a.end(); ++iter)
      res.push_back(*iter);
  }
  
  return res;
}

// 归并排序的递归形式
vector<int> mergesort(vector<int>& seq, int* invcount)
{
  if (seq.size() == 1) return seq;
  else{
    // split the seq into two subseqs
    int lsize = seq.size() >> 1;
    vector<int> tmpl(seq.begin(), seq.begin() + lsize);
    vector<int> tmpr(seq.begin() + lsize, seq.end());
    
    vector<int> lseq, rseq;
    // recursively slove subproblems 
    lseq = mergesort(tmpl, invcount);
    rseq = mergesort(tmpr, invcount);
    
    return merge(lseq, rseq, invcount);
  }
}

// in-place merge sort
namespace inplace
{
/// Merge two sorted range [beg, mid), [mid, end).
void Merge(vector<int>& arr, int beg, int mid, int end, int* invcnt)
{
  for (int i = beg, j = mid; i < mid && j < end;)
  {
    if (arr[i] > arr[j])
    {
      *invcnt += (mid - i);
      std::swap(arr[i], arr[j]);
      // rearrange to keep the structure 
      for (int t = j; t > i+1; --t)
      {
        std::swap(arr[t], arr[t-1]);
      }
      ++mid;
      ++j;
    } 
    ++i;
  }
}

/// Inplace merge sort the range [beg, end).
void MergeSort(vector<int>& arr, int beg, int end, int* invcnt)
{
  if (end - beg > 1) // need sort
  {
    int mid = (beg + end) / 2;
    MergeSort(arr, beg, mid, invcnt);
    MergeSort(arr, mid, end, invcnt);
    Merge(arr, beg, mid, end, invcnt);
  }
}
} // namespace inplace

/// reverse the arr by length k
void ReverseBy(vector<int>& arr, int k)
{
  for (auto beg = arr.begin(); beg != arr.end(); beg += k)
    std::reverse(beg, beg + k);
}

/// compute elapsed time from start_time
inline double TimeElapsed(clock_t start_time)
{
  return static_cast<double>(clock()-start_time)
    / CLOCKS_PER_SEC * 1000;
}

/// Test wrapper
void UniTest(const vector<int>& numbers, 
             const vector<int>& qs,
             bool inplace)
{
  vector<int> dummynum(numbers);
  vector<int> buffer(numbers.size());
  for (auto e : qs)
  {
    int invcount = 0;
    ReverseBy(dummynum, 1<<e);
    buffer.clear();
    buffer.assign(dummynum.begin(), dummynum.end());

    if (inplace)  // use inplace merge sort
      inplace::MergeSort(buffer, 0, buffer.size(), &invcount);
    else
      mergesort(buffer, &invcount);

    cout << invcount << endl;
  }
}

int main()
{
  // io
  int n;
  cin >> n;
  vector<int> numbers;
  for (int i = 0, tmp = 0; i != (1<<n); ++i)
  {
    cin >> tmp;
    numbers.push_back(tmp);
  }
  int m;
  cin >> m;
  vector<int> qs;
  for (int i = 0, tmp = 0; i != m; ++i)
  {
    cin >> tmp;
    qs.push_back(tmp); 
  }
  // done
  
  clock_t start = clock();
  UniTest(numbers, qs, false);
  cout << TimeElapsed(start) << "ms for mergesort" << endl;

  clock_t start2 = clock();
  UniTest(numbers, qs, true);
  cout << TimeElapsed(start2) << "ms for inplace mergesort" << endl;
  return 0;
}
```
附运行结果，体会一下：
```
0
6
6
0
0.185ms for mergesort
0
6
6
0
0.068ms for inplace mergesort
```
差了3倍左右！

# 数据结构相关

**大部分出自[《剑指Offer》](https://www.nowcoder.com/ta/coding-interviews)**

## 打印二叉树最右边的节点

给定一个二叉树，打印其每层最右边的节点的值。

```c++
#include <iostream>
#include <vector>

using std::vector;

struct TreeNode {
    int val;
    TreeNode* left;
    TreeNode* right;
    TreeNode(int _val):
        val(_val), left(nullptr), right(nullptr) { }
};

// print the right-most node of each layer of a tree.
vector<int> PrintRightMost(TreeNode* root)
{
    if (!root) throw std::invalid_argument("empty tree");
    vector<int> ret;
    while (root)
    {
        ret.push_back(root->val);
        // prefer see right child than left
        if (!root->right)
            root = root->left;
        root = root->right;
    }
    return ret;
}
```

## 使用两个栈构造一个队列

```c++
/*
 * Basic idea:
 *     1. the top of stack1 as queue rear
 *     2. the top of stack2 as queue front
 */

#include <stack>
#include <iostream>

using namespace std;

class Queue {
private:
    stack<int> s1;
    stack<int> s2;

public:
    void push(int _node) {
        s1.push(_node);
    }

    int pop() {
        if (s2.empty()) {
            while (!s1.empty()) {
                s2.push(s1.top());
                s1.pop();
            }
        }
        int res = s2.top();
        s2.pop();
        return res;
    }
};
```

## 使用两个队列构造一个栈

```c++
/*
 * 1. queue2 as a auxiliary storage
 * 2. push: push to the rear of queue1
 * 3. pop: 
 *    3.1. quque1 has only one element, pop it
 *    3.2. pop the elements of queue1, push them to queue2
 *         till queue1 has exactly one left, pop it
 *    then pop elems of queue2 push to queue1
 */

#include <queue>

using namespace std;

class Stack {
private:
    queue<int> q1;
    queue<int> q2;

public:
    void push(int _node) {
        q1.push(_node);
    }

    int pop() {
        while (q1.size() != 1) {
            q2.push(q1.front());
            q1.pop();
        }
        int res = q1.front();
        q1.pop();
        while (!q2.empty()) {
            q1.push(q2.front());
            q2.pop();
        }
        return res;
    }
};
```

## 反向打印链表

给定一个单链表，反向打印每个节点的值。

```c++
/*
 * 1. use stack
 * 2. use recursion
 */

#include <iostream>
#include <vector>
#include <stack>

using namespace std;

class ListNode {
public:
    int val;
    ListNode *next;
    ListNode(int x) : val(x), next(nullptr) {}
};

class Solution {
    vector<int> printListFromTailToHead(ListNode* head) {
        vector<int> ret;
        // boundary case
        if (head == nullptr) return ret;

        stack<int> s;
        for (auto p = head; p != nullptr; p = p -> next) {
            s.push(p -> val);
        }

        while (!s.empty()) {
            ret.push_back(s.top());
            s.pop();
        }
        return ret;
    }

    // recursive needs a member variable
    // use recursion stack, tricky
    vector<int> arr;
    vector<int> reversePrint(ListNode* head) {
        if (head) {
            reversePrint(head -> next);
            arr.push_back(head -> val);
        }
        return arr;
    }
    /*
     * Consider the closure, at one recursive step,
     * what I should do? Let's drop all the details,
     * just look one recursive step.
     * What had I done?
     *     Oh gee, I see if the head is not null,
     *     I must push the value to the vector,
     *     but before this, I should take a look at
     *     `head -> next`, since I have to push
     *     the tail first. So which one can help me
     *     do this? Yes, the function itself! Then
     *     after I have addressed the tail, now I'm
     *     going to push current value to the vector.
     *     That's all I need!
     * The key is you work in one recursive step, and
     * form a closure for the next, and do not forget
     * the base case (stopping rules). That how
     * recursion runs! And you are free of those
     * confusing details.
     */
};
```

## 判断可能的出栈序列

输入两个整数序列，第一个序列表示栈的压入顺序，请判断第二个序列是否可能为该栈的弹出顺序。假设压入栈的所有数字均不相等。例如序列1,2,3,4,5是某栈的压入顺序，序列4,5,3,2,1是该压栈序列对应的一个弹出序列，但4,3,5,1,2就不可能是该压栈序列的弹出序列。（注意：这两个序列的长度是相等的）

```c++
/*
 * The idea is I push all elems of `pushV` into 
 * a stack `s`, simultaneously, I track if the elems 
 * of `popV` equal to the `s.top()`. If it is, I will
 * pop a elem from the stack and track the next elem
 * of `popV` till a mismatch. Then I'll continue to push
 * elems into the stack.
 *
 * When I run out all elems of `pushV`, I check if the
 * stack is empty, if it is, then the `popV` should be
 * a possible pop sequence or vice versa.
 *
 * Credit: https://www.nowcoder.com/profile/248554
 */

#include<iostream>
#include<stack>
#include<vector>

using namespace std;

class Solution {
public:
    bool IsPopOrder(vector<int> pushV, vector<int> popV) {
        // border case
        if (pushV.size() == 0) return false;
        
        stack<int> s;
        auto i = 0, j = 0;
        while (i != pushV.size()) {
            s.push(pushV[i++]);
            // KEY POINT here
            while (!s.empty()
                && s.top() == popV[j]
                && j != popV.size()) {
                s.pop();
                j++;
            }
        }
        return s.empty();
    }
};

// test
int main() {
    vector<int> pushV = {1,2,3,4,5};
    vector<int> popV = {4,5,3,2,1};
    cout << Solution().IsPopOrder(pushV, popV);
    return 0;
}
```

## 括号匹配

原题：https://leetcode.com/problems/valid-parentheses/

```c++
class Solution {
public:  
  bool isValid(string s) {    // 此解法还是比较elegant的
    stack<char> stk;
        
    for (auto &c : s)
    {
      switch (c)
      {
        case '{': stk.push('}'); break;
        case '(': stk.push(')'); break;
        case '[': stk.push(']'); break;
        default:
        {
          if (stk.empty() || c != stk.top()) // 巧妙地判断了stk非空
              return false;
          else
              stk.pop();
        }
      }
    }
    return stk.empty();
  }
};
```

## 二叉树的层次遍历

给定一颗二叉树，按每一层从左往右的顺序遍历。（队列的典型应用）

```c++
/*
 * This is a typical application of queue.
 * With the help of a queue, you can easily do this.
 *
 * You can also use recursion.
 */

#include <queue>
#include <vector>

using namespace std;

class TreeNode {
public:
    int val;
    TreeNode* left;
    TreeNode* right;
    TreeNode(int x) : val(x), left(NULL), right(NULL) {}
};

class Solution {
public:
    vector<int> HierarchicalTraversal(TreeNode* root) {
        if (root == nullptr) { 
            // further error handle
            return vector<int>(); 
        }

        vector<int> ret;
        queue<TreeNode*> q;
        q.push(root);

        while(!q.empty()) {
            auto cur = q.front();
            // from left to right push the current
            // root's children to the queue
            if (cur -> left) q.push(cur -> left);
            if (cur -> right) q.push(cur -> right);
            ret.push_back(cur -> val);
            q.pop();
        }
        return ret;
    }


    /// recursive
    vector<vector<int> > layerTraverse(TreeNode* root) {
        if (root == nullptr) return ret;
        build(root, 0); 
        return ret;
    }

    // recursion needs a member variable
    vector<vector<int> > ret;
    void build(TreeNode* p, int depth) {
        if (p == nullptr) return;

        if (ret.size() == depth)
            ret.push_back(vector<int>());
        ret[depth].push_back(p -> val); // use depth to track layer
        build(p -> left, depth + 1);
        build(p -> right, depth + 1);
    }
};
```

## 求整数的二进制表示中“1”的个数

输入一个整数，输出该数二进制表示中1的个数。其中负数用补码表示。

```c++
/*
 * `n` and `n-1` are the same from high bit position
 * to low, they differs from the last bit of 1 of n,
 * let's name it x. Have a look from x to the lowest 
 * bit position,
 * n:   010101000
 * &         x      <--- position x
 * n-1: 010100111
 * ---------------
 *      010100000   <--- n&(n-1)
 * It erases the last bit of 1 in n!!!
 *
 * This is why the following procedure will work. :)
 */

#include <iostream>

int NumOf1(int n) {
    int cnt = 0;
    while (n) {
        n = n & (n-1);
        ++cnt;
    }
    return cnt;
}

int main() {
    int N = 0;
    std::cin >> N;
    std::cout << NumOf1(N);
    return 0;
}
```

## 不可描述

求出1~13的整数中1出现的次数,并算出100~1300的整数中1出现的次数？为此他特别数了一下1~13中包含1的数字有
1、10、11、12、13
因此共出现6次,但是对于后面问题他就没辙了。ACMer希望你们帮帮他,并把问题更加普遍化,可以很快的求出任意非负整数区间中1出现的次数（从1 到 n 中1出现的次数）。

```c++
/*
 * Credits: unknown
 *
 * Idea:
 *   1) Focus exactly one decimal position, calculate the
 *      number of ones.
 *   2) Run out from lowest to highest position, add them
 *      together, it's the answer.
 *
 *  Imaging the numbers from 1 to n sits in a line in
 *  front of you. Now you're required to calculates all
 *  the ones in the sequence. A basic way is that, each
 *  time I focus on the same digit pos, and count all
 *  ones in that pos. Next time I focus on another pos.
 *  And I sum them all together, finally got the answer.
 *
 *  See how can we count the num of ones in a specific
 *  decimal pos? Let's do that! Suppose N = 301563. 
 *
 *  Step 1.
 *  Now I focus the hundred position, and split N into `a`
 *  and `b`, where
 *
 *  a = ceil(N / 100) = 3015
 *  b = N % 100 = 63
 *
 *  1). There are (a / 10 + 1) = 302 hits of one
 *  2). Each of length 100
 *  3). Totally (a/10 + 1) * 100 hits of one
 *
 *  Let me explain a little:
 *  (000-301)5(00-99) -> (000-301)1(00-99)
 *  
 *  The digits above hundred pos have 302 variants, and
 *  the digits under hundred pos has 100 variants, thus
 *  gives a total (a/10 + 1) * 100.
 *
 *  Step 2.
 *  This time I focus on thousand pos, and now
 *
 *  a = N / 1,000 = 301
 *  b = N % 1,000 = 563
 *
 *  1). There are (a/10) = 30 hits of one
 *  2). Each of length 1000
 *  3). And a tail hits of 564
 *
 *  (00-29)1(000-999) + 301(000-563)
 *  This gives 30 * 1000 + 564 = (a/10)*1000+(b+1)
 *
 *  Step 3.
 *  Now move to ten thousand pos, with
 *
 *  a = N / 10,000 = 30
 *  b = N % 10,000 = 1563
 *
 *  1). There are total (a/10)=3 hit
 *  2). Each of length 10,000
 *
 *  (0-2)1(0000-9999)
 *  gives 3 * 10,000 = (a/10).
 *
 *  That's all 3 cases. Let's write!
 */

class Solution {
public:
    int NumOnes(int n) {
        int ones = 0;
        for (long long m = 1; m <= n; m *= 10) {
            ones +=
                /*
                 * this covers case 1 & 3
                 * since (a+8)/10 = a/10 + 1 if a%10 >= 2
                 * (a+8)/10 = a/10 if a%10 == 0
                 */
                (n/m + 8) / 10 * m
                +
                // case 2
                (n/m % 10 == 1) * (n%m + 1);
        }
        return ones;
    }
};
```

## K轮换

原题：https://leetcode.com/problems/rotate-array/

Given an array, rotate the array to the right by k steps, where k is non-negative.

Example 1:
```
Input: [1,2,3,4,5,6,7] and k = 3
Output: [5,6,7,1,2,3,4]
Explanation:
rotate 1 steps to the right: [7,1,2,3,4,5,6]
rotate 2 steps to the right: [6,7,1,2,3,4,5]
rotate 3 steps to the right: [5,6,7,1,2,3,4]
```

Example 2:
```
Input: [-1,-100,3,99] and k = 2
Output: [3,99,-1,-100]
Explanation: 
rotate 1 steps to the right: [99,-1,-100,3]
rotate 2 steps to the right: [3,99,-1,-100]
```

Note:

- Try to come up as many solutions as you can, there are at least 3 different ways to solve this problem.
- Could you do it in-place with O(1) extra space?

> 提供三种方法：第一种，效率最低，因为vector从头插入元素开销很大；第二种，花费额外的空间，来降低时间开销；第三种，挺好的，std::reverse用的是首尾交换元素，无额外空间开销。

```c++
class Solution {
public:
    void rotate(vector<int>& nums, int k) {
#if false   // method 1.
        if (k == 0) return;
        nums.insert(nums.begin(), nums.back());
        nums.pop_back();
        rotate(nums, k-1);
#elif false  // method 2.
        vector<int> dummy(nums);
        for (int i = 0; i != dummy.size(); ++i)
        {
            nums[(i+k) % nums.size()] = dummy[i];
        }
#elif true  // method 3.
        k %= nums.size();
        std::reverse(nums.begin(), nums.end());
        std::reverse(nums.begin(), nums.begin() + k);
        std::reverse(nums.begin() + k, nums.end());
#endif
    }
};
```

## Move zeros

原题：https://leetcode.com/problems/move-zeroes/

Given an array nums, write a function to move all 0's to the end of it while maintaining the relative order of the non-zero elements.

Example:
```
Input: [0,1,0,3,12]
Output: [1,3,12,0,0]
```
Note:
- You must do this in-place without making a copy of the array.
- Minimize the total number of operations.

> 思路：记录数字0出现的个数count。如果当前数字是0，给count加一；如果不是0，将这个值往前挪count位。最后将最后count个元素置0.

```c++
class Solution {
public:
    void moveZeroes(vector<int>& nums) {
        if (nums.size() < 2) return;
        
        // c.f. https://leetcode.com/explore/interview/card/top-interview-questions-easy/92/array/727/
        int numzeros = 0;
        for (int i = 0; i != nums.size(); ++i)
        {
            if (nums[i] == 0)
                ++numzeros;
            else
                nums[i-numzeros] = nums[i];
        }
        // set the tails to 0
        while (numzeros)
        {
            nums[nums.size() - numzeros] = 0;
            --numzeros;
        }
    }
};
```
