# Databases

## MySQL

Connect to MySQL server:

```bash
mysql -h <host> -u <user> -p
# Or example
mysql -h localhost -u root -p
```


## PostgreSQL

Connect to PostgreSQL server:

```bash
psql -h <host> -U <user> -d <database>
# Or example
psql -h localhost -U postgres -d postgres
```

## MongoDB

Connect to MongoDB server:

```bash
mongo <host>:<port>/<database> -u <user> -p <password>
# Or example
mongo localhost:27017/test -u root -p root
```

## Redis

Connect to Redis server:

```bash
redis-cli -h <host> -p <port> -a <password>
# Or example
redis-cli -h localhost -p 6379 -a root
```

## Sqlite

Connect to Sqlite database:

```bash
sqlite3 <database>
# Or example
sqlite3 test.db
```
