<?php
declare(strict_types=1);

namespace Domain\SharedKernel\Event;

use BadMethodCallException;
use LogicException;

final class EventPublisher
{
    /** @var self */
    private static $instance;
    private $dispatcher;
    /** @var EventSubscriber[] */
    private $subscribers = [];

    private function __construct(EventDispatcherInterface $dispatcher)
    {
        $this->dispatcher = $dispatcher;
    }

    public static function boot(EventDispatcherInterface $dispatcher): void
    {
        if (static::$instance === null) {
            static::$instance = new self($dispatcher);
        }
    }

    public static function raise(EventInterface $event): void
    {
        if (static::$instance === null) {
            throw new LogicException('An error occurred, needs to be booted before invoke raise.');
        }

        static::$instance->dispatcher->record($event);
    }

    private function __clone()
    {
        throw new BadMethodCallException('Clone is not supported.');
    }

//    public static function subscribe(EventSubscriber $subscriber): void
//    {
//        static::$instance->subscribers[] = $subscriber;
//    }
//
//    public static function publish(Event $event): void
//    {
//        foreach (static::$instance->subscribers as $subscriber) {
//            if ($subscriber->isSubscribedTo($event) === true) {
//                $subscriber->handle($event);
//            }
//        }
//    }
}
