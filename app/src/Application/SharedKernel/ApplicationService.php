<?php
declare(strict_types=1);

namespace Application\SharedKernel;

use Application\SharedKernel\Exception\ApplicationServiceException;
use Domain\SharedKernel\Exception\DomainCoreException;

interface ApplicationService
{
    /**
     * @param ApplicationRequest|null $request
     * @return mixed
     * @throws ApplicationServiceException
     * @throws DomainCoreException
     */
    public function execute(?ApplicationRequest $request);
}
