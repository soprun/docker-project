<?php
declare(strict_types=1);

namespace Domain\Role\Model;

use Domain\Role\ValueObject\SkillId;

class Skill implements SkillInterface
{
    private $id;
    private $name;
    private $group;
    private $split;

    protected function __construct(SkillId $id)
    {
        $this->id = $id;
    }

    public static function create(
        SkillId $id,
        string $name,
        SkillGroupInterface $group
    ): self
    {
        $skill = new self(
            $id
        );
        $skill->name = $name;
        $skill->group = $group;
        // $skill->split = $split;

        return $skill;
    }

    public function id(): SkillId
    {
        return $this->id;
    }

    public function name(): string
    {
        return $this->name;
    }

    public function group(): SkillGroupInterface
    {
        return $this->group;
    }

//    public function allSplit(): array
//    {
//        return $this->split;
//    }
//
//    public function attachSplit(SplitInterface $split): void
//    {
//        $this->split[$split->getId()] = $split;
//    }
//
//    public function detachSplit(SplitInterface $split): void
//    {
//        unset($this->split[$split->getId()]);
//    }
//
//    public function containsSplit(SplitInterface $split): bool
//    {
//        return array_key_exists($split->getId(), $this->split);
//    }
}
