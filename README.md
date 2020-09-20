# PHP project using docker containers - sandbox
[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Fsoprun%2Fdocker-project.svg?type=shield)](https://app.fossa.com/projects/git%2Bgithub.com%2Fsoprun%2Fdocker-project?ref=badge_shield)

---

- [ ] https://github.com/devilbox/docker-php-fpm
- [ ] https://github.com/bsramin/dch-project-sample


...

## Running

...

# 3-tier application architecture


https://benebsworth.com/kubernetes-cicd-part-1/

----
https://github.com/galexrt/docker-nginx-php-fpm

---

client-tier
app-tier
database-tier

---

https://github.com/symbiote/docker-project/blob/master/du.sh

---

https://searchsoftwarequality.techtarget.com/definition/3-tier-application
http://www.inanzzz.com/index.php/post/0e95/copying-symfony-application-into-docker-container-with-multi-stage-builds
https://github.com/jtreminio/php-docker
https://github.com/wodby/php/blob/master/7/Dockerfile
https://hub.docker.com/r/nasqueron/php-cli/dockerfile
https://tecadmin.net/tutorial/docker-run-static-website
https://github.com/soleo/wordpress/blob/master/php7.2/fpm-alpine/Dockerfile
https://github.com/nunomaduro/phpinsights
https://phpinsights.com/ide.html#supported-ide



https://github.com/evertramos/docker-wordpress


- [ ] https://github.com/FiloSottile/mkcert

## Containers

- **nginx** : ...
- **php-fpm**: Run PHP Web Application
- **php-cli**: Run PHP CLI Application
- **php-queued-jobs**: Simple Queue Service (SQS) - 
- **php-sqs-runner**: ...
- **selenium**: ...
- **mailhog**: ...
- **postgres**: ...
- **rabbitmq**: ...
- **rabbitmq-management**: ...
- **redis**: ...
- **elastic**: ...


## Debug & message logging.

[Severity_levels](https://en.wikipedia.org/wiki/Syslog#Severity_levels)

| Debug level | Description |
| --- | --- |
| `emergency` | Emergency events. |
| `alert` | Events for which action must be taken immediately. |
| `critical` | Critical conditions. |
| `error` | Runtime errors that do not require immediate action. |
| `warning` | Exceptional occurrences that are not errors. |
| `notice` | Normal but significant events. |
| `info` | Interesting events |
| `debug` | Detailed debug information. |

## What are `/dev/stdout` and `/dev/stdin`?

| Standard streams | Description |
| --- | --- |
| `/dev/stdin` | Стандартный поток ввода. |
| `/dev/stdout` | Стандартный поток вывода. |
| `/dev/stderr` | Стандартный поток ошибок. |


# Updating our containers

### Stop the container
Firstly, stop the container.

```bash
docker stop <container_name>
```

## Remove the container
Once the container has been stopped, remove it.

```bash
docker rm <container_name>
```

## Pull the latest version
Now you can pull the latest version of the application image from Docker Hub.

```bash
docker pull linuxserver/<image_name>
```

## Recreate the container
Finally, you can recreate the container.

```bash
docker create \
  --name=<container_name> \
  -v <path_to_data>:/config \
  -e PUID=<uid> \
  -e PGID=<gid> \
  -p <host_port>:<app_port> \
  linuxserver/<image_name>
```

## Docker Compose
It is also possible to update a single container using Docker Compose:

```bash
docker-compose pull linuxserver/<image_name>
docker-compose up -d <container_name>
```

Or, to update all containers at once:

```bash
docker-compose pull
docker-compose up -d
```

## Removing old images
Whenever a Docker image is updated, a fresh version of that image gets downloaded and stored on your host machine.

```bash
docker image prune
```

# Volumes

# User / Group Identifiers

In this instance `PUID=1000` and `PGID=1000`, to find yours use id user as below:

```bash
id username
uid=1000(dockeruser) gid=1000(dockergroup) groups=1000(dockergroup)
```

# Logger

Shell access whilst the container is running:
```bash
docker exec -it <container_name> /bin/bash
```

To monitor the logs of the container in realtime:
```bash
docker logs -f <container_name>
```


## Restarting proxy container

```bash
docker exec -it <container_name> nginx -s reload
```


---


SAPI
PHP on Debian/Ubuntu is divided by version and Server Application Programming Interface. A SAPI is the context in which PHP is run. The most common are:

cli - when running on the command line
fpm - when fulfilling a web request via fastcgi
apache2 - when run in Apache's mod-php

---

Now you'll be able to see any PHP error logs as part of the docker container log stream:
```bash
docker logs -f <container_name>
```

To display only errors and hide the access log, you can pipe stdout to /dev/null:
```bash
docker logs -f <container_name> >/dev/null
```

To follow only the access log, you can pipe stderr to /dev/null:
```bash
docker logs -f <container_name> 2>/dev/null
```

https://olvlvl.com/2019-06-install-php-ext-source

https://github.com/EugenMayer/docker-sync

https://github.com/castlemilk/kubernetes-cicd

## License
[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Fsoprun%2Fdocker-project.svg?type=large)](https://app.fossa.com/projects/git%2Bgithub.com%2Fsoprun%2Fdocker-project?ref=badge_large)
=======
