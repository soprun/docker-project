<?php
declare(strict_types=1);

namespace Domain\Role\Exception;

use Domain\Role\Model\Role;
use Domain\Role\Model\SkillInterface;
use Domain\SharedKernel\Exception\DomainCoreException;
use Exception;
use Throwable;

final class RoleSkillException extends Exception implements DomainCoreException
{
    protected $role;
    protected $skill;

    public static function alreadyContainsSkill(Role $role, SkillInterface $skill, Throwable $previous = null): self
    {
        $exception = new self(
            sprintf(
                'An error occurred, role "%s" already contains skill "%s".',
                $role->id()->toString(),
                $skill->id()->toString()
            ),
            0,
            $previous
        );

        $exception->role = $role;
        $exception->skill = $skill;

        return $exception;
    }

    public static function doesNotContainSkill(Role $role, SkillInterface $skill, Throwable $previous = null): self
    {
        $exception = new self(
            sprintf(
                'An error occurred, role "%s" does not contain skill "%s".',
                $role->id()->toString(),
                $skill->id()->toString()
            ),
            0,
            $previous
        );

        $exception->role = $role;
        $exception->skill = $skill;

        return $exception;
    }
}
