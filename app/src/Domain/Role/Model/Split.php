<?php
declare(strict_types=1);

namespace Domain\Role\Model;

class Split implements SplitInterface
{
    private $id;
    private $name;
    private $code;
    private $type;

    public function __construct(int $id, string $name, int $code, SplitTypeInterface $type)
    {
        $this->id = $id;
        $this->name = $name;
        $this->code = $code;
        $this->type = $type;
    }

    public function id(): int
    {
        return $this->id;
    }

    public function name(): string
    {
        return $this->name;
    }

    public function code(): int
    {
        return $this->code;
    }

    public function type(): SplitTypeInterface
    {
        return $this->type;
    }
}
