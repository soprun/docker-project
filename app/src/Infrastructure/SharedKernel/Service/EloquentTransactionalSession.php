<?php
declare(strict_types=1);

namespace Infrastructure\SharedKernel\Service;

use Application\SharedKernel\Transactional\TransactionalSession;
use DB;

final class EloquentTransactionalSession implements TransactionalSession
{
    public function executeAtomically(callable $operation)
    {
       return DB::transaction($operation);
    }
}
