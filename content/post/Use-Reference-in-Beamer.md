---
title: 在 Beamer 中使用参考文献
date: 2019-01-03 16:05:47
categories: ['Techniques']
tags: ['latex', 'beamer', '排版']
---

<font color="red">Needs polish!</font>

前略。

Beamer 引用参考文献与文章类似，只是一开始听说 beamer 不支持 `\cite`，搞得我走了不少弯路（其实是可以的）。

<!-- more -->

### 使用 bibtex

假设你有 `mybeamer.tex` 文件，在同目录下新建 `mybeamer.bib` 文件（其实只是纯文本，特殊后缀而已）。将你所有需要引用的文献条目写入该文献中。比如，
```bib
%%% ./mybeamer.bib

@article{shamir2010learning,
  title={Learning and generalization with the information bottleneck},
  author={Shamir, Ohad and Sabato, Sivan and Tishby, Naftali},
  journal={Theoretical Computer Science},
  volume={411},
  number={29-30},
  pages={2696--2711},
  year={2010},
  publisher={Elsevier}
}
```
> Note: 关于 bibtex 引用格式的获取，直接上 [Google Scholar](https://scholar.google.com/) 或者[百度学术](https://xueshu.baidu.com/) 搜所引文题目，导出为 bibtex 格式。

然后在你的 tex 文件中加入
```tex
%%% ./mybeamer.tex

\usepackage{cite}
% Removes icon in bibliography
\setbeamertemplate{bibliography item}[text]
...
\begin{document}
...
%%% end of your presentation slides
\begin{frame}[allowframebreaks]{References}
	%\bibliographystyle{plain}
	\bibliographystyle{amsalpha}
	%\bibliography{mybeamer} also works
	\bibliography{./mybeamer.bib}
\end{frame}
\end{document}
```
> Note: bib 文件可以不于 tex 文件同名，作相应改动即可。

**编译顺序（这很重要）**

首先用`pdflatex`或者`xelatex`编译你的 tex 文件`mybeamer.tex`，
```sh
pdflatex mybeamer.tex
```
这样会在当前目录产生一个`.aux`文件。然后使用`bibtex`编译该文件，
```sh
bibtex mybeamer
```
然后再用`pdflatex`编译一遍。此时应该会出现应用错误，小问号等警告。此时**再用`pdflatex`编译一遍**即可。如果出现了其他错误，删掉所有 `.bbl, .aux` 文件，重复以上操作。

总结一下四个步骤：
1. `pdflatex mybeamer.tex`
2. `bibtex mybeamer`
3. `pdflatex mybeamer.tex`
4. `pdflatex mybeamer.tex`

## References

- [LaTeX/Presentations](https://en.wikibooks.org/wiki/LaTeX/Presentations)
- [LaTeX到底怎么加bib？？ - 知乎](https://www.zhihu.com/question/30344123/answer/53377390)
