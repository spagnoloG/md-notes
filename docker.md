# Docker

## Nuke docker

```bash

#!/bin/bash

printf "Stopping all containers\n"
docker ps | awk ' {print $1} ' | xargs docker kill

printf "Deleting all containers\n"
docker container ls --filter "status=exited" | awk '{ print $1 }' | xargs docker container rm

printf "Deleting all images\n"
docker image ls | awk '{print $3}' | xargs docker image rm --force
```

## Basic config example

```yml
# docker-compose.yml
version: "3"

services:
  web:
    build: .
    # build from Dockerfile
    context: ./Path
    dockerfile: Dockerfile
    ports:
      - "5000:5000"
    volumes:
      - .:/code
  redis:
    image: redis
```

## Common commands

```bash
# Starts existing containers for a service.
docker-compose start

# Stops running containers without removing them.
docker-compose stop

# Pauses running containers of a service.
docker-compose pause

# Unpauses paused containers of a service.
docker-compose unpause

# Lists containers.
docker-compose ps

# Builds, (re)creates, starts, and attaches to containers for a service.
docker-compose up

# Stops containers and removes containers, networks, volumes, and images created by up.
docker-compose down
```

## Config file reference

### Building

```yml
web:
  # build from Dockerfile
  build: .
  # build from custom Dockerfile
  build:
    context: ./dir
    dockerfile: Dockerfile.dev
  # build from image
  image: ubuntu
  image: ubuntu:14.04
  image: tutum/influxdb
  image: example-registry:4000/postgresql
  image: a4bc65fd
```

### Ports

```yml
ports:
  - "3000"
  - "8000:80" # machine - port : container - port
# expose ports to linked services (not to host)
expose: ["3000"]
```

### Commands

```yml
# command to execute
command: bundle exec thin -p 3000
command: [bundle, exec, thin, -p, 3000]

# override the entrypoint
entrypoint: /app/start.sh
entrypoint: [php, -d, vendor/bin/phpunit]
```

### Environment variables

```yml
# environment vars
environment:
  RACK_ENV: development
environment:
  - RACK_ENV=development

# environment vars from file
env_file: .env
env_file: [.env, .development.env]
```

### Dependencies

```yml
# makes the `db` service available as the hostname `database`
# (implies depends_on)
links:
  - db:database
  - redis

# make sure `db` is alive before starting
depends_on:
  - db
```

### Other options

```yml
# make this service extend another
extends:
  file: common.yml # optional
  service: webapp
volumes:
  - /var/lib/mysql
  - ./_data:/var/lib/mysql
```

## Advanced features

### Labels

```yml
services:
  web:
    labels:
      com.example.description: "Accounting web app"
```

### DNS servers

```yml
services:
  web:
    dns: 8.8.8.8
    dns:
      - 8.8.8.8
      - 8.8.4.4
```

### Devices

```yml
services:
  web:
    devices:
      - "/dev/ttyUSB0:/dev/ttyUSB0"
```

### External links

```yml
services:
  web:
    external_links:
      - redis_1
      - project_db_1:mysql
```

### Hosts

```yml
services:
  web:
    extra_hosts:
      - "somehost:192.168.1.100"
```

### Network

```yml
# creates a custom network called `frontend`
networks:
  frontend:
```

### External network

```yml
# join a preexisting network
networks:
  default:
    external:
      name: frontend
```

### Problmes with UFW on VPS?

Well this comes with experience iguess. I once disabled all traffic, but the ssh and https using UFW
,but did not know that docker fucks up iptables and bypasses ufw. So I left
the database open...

So there is thankfully a [workadound](https://github.com/chaifeng/ufw-docker/blob/master/README.md#solving-ufw-and-docker-issues),

basically add this segment to file `/etc/ufw/after.rules`.

```bash
# BEGIN UFW AND DOCKER
*filter
:ufw-user-forward - [0:0]
:ufw-docker-logging-deny - [0:0]
:DOCKER-USER - [0:0]
-A DOCKER-USER -j ufw-user-forward

-A DOCKER-USER -j RETURN -s 10.0.0.0/8
-A DOCKER-USER -j RETURN -s 172.16.0.0/12
-A DOCKER-USER -j RETURN -s 192.168.0.0/16

-A DOCKER-USER -p udp -m udp --sport 53 --dport 1024:65535 -j RETURN

-A DOCKER-USER -j ufw-docker-logging-deny -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -d 192.168.0.0/16
-A DOCKER-USER -j ufw-docker-logging-deny -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -d 10.0.0.0/8
-A DOCKER-USER -j ufw-docker-logging-deny -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -d 172.16.0.0/12
-A DOCKER-USER -j ufw-docker-logging-deny -p udp -m udp --dport 0:32767 -d 192.168.0.0/16
-A DOCKER-USER -j ufw-docker-logging-deny -p udp -m udp --dport 0:32767 -d 10.0.0.0/8
-A DOCKER-USER -j ufw-docker-logging-deny -p udp -m udp --dport 0:32767 -d 172.16.0.0/12

-A DOCKER-USER -j RETURN

-A ufw-docker-logging-deny -m limit --limit 3/min --limit-burst 10 -j LOG --log-prefix "[UFW DOCKER BLOCK] "
-A ufw-docker-logging-deny -j DROP

COMMIT
# END UFW AND DOCKER
```

## Best flag for debugging dockerfile

`docker compose --verbose up --build`
But do not fuck up the order of the arguments!

## Composing dockerfiles

### Postgres dockerfile with init script

```dockerfile
FROM postgres:16.1-bookworm

COPY scripts/* /docker-entrypoint-initdb.d/
```

```docker-compose
  postgres:
    build:
      context: postgres
      dockerfile: Dockerfile
    env_file:
      - .postgres.env
    volumes:
      - ./data/pgdata:/var/lib/postgresql/data
```

file: .postgres.env

```text
POSTGRES_DB=postgresdb
POSTGRES_USER=postgresuser
POSTGRES_PASSWORD=postgrespass
```

### Mysql dockerfile with init script

```dockerfile
FROM mysql:8.0.31

ADD ./scripts/* /docker-entrypoint-initdb.d/
```

```docker-compose
  mysql:
    image: mysql:8.2.0
    env_file:
      - .mysql.env
    volumes:
      - ./data/mysql:/var/lib/mysql
```

file: .mysql.env

```text
MYSQL_DATABASE=mysqldb
MYSQL_USER=mysqluser
MYSQL_PASSWORD=mysqlpass
MYSQL_ROOT_PASSWORD=mysqlpass
```

### Containerize a script

```dockerfile
FROM python:3.10-bookworm

WORKDIR /app

COPY requirements.txt .

RUN python -m venv $VENV_PATH
ENV PATH="$VENV_PATH/bin:$PATH"

RUN pip install --no-cache-dir -r requirements.txt

COPY main.py .

CMD ["bash", "-c", "while true; do python main.py; sleep 30; done"]
```

```docker-compose
  pythonml:
    build:
      context: pythonml
      dockerfile: Dockerfile
    volumes:
      - ./data/pythonml:/app/predictions
    environment:
      - POSTGRES_HOST=postgres
      - MYSQL_HOST=mysql
    env_file:
      - .postgres.env
      - .mysql.env
    depends_on:
      - postgres
      - mysql
```

## Jupyter notebook

```dockerfile
FROM python:3.11.1-bullseye

ENV JUPYTER_DIR=/jupyter-data
ENV JUPYTER_PASSWORD=supersecurepassword
ENV VENV_PATH=/opt/venv

RUN python -m venv $VENV_PATH
ENV PATH="$VENV_PATH/bin:$PATH"

RUN pip install mysql-connector-python==8.0.31 jupyter==1.0.0 pandas==1.5.2

EXPOSE 8888

ENTRYPOINT jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser --NotebookApp.token=${JUPYTER_PASSWORD} --allow-root --notebook-dir=${JUPYTER_DIR}
```

```docker-compose
  jupyter:
    build:
      context: ./jupyter
    ports:
      - 666:8888
    environment:
      - JUPYTER_DIR=/jupyter-data
      - JUPYTER_PASSWORD=bejba123
    volumes:
      - ./notebooks:/jupyter-data
    networks:
      - ids-network
```
