<?php

declare(strict_types=1);

namespace App\Controller;

use Memcached;
use PDO;
use Redis;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Throwable;

final class DefaultController extends AbstractController
{
    public function index(): Response
    {
        // echo '<pre>';
        // dd($this->getParameter('debug'));

        try {
            $connection = new PDO(
                "pgsql:host=${_ENV['POSTGRES_HOST']};port=${_ENV['POSTGRES_PORT']};dbname=${_ENV['POSTGRES_DB']}",
                $_ENV['POSTGRES_USERNAME'],
                $_ENV['POSTGRES_PASSWORD']
            );

            if ($connection) {
                echo 'postgres connection success!'.PHP_EOL;
            }
        } catch (Throwable $exception) {
            echo $exception->getMessage();
        }

        try {
            $connection = new Memcached();

            if ($connection->addServer($_ENV['MEMCACHED_HOST'], (int)$_ENV['MEMCACHED_PORT']) === true) {
                echo 'memcached connection success!'.PHP_EOL;
            }
        } catch (Throwable $exception) {
            echo $exception->getMessage();
        }

        try {
            $connection = new Redis();

            if ($connection->connect('redis', (int)$_ENV['REDIS_PORT'], 3) === true) {
                echo 'redis connection success!'.PHP_EOL;
            }
        } catch (Throwable $exception) {
            echo $exception->getMessage();
        }


        return new Response('... : ' . time());
    }
}
