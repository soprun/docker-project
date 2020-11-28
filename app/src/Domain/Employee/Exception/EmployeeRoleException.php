<?php
declare(strict_types=1);

namespace Domain\Employee\Exception;

use Domain\Employee\Model\Employee;
use Domain\Role\Model\RoleInterface;
use Exception;
use Throwable;

final class EmployeeRoleException extends Exception implements EmployeeException
{
    private $employee;
    private $role;

    public static function alreadyContainsRole(
        Employee $employee,
        RoleInterface $role,
        Throwable $previous = null
    ): self
    {
        $exception = new self(
            sprintf(
                'An error occurred, employee "%s" already contains role "%s".',
                $employee->id()->toString(),
                $role->id()->toString()
            ),
            0,
            $previous
        );

        $exception->employee = $employee;
        $exception->role = $role;

        return $exception;
    }

    public static function doesNotContainRole(
        Employee $employee,
        RoleInterface $role,
        Throwable $previous = null
    ): self
    {
        $exception = new self(
            sprintf(
                'An error occurred, employee "%s" does not contain role "%s".',
                $employee->id()->toString(),
                $role->id()->toString()
            ),
            0,
            $previous
        );

        $exception->employee = $employee;
        $exception->role = $role;

        return $exception;
    }
}
