---
title: Linux 相关信息速查
date: 2019-03-07 19:22:02
categories: ['Linux']
tags: ['info','reference']
---

本文主要引用 [Liam Huang](https://liam.page/2016/11/06/Linux-Info-Cheatsheet/) 的博客。

## 系统相关

```bash
lsb_release -a              # 查看操作系统版本
head -n 1 /etc/issue        # 查看操作系统版本
cat /proc/version           # 查看操作系统内核信息
uname -a                    # 查看操作系统内核信息、CPU 信息
cat /proc/cpuinfo           # 查看 CPU 信息
hostname                    # 查看计算机名字
env                         # 列出环境变量
lsmod                       # 列出加载的内核模块
uptime                      # 查看系统运行时间、负载、用户数量
cat /proc/loadavg           # 查看系统负载
```

<!-- more -->

## 内存外存

```bash
free -m                     # 查看物理内存和交换区的使用情况
grep MemTotal /proc/meminfo # 查看内存总量
grep MemFree /proc/meminfo  # 查看空闲内存总量
df -h                       # 查看各分区使用情况
fdisk -l                    # 查看所有分区
swapon -s                   # 查看所有交换分区
hdparm -i /dev/hda          # 查看 IDE 磁盘的参数
dmesg | grep IDE            # 查看系统启动时 IDE 磁盘的状态
mount | column -t           # 查看各分区的挂载状态
du -sh <目录名>              # 查看指定目录的大小
```

## 网络状态

```bash
ifconfig                    # 查看所有网络接口的属性
ip addr show                # 同上
iptables -L                 # 查看 iptables 防火墙
route -n                    # 查看本机路由表
netstat -lntp               # 查看所有监听端口
netstat -antp               # 查看所有已建立的连接
netstat -s                  # 查看网络统计信息
```

## 用户状态相关

```bash
w                           # 查看活动用户以及他们在做什么
who                         # 查看活动用户
id <用户名>                  # 查看用户的 ID、组信息
cut -d: -f1 /etc/passwd     # 查看系统中所有用户
cut -d: -f1 /etc/group      # 查看系统所有组
```

## 进程状态相关

```bash
ps -ef                      # 查看所有进程
ps aux                      # 同上
top                         # 动态显示进程状态
```
