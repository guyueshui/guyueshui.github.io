---
title: "Brief Introduction to Shell Script"
date: Fri Nov 22 2019
lastmod: 2019-11-22T16:59:46+08:00
categories: [Notes]
tags: [shell]
mathjax: false

---

This article is mainly refered to "The Linux Command Line"[^a]. I just take
some most important things out of the book.

## Expansion

Each time you type a command line and press the <kbd>Enter</kbd> key, bash
performs several processes upon the text before it carries out your command. 
Just look an example:

```bash
[me@linuxbox ~]$ echo *
Desktop Documents ls-output.txt Music Pictures Public Templates Videos
```

Why not display an asterisk? That's **expansion**! `*` *expands* to all files in
current directory.

### Pathname expansion

```bash
[me@linuxbox ~]$ ls
Desktop ls-output.txt Pictures Templates
Documents Music Public Videos

[me@linuxbox ~]$ echo D*
Desktop Documents

[me@linuxbox ~]$ echo *s
Documents Pictures Templates Videos

[me@linuxbox ~]$ echo [[:upper:]]*
Desktop Documents Music Pictures Public Templates Videos

[me@linuxbox ~]$ echo /usr/*/share
/usr/kerberos/share /usr/local/share
```

### Tilde expansion

As you know, `~` has a special meaning of the home directory of current user.

```bash
[me@linuxbox ~]$ echo ~
/home/me

[me@linuxbox ~]$ echo ~foo
/home/foo
```

### Arithmetic expansion

The shell allows arithmetic to be performed by expansion. This allows us to
use the shell prompt as a calculator:

```bash
[me@linuxbox ~]$ echo $((2 + 2))
4

[me@linuxbox ~]$ echo with $((5%2)) left over.
with 1 left over.
```

Note: Arithmetic expansion supports only integers (whole numbers, no 
decimals).

### Brace expansion

```bash
[me@linuxbox ~]$ echo Front-{A,B,C}-Back
Front-A-Back Front-B-Back Front-C-Back
```

Patterns to be brace expanded may contain a leading portion called a
*preamble* and a trailing portion called a *postscript*. The brace expression
itself may contain either a comma-separated list of strings or a range of 
integers or single characters. The pattern may not contain embedded 
whitespace.  Here is an example using a range of integers:

```bash
[me@linuxbox ~]$ echo Number_{1..5}
Number_1 Number_2 Number_3 Number_4 Number_5

[me@linuxbox ~]$ echo {Z..A}
Z Y X W V U T S R Q P O N M L K J I H G F E D C B A

[me@linuxbox ~]$ echo a{A{1,2},B{3,4}}b
aA1b aA2b aB3b aB4b
```

### Command substitution

Command substitution allows us to use the output of a command as an
expansion:

```bash
[me@linuxbox ~]$ echo $(ls)
Desktop Documents ls-output.txt Music Pictures Public Templates Videos

[me@linuxbox ~]$ ls -l $(which cp)
-rwxr-xr-x 1 root root 71516 2012-12-05 08:58 /bin/cp
```

There is an alternative syntax for command substitution in older shell
programs that is also supported in bash . It uses back quotes instead 
of the dollar sign and parentheses:

```bash
[me@linuxbox ~]$ ls -l `which cp`
-rwxr-xr-x 1 root root 71516 2012-12-05 08:58 /bin/cp
```

## Quoting

Usage of single or double quotes in shell commands is confusing for me,
at least. Hey, take a look:

```bash
[me@linuxbox ~]$ echo are you     ok
are you ok

[me@linuxbox ~]$ echo 'are you     ok'
are you     ok

[me@linuxbox ~]$ echo "are you     ok"
are you     ok

[me@linuxbox ~]$ echo The total is $100.00
The total is .00

[me@linuxbox ~]$ echo 'The total is $100.00'
The total is $100.00

[me@linuxbox ~]$ echo "The total is $100.00"
The total is .00
```

Isn't that confusing? Fortunately, the shell provides a mechanism called 
quoting to selectively suppress unwanted expansions.

### Double quotes

If you place text inside double quotes, all the special characters used 
by the shell lose their special meaning and are treated as ordinary 
characters. The exceptions are **$ (dollar sign), \ (backslash), 
and \` (back tick)**.

By default, word splitting looks for the presence of spaces, tabs, and
newlines (linefeed characters) and treats them as delimiters between 
words. This means that unquoted spaces, tabs, and newlines are not 
considered to be part of the text. They serve only as separators. 
The fact that newlines are considered delimiters by the word splitting
mechanism causes an interesting, albeit subtle, effect on command 
substitution. Consider the following:

```bash
[me@linuxbox ~]$ echo $(cal)
February 2012 Su Mo Tu We Th Fr Sa 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29

[me@linuxbox ~]$ echo "$(cal)"
   February 2012
Su Mo Tu We Th Fr Sa
             1 2 3 4
 5  6  7  8  9 10 11
12 13 14 15 16 17 18
19 20 21 22 23 24 25
26 27 28 29
```

In the first instance, the unquoted command substitution resulted in
a command line containing 38 arguments; in the second, the result was a
command line with 1 argument that includes the embedded spaces and
newlines.

### Single quotes

If we need to suppress all expansions, we use single quotes. Here is 
a comparison of unquoted, double quotes, and single quotes:

```bash
[me@linuxbox ~]$ echo text ~/*.txt {a,b} $(echo foo) $((2+2)) $USER
text /home/me/ls-output.txt a b foo 4 me
[me@linuxbox ~]$ echo "text ~/*.txt {a,b} $(echo foo) $((2+2)) $USER"
text ~/*.txt {a,b} foo 4 me
[me@linuxbox ~]$ echo 'text ~/*.txt {a,b} $(echo foo) $((2+2)) $USER'
text ~/*.txt {a,b} $(echo foo) $((2+2)) $USER
```

As we can see, with each succeeding level of quoting, more and more
expansions are suppressed.

## Variables and assignments

- the shell does not care about the type of data assigned to a variable; it treats them all as **strings**.
- in an assignment, there must be **no spaces** between the variable name, the equal sign, and the value.

```bash
a=z                 # Assign the string "z" to variable a.
b="a string"        # Embedded spaces must be within quotes.
c="a string and $b" # Other expansions such as variables can be expanded into the assignment.
d=$(ls -l foo.txt)  # Results of a command.
e=$((5 * 7))        # Arithmetic expansion.
f="\t\ta string\n"  # Escape sequences such as tabs and newlines.
```

## "Here documents"

A here document is an additional form of I/O redirection in which we 
embed a body of text into our script and feed it into the standard input 
of a command. It works like this:

```bash
command << token
text...
token
```

where command is the name of a command that accepts standard input and
token is a string used to indicate the end of the embedded text. For
example, you

```bash
$ cat << _EOF_
heredoc> are you
heredoc> ok?
heredoc> Yes i am.
heredoc> And you?
heredoc> _EOF_
are you
ok?
Yes i am.
And you?
```

Namely, you just use a custom EOF indicator of the input to that command.
So what’s the advantage of using a here document? It’s mostly the same as
echo , except that, by default, single and double quotes within here 
documents lose their special meaning to the shell. Here is a 
command-line example:

```bash
[me@linuxbox ~]$ foo="some text"
[me@linuxbox ~]$ cat << _EOF_
> $foo
> "$foo"
> '$foo'
> \$foo
> _EOF_
some text
"some text"
'some text'
$foo
```

As we can see, the shell pays no attention to the quotation marks. It 
treats them as ordinary characters. This allows us to embed quotes freely within a here document.

If we change the redirection operator from `<<` to `<<-` , the shell will
ignore leading tab characters in the here document. This allows a here
document to be indented, which can improve readability:

```bash
$ cat <<- E_o_F
heredocd> no indent
heredocd>    indent
heredocd>         hiahia
heredocd>         E_o_F
heredocd> E_o_F
no indent
   indent
        hiahia
        E_o_F
```

## Flow control 

### Using `if`

The syntax of if-statement is
```bash
if commands; then
  commands
[elif commands; then
  commands...]
[else
  commands]
fi
```
where commands is a list of commands. This may be a little confusing at
first glance, "if" should judge a condition rather than a series of
commands. This leads to the concept of **exit status**.

Commands (including the scripts and shell functions we write) issue a 
value to the system when they terminate, called an exit status. This 
value, which is an integer in the range of 0 to 255, indicates the 
success or failure of the command’s execution. By convention, a value 
of 0 indicates success, and any other value indicates failure. The shell 
provides a parameter that we can use to examine the exit status. Here 
we see it in action: 
```bash
[me@linuxbox ~]$ ls -d /usr/bin
/usr/bin
[me@linuxbox ~]$ echo $?
0
[me@linuxbox ~]$ ls -d /bin/usr
ls: cannot access /bin/usr: No such file or directory
[me@linuxbox ~]$ echo $?
2
```

The shell provides two extremely simple built-in commands that do
nothing except terminate with either a 0 or 1 exit status. The true 
command always executes successfully, and the false command always 
executes unsuccessfully:
```bash
[me@linuxbox ~]$ true
[me@linuxbox ~]$ echo $?
0
[me@linuxbox ~]$ false
[me@linuxbox ~]$ echo $?
1
```

### Using `test`

By far, the command used most frequently with if is `test`. The test 
command performs a variety of checks and comparisons. It has two 
equivalent forms:
```bash
test expression
# or
[ expression ]
```
where "expression" is an expression that is evaluated as either true or 
false. The test command returns an exit status of 0 when the expression 
is true and a status of 1 when the expression is false.

**File expressions**

| Expression        | Is true if...                                                                           |
|-------------------|-----------------------------------------------------------------------------------------|
| `file1 -nt file2` | `file1` is newer than `file2`.                                                          |
| `file1 -ot file2` | `file1` is older than `file2`.                                                          |
| `-d file`         | `file` exists and is a directory.                                                       |
| `-e file`         | `file` exists.                                                                          |
| `-L file`         | `file` exists and is a symbolic link.                                                   |
| `-r file`         | `file` exists and is readable (has readable permission for the effective user).         |
| `-s file`         | `file` exists and has a length greater than zero.                                       |
| `-w file`         | `file` exists and is writable (has writable permission for the effective user).         |
| `-x file`         | `file` exists and is executable (has execute/search permission for the effective user). |

**String expressions**

| Expression           | Is true if...                               |
|----------------------|---------------------------------------------|
| `string`             | `string` is not null                        |
| `-n string`          | the length of `string` is greater than zero |
| `-z string`          | the length of `string` is zero              |
| `string1 == string2` | `string1` and `string2` are equal.          |
| `string1 != string2` | `string1` and `string2` are not equal.      |
| `string1 > string2`  | `string1` sorts after `string2`.            |
| `string1 < string2`  | `string1` sorts before `string2`.           |

Note: the > and < expression must be quoted (or escaped with a backslash)
when used with `test`, oterwise they will be interpreted as the shell
redirection opreators.

**Integer expressions**

| Expression              | Is true if...                                     |
|-------------------------|---------------------------------------------------|
| `integer1 -eq integer2` | `integer1` is equal to `integer2`                 |
| `integer1 -ne integer2` | `integer1` is not equal to `integer2`             |
| `integer1 -le integer2` | `integer1` is less than or equal to `integer2`    |
| `integer1 -lt integer2` | `integer1` is less than `integer2`                |
| `integer1 -ge integer2` | `integer1` is greater than or equal to `integer2` |
| `integer1 -gt integer2` | `integer1` is greater than `integer2`             |

### Modern `test`

Recent versions of bash include a compound command that acts as an
enhanced replacement for `test` . It uses the following syntax:
```bash
[[ expression ]]
```
where expression is an expression that evaluates to either a true or false
result. The [[ ]] command is very similar to test (it supports all of its 
expressions) but adds an important new string expression:
```bash
string =~ regex
```
which returns true if `string` is matched by the extended regular expression
`regex`.

## (( ))-Designed for integers

(( )) is used to perform **arithmetic truth tests**. An arithmetic truth test
results in true if the result of the arithmetic evaluation is non-zero.

```bash
[me@linuxbox ~]$ if ((1)); then echo "It is true."; fi
It is true.
[me@linuxbox ~]$ if ((0)); then echo "It is true."; fi
[me@linuxbox ~]$]
```

## Shell function

Shell functions must be declared before using it. There are two ways to
define a shell function:

```bash
function name {
  commands
  return
}

name () {
  commands
  return
}
```

### Use local variables in shell functions

Local variables are accessible only within the shell function
in which they are defined, and they cease to exist once the shell function
terminates.

```bash
#!/bin/bash

# local-vars: script to demonstrate local variables

foo=0   # global

func1()
{
  local foo=1   # local
  echo "func1 foo = $foo"
}

func2()
{
  local foo=2   # local
  echo "func1 foo = $foo"
}

echo "global foo = $foo"
func1
echo "global foo = $foo"
func2
echo "global foo = $foo"
```

```bash
$ ./local-vars
global foo = 0
func1 foo = 1
global foo = 0
func1 foo = 2
global foo = 0
```

We see that the assignment of values to the local variable foo within
both shell functions has no effect on the value of foo defined outside the
functions.

TO BE CONTINUED...

[1]: https://www.amazon.com/product-reviews/1593279523

[^a]: ["The Linux Command Line, A Complete Introduction"][1], William E. Shotts, Jr.
