<?php
declare(strict_types=1);

namespace Domain\Employee\Model;

use Domain\Employee\ValueObject\NotificationId;

interface NotificationInterface
{
    public function id(): NotificationId;
}
