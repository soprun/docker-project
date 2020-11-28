<?php
declare(strict_types=1);

namespace Domain\Role\Event;

use Domain\Role\ValueObject\RoleId;

interface RoleEvent
{
    public function getRoleId(): RoleId;
}
