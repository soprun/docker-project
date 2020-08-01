# .PHONY: all docker-up docker-build docker-build-force docker-down

all: success

success:
	@echo Success...

build-php-cli:
	@docker build \
	--build-arg APP_ENV=dev \
	--build-arg APP_DEBUG=1 \
	--file ./docker/php-cli/Dockerfile \
	--tag sandbox/php-cli .

build-php-fpm:
	@docker build \
	--build-arg APP_ENV=dev \
	--build-arg APP_DEBUG=1 \
	--file ./docker/php-fpm/Dockerfile \
	--tag sandbox/php-fpm .

run-php-cli: build-php-cli
	docker run --interactive --tty --rm -v $(pwd):/app sandbox/php-cli bash

run-php-fpm: build-php-fpm
	docker run --interactive --tty --rm -v $(pwd):/app sandbox/php-fpm bash

#build-php-fpm:
#	docker build --progress tty --file ./docker/php-fpm/Dockerfile --tag sandbox/php-fpm:7.4 .
#	docker build --progress tty --file ./docker/php-fpm/Dockerfile --tag sandbox/php-fpm .