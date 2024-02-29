## Licesing

Use [this](https://github.com/fsfe/reuse-tool) tool to check for licesing of the code.

To license lets say latex files:

```bash
reuse annotate --copyright "Gasper Spagnolo" --license MIT --style tex --recursive .
```

Check for licenses in the project

```bash
reuse lint
```
