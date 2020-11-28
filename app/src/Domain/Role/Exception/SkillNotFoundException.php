<?php
declare(strict_types=1);

namespace Domain\Role\Exception;

use Domain\Role\ValueObject\SkillId;
use Domain\SharedKernel\Exception\NotFoundException;
use Exception;
use Throwable;

final class SkillNotFoundException extends Exception implements NotFoundException
{
    protected $id;

    public static function byId(SkillId $id, Throwable $previous = null): self
    {
        $exception = new self(
            sprintf(
                'An error occurred on ID "%s", the skill was not found.',
                $id->toString()
            ),
            404,
            $previous
        );

        $exception->id = $id;

        return $exception;
    }
}
