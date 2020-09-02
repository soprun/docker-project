<?php

declare(strict_types=1);

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;

final class DefaultController extends AbstractController
{
    public function index(): Response
    {
        try {
            $connection = new PDO(
                "pgsql:host=${_ENV['POSTGRES_HOST']};port=${_ENV['POSTGRES_PORT']};dbname=${_ENV['POSTGRES_DB']}",
                $_ENV['POSTGRES_USERNAME'],
                $_ENV['POSTGRES_PASSWORD']
            );

            if ($connection) {
                echo 'Connection success!'.PHP_EOL;
                exit(0);
            }
        } catch (Throwable $exception) {
            echo $exception->getMessage();
        }

        return new Response('... : ' . time());
    }
}
