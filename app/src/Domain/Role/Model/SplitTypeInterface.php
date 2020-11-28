<?php
declare(strict_types=1);

namespace Domain\Role\Model;

interface SplitTypeInterface
{
    public function id(): int;

    public function name(): string;

    public function priority(): int;
}
