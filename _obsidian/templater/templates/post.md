<%*
let title = tp.file.title
if (title.startsWith("Untitled") || title.startsWith("未命名")) {
	title = await tp.system.prompt("Title");
	await tp.file.rename(title);
} 
_%>

---
title:  <%* tR += title %>
date: <% tp.date.now(format="") %>
keywords: []
categories: []
tags: []
draft: true
mathjax: false

---

<% tp.file.cursor() %>

<!-- more -->
