<?php
declare(strict_types=1);

namespace Domain\Role\Model;

class SplitType implements SplitTypeInterface
{
    private $id;
    private $name;
    private $priority;

    public function __construct(int $id, string $name, int $priority)
    {
        $this->id = $id;
        $this->name = $name;
        $this->priority = $priority;
    }

    public function id(): int
    {
        return $this->id;
    }

    public function name(): string
    {
        return $this->name;
    }

    public function priority(): int
    {
        return $this->priority;
    }
}
