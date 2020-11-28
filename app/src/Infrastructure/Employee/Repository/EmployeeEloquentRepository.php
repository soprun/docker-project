<?php
declare(strict_types=1);

namespace Infrastructure\Employee\Repository;

use App\RoleUser;
use Domain\Employee\Exception\EmployeeNotFoundException;
use Domain\Employee\Model\Employee;
use Domain\Employee\Model\EmployeeInterface;
use Domain\Employee\Repository\EmployeeRepository;
use Domain\Employee\ValueObject\EmployeeId;
use Infrastructure\Employee\Identity\IdentificationProvider;
use RuntimeException;
use Throwable;
use function count;

final class EmployeeEloquentRepository implements EmployeeRepository
{
    protected $identificationProvider;

    public function __construct(IdentificationProvider $identificationProvider)
    {
        $this->identificationProvider = $identificationProvider;
    }

    public function findOne(EmployeeId $id): EmployeeInterface
    {
        try {
            $employeeData = $this->identificationProvider->fetch($id->toString());

            if (count($employeeData) === 0) {
                throw new RuntimeException(
                    'An error occurred, an empty response from the provider.'
                );
            }

            return $this->createFromRawData($employeeData);
        } catch (Throwable $exception) {
            throw EmployeeNotFoundException::byIdentifier(
                $id,
                $exception
            );
        }
    }

    private function createFromRawData(array $employeeData): Employee
    {
        /** @var RoleUser[] $roleUser */
        $roleUser = (new RoleUser())->newQuery()
            ->where('user_id', $employeeData['id'])
            ->get();

        $roles = [];

        foreach ($roleUser as $item) {
            $roles[] = $item->role;
        }

        $employee = Employee::create(
            new EmployeeId($employeeData['id']),
            ...$roles
        );

        return $employee;
    }

    public function findOneAccount(string $account): EmployeeInterface
    {
        try {
            $employeeData = $this->identificationProvider->fetchByAccount($account);

            if (count($employeeData) === 0) {
                throw new RuntimeException(
                    'An error occurred, an empty response from the provider.'
                );
            }

            return $this->createFromRawData($employeeData);
        } catch (Throwable $exception) {
            throw EmployeeNotFoundException::byAccount(
                $account,
                $exception
            );
        }
    }

    public function save(EmployeeInterface $employee): void
    {
        // TODO: Implement save() method.
    }
}
