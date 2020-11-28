<?php
declare(strict_types=1);

namespace Domain\Role\Event;

use Domain\Role\ValueObject\RoleId;
use Domain\SharedKernel\Event\Event;

final class RoleNameWasChanged extends Event implements RoleEvent
{
    private $roleId;
    private $name;

    public function __construct(RoleId $roleId, string $name)
    {
        parent::__construct();

        $this->roleId = $roleId;
        $this->name = $name;
    }

    public function getRoleId(): RoleId
    {
        return $this->roleId;
    }

    public function getName(): string
    {
        return $this->name;
    }
}
