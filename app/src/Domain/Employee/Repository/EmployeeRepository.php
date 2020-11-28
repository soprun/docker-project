<?php
declare(strict_types=1);

namespace Domain\Employee\Repository;

use Domain\Employee\Model\EmployeeInterface;
use Domain\Employee\ValueObject\EmployeeId;

interface EmployeeRepository
{
    public function findOne(EmployeeId $id): EmployeeInterface;

    public function findOneAccount(string $account): EmployeeInterface;

    public function save(EmployeeInterface $employee): void;
}
