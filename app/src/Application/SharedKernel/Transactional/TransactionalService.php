<?php
declare(strict_types=1);

namespace Application\SharedKernel\Transactional;

use Application\SharedKernel\ApplicationRequest;
use Application\SharedKernel\ApplicationService;
use Application\SharedKernel\Exception\TransactionalException;
use Throwable;

final class TransactionalService implements ApplicationService
{
    private $service;
    private $session;

    public function __construct(
        ApplicationService $service,
        TransactionalSession $session
    )
    {
        $this->service = $service;
        $this->session = $session;
    }

    public function execute(?ApplicationRequest $request)
    {
        try {
            return $this->session->executeAtomically(function () use ($request) {
                return $this->service->execute($request);
            });
        } catch (Throwable $exception) {
            throw new TransactionalException($this->service, $request, $exception);
        }
    }
}
