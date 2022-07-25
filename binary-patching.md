---
tags: [linux]
title: Binary Patching
created: '2021-12-05T22:45:44.151Z'
modified: '2021-12-05T22:46:14.308Z'
---

# Binary patching
firstly check in ghidra what hex value has function call. then open binary in vim, find that and replace all fucntion hex values with 90
`:%!xxd` and `:%!xxd -r`    

