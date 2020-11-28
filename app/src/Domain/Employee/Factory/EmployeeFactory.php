<?php
declare(strict_types=1);

namespace Domain\Employee\Factory;

use Domain\Employee\Model\Employee;
use Domain\Employee\Model\EmployeeInterface;
use Domain\Employee\ValueObject\EmployeeId;
use Domain\Role\Model\RoleInterface;

final class EmployeeFactory
{
    public static function createFromRawData(array $rawData, RoleInterface ...$roles): EmployeeInterface
    {
        $employeeData = $rawData['employee_data'];

        $employee = Employee::create(
            new EmployeeId($employeeData['id']),
            ...$roles
        );

        return $employee;
    }
}
