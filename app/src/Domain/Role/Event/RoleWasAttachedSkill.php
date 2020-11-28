<?php
declare(strict_types=1);

namespace Domain\Role\Event;

use Domain\Role\ValueObject\RoleId;
use Domain\Role\ValueObject\SkillId;
use Domain\SharedKernel\Event\Event;

final class RoleWasAttachedSkill extends Event implements RoleEvent
{
    private $roleId;
    private $skillId;

    public function __construct(
        RoleId $roleId,
        SkillId $skillId
    )
    {
        parent::__construct();

        $this->roleId = $roleId;
        $this->skillId = $skillId;
    }

    public function getRoleId(): RoleId
    {
        return $this->roleId;
    }

    public function getSkillId(): SkillId
    {
        return $this->skillId;
    }
}
