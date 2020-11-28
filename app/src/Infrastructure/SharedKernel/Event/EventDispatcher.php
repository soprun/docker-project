<?php
declare(strict_types=1);

namespace Infrastructure\SharedKernel\Event;

use Domain\SharedKernel\Event\EventCollector;
use Domain\SharedKernel\Event\EventDispatcherInterface;
use Domain\SharedKernel\Event\EventInterface;
use Domain\SharedKernel\Event\EventPublisher;
use Illuminate\Contracts\Events\Dispatcher as InfrastructureEventDispatcher;

final class EventDispatcher implements EventDispatcherInterface
{
    private $collector;
    private $dispatcher;

    public function __construct(EventCollector $collector, InfrastructureEventDispatcher $dispatcher)
    {
        $this->collector = $collector;
        $this->dispatcher = $dispatcher;

        EventPublisher::boot($this);
    }

    public function record(EventInterface $event): void
    {
        $this->collector->collect($event);
        $this->dispatcher->dispatch($event->name(), $event);
        // $this->dispatcher->dispatch($event->name(), $event);
    }

    public function dispatch(): void
    {
        foreach ($this->collector->events() as $key => $event) {
            $this->dispatcher->dispatch($event->name(), $event);
            $this->collector->remove($key);
        }
    }
}
