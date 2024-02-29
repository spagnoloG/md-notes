# Curl

## Download any file

- `curl -o <file.extension> <url>` -download with new filename
- `curl -O <url>` - download with original filename
- `curl -X POST/GET/DELETE <url>` - different requests methods

useful flags:

- `-L` - use redirection
- `-H 'key:value'` - add header

- `curl -IL ssrd.io` - get information about server
- `url -vL ssrd.io` - display handshake with a server
