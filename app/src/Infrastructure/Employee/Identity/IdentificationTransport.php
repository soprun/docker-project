<?php
declare(strict_types=1);

namespace Infrastructure\Employee\Identity;

use GuzzleHttp\ClientInterface;
use GuzzleHttp\Exception\BadResponseException;
use GuzzleHttp\Exception\GuzzleException;
use GuzzleHttp\RequestOptions;
use Psr\Log\LoggerInterface;
use Symfony\Component\HttpFoundation\Response;

final class IdentificationTransport
{
    private $client;
    private $logger;

    public function __construct(ClientInterface $client, LoggerInterface $logger)
    {
        $this->client = $client;
        $this->logger = $logger;
    }

    public function send(string $uri, array $options = null, string $method = null): array
    {
        $config = [
            RequestOptions::HEADERS => [
                'Accept' => 'application/json',
                'Content-Type' => 'application/json;v=3.0',
            ],
            // RequestOptions::QUERY => [],
            // RequestOptions::JSON => '',

            RequestOptions::VERIFY => true,
            RequestOptions::HTTP_ERRORS => true,
            RequestOptions::ALLOW_REDIRECTS => false,

            RequestOptions::TIMEOUT => 2,
            RequestOptions::READ_TIMEOUT => 5,
            RequestOptions::CONNECT_TIMEOUT => 10,
        ];

        $options = array_merge($config, $options ?? []);
        $method = $method ?? 'GET';

        try {
            $response = $this->client->request($method, $uri, $options);
        } catch (BadResponseException $exception) {
            $response = $exception->getResponse();
        } catch (GuzzleException $exception) {
            throw new IdentificationException(
                'A critical http client error has occurred.',
                400,
                $exception
            );
        }

        $content = $response->getBody()->getContents();
        $content = json_decode($content, true);

        if ($response->getStatusCode() === Response::HTTP_OK) {
            $this->logger->info('IdentificationTransport: successfully', [
                'url' => $uri,
                'options' => $options,
                'method' => $method,
            ]);

            return $content;
        }

        if ($response->getStatusCode() === 404) {
            $this->logger->info('IdentificationTransport: Not found!', [
                'url' => $uri,
                'options' => $options,
                'method' => $method,
            ]);

            throw new IdentificationException(
                'An error occurred, the requested employee was not found!.'
            );
        }

        $this->logger->error('IdentificationTransport: fatal', [
            'url' => $uri,
            'options' => $options,
            'method' => $method,
            'statusCode' => $response->getStatusCode(),
            'content' => $content,
        ]);

        throw new IdentificationException(sprintf(
            'An error occurred while retrieving data from the transport bus, code "%u".',
            $response->getStatusCode()
        ));
    }
}
