<?php
declare(strict_types=1);

namespace Domain\Role\Exception;

use Domain\SharedKernel\Exception\DomainCoreException;
use Exception;
use Throwable;

final class RoleException extends Exception implements DomainCoreException
{
    public static function create(Throwable $previous = null): self
    {
        $exception = new self(
            'An error occurred while creating the role.',
            0,
            $previous
        );

        return $exception;
    }
}
