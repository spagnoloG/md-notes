---
tags: [linux]
title: Locate
created: '2021-10-25T21:52:02.050Z'
modified: '2021-12-09T21:08:10.036Z'
---

# Locate
### Examples of locate command
use whatis/man locate for more info

- `locate --all "passwd"`
- `locate /etc --all "passwd"`
- `locate "passwd" | grep "/etc/"`
- `locate --all "*.conf" | grep resolv`
- `locate --all "*conf" | grep proxychains` 
- `locate --all -c "*.conf"` -  Count number of files whith provided name / pattern

Use `-i` parameter to search uppercase/lowercase !
