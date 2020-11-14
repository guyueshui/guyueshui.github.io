---
title: Matrix Factorization
date: 2019-01-03 21:07:38
categories: ['Notes']
tags: ['math','algebra']
mathjax: true
---

## Preliminaries

**Def**: A matrix $A \in M_n$ is *normal* if $AA^∗ = A^∗A$, that is, if $A$ commutes with its conjugate transpose.

**Def**: A complex matrix $A$ is *unitary* if $AA^∗ = I$ or $A^∗A = I$, and a real matrix $B$ is *orthogonal* if $BB^T = I$ or $B^TB = I$.

![Image adapted from Meyer's book](https://i.loli.net/2019/01/03/5c2e1178ec116.png)

**There is no so-called "orthonormal" matrix. There is just an orthogonal matrix whose rows or columns are orthonormal vectors.**

<!-- more -->

Notice that
$$
\begin{gathered}
U^*U = I \Longleftrightarrow U^{\star}UU^{\star} = IU^{\star} = U^{\star} \\
\Longleftrightarrow UU^{\star} = (U^{\star})^{-1}U^{\star} = I
\end{gathered}
$$
the columns of $U$ are orthonormal if and only if the rows are orthonormal.

So the definition can be summarized as below:

- Hermitian: $A=A^{\star}$
- Unitary: $A^{\star}A=AA^{\star}=I$
- Symmetric: $A = A^{T}$
- Orthogonal: $A^TA=AA^T=I$

## Eigenvalue Decomposition

## Singular Value Decomposition

## $LU$ Factorization

## $QR$ Factorization
