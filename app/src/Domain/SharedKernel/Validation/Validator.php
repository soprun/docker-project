<?php
declare(strict_types=1);

namespace Domain\SharedKernel\Validation;

abstract class Validator
{
    private $validationHandler;

    public function __construct(ValidationHandler $validationHandler)
    {
        trigger_error('Don\'t touch!', E_USER_WARNING);

        $this->validationHandler = $validationHandler;
    }

    abstract public function validate();

    protected function handleError(iterable $errors): void
    {
        $this->validationHandler->handleError($errors);
    }
}