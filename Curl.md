---
tags: [linux]
title: Curl
created: '2021-12-05T22:26:06.249Z'
modified: '2021-12-05T23:01:15.615Z'
---

# Curl

### Download any file
- `curl -o <file.extension> <url>` -download with new filename
- `curl -O <url>` - download with original filename

useful flags:
- `-L` - use redirection
- `-H 'key:value'` - add header

- `curl -IL ssrd.io` - get information about server
- `url -vL ssrd.io` - display handshake with a server
