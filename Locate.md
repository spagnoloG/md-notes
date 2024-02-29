# Locate

### Examples of locate command

use whatis/man locate for more info

- `locate --all "passwd"`
- `locate /etc --all "passwd"`
- `locate "passwd" | grep "/etc/"`
- `locate --all "*.conf" | grep resolv`
- `locate --all "*conf" | grep proxychains`
- `locate --all -c "*.conf"` - Count number of files whith provided name / pattern

Use `-i` parameter to search uppercase/lowercase !
