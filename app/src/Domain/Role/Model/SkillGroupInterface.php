<?php
declare(strict_types=1);

namespace Domain\Role\Model;

interface SkillGroupInterface
{
    public function id(): int;

    public function name(): string;
}
