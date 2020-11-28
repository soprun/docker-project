<?php
declare(strict_types=1);

namespace Domain\Employee\Event;

use Domain\Employee\ValueObject\NotificationId;
use Domain\Employee\ValueObject\NotificationState;
use Domain\SharedKernel\Event\Event;

final class NotificationStateWasChanged extends Event
{
    private $notificationId;
    private $state;

    public function __construct(
        NotificationId $notificationId,
        NotificationState $state
    )
    {
        parent::__construct();

        $this->notificationId = $notificationId;
        $this->state = $state;
    }

    public function getNotificationId(): NotificationId
    {
        return $this->notificationId;
    }

    public function getState(): NotificationState
    {
        return $this->state;
    }
}
