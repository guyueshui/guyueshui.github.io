---
title: 浅谈 Logistic 回归
date: 2019-03-15 22:59:39
categories: ['Learning Notes']
tags: ['math', 'machine learning', 'regression', 'classification']
---

In editing...

**Logistic回归属于分类模型！！！**

## 从最小二乘说起

## 线性回归

## 概率解释

## Sigmoid函数的引入

如果把我比作一张白纸，在我的知识储备中，现在只有线性回归。但是要处理分类问题，我该怎么办？没办法，先考虑一个二分类问题，$y \in \{0,1\}$，我们准备霸王硬上弓，用回归模型套上去！
$$
y = h_{\theta}(x)
$$

至少我们希望$h_{\theta}(x) \in (0,1)$，就那么刚刚好，有一族函数，这里我们特指其中一个
$$
g(z) = \frac{1}{1+e^{-z}} \in (0,1)
$$

请记住它的名字，它就是大名鼎鼎的sigmoid函数。可以的话，请再记住它两个迷人的性质：

1. $g'(t) = g(t)(1-g(t))$
2. $1 - g(t) = g(-t)$

## Logistic 回归

现在，我们模型的假设是
$$
\begin{split}
y &= h_{\mathbf{\theta}}(\mathrm{x}) = g(\mathbf{\theta}^T \mathrm{x}) \\
&= \frac{1}{1+\exp({-\theta^T \mathrm{x}})} = g(z)
\end{split}
$$

我们希望通过训练改变 $\theta$ 的值，进一步改善我们的模型。现在，我们打算换一个角度来看待这个问题，因为$g(\theta^T x) \in (0,1)$，正好可以表示一个概率，而之前我们看到，最小二乘实际上等价于，我对数据有一些假设（高斯白噪声），在这些假设下，做参数$\theta$的极大似然估计(MLE). 基于这个想法，我们假设，
$$
\begin{split}
P(y=1|x;\theta) &=  h_{\theta}(x) \\
P(y=0|x;\theta) &=  1 - h_{\theta}(x)
\end{split}
$$

然后就那么刚刚好，回忆一下sigmoid函数有哪些迷人的性质，你会发现下面的式子也是对的
$$
p(y|x;\theta) = [h_{\theta}(x)]^y [1-h_{\theta}(x)]^{1-y}
$$

再假设m个样本独立同分布，我们得到似然函数
$$
\begin{split}
L(\theta) &= p(\mathbf{y} | \mathbf{X}; \mathrm{\theta}) \\
&= \prod_{i=1}^m p(y_i | x_i ; \theta)
\end{split}
$$

进一步，得到对数似然
$$
\begin{split}
l(\theta) &= \log L(\theta) \\
&=\sum_{i=1}^m \left[ y_i\log h(x_i) + (1-y_i)\log(1-h(x_i)) \right]
\end{split}
$$

现在，我们基于MLE的方法，来调整参数 $\theta$ 的值，使得对数似然函数最大。很自然的，我们可以使用梯度上升的方法，更新规则为
$$
\theta = \theta + \alpha \nabla_{\theta} l(\theta)
$$

注意梯度上升是沿着正梯度方向更新。给定一个训练样本 $(x,y)$, 其梯度为
$$
\begin{split}
\frac{\partial}{\partial \theta_j} l(\theta)
&= \left(\frac{y}{g(z)} - \frac{1-y}{1-g(z)}
\right)
\frac{\partial g(z)}{\partial z} \frac{\partial z}{\partial \theta_j} \\
&= (y-g(z)) \frac{\partial z}{\partial \theta_j} \\
&= (y-h_{\theta}(x))x_j
\end{split}
$$

迭代使得似然函数最大化，完成训练。最后应该输出一个0~1之间的概率值。我们可以人为设定一个阈值（如0.5），当输出概率大于0.5，判定$y=1$，反之亦然。如此一来，就完成了回归到分类的转化。

另外，上述sigmoid函数又叫logistic函数，故名。**Logistic回归事实上是一个分类器！！！**

## 扩展为 softmax
