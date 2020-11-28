<?php
declare(strict_types=1);

namespace Domain\Role\Exception;

use Domain\Role\ValueObject\RoleId;
use Domain\SharedKernel\Exception\NotFoundException;
use Exception;
use Throwable;

final class RoleNotFoundException extends Exception implements NotFoundException
{
    protected $id;

    public static function byId(RoleId $id, Throwable $previous = null): self
    {
        $exception = new self(
            sprintf(
                'An error occurred on ID "%s", the role was not found.',
                $id->toString()
            ),
            404,
            $previous
        );

        $exception->id = $id;

        return $exception;
    }
}
