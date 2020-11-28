<?php
declare(strict_types=1);

namespace Application\SharedKernel\Exception;

use Application\SharedKernel\ApplicationRequest;
use Application\SharedKernel\ApplicationService;
use Throwable;
use function get_class;

final class TransactionalException extends \RuntimeException
{
    private $service;
    private $request;

    public function __construct(
        ApplicationService $service,
        ApplicationRequest $request,
        Throwable $previous = null
    )
    {
        parent::__construct(
            sprintf(
                'An error occurred while executing the transaction for the service "%s".',
                get_class($service)
            ),
            0,
            $previous
        );
        $this->service = $service;
        $this->request = $request;
    }

    public function getService(): ApplicationService
    {
        return $this->service;
    }

    public function getRequest(): ApplicationRequest
    {
        return $this->request;
    }
}
