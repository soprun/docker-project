<?php
declare(strict_types=1);

namespace App\Tests;

use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;

final class DefaultTest extends WebTestCase
{
    public function testSomething(): void
    {
        static::assertTrue(true);

        $client = static::createClient();

        $client->request('GET', '/');
        $this->assertEquals(200, $client->getResponse()->getStatusCode());

        $client->request('GET', '/404');
        $this->assertEquals(404, $client->getResponse()->getStatusCode());

    }
}
