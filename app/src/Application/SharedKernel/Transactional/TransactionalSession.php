<?php
declare(strict_types=1);

namespace Application\SharedKernel\Transactional;

interface TransactionalSession
{
    public function executeAtomically(callable $operation);
}
