<?php
declare(strict_types=1);

namespace Domain\SharedKernel\Event;

use function array_key_exists;

final class EventCollector
{
    private static $instance;
    private $events = [];

    private function __construct()
    {
    }

    public function collect(EventInterface $event): void
    {
        self::instance()->events[] = $event;
    }

    public static function instance(): self
    {
        if (null === self::$instance) {
            self::$instance = new self();
        }

        return self::$instance;
    }

    /**
     * @return EventInterface[]
     */
    public function events(): array
    {
        return self::instance()->events;
    }

    public function remove(int $key): void
    {
        if (array_key_exists($key, self::instance()->events) === true) {
            unset(self::instance()->events[$key]);
        }
    }

    public function shutdown(): void
    {
        self::$instance = null;
    }

    public function flush(): void
    {
        self::instance()->events = [];

        reset(self::instance()->events);
    }
}
