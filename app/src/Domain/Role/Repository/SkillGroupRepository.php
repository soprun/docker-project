<?php
declare(strict_types=1);

namespace Domain\Role\Repository;

use Domain\Role\Model\SkillGroupInterface;

interface SkillGroupRepository
{
    public function findOne(int $id): SkillGroupInterface;

    public function save(SkillGroupInterface $group): void;
}
