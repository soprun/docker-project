<?php
declare(strict_types=1);

namespace Domain\Employee\Exception;

use Domain\Employee\ValueObject\EmployeeId;
use Domain\SharedKernel\Exception\NotFoundException;
use Exception;
use Throwable;

final class EmployeeNotFoundException extends Exception implements EmployeeException, NotFoundException
{
    protected $employeeId;
    protected $account;

    public static function byIdentifier(EmployeeId $employeeId, Throwable $previous = null): self
    {
        $exception = new self(
            sprintf(
                'An error occurred on ID "%s", the employee was not found.',
                $employeeId
            ),
            404,
            $previous
        );

        $exception->employeeId = $employeeId;

        return $exception;
    }

    public static function byAccount(string $account, Throwable $previous = null): self
    {
        $exception = new self(
            sprintf(
                'An error occurred on account "%s", the employee was not found.',
                $account
            ),
            404,
            $previous
        );

        $exception->account = $account;

        return $exception;
    }
}
