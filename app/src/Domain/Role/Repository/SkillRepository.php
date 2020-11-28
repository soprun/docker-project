<?php
declare(strict_types=1);

namespace Domain\Role\Repository;

use Domain\Role\Exception\SkillNotFoundException;
use Domain\Role\Model\SkillInterface;
use Domain\Role\ValueObject\SkillId;

interface SkillRepository
{
    /**
     * @param SkillId $id
     * @return SkillInterface
     * @throws SkillNotFoundException
     */
    public function findOne(SkillId $id): SkillInterface;

    public function save(SkillInterface $skill): void;
}
