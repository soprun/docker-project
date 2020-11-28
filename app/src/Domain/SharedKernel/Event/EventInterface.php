<?php
declare(strict_types=1);

namespace Domain\SharedKernel\Event;

use DateTimeImmutable;

interface EventInterface
{
    public function name(): string;

    public function occurredOn(): DateTimeImmutable;
}
