# GPG

### Create your own GPG signature

```bash
gpg --gen-key
gpg --list-keys #list
```

### Check yubikey status (or any other card management tool)

```bash
gpg --card-status
```

### Move your keys to your yubikey

```bash
gpg --edit-key <key>
gpg> toggle
gpg> keytocard
```

### Delete / export key

```bash
gpg --delete-secret-keys <key>
gpg --export-secret-keys <key> > private-key-backup.asc
```

### Export public key

```bash
gpg --armor --export <key> > public-key.asc
```

### Import private key

```bash
gpg --import private-key-backup.asc
```
