<?php
declare(strict_types=1);

namespace Domain\SharedKernel\Event;

interface EventDispatcherInterface
{
    public function record(EventInterface $event): void;

    public function dispatch(): void;
}
