<?php
declare(strict_types=1);

namespace Domain\SharedKernel\Model;

use Domain\SharedKernel\Event\EventInterface;
use Domain\SharedKernel\Event\EventPublisher;

abstract class AggregateRoot
{
    final protected function raise(EventInterface $event): void
    {
        EventPublisher::raise($event);
    }
}
