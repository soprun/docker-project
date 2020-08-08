# PHP project using docker containers - sandbox

...

## Running

...

# 3-tier application architecture

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

## Containers

- **nginx** : ...
- **php-fpm**: Run PHP Web Application
- **php-cli**: Run PHP CLI Application
- **php-queued-jobs**: ...
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
