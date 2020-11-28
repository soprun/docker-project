<?php

declare(strict_types=1);

namespace App\Controller;

use Psr\Log\LoggerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;

final class DefaultController extends AbstractController
{
    public function index(LoggerInterface $logger): Response
    {
        $logger->info('We are logging!');

        return new Response('lol');
    }
}
