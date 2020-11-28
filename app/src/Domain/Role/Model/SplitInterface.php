<?php
declare(strict_types=1);

namespace Domain\Role\Model;

interface SplitInterface
{
    public function id(): int;

    public function name(): string;

    public function code(): int;

    public function type(): SplitTypeInterface;
}
