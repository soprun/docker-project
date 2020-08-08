<?php

declare(strict_types=1);

use PhpAmqpLib\Connection\AMQPStreamConnection;

require_once __DIR__.'/../../vendor/autoload.php';

try {
    $connection = new AMQPStreamConnection(
        $_ENV['RABBITMQ_HOST'],
        $_ENV['RABBITMQ_PORT'],
        $_ENV['RABBITMQ_USERNAME'],
        $_ENV['RABBITMQ_PASSWORD'],
        $_ENV['RABBITMQ_VHOST']
    );

    $channel = $connection->channel();

    if ($channel->is_open() === true) {
        echo 'Connection success!'.PHP_EOL;
        exit(0);
    }
} catch (Throwable $exception) {
    echo $exception->getMessage();
}

exit(1);
