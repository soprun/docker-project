<?php
declare(strict_types=1);

namespace Domain\Employee\Event;

use Domain\Employee\ValueObject\EmployeeId;
use Domain\Role\ValueObject\RoleId;
use Domain\SharedKernel\Event\Event;

final class EmployeeWasAttachedRole extends Event
{
    private $employeeId;
    private $roleId;

    public function __construct(
        EmployeeId $employeeId,
        RoleId $roleId
    )
    {
        parent::__construct();

        $this->employeeId = $employeeId;
        $this->roleId = $roleId;
    }

    public function getEmployeeId(): EmployeeId
    {
        return $this->employeeId;
    }

    public function getRoleId(): RoleId
    {
        return $this->roleId;
    }
}
