<?php
declare(strict_types=1);

namespace Domain\Role\Model;

use Domain\Role\ValueObject\SkillId;

interface SkillInterface
{
    public function id(): SkillId;

    public function name(): string;

    public function group(): SkillGroupInterface;

    // public function allSplit(): iterable;

    // public function attachSplit(SplitInterface $split): void;

    // public function detachSplit(SplitInterface $split): void;

    // public function containsSplit(SplitInterface $split): bool;
}
