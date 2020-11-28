<?php
declare(strict_types=1);

namespace Domain\SharedKernel\Model;

use Domain\SharedKernel\Exception\ValidationException;
use const PHP_INT_MAX;

abstract class EntityIdentity
{
    private $id;

    public function __construct($id)
    {
        $this->id = $this->validate($id);
    }

    /**
     * @param int $id
     * @return int
     * @see http://json-schema.org/latest/json-schema-validation.html#rfc.section.5.1
     */
    protected function validate($id): int
    {
        if (is_numeric($id) === false) {
            throw new ValidationException('An error occurred, the ID must be integer.');
        }

        $number = abs($id);

        if (is_nan($number) === true) {
            throw new ValidationException('is nan');
        }

        if (is_finite($number) === false) {
            throw new ValidationException('is not finite');
        }

        if ($number !== $id) {
            throw new ValidationException('Abstract number does not correspond to the initial number.');
        }

        if ($number >= PHP_INT_MAX) {
            throw new ValidationException('An abstract number cannot be greater than the maximum number allowed.');
        }

        return $number;
    }

    final public function equal(int $id): bool
    {
        return $this->toString() === $this->validate($id);
    }

    final public function toString(): int
    {
        return $this->id;
    }

    final public function __toString(): string
    {
        return (string)$this->toString();
    }
}
