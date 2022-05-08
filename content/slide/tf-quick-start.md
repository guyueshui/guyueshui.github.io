---
title: "Tf Quick Start"
date: 2019-05-05
outputs: ["Reveal"]
layout: "list"
keywords: []
categories: []
tags: []
draft: false
mathjax: false

---

## Introduction to TensorFlow 
A Quick Start

<small>Yychi Fyu @SIST, ShanghaiTech</small>
<!-- .slide: data-background="" -->

---

## Outline

1. TF Primitives
    - tensor
    - graphs
    - session
    - variable
    - placeholder
2. An Example

---

{{% section %}}
### High-level overview

Computation Graph: The structure of TF.
- operators as nodes
- tensors as links

<img src="https://s2.ax1x.com/2019/05/05/Ewocp4.png" width=300 alt="computation graph" />

---

```python
import tensorflow as tf

W = tf.constant([[1, 2]])
x = tf.constant([[3], [4]])
b = tf.constant(5)
y = tf.matmul(W, x) + b
print(y)
```

```
Tensor("add_5:0", shape=(1, 1), dtype=int32)
```
The above codes "describe" a computation graph:
![](https://s2.ax1x.com/2019/05/05/EwLKXQ.png)

---

<big>How can we actually see a `tensor`?</big>

To evaluate a tensor, we need
1. an instance of session created by `tf.Session()`
2. evaluate the tensor at the target session

```python
sess = tf.Session()
y_value = y.eval(session=sess)
print(y_value)
```
```
[[16]]
```
> This is so-called lazy-evaluation!

{{% /section %}}

---

Keep in mind:

1. TF code just "describes" computations and doesn't actually perform it
2. each node is a TF operator
3. each link (edge) transports some tensors

---

{{% section %}}
<!-- .slide: data-transition="concave" -->

### tensors

`tensor` is most fundamental object in TF. Almost all TF operations return the reference of `tensor`.

- rank-0 tensor = scalar
- rank-1 tensor = vector
- rank-2 tensor = matrix

<img src="https://static.packt-cdn.com/products/9781787125933/graphics/B07030_14_01.jpg" width="600" alt="Tensors" />

---

Create constant tensor

```python
import tensorflow as tf
import numpy as np

a = tf.constant(2)          # rank-0
b = tf.constant([1, 2])     # rank-1
c = tf.constant([[1], [2]]) # rank-2
print(a)
print(b)
print(c)
```
```
Tensor("Const_15:0", shape=(), dtype=int32)
Tensor("Const_16:0", shape=(2,), dtype=int32)
Tensor("Const_17:0", shape=(2, 1), dtype=int32)
```
<p class="fragment fade-up">
Mind the shape!
</p>

---

Interactive tensor evaluation

1. Create zeros tensor
```python
>>> tf.zeros(2)
<tf.Tensor 'zeros:0' shape=(2,) dtype=float32>
```
2. Evaluate the value of a tensor
```python
# use `tf.InteractiveSession()` for eager evaluation
>>> tf.InteractiveSession()
>>> a = tf.zeros(2)
>>> a.eval()
array([0., 0.], dtype=float32)
```

---

Tensor addition and scaling

```python
>>> a = tf.ones(shape=(2, 2))
>>> b = tf.fill((2, 2), 2.0)
>>> c = a + b
>>> c.eval()
array([[3., 3.],
       [3., 3.]], dtype=float32)    
```
```python
>>> d = 2 * c
>>> d.eval()
array([[6., 6.],
       [6., 6.]], dtype=float32)    
```
```python
>>> e = c * d           # elem-wise multiplication
>>> f = tf.matmul(c, d) # matrix multiplication
>>> print(e.eval(), f.eval())
[[18. 18.]
 [18. 18.]]
[[36. 36.]
 [36. 36.]]
```

---

Tensor data types

```python
>>> a = tf.ones(2, dtype=tf.int32)
>>> a.eval()
array([1, 1], dtype=int32)
>>> b = tf.cast(a, dtype=tf.float32)
>>> b.eval()
array([1., 1.], dtype=float32)
```

---

Tensor shapes!

```python
a = tf.range(0, 8)             # shape=(8,)
b = tf.expand_dims(a, 0)       # shape=(1,8)
c = tf.expand_dims(a, 1)       # shape=(8,1)
d = tf.reshape(a, shape(4, 2)) # shape=(4,2)
print(a.eval(), b.eval(), c.eval(), d.eval())
```
```
[0 1 2 3 4 5 6 7]
[[0 1 2 3 4 5 6 7]]
[[0]
 [1]
 [2]
 [3]
 [4]
 [5]
 [6]
 [7]]
[[0 1]
 [2 3]
 [4 5]
 [6 7]]
```

{{% /section %}}

---

### Graphs

Any computation in TF is represented as an instance of a `tf.Graph` object.

![](pure-graph.svg)

---

{{% section %}}
### Sessions

A `tf.Session()` object stores the context under which a computation is performed.

- expressions are evaluated at a specific session
- offen use an explicit context instead of a hidden one

---

Use an explicit context
```python
>>> sess = tf.Session()
>>> a = tf.ones(shape=(2, 2))
>>> b = tf.matmul(a, a)
>>> b.eval(session=sess)
array([[2., 2.],
       [2., 2.]], dtype=float32)
```
{{% /section %}}

---

{{% section %}}
### Variables

- Constant tensors are immutable
- We need some mutable tensors

Here comes `tf.Variable()`.

---

Creating a variable is easy enough.
```python
>>> a = tf.Variable(tf.ones(shape=(2, 2)))
>>> a
<tf.Variable 'Variable:0' shape=(2,) dtype=float64_ref>
```

What about to evaluate the variable `a`?
```python
>>> a.eval()
FailedPreconditionError: Attempting to use uninitialized value Variable_1
```
As we said before, TF code just describes computation, a variable should be initialized before using it.

---

How to use a variable? Just initialize it!

```python
>>> sess = tf.Session()
>>> sess.run(tf.global_variables_initializer())
>>> a.eval(session=sess)
array([[1., 1.],
       [1., 1.]], dtype=float32)
```
A variable is mutable, and statful, we can assign a new value to it!

---

Assigning values to variables

```python
>>> sess.run(a.assign(tf.zeros(shape=(2, 2))))
array([[0., 0.],
       [0., 0.]], dtype=float32)
>>> a.eval(session=sess) # `a` is changed
array([[0., 0.],
       [0., 0.]], dtype=float32)
```

<p class="fragment fade-up">
The shape should match!
</p>
{{% /section %}}

---

{{% section %}}
### Placeholders

Since we already have variables, why do we need placeholders?

<p class="fragment fade-up">
A placeholder is a way to input information into a TF computation graph.
</p>

<p class="fragment fade-down">
*"Think of placeholders as the input nodes through which information enters TF."*
</p>

---

- a placeholder is used to feed outside data into the graph
- a variable is initialized inside the graph

<img src="placeholder.png" width=400>

---

- use feed dictionary to feed data into placeholders
- feed dictionary: `tf.Tensor` $\mapsto$ `np.ndarray`

```python
>>> a = tf.placeholder(tf.float32, shape=(1,))
>>> b = tf.placeholder(tf.float32, shape=(1,))
>>> c = a + b
>>> c.eval(session=sess, feed_dict={a: [1.], b: [2.]})
array([3.], dtype=float32)
```
{{% /section %}}

---
<!-- .slide: data-transition="zoom" data-background="#2f2f3f" -->

### Review

1. tensor: basic obejct in TF
2. graph: computation language
3. session: computation context
4. variable: statful and assignable
5. placeholder: "mouth" of graph :)


---

## An Example

Linear Regression

---

{{% section %}}
Use synthetic toy data for the regression task. The data is generated by
$$
y = wx + b + \epsilon,
$$
where $\epsilon \sim N(0,1)$.

---

Generate the data
```python
import tensorflow as tf
import numpy as np
import matplotlib.pyplot as plt
np.random.seed(256)
tf.set_random_seed(256)

# Generating sythetic data
N = 100
w_true = 5
b_true = 2
X = np.random.rand(N, 1)                          # shape=(100, 1)
noise = np.random.normal(scale=0.1, size=(N, 1))
Y = w_true * X + b_true + noise                   # shape=(100, 1)
```
---

Plot the data

<img src="synthetic_data.png" width=600 />

---

Generate TF graph
```python
# Generate tensorflow graph
with tf.name_scope("placeholders"):
    x = tf.placeholder(tf.float32, shape=(N, 1))
    y = tf.placeholder(tf.float32, shape=(N, 1))

with tf.name_scope("weights"):
    W = tf.Variable(tf.constant(4.9)) # shape=() rank-0
    b = tf.Variable(tf.constant(2.1)) # shape=() rank-0

with tf.name_scope("prediction"):
    y_pred = W * x + b # shape=(100, 1)

with tf.name_scope("loss"):
    l = tf.reduce_sum((tf.squeeze(y - y_pred))**2)

with tf.name_scope("optim"):
    train_op = tf.train.AdamOptimizer(.001).minimize(l)

with tf.name_scope("summaries"):
    tf.summary.scalar("loss", l)
    merged = tf.summary.merge_all()

train_writer = tf.summary.FileWriter('/tmp/lr-train', tf.get_default_graph())
```

---

Perform training
```python
# perform training
n_steps = 1000
with tf.Session() as sess:
    # initialization
    sess.run(tf.global_variables_initializer())
    for i in range(n_steps):
        feed_dict = {x: X, y: Y}
        _, summary, loss = sess.run([train_op, merged, l], feed_dict=feed_dict)
        print("step %d, loss: %f" % (i, loss))
        train_writer.add_summary(summary, i)
```
{{% /section %}}

---

<font size='100'>Thank you!</font>