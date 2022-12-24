---
tags: [linux]
title: Compression
created: '2021-11-06T22:08:33.761Z'
modified: '2021-12-31T10:35:51.469Z'
---

# Compression

### Tar archives

- `tar -cf file.tar dir/` -archive using tar, extract `tar -xvf file.tar`
- `sudo tar -czf file.tar.gz dir/` gzip dir

### Gzip
- `gunzip archive.gz`

### Zip archives

- `unzip -x <file.zip> -d <destination_dir>` - unzip
-`zip -r {filename.zip} {foldername}` -zip
- `  zip -r assignment3 assignment3 -x assignment3/images/** -x assignment3/instructions.pdf` - exclude
- ` unzip -l assignment3.zip` - list

### 7zip archives
- `7z x <file.7z>` - unzip

## If you are super lazy

- `binwalk -e -M <file.zip>` - tries different extraction methods and recursively uznips
