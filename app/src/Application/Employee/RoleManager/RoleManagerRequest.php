<?php
declare(strict_types=1);

namespace Application\Employee\RoleManager;

final class RoleManagerRequest
{
    private $employeeId;
    private $rolesIds;

    public function __construct(string $employeeId, string ...$rolesIds)
    {
        $this->employeeId = $employeeId;
        $this->rolesIds = $rolesIds;
    }

    public function getEmployeeId(): string
    {
        return $this->employeeId;
    }

    /**
     * @return string[]
     */
    public function getRolesIds(): array
    {
        return $this->rolesIds;
    }
}
