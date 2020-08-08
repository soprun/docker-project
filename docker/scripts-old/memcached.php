<?php

declare(strict_types=1);

try {
    $connection = new Memcached();

    if ($connection->addServer($_ENV['MEMCACHED_HOST'], (int)$_ENV['MEMCACHED_PORT']) === true) {
        echo 'Connection success!'.PHP_EOL;
        exit(0);
    }
} catch (Throwable $exception) {
    echo $exception->getMessage();
}

exit(1);
