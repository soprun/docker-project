<?php
declare(strict_types=1);

namespace Domain\Role\Event;

use Domain\Role\ValueObject\RoleId;
use Domain\SharedKernel\Event\Event;

final class RoleWasCreated extends Event implements RoleEvent
{
    private $roleId;

    public function __construct(RoleId $roleId)
    {
        parent::__construct();

        $this->roleId = $roleId;
    }

    public function getRoleId(): RoleId
    {
        return $this->roleId;
    }
}
