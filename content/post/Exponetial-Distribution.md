---
title: Exponential Distribution
date: 2018-12-25 22:21:49
categories: ['Notes']
tags: ['math', 'probability']
---

## Story

> The Exponential distribution is the continuous counterpart to the [Geometric distribution](file://./Geometric-Distribution.md). The story of the Exponential distribution is analogous, but we are now waiting for a success in continuous time, where successes arrive at a rate of $\lambda$ successes per unit of time. The average number of successes in a time interval of length $t$ is $\lambda t$, though the actual number of successes varies randomly. An Exponential random variable represents the waiting time until the first arrival of a success.
>
> <div style="text-align:right">——adapted from Book BH</div>

<!-- more -->

## Basic

**Definition**: A continuous r.v. $X$ is said to have the *Exponential distribution* with parameter $\lambda$ if its PDF is
$$
f(x) = \lambda e^{-\lambda x}, \quad x > 0
$$
The corresponding CDF is 

$$
F(x) = 1 - e^{-\lambda x}, \quad x > 0
$$

To calculate the expectation and variance, we first consider $X \sim Exp(1)$ with PDF $f(x) = e^{-x}$, then
$$
\begin{split}
E(X) &= \int_0^{\infty} x e^{-x} dx = 1  \\
E(X^2) &= \int_0^{\infty} x^2 e^{-x} dx \\
&= -x^2e^{-x}|_0^{\infty} + 2\int_0^{\infty} x e^{-x} dx \\
&= 2E(X) = 2 \\
Var(X) &= E(X^2) - E^2(X) = 2-1 = 1 \\
M_X(t) &= E(e^{tX}) = \int_0^{\infty} e^{tx} e^{-x} dx \\
&= \int_0^{\infty} e^{-(1-t)x} dx = \frac{1}{1-t} \quad \text{for }t<1
\end{split}
$$

Now let $Y=\frac{X}{\lambda} \sim Exp(\lambda)$ for 
$$
f_Y(y) = f_X(X(y))\frac{dx}{dy} = e^{-\lambda y}\cdot\lambda \sim Exp(\lambda)
$$
or
$$
P(Y\le y) = P(X\le \lambda y) = 1 - e^{-\lambda y} \sim Exp(\lambda).
$$
Hence, we can get

- $E(Y) = E(X/\lambda) = 1/\lambda$
- $Var(Y) = Var(X/\lambda) = 1/\lambda^2$
- MGF (moment generating function):
$$
\begin{split}
  M_Y(t) &= E(e^{tY}) =E(e^{tX/\lambda}) \\
	&= E(e^{\frac{t}{\lambda}X}) = M_X(\frac{t}{\lambda}) = \frac{1}{1-t/\lambda} \\
  &= \frac{\lambda}{\lambda -t} \quad \text{for }t<\lambda
  \end{split}
$$


## Memeoryless Property

Memoryless is something like $P(X \ge s+t ~|~ X \ge s) = P(X \ge t)$, let $X \sim Exp(\lambda)$, then
$$
\begin{split}
P(X \ge s+t ~|~ X \ge s) &= \frac{P(X \ge s+t, ~X \ge s)}{P(X \ge s)} \\
&= \frac{P(X \ge s+t)}{P(X \ge s)} \\
&= \frac{e^{-\lambda (s+t)}}{e^{-\lambda s}} = e^{-\lambda t} \\
&= P(X \ge t)
\end{split}
$$

**Theorem**: If $X$ is a positive continuous r.v. with memoryless property, then $X$ has an *exponential distribution*. Similarly, if $X$ is discrete, then it has a *geometric distribution*.

> Proof idea: use survival function and solve differential equations.

## Examples

**eg.1** $X_1 \sim Exp(\lambda_1), ~X_2 \sim Exp(\lambda_2)$, and $X_1 \perp X_2$. Then $P(X_1 < X_2) = \frac{\lambda_1}{\lambda_1 + \lambda_2}$.

**Proof**: By LOTP (law of total probability),
$$
\begin{split}
P(X_1 < X_2) &= \int_0^{\infty} f_{X_1}(x) P(X_2 > X_1 ~|~ X_1=x) dx \\
&= \int_0^{\infty} f_{X_1}(x) P(X_2 > x ~|~ X_1=x) dx \\
&= \int_0^{\infty} f_{X_1}(x) P(X_2 > x) dx \quad \text{(independence)} \\
&= \int_0^{\infty} \lambda_1 e^{-\lambda_1 x} e^{-\lambda_2 x} dx \\
&= \lambda_1 \int_0^{\infty} e^{-(\lambda_1 + \lambda_2) x} dx \\
&= \frac{\lambda_1}{\lambda_1 + \lambda_2}
\end{split}
$$

**eg.2** $\{X_i\}_{i=1}^n$ are independent with $X_j \sim Exp(\lambda_j)$. Let $L = \min(X_1, \cdots, X_n)$, then $L \sim Exp(\lambda_1 + \cdots \lambda_n)$.

**Proof**:
$$
\begin{split}
P(L > t) &= P\left(\min(X_1,\cdots,X_n) > t\right) \\
&= P(X_1 > t, \cdots, X_n >t) \\
&= P(X_1 > t) \cdots P(X_n >t) \quad \text{indep.} \\
&= e^{-\lambda_1 t}\cdots e^{-\lambda_n t} \\
&= e^{-(\lambda_1 + \cdots \lambda_n)t} \sim Exp\left(\sum_j \lambda_j\right)
\end{split}
$$

The intuition of this result is that if you consider $n$ Poisson processes with rate $\lambda_j$,
- $X_1$ as the waiting time for a green car
- $X_2$ as the waiting time for a red car
- ...

Then $L$ is the waiting time for a car of any color (i.e., any car). So it makes sense, the rate is $\lambda_1 + \cdots + \lambda_n$.

**eg.3** (Difference of two exponetial) Let $X \sim Exp(\lambda)$ and $Y \sim Exp(\mu)$, $X \perp Y$. Then what is the PDF of $Z=X-Y$?

**Solution**:
Recall the story of exponential, one can think of $X$ and $Y$ as waiting times for two independent things. For example,
- $X$ as the waiting time for a red car passing by
- $Y$ as the waiting time for a blue car

If we see a blue car passing by, then the further waiting time for a red car is still distributed as same distribution as $Y$, for the memoryless property of exponential. Likewise, if we see a red car passing by, then the further waiting time is distributed as same as $X$. The further waiting time is somehow what we are interested in, say $Z$.

The above intuition says that, the conditional distribution of $X-Y$ given $X > Y$ is the distribution of $X$, and the conditional distribution of $X-Y$ given $X \le Y$ is the distribution of $-Y$ (or in other words, the conditional distribution of $Y-X$ given $Y \ge X$ is same as the distribution of $Y$).

> To make full use of our intuition, we know that
> - If $X>Y$, which means $Z>0$, then $Z~|~X>Y = X$ a.s. holds, that is
> $$
> \begin{gathered}
> f_Z(z~|~X>Y) = \lambda e^{-\lambda z} \\
> \text{and since }P(X<Y) = 0 \\
> \implies f_Z(z) = f_Z(z~|~X>Y)P(X>Y) \\
> = \frac{\mu}{\lambda + \mu}\lambda e^{-\lambda z}.
> \end{gathered}
> $$
> - If $X < Y$, which means $Z < 0$, then $Z~|~X<Y = -Y$ a.s. holds, that is
> $$
> \begin{gathered}
> f_Z(z~|~X<Y) = f_Y(y(z))\left|\frac{dy}{dz}\right| = \mu e^{\mu z} \\
> \implies f_Z(z) = f_Z(z~|~X<Y)P(X<Y) \\
> = \frac{\lambda}{\lambda + \mu} \mu e^{\mu z}
> \end{gathered}
> $$
>
> However, this is just a sketch. Later we will see how to derivate the form mathematically.

From the above point of view, the PDF of $Z$ had better be discussed by the sign of $Z$. 

- If $Z > 0$, which implies $X > Y\implies P(X < Y) = 0 $, then 

$$
\begin{split}
P(Z > z) &= P(X-Y>z ~|~ X>Y)P(X>Y) + P(Z>z~|~X<Y)P(X<Y) \\
&= P(X>z)P(X>Y) + 0 \quad \text{(memoryless)} \\
&= \frac{\mu}{\lambda + \mu} e^{-\lambda z} \quad \text{(by eg.1)}  \\
\implies f_Z(z) &= \frac{\lambda\mu}{\lambda + \mu} e^{-\lambda z} \quad \text{for }z>0 
\end{split}
$$

- If $Z \le 0$, which implies $X \le Y$, then 

$$
\begin{split}
P(Z < z) &= P(Z<z ~|~ X>Y)P(X>Y) + P(X-Y<z~|~X<Y)P(X<Y) \\
&= 0 + P(Y-X > -z ~|~ Y>X)P(Y>X)  \\
&= P(Y>X)P(Y > -z) \quad \text{(memoryless)}  \\
&= \frac{\lambda}{\lambda + \mu}e^{\mu z} \quad \text{(by eg.1)} \\
\implies f_Z(z) &= \frac{\lambda\mu}{\lambda + \mu}e^{\mu z} \quad \text{for }z<0
\end{split}
$$

Therefore, the PDF of $Z$ has the form
$$
f_Z(z) = \frac{\lambda\mu}{\lambda + \mu} 
\begin{cases}
e^{-\lambda z} &\quad z>0 \\
e^{\mu z} &\quad z<0
\end{cases}
$$

> Note: $P(X=Y)=0$ since the integral domain is a line ($y=x$) whose measure is 0. That is $P(Z=0) = 0$. This is why we can give no care of the case $X=Y$.

