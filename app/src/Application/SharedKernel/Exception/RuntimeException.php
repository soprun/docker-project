<?php
declare(strict_types=1);

namespace Application\SharedKernel\Exception;

use Exception;

final class RuntimeException extends Exception implements ApplicationServiceException
{
}
