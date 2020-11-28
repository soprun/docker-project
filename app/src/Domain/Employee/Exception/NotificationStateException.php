<?php
declare(strict_types=1);

namespace Domain\Employee\Exception;

use Domain\Employee\Model\Notification;
use Domain\Employee\ValueObject\NotificationState;
use Exception;

final class NotificationStateException extends Exception implements NotificationException
{
    private $notification;
    private $state;

    public static function cannotChange(
        Notification $notification,
        NotificationState $state
    ): self
    {
        $exception = new self(
            sprintf(
                'An error occurred on ID "%s", cannot change to %s.',
                $notification->id()->toString(),
                $state->currentName()
            )
        );
        $exception->notification = $notification;
        $exception->state = $state;

        return $exception;
    }
}
