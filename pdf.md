# PDF MANIPULATION

### PDFTK
Take individual pages out of pdf
```bash
thinkpad :: ~/Downloads » pdftk Document_2022-08-14_152049.pdf cat 1 output subvencija/karmen_spagnolo.pdf
thinkpad :: ~/Downloads » pdftk Document_2022-08-14_152049.pdf cat 2 output subvencija/brigita_spagnolo.pdf
thinkpad :: ~/Downloads » pdftk Document_2022-08-14_152049.pdf cat 3 output subvencija/darjo_spagnolo.pdf
```

### Pandoc
- `pandoc -o doc.pdf doc.md` - convert md to pdf


### Create a sorted pdf

```bash
#!/bin/bash

files=()

while IFS= read -r file; do
    files+=("$file")
done < <(ls *.pdf | sort -n -t '.' -k1,1)

pdftk "${files[@]}" cat output combined.pdf

echo "All slides have been combined into combined.pdf"
```
