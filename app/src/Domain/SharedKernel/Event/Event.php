<?php
declare(strict_types=1);

namespace Domain\SharedKernel\Event;

use DateTimeImmutable;

abstract class Event implements EventInterface
{
    private $occurredOn;

    public function __construct()
    {
        $this->occurredOn = new DateTimeImmutable();
    }

    final public function name(): string
    {
        return static::class;
    }

    final public function occurredOn(): DateTimeImmutable
    {
        return $this->occurredOn;
    }
}
