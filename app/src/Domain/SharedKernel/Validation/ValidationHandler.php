<?php
declare(strict_types=1);

namespace Domain\SharedKernel\Validation;

interface ValidationHandler
{
    public function handleError(iterable $errors): void;
}
