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


## Milvus DB

Milvus is a powerful open-source vector database that is designed to handle large-scale machine learning and deep learning applications. Some of the best use cases for Milvus include:

- Image and Video Search
- Natural Language Processing
- Anomaly Detection
- Recommendation Systems
- Facial Recognition


### Milvus cli

#### Installation

```bash
pip install milvus-cli
```

```
:: fedora > milvis_cli
  __  __ _ _                    ____ _     ___
 |  \/  (_) |_   ___   _ ___   / ___| |   |_ _|
 | |\/| | | \ \ / / | | / __| | |   | |    | |
 | |  | | | |\ V /| |_| \__ \ | |___| |___ | |
 |_|  |_|_|_| \_/  \__,_|___/  \____|_____|___|

Milvus cli version: 0.3.2
Pymilvus version: 2.2.1

Learn more: https://github.com/zilliztech/milvus_cli.


milvus_cli > connect <options> # to connect to the database 
# You can always use the help command to help you craft better
```

The best reference how to use their CLI is their (https://github.com/milvus-io/milvus_cli#commands)[Github] page and not the documentation.
As it is more suitable for rapid development.

### Useful commands

```bash
show collections 
delete collection <coll_name>
describe collection -c <coll_name> 
```
