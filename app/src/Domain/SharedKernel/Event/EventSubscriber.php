<?php
declare(strict_types=1);

namespace Domain\SharedKernel\Event;

interface EventSubscriber
{
    public function handle(Event $event): void;

    public function isSubscribedTo(Event $event): bool;
}
