<?php
declare(strict_types=1);

namespace Application\Role\UpdateRoleService;

use Application\SharedKernel\ApplicationRequest;

final class UpdateRoleRequest implements ApplicationRequest
{
    private $roleId;
    private $name;
    private $skill;

    public function __construct(
        string $roleId,
        string $name,
        int ...$skill
    )
    {
        $this->roleId = $roleId;
        $this->name = $name;
        $this->skill = $skill;
    }

    public function getRoleId(): string
    {
        return $this->roleId;
    }

    public function getName(): string
    {
        return $this->name;
    }

    public function getSkill(): array
    {
        return $this->skill;
    }
}
