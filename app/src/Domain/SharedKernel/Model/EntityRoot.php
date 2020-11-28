<?php
declare(strict_types=1);

namespace Domain\SharedKernel\Model;

abstract class EntityRoot
{
    protected $id;

    public function __construct(int $id)
    {
        $this->id = $id;
    }

    final public function equals(string $id): bool
    {
        return $this->id === $id;
    }

    public function id(): int
    {
        return $this->id;
    }

    final public function equal(int $id): bool
    {
        return $this->id() === $id;
    }

    final public function __toString(): string
    {
        return (string)$this->id();
    }
}
