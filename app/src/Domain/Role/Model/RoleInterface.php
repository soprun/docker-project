<?php
declare(strict_types=1);

namespace Domain\Role\Model;

use Domain\Role\ValueObject\RoleId;

interface RoleInterface
{
    public function id(): RoleId;

    /**
     * @return string
     * @deprecated use RoleName
     */
    public function name(): string;

    /**
     * @param string $name
     * @deprecated use RoleName
     */
    public function changeName(string $name): void;

    /**
     * @return SkillInterface[]
     */
    public function allSkill(): iterable;

    public function attachSkill(SkillInterface $skill): void;

    public function detachSkill(SkillInterface $skill): void;

    public function containsSkill(SkillInterface $skill): bool;
}
