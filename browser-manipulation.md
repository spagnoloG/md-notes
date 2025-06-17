## Browser manipulation

### Find all the open tabs in current broser session.

Firstly copy the database as it is probably locked by the browser and it cannot be accessed otherwise.

```bash
cp ~/.config/BraveSoftware/Brave-Browser/Default/History /tmp/History-copy
```

Then perform (filtered) SQL query on the copied database:

```bash
sqlite3 /tmp/History-copy \
"SELECT url, title FROM urls WHERE url LIKE '%sharepoint%' ORDER BY last_visit_time DESC LIMIT 20;"
```
