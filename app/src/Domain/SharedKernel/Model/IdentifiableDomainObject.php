<?php
declare(strict_types=1);

namespace Domain\SharedKernel\Model;

use Ramsey\Uuid\Uuid;

abstract class IdentifiableDomainObject
{
    private $uuid;

    protected function __construct(?string $uuid)
    {
        $this->uuid = $uuid ?: Uuid::uuid4()->toString();
    }

    final public function toString(): string
    {
        return $this->uuid;
    }

    final public static function create(string $uuid = null)
    {
        return new static($uuid);
    }

    final public function equalsTo(IdentifiableDomainObject $identity): bool
    {
        return strcmp($this->toString(), $identity->toString()) === 0;
    }

    final public function __toString(): string
    {
        return $this->toString();
    }
}
