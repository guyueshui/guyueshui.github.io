---
title: "Nueral Network Learning Notes"
date: Tue Oct 29 2019
lastmod: 2019-10-29T10:45:03+08:00
keywords: []
categories: [notes]
tags: [cnn]
mathjax: true

---

Hello here.

## CNN

### Conv Layer

Conv Layer is usually decreasing the input size, i.e., the output size may less or equal than input.

- take a volume as input: height x weight x depth, e.g., 32x32x3. Typically think an image having three channels: R, G, B.
- a filter has the same depth as the input volume, e.g., 5x5x3 (since the filter always has a same depth as input vloume, the depth of the filter is sometimes omitted).
- each filter convolving with the input will produce an activation map, two filters will produce two, etc.

The result of the convolution at each location is just a scalar number (the result of taking a dot product between the filter and a small chunk of the image, i.e., $5\times 5 \times 3 = 75$-dimensional dot product + bias: $w^\top x + b$), which totally yields a 2D matrix (called **activation map**) as the filter sliding over the image. For example, 32x32x3 image convolved by 5x5x3 filter will yield a 28x28 activation map.

ConvNet is a sequence of convolution layers, interspersed with activation functions.

Let's find out how the spatial dimensions change (since the depth of input and filter will always match, and then shrinks to 1 in actication map). Suppose we have 7x7 input spatially, 3x3 filter, then we have 5x5 output. If applied with stride 2, then 3x3 output. What about stride 3? Oh, it doesn't fit, you cannot apply 3x3 filter on 7x7 input with stride 3.

Output size: (N-F)/stride + 1 for NxN input, FxF filter.

Take padding into account since it's common to zero pad the border. E.g., 7x7 input, 3x3 filter, applied with stride 1, pad with 1 pixel border, what is the output? Oh, it's 7x7 output! In general, common to see CONV layers with stride 1, filters of size FxF, and zero-padding with (F-1)/2, which will **perserve size spatially**.

Output size: $(N + 2\times padding - F) / stride + 1$.

Train yourself, 32x32x3 input, 10 5x5 filters with stride 1, pad 2, what is the output volume size? Oh, 32x32x10 output! What is the number of parameters in this layer? Oh, $(5 \times 5 \times 3 + 1) \times 10 = 760$, plus 1 for bias.

To summarize, the Conv Layer:

- Accepts a volume of size $W_1 \times H_1 \times D_1$
- Requires four hyperparameters:
  - Number of filters K,
  - their spatial extent F,
  - the stride S,
  - the amount of zero padding P.
- Produces a volume of size $W_2 \times H_2 \times D_2$ where:
  - <font color=#0066ff>$W_2 = (W_1 − F + 2P)/S+1$</font>
  - $H_2 = (H_1−F+2P)/S+1$ (i.e. width and height are computed equally by symmetry)
  - $D_2=K$
- With parameter sharing, it introduces $F\cdot F\cdot D_1$ weights per filter, for a total of $(F\cdot F\cdot D_1)\cdot K$ weights and $K$ biases.
- In the output volume, the $d$-th depth slice (of size $W_2 \times H_2$) is the result of performing a valid convolution of the $d$-th filter over the input volume with a stride of $S$, and then offset by $d$-th bias.

A common setting of the hyperparameters is $F=3,S=1,P=1$. However, there are 
common conventions and rules of thumb that motivate these hyperparameters. 
$F$ is usually odd, $K$ is usually power of 2 for computation efficiency.

### ConvTranspose Layer

ConvTranspose Layer is usually increasing the input size, i.e., the output size is greater or equal than input.

ConvTranspose is also called transposed convolution, deconvolution, etc.
For convenience, we first summarize, the ConvTanspose layer:

- Accepts a volume of size $W_1 \times H_1 \times D_1$
- Requires four hyperparameters:
  - Number of filters K,
  - their spatial extent F,
  - the stride S,
  - the amount of zero padding P.
- Produces a volume of size $W_2 \times H_2 \times D_2$ where:
  - <font color=#0066ff>$W_2 = S(W_1 − 1) + F - 2P$</font>
  - $H_2 = S(H_1−1) + F - 2P$ (i.e. width and height are computed equally by symmetry)
  - $D_2=K$

The following isn't that correct.

Then what on earth does transposed convolution do? In fact, a transposed convolution has an associated convolution with <s>$F \times F$ filter, $1/S$ stride, $(F-P-1)$ padding</s>, here i haven't configured it out. Recall that, the layer requires four parameters while K does not affect the spatial size ($W \times H$).

So if we have a square input volumn of size $I \time I \times D$, and we pass it into an ConvTranspose Layer with parameter (K, F, S, P), then the output has shape:

$$
\begin{split}
  O &= \frac{I + 2(F-P-1) - F}{1/S} + 1 =
\end{split}
$$

### Pooling Layer

- makes the representations smaller and more manageable
- operates over each activation map independently

Intuition of max pooling: select the neuron whose response is maximal.




## References

1. [cs231n winter 2016][1]
2. [cs231n notes][2]
3. [Convolution arithmetic tutorial][3]
4. [conv_arithmetic][4]

[1]: https://www.bilibili.com/video/av71409380/?p=7
[2]: http://cs231n.github.io/convolutional-networks/
[3]: http://deeplearning.net/software/theano_versions/dev/tutorial/conv_arithmetic.html
[4]: https://github.com/vdumoulin/conv_arithmetic
