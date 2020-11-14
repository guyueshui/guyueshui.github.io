---
title: The Beauty of Recursion
date: 2019-04-23 09:08:28
lastmod: 2019-10-29
categories: ['Notes']
tags: ['recursion','programming thought']
mathjax: true
---

<font color="red">Declaration: this article is in long time editing...</font>

--------

Here comes some beautiful recursive solutions to some problems.

## Examples

Some of the problems have a very nice recursive structure, we can deal with them just using one step recursion.

### Fibonacci Numbers

The first comes very famous Fibonacci Numbers, which is a sequence of
0, 1, 1, 2, 3, 5, 8, 13 ...
The structure is easily captured, if we use $\text{fib}(n)$ to denote the $n^{\text{th}}$ Fibonacci Number (n is assumed to start from 0).
$$
\text{fib}(n) = \begin{cases}
n, &\text{ if } n \le 1 \newline
\text{fib}(n-1) + \text{fib}(n-2), &\text{ if } n > 1.
\end{cases}
$$
That is why we can write easily a procedure to compute the fibs. If we use MIT Scheme, we can write as follows:
```scheme
(define (fib n)
    (if (<= n 1)
        n
        (+ (fib (- n 1))
           (fib (- n 2)))))
```
or write a iterative version, since the above recursion has time complexity $O(2^n)$,
```scheme
(define (fib n)
    (define (fib-iter a b cnt)
        (if (= cnt 0)
            b
            (fib-iter (+ a b) a (- cnt 1))))
    (fib-iter 1 0 n))
```
This is called tail recursion in Lisp, it generates a iterative process so that in scheme it is iterative, though in many other languages it may belong to recursive thing. Following is a cpp version.
```c++
// iterative fibonacci
class Solution {
public:
    int fib(int n) {
        return fib_iter(1, 0, n);
    }

    // tail recursion <=> iteration
    // please refer to SICP Ch. 1.2.2
    int fib_iter(int a, int b, int cnt) {
        if (cnt == 0) return b;
        else
            return fib_iter(a+b, a, cnt-1);
    }
};
```

### Jump Floor

A frog is jumping, it can either jump one or two steps at a time. How many ways can he jump from 0 to nth floor? For instance, from 0 to 3, there are 3 ways:
1. 1,2 (first one, then it jumps two steps and reach 3)
2. 2,1 (first two, then it jumps one step and reach 3)
3. 1,1,1

Make sure you catch the problem. It will indeed reduce to Fibonacci Numbers. Let's see. **Always try the First-Case Analysis.** Denote $\text{opt}(n)$ to be the number of ways it jumps from 0 to $n^{\text{th}}$ floor. If we condition on the first step, then
1. it jumps 1 at first time, then the remaining is the number of ways to jump from 0 to $(n-1)^{\text{th}}$ floor, which is $\text{opt}(n-1)$.
2. it jumps 2 at first time, then the remaining $\text{opt}(n-2)$.

Hence we get the following:
$$
\text{opt}(n) =
\begin{cases}
n, & n \le 2 \newline
\text{opt}(n-1) + \text{opt}(n-2), & n > 2.
\end{cases}
$$
Note that the above is a Fibonacci sequence except the index shifting.
```c++
class Solution {
public:
    // top-down fashion, recursive and O(2^n)
    int jumpFloor(int n) {
        if (n == 1) return 1;
        if (n == 2) return 2;
        return jumpFloor(n-1) + jumpFloor(n-2);
    }

    // iterative O(n)
    int opt(int n) {
        if (n <= 2) return n;

        // else
        int a = 1, b = 2;
        /* apply the transform n-2 times
         * then `b` is fib(n)
         *    a = b
         *    b = a + b
         */
        for (; n > 2; --n) {
            b = a + b;
            a = b - a; // `a` is the previous `b`
        }
        return b;
    }
};
```

### Linked-List Reverse

You are given a linked list, which is defined by a cxx `struct` or `class`. Can you output the reversed linked list?

```c++
// Problem: Reverse a linked list.
// A linked list can be reversed either iteratively
// or recursively.
// Could you implement both?

class ListNode {
public:
    int val;
    ListNode * next;
    ListNode(int x) : val(x), next(nullptr) {}
};

class Solution {
public:
    // iterative
    ListNode* reverseList(ListNode* head) {
        // base case
        if (!head || head -> next == nullptr)
            return head;

        auto origin_head = head;
        auto p = head -> next;
        while (p) {
            // a copy for next iteration
            auto newp = p -> next;
            p -> next = head; // relink
            head = p; // update head
            p = newp; // ready for next iteration
        }
        // set origin head -> next point to null
        origin_head -> next = nullptr;
        return head;
    }

    // recursive
    ListNode* ReverseList(ListNode* head) {
        if (!head || head -> next == nullptr)
            return head;
        
        // suppose it can already do the job
        auto p = ReverseList(head -> next);
        auto tmp = p;
        // move tmp until reaching the end
        while (tmp -> next) {
            tmp = tmp -> next;
        }
        tmp -> next = head; // relink
        head -> next = nullptr;
        return p;
    }
};
```

### Reverse Print

You are given a linked list, can you print it's elements from end to begining?

```c++
// Problem: print from the end to begining of
// a given linked list.

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

## Conclusions

What can we do use recursions? How shall we consider when wrting recursions? The most important thing, I think, is **closure**. You must have the experience that some day you were working with a recursive procedure, getting stuck in the conditions and inputs/outputs of the recursion, you came up with a mess when trying to understanding or simulating the process in your brain, and finally, you even did not know why it works, what happened inside it, how did it reach the boundary cases, etc.

The key is not to consider! Stop digging your pit and bury yourself. Leave all the details behind, **all your focus is just one recursion step**. You deal with each recursion step like a blackbox, with its inputs and outputs. Each time, you should form a closure. Specifically, you must formulate your outputs of the current recursion step so that it can fit to next recursion step as a input. And you are focusing to find the common pattern that each recursion step should do. That depends on situations, but you should have the ability to extract some common pattterns in some problems.

**Do not forget your base cases** (or boundary cases, stopping rules). That's the export of recursion. Once you have done in recursion steps, the next thing to consider is the base cases. Where can the procedure exit, how many cases will it reach. Usually these base cases are very hard to find, and can be very confusing. Be careful to deal with them.

Once you had completed the above, you are almost done! Now you are free of those confusing details. The key is sometimes you know what you have no need to consider.
