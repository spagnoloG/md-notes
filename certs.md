# CERTS

## Generate self-signed certificate

[creds](https://stackoverflow.com/questions/66604487/how-do-i-generate-fullchain-pem-and-privkey-pem)

```bash
openssl genrsa > privkey.pem
openssl req -new -x509 -key privkey.pem > fullchain.pem
```
