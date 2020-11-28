<?php
declare(strict_types=1);

namespace Domain\SharedKernel\Exception;

use Exception;

final class RuntimeException extends Exception implements DomainCoreException
{
}
