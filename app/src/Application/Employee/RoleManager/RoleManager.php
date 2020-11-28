<?php
declare(strict_types=1);

namespace Application\Employee\RoleManager;

use Domain\Employee\Repository\EmployeeRepository;
use Domain\Employee\ValueObject\EmployeeId;
use Domain\Role\Repository\RoleRepository;
use Domain\Role\ValueObject\RoleId;

final class RoleManager implements RoleManagerInterface
{
    private $employeeRepository;
    private $roleRepository;

    public function __construct(
        EmployeeRepository $employeeRepository,
        RoleRepository $roleRepository
    )
    {
        $this->employeeRepository = $employeeRepository;
        $this->roleRepository = $roleRepository;
    }

    public function attachRole(RoleManagerRequest $request): void
    {
        $employee = $this->employeeRepository->findOne(
            EmployeeId::create($request->getEmployeeId())
        );

        foreach ($request->getRolesIds() as $id) {
            $role = $this->roleRepository->findOne(
                RoleId::create($id)
            );

            $employee->attachRole($role);
        }

        $this->employeeRepository->save($employee);
    }

    public function detachRole(RoleManagerRequest $request): void
    {
        $employee = $this->employeeRepository->findOne(
            EmployeeId::create($request->getEmployeeId())
        );

        foreach ($request->getRolesIds() as $id) {
            $role = $this->roleRepository->findOne(
                RoleId::create($id)
            );

            $employee->detachRole($role);
        }

        $this->employeeRepository->save($employee);
    }

    public function overwriteRole(RoleManagerRequest $request): void
    {
        $employee = $this->employeeRepository->findOne(
            EmployeeId::create($request->getEmployeeId())
        );

        foreach ($employee->allRole() as $role) {
            $employee->detachRole($role);
        }

        foreach ($request->getRolesIds() as $id) {
            $role = $this->roleRepository->findOne(
                RoleId::create($id)
            );

            $employee->attachRole($role);
        }

        $this->employeeRepository->save($employee);
    }
}
