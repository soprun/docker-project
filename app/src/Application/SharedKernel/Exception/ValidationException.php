<?php
declare(strict_types=1);

namespace Application\SharedKernel\Exception;

use Exception;

final class ValidationException extends Exception implements ApplicationServiceException
{
}
