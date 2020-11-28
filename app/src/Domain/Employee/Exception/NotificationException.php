<?php
declare(strict_types=1);

namespace Domain\Employee\Exception;

use Domain\SharedKernel\Exception\DomainCoreException;

interface NotificationException extends DomainCoreException
{
}
