<?php
declare(strict_types=1);

namespace Infrastructure\Employee\Identity;

use function count;
use function sprintf;

final class IdentificationProvider
{
    private $transport;

    public function __construct(IdentificationTransport $transport)
    {
        $this->transport = $transport;
    }

    public function fetchByAccount(string $account): array
    {
        $response = $this->transport->send(
            sprintf('search/ad_employees_by_ad_login?adLogin=%s', $account)
        );

        if (is_countable($response['data']) && count($response['data']) === 0) {
            return [];
        }

        return $response['data'][0];
    }

    public function fetch(string $id): array
    {
        $response = $this->transport->send(
            sprintf('employees/%s', $id)
        );

        return $response['data']['employee_data'];
    }

    public function searchAccount(string $criteria): void
    {
    }
}
