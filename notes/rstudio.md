# Rstudio

## If it does not launch on wayland:

```bash
export QT_QPA_PLATFORM=xcb
rstudio #if you are on arch or derivative then include "--no-sandbox" flag
```
