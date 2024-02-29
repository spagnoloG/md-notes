#!/bin/bash

set -eux

for f in `ls notes/*.md`; do
  echo "Processing $f"
  echo "  - [${f##*/}](${f##*/})" >> ./notes/index.md
done
