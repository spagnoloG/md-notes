# Ripgrep

## Basic Usage

- `rg <pattern>` - Search for a pattern in the current directory and all subdirectories.
- `rg -i <pattern>` - Case insensitive search.
- `rg -w <pattern>` - Search for whole words.

## File Inclusion/Exclusion

- `rg <pattern> -g '*.rs'` - Search only in Rust files.
- `rg <pattern> -g '!*.log'` - Exclude log files from the search.
- `rg --type-add 'web:*.{html,css,js}' -tweb <pattern>` - Search in files with custom type (html, css, js).

## Output Control

- `rg -C 3 <pattern>` - Show 3 lines of context around matches.
- `rg -A 3 <pattern>` - Show 3 lines after the match.
- `rg -B 3 <pattern>` - Show 3 lines before the match.
- `rg --color always <pattern>` - Force color output.

## Advanced Searching

- `rg '(foo|bar)'` - Search for foo or bar using regex.
- `rg -z <pattern>` - Search in compressed (gzip) files.
- `rg --multiline 'foo\nbar'` - Multiline search.
- `rg -uu <pattern>` - Search hidden files and directories, and traverse symlinked directories.

## Performance

- `rg -j4 <pattern>` - Use 4 threads for searching.

## File Types

- `rg --type-list` - List all supported file types.
- `rg -tpy <pattern>` - Search only in Python files.

## Ignoring Files

- `rg --ignore-file .gitignore <pattern>` - Respect ignore patterns listed in a .gitignore file.
- `rg --no-ignore <pattern>` - Ignore .ignore and .gitignore files

## Ignoring Specific Directories

To exclude specific directories from your search, use the `--glob` option with a negation (`!`) pattern. This tells `rg` to ignore files or directories that match the given pattern.

- `rg <pattern> -g '!dir_to_ignore/*'` - Ignore a specific directory.
- `rg <pattern> -g '!dir_to_ignore/**'` - Ignore a specific directory and all its subdirectories.
- `rg <pattern> -g '!{dir1,dir2}/*'` - Ignore multiple specific directories.
- `rg <pattern> -g '!*.ext'` - Ignore files with a specific extension.

### Some in practice examples

```bash
rg -i authorized_keys -g '!/proc/*' -g '!/sys/*' -g '!/dev/*' -g '!/nix/store/*' -j$(nproc) # quickly find all files containg authorized_keys
rg --files -g authorized_keys -g '!/proc/*' -g '!/sys/*' -g '!/dev/*' -g '!/nix/store/*' -j$(nproc) # list all files names containg authorized_keys
```
