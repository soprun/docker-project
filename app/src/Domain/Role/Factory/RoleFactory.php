<?php
declare(strict_types=1);

namespace Domain\Role\Factory;

use Domain\Role\Exception\RoleException;
use Domain\Role\Model\Role;
use Domain\Role\Model\RoleInterface;
use Domain\Role\Model\SkillInterface;
use Throwable;

final class RoleFactory
{
    public static function create(string $name, SkillInterface ...$skill): RoleInterface
    {
        try {
            $role = Role::create(
                $name
            );

            foreach ($skill as $item) {
                $role->attachSkill($item);
            }

            return $role;
        } catch (Throwable $exception) {
            throw RoleException::create($exception);
        }
    }
}
