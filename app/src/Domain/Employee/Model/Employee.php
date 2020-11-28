<?php
declare(strict_types=1);

namespace Domain\Employee\Model;

use Domain\Employee\Event\EmployeeWasAttachedRole;
use Domain\Employee\Event\EmployeeWasDetachedRole;
use Domain\Employee\Exception\EmployeeRoleException;
use Domain\Employee\ValueObject\EmployeeId;
use Domain\Role\Model\RoleInterface;
use Domain\SharedKernel\Model\AggregateRoot;
use function array_key_exists;

final class Employee extends AggregateRoot implements EmployeeInterface
{
    private $id;
    private $roles = [];

    protected function __construct(EmployeeId $id)
    {
        $this->id = $id;
    }

    public static function create(
        EmployeeId $id,
        RoleInterface ...$roles
    ): self
    {
        $employee = new self(
            $id
        );
        $employee->roles = $roles;

        return $employee;
    }

    public function id(): EmployeeId
    {
        return $this->id;
    }

    public function allRole(): iterable
    {
        return $this->roles;
    }

    public function attachRole(RoleInterface $role): void
    {
        if ($this->containsRole($role) === true) {
            throw EmployeeRoleException::alreadyContainsRole($this, $role);
        }

        $this->roles[$role->id()->toString()] = $role;

        $this->raise(
            new EmployeeWasAttachedRole($this->id, $role->id())
        );
    }

    public function containsRole(RoleInterface $role): bool
    {
        return array_key_exists($role->id()->toString(), $this->roles);
    }

    public function detachRole(RoleInterface $role): void
    {
        if ($this->containsRole($role) === false) {
            throw EmployeeRoleException::doesNotContainRole($this, $role);
        }

        unset($this->roles[$role->id()->toString()]);

        $this->raise(
            new EmployeeWasDetachedRole($this->id, $role->id())
        );
    }
}
