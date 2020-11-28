<?php
declare(strict_types=1);

namespace Application\Role\CreateRoleService;

use Application\SharedKernel\ApplicationRequest;

final class CreateRoleRequest implements ApplicationRequest
{
    private $name;
    private $skill;

    public function __construct(
        string $name,
        int ...$skill
    )
    {
        $this->name = $name;
        $this->skill = $skill;
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
