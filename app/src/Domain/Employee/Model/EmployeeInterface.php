<?php
declare(strict_types=1);

namespace Domain\Employee\Model;

use Domain\Employee\ValueObject\EmployeeId;
use Domain\Role\Model\RoleInterface;

interface EmployeeInterface
{
    public function id(): EmployeeId;

    public function allRole(): iterable;

    public function attachRole(RoleInterface $role): void;

    public function detachRole(RoleInterface $role): void;

    public function containsRole(RoleInterface $role): bool;
}
