# .PHONY: all docker-up docker-build docker-build-force docker-down

all: success

success:
	@echo Success...

build-php-cli:
	@docker build \
	--build-arg app_env=dev \
	--build-arg app_debug=true \
	--file ./docker/php-cli/Dockerfile \
	--tag sandbox/php-cli .

build-php-fpm:
	@docker build \
	--build-arg app_env=dev \
	--build-arg app_debug=true \
	--file ./docker/php-fpm/Dockerfile \
	--tag sandbox/php-fpm \
	.

run-php-cli: build-php-cli
	@docker run --interactive --tty --rm --volume $(pwd):/app sandbox/php-cli bash

run-php-fpm: build-php-fpm
	@docker run --interactive --tty --rm --volume $(pwd):/app sandbox/php-fpm bash

#build-php-fpm:
#	docker build --progress tty --file ./docker/php-fpm/Dockerfile --tag sandbox/php-fpm:7.4 .
#	docker build --progress tty --file ./docker/php-fpm/Dockerfile --tag sandbox/php-fpm .

#SYS_PREFIX := $(shell $(SENTRY_EXE) -c "import sys; print(sys.prefix)")
#
#sentry-cli:
	 @docker pull getsentry/sentry-cli
#	@docker run --rm -v $(pwd):/work getsentry/sentry-cli $(call args,--help)

#.PHONY: container-name
#container-name:
#	echo container-name
#	# docker-compose -p $PROJECT_NAME up -d container-name

build:
	@echo 'RUN build.sh'
	@sh ./docker/build.sh

clean:
	@echo 'RUN clean...'
	@echo 'RUN build.sh'

release:
	@echo 'RUN release...'
	@sh ./docker/build.sh

deploy:
	@echo 'RUN build.sh'
	@sh ./docker/deploy.sh


composer:
	@docker-compose exec -T app composer install

check:
	@docker-compose exec -T app php bin/console security:check

down:
	@docker-compose down --volumes
	@make -s clean

#clean:
	@#docker system prune --volumes --force

#all:
#	@make -s build
#	@make -s composer
#	@make -s database
#	@make -s test
#	@make -s down
#	@make -s clean

.PHONY: docker-list
container_list_format := 'table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'

docker-list:
	@docker container list --format $(container_list_format)

docker-port:
	@docker container list --filter publish=80-443 --format $(container_list_format)
