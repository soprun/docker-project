<?php
declare(strict_types=1);

namespace Domain\SharedKernel\ValueObject;

use function in_array;

abstract class State
{
    protected static $conditions = [];

    private $name;

    public function __construct(string $name)
    {
        $this->name = $name;
    }

    public function currentState(): self
    {
        return $this;
    }

    public function stateIsEqualTo(self $state): bool
    {
        return $this->currentName() === $state->currentName();
    }

    public function currentName(): string
    {
        return $this->name;
    }

    public function stateCanBeChangedTo(self $state): bool
    {
        return in_array($state->name, $this->available(), true);
    }

    public function available(): array
    {
        return static::$conditions[$this->name] ?? [];
    }
}
