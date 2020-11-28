<?php
declare(strict_types=1);

namespace Domain\Role\Model;

class SkillGroup implements SkillGroupInterface
{
    private $id;
    private $name;

    protected function __construct(int $id, string $name)
    {
        $this->id = $id;
        $this->name = $name;
    }

    public static function create(
        int $id,
        string $name
    ): self
    {
        return new self(
            $id,
            $name
        );
    }

    public function id(): int
    {
        return $this->id;
    }

    public function name(): string
    {
        return $this->name;
    }
}
