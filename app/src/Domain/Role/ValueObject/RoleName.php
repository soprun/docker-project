<?php
declare(strict_types=1);

namespace Domain\Role\ValueObject;

use Domain\SharedKernel\Exception\ValidationException;
use function strlen;

final class RoleName
{
    private const MIN_LENGTH = 5;
    private const MAX_LENGTH = 100;

    // private const FORMAT = '/^[a-zA-Z0-9_]+$/';

    private $name;

    public function __construct(string $name)
    {
        $name = trim($name);

        if (empty($name) === true) {
            throw new ValidationException('Empty role name.');
        }

        $length = strlen($name);

        if ($length < self::MIN_LENGTH) {
            throw new ValidationException(
                sprintf(
                    'Role name must be %d characters or more.',
                    self::MIN_LENGTH
                )
            );
        }

        if ($length > self::MAX_LENGTH) {
            throw new ValidationException(
                sprintf(
                    'Role name must be %d characters or less.',
                    self::MIN_LENGTH
                )
            );
        }

        $this->name = $name;
    }

    public function toString(): string
    {
        return $this->name;
    }
}
