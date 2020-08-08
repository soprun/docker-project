<?php

declare(strict_types=1);

try {
    $connection = new Redis();

    if ($connection->connect('redis', (int)$_ENV['REDIS_PORT'], 3) === true) {
        echo 'Connection success!'.PHP_EOL;
        exit(0);
    }
} catch (Throwable $exception) {
    echo $exception->getMessage();
}

exit(1);
