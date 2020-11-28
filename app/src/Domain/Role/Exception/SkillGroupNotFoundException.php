<?php
declare(strict_types=1);

namespace Domain\Role\Exception;

use Domain\SharedKernel\Exception\NotFoundException;
use Exception;
use Throwable;

final class SkillGroupNotFoundException extends Exception implements NotFoundException
{
    protected $id;

    public static function byId(int $id, Throwable $previous = null): self
    {
        $exception = new self(
            sprintf(
                'An error occurred on ID "%s", the skill group was not found.',
                $id
            ),
            404,
            $previous
        );

        $exception->id = $id;

        return $exception;
    }
}
