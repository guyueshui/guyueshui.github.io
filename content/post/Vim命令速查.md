---
title: Vim Quick Reference
date: 2018-12-20 19:17:54
categories: ['Techniques']
tags: ['vim','reference']
---

<font color="red">This article needs polish, do not truely trust it!</font>

Vim is so-called the god of editors, but not so friendly to new users. Today we will cover some techniques and trick of vim, for further reference.

<!-- more -->

## General Pattern

A vim operation consists of three parts, namely
```
[OPERATOR][NUMBER][MOTION]
```

where

- `OPERATOR` - what you want to do? This mainly covers copy, cut, paste, etc.
- `NUMBER` - how many times do you want? It's nothing but repeating the operation `NUMBER` times, and it's **optional**.
-	`MOTION` - where do you want to go? This point out the scope where the `OPERATOR` applies.

> Note: order does not matter sometimes.

## Operators

### Copy, Cut, Paste

- v - visual mode, now you can select what you want
- V - visual in line, this is extremely useful when you want to copy a line, just `V`+`y`!
- y - yank, like <kbd>Ctrl</kbd>+<kbd>C</kbd>, copy the selected text to clipboard (`"`)
	> - `yy`: copy current line
	> - `5yy`: copy 5 lines below
	> - `y`+`MOTION`: copy the motion scope
	>	 + `y0`: copy from here to BOL (beginning of line)
	>	 + `y$`: copy from here to EOL
	>	 + `y4G`: copy from here to line 4
	>	 + `y?bar`: copy from here to previous occurrence of `bar`
- d - delete & yank, not only delete, but also yank
- p - paste after the cursor
- P - paste before the cursor

### Edit

- i - insert
- a - insert after the cursor
- o - insert a line below and insert
- O - insert a line above and insert
- r - replace, replace the character inplace
- x - delete current character
- s - delete the character and insert
- u - recall the last command
- `^r` - recall the last recall, namely redo
- `.` - repeat the last command

> Note: all deleted things were automatically yanked in buffers, i.e., register `"`

## Motions

### Basic

- h - move left
- l - move right
- j - move down
- k - move up
	> Note: view `(h, l)` and `(j, k)` as pairs
- G - jump to EOF (end of file)
- gg - jump to BOF
- `x` + (gg | G) - jump to line `x` (must be a valid line number)

Some additional movements:

- w - next word, points to the first letter
- b - back, previous word, points to the first letter
- e - end, jump to the end of the word
<br />
- `%` - find the bracket matches (`( )`,`{ }`, `[ ]`...)
<br />
- `^e` - scroll down
- `^y` - scroll up
- `^d` - half-screen down
- `^u` - half-screen up
<br />
- `*` - jump to next occurrence of current word
- `#` - jump to previous occurrence of current word

> Note: view `(w, b)` as a pair

### Inline movement

- `^`: jump to the first character which is not a blank (space, tab, `\n`, `\r`)
- `g_`: jump to the last character which isn't a blank
<br />
- `0`: jump to the beginning
- `$`: jump to the end
<br />
- f`x`: find next `x` in current line
	> Note: you can use `;`(alongside) and `,`(reverse side) to repeat this in two directions
- F`x`: find previous `x` in current line
	> Note: same rules can be applied
<br />
- t`x`: find next `x` and move 1 backward
- T`x`: find previous `x` and move 1 backward

![Image adapted from REF3](https://i0.wp.com/yannesposito.com/Scratch/img/blog/Learn-Vim-Progressively/line_moves.jpg?zoom=2)

-------------------

## Commands

### Search & Replace

- `/keyword` - search `keyword` after the cursor
- `?keyword` - search	`keyword` before the cursor
	> Note: use `n`(search next) or `N`(search previous) for quick search
- `:{search_scope}s/{target}/{replace}/{replace_flag}` - replace `{target}` to `{replace}`
	> - `s` stands for substitute.
	> - `:%s/a/b/g`: global (`%`) search `a`, replace it to `b` at every (`g`) occurrence
	> - `:%s/a/b/gc`: interact with every replace

**More detail**

It has a general pattern:
```
:[range]s/from/to/[flags]
```
The default range is current line. See some examples:

- `:1,10s/from/to` - search and replace between line 1 and 10 (included)
- `:10s/from/to/` - search and replace only in line 10
- `:%s/from/to/` - in global scope

`flags` can be
- g: replace all matches in whole line w/o confirmation
- c: confirm before replace
- i: ignore lower/upper case
- e: ignore error

Note that flags can be combined together, e.g., `:%s/from/to/gc` means search and replace in global and ask for confirmation before each replacement.

**Use regular expression**

| Meta character | Explanation                                  |
| :------------: | -------------------------------------------- |
|      `.`       | Matches any character                        |
|    `[abc]`     | Matches any char from the list               |
|    `[^abc]`    | Matches any char except from the list        |
|      `\d`      | Matches numers == `[0-9]`                    |
|      `\D`      | Opposite to above == `[^0-9]`                |
|      `\x`      | Matches hex numbers == `[0-9A-Fa-f]`         |
|      `\X`      | Opposite to above == `[^0-9A-Fa-f]`          |
|      `\l`      | Matches lower case letters == `[a-z]`        |
|      `\L`      | opposite to above == `[^a-z]`                |
|      `\u`      | Matches upper case letters == `[A-Z]`        |
|      `\U`      | Opposite to above == `[^A-Z]`                |
|      `\w`      | Matches alphanumeric chars == `[0-9A-Za-z_]` |
|      `\W`      | Opposite to above == `[^0-9A-Za-z_]`         |
|      `\t`      | Matches `<TAB>`                              |
|      `\s`      | Matches space == `[\t]`                      |
|      `\S`      | Opposite to above                            |

Special characters need to be escaped. Some of them are `.[]\*/`, if you want to match some of them, put the backslash "\" ahead. For example: `* -> \*`.

There are also some special form to express how much do you expect to match the specific pattern.

| Meta char | Explanation         |
| :-------: | ------------------- |
|    `*`    | match >= 0 times    |
|   `\+`    | match >= 1 times    |
|   `\?`    | match 0 or 1 time   |
| `\{n,m}`  | match n<=x<=m times |
|  `\{n}`   | match n times       |
|  `\{n,}`  | match >= n times    |
|  `\{,m}`  | match <= m times    |

Also, some postional characters.

| Meta char | Explanation       |
| :-------: | ----------------- |
|    `$`    | end of line       |
|    `^`    | beginning of line |
|   `\<`    | beginning of word |
|   `\>`    | end of word       |

Some examples:
- remove the spaces of eol: `%s/\s+$//g`
- remove spaces of bol: `%s/^\s*//` or `%s/^ *//`
- delete empty line: `%s/^$//` or `g/^$/d`
- delete lines with `<space>` or `<tab>` as beginning: `%s/^[ |\t]*$//` or `g/^[ |\t]*$/d`

Note that pattern in regex scoped by `\(<pattern>\)` can be refered as `\1`, `\2`, etc. in the latter statement. For example, I want to replace every "abc...xyz" to "xyz...abc", just write like this 
```
%s/\(abc\)\(.*\)\(xyz\)/\3\2\1/g
```

-------------------

## Advanced Tricks

### Auto Complete

In insert mode, press `^p`, vim will give you a list of all words you have typed, kind of auto complete.

![Image adapted from REF3](https://i2.wp.com/yannesposito.com/Scratch/img/blog/Learn-Vim-Progressively/completion.gif?zoom=2)

### Markers

-	`:marks` - list of marks
- `mk` - mark current position (can use a-z)
	> also known as `:mark k`
- `'k` - move to mark k
- `d'k` - delete from current position to mark k
- `'a-z` - same file
- `'A-Z` - between files

> A straight tick `'` refers to the line, use a backtick `` ` `` to also include the column, see [here][foo].

**It seems that the marker `.` will mark the last edit position, so if you open your last edited file again, `` `. `` will take you to that position!** 

### Block Editing

One of the magic of vim is block editing. Just press `^V` to enter block mode. Then select some block you are interested, then make some modifications. Finally press `Esc`, then those modifications you have just made will be applied onto every line of the block.

See this magic:

1. `^` jump to BOL
2. `^V` enter block mode
3. `4j` move 4 lines down
4. `I` enter insert mode and add something
5. `Esc` to see the effect

![Image adapted from REF3](https://i1.wp.com/yannesposito.com/Scratch/img/blog/Learn-Vim-Progressively/rectangular-blocks.gif?zoom=2)

Additionally, you can

1. `^v/v/V` enter visual mode
2. `J` joint them into one line
2. `<` or `>` modify indents
2. `=` auto indent (extremely powerful?)

![Image adapted from REF3](https://i1.wp.com/yannesposito.com/Scratch/img/blog/Learn-Vim-Progressively/autoindent.gif?zoom=2)

or

1. `^v` enter block mode
2. select some line
3. `$` jump to EOL
4. `A` append something
5. `Esc` see the effect

![Image adapted from REF3](https://i2.wp.com/yannesposito.com/Scratch/img/blog/Learn-Vim-Progressively/append-to-many-lines.gif?zoom=2)

### Macro Recording

Press `qx`, where `x` is the macro name, will enter macro recording mode, all actions will be recorded, just like a tape recorder. If you don't want to record anymore, press `q` to stop recording.

To replay the record, press `@x`. Moreover, `@@` will replay the last recorded macro.

Summarization:

`qa` - record macro a
`q` - stop recording macro
`@a` - run macro a
`@@` - rerun last run macro

### Clipboard

Vim provides 12 clipboards (registers): `0`, `1`, `2` .. `9`, `a`, `"`. If your vim support system clipboard, there will be two additional register: `+` and `*`. Use `:reg` to see what are in your registers.

For X11 systems, things selected or highlighted will be saved in register `*`, while things yanked or cutted will be saved in register `+`.

> To see whether your vim support system clipboard, type `$ vim --version`

In general, all your copy and paste operations are performed at register `"` by default. To use other register, add a prefix `"6` to your yank or paste commands. For example:
```vim
"6p		" put the buffer in register 6 to file
"8yy		" yank current line to register 8
:put {reg}	" put things in {reg} to file, <=> "{reg}p
```

### Multi-file

-	`:e <file>` - edit `<file>` in new buffer
-	`bnext` - go to the next buffer
-	`bprev` - go previous
-	`bd` - delete a buffer (close a file)
-	`ls` - list all open buffers

**Multi-window**

- `:sp <file>` - split horizontally and open `<file>`
- `:vsp` - split vertically <s>and open filename optionally, same file by default</s>
- `^w` + `h/j/k/l` - focus left/down/up/right window
-	`:close` - close current window (buffer & file)

**Multi-tab**

-	`tabnew <file>` - open `<file>` in new tab, empty file by default
-	`gt` or `:tabnext` - move to the next tab
-	`gT` or `:tabprev` - move to previous
-	`<num>gt` - move to tab number `<num>`
-	`:tabclose` - close the current tab (windows & files)
-	`:tabonly` - close all tabs except for the current one
-	`:tabdo <cmd>` - apply the `<cmd>` to all tabs
	> `tabdo q` will close all tabs

### Spell Check

- `:set spell` - toggle on spell checker
- `:set nospell` - toggle off spell checker
- `]s` - move to next mistake
- `[s` - move tp previous mistake
- `z=` - choose an alternative
- `zg` - add to userdict
- `zw` - remove from userdict


## Reference

1. [Vim操作](https://github.com/ruanyf/articles/blob/master/dev/vim/operation.md)
2. [在 Vim 中优雅地查找和替换](https://harttle.land/2016/08/08/vim-search-in-file.html)
3. [简明 Vim 练级攻略](https://globalinheart.wordpress.com/2011/09/07/%E7%AE%80%E6%98%8E-vim-%E7%BB%83%E7%BA%A7%E6%94%BB%E7%95%A5/)
4. [Vim Cheat Sheet](https://vim.rtorr.com/)
5. [Vim cheatsheet](https://devhints.io/vim)
6. [Vim查找替换及正则表达式的使用](https://tanqisen.github.io/blog/2013/01/13/vim-search-replace-regex/)
