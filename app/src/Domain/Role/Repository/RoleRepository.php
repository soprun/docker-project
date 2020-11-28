<?php
declare(strict_types=1);

namespace Domain\Role\Repository;

use Domain\Role\ValueObject\RoleId;
use Domain\Role\Model\RoleInterface;

interface RoleRepository
{
    public function findOne(RoleId $id): RoleInterface;

    public function save(RoleInterface $role): RoleInterface;
}
