<?php
declare(strict_types=1);

namespace Domain\Role\Model;

use Domain\Role\Event\RoleNameWasChanged;
use Domain\Role\Event\RoleWasAttachedSkill;
use Domain\Role\Event\RoleWasCreated;
use Domain\Role\Event\RoleWasDetachedSkill;
use Domain\Role\Exception\RoleSkillException;
use Domain\Role\ValueObject\RoleId;
use Domain\SharedKernel\Exception\ValidationException;
use Domain\SharedKernel\Model\AggregateRoot;
use function array_key_exists;

final class Role extends AggregateRoot implements RoleInterface
{
    private $id;
    private $name;
    private $skill = [];

    public function __construct(
        RoleId $id,
        string $name,
        SkillInterface ...$skills
    )
    {
        $this->id = $id;
        $this->name = $name;

        foreach ($skills as $skill) {
            $this->skill[$skill->id()->toString()] = $skill;
        }
    }

    public static function create(
        string $name
    ): self
    {
        $id = RoleId::create();
        $name = self::validationName($name);

        $role = new self(
            $id,
            $name
        );

        $role->raise(
            new RoleWasCreated($id)
        );

        return $role;
    }

    public function id(): RoleId
    {
        return $this->id;
    }

    public function name(): string
    {
        return $this->name;
    }

    public function changeName(string $name): void
    {
        $this->name = self::validationName($name);

        $this->raise(
            new RoleNameWasChanged($this->id(), $this->name)
        );
    }

    private static function validationName(string $name): string
    {
        $name = trim($name);

        if ($name === '') {
            throw new ValidationException(
                'An error occurred, the role name should not be empty.'
            );
        }

        return $name;
    }

    public function allSkill(): iterable
    {
        return $this->skill;
    }

    public function attachSkill(SkillInterface $skill): void
    {
        if ($this->containsSkill($skill) === true) {
            throw RoleSkillException::alreadyContainsSkill($this, $skill);
        }

        $this->skill[$skill->id()->toString()] = $skill;

        $this->raise(
            new RoleWasAttachedSkill($this->id(), $skill->id())
        );
    }

    public function detachSkill(SkillInterface $skill): void
    {
        if ($this->containsSkill($skill) === false) {
            throw RoleSkillException::doesNotContainSkill($this, $skill);
        }

        unset($this->skill[$skill->id()->toString()]);

        $this->raise(
            new RoleWasDetachedSkill($this->id(), $skill->id())
        );
    }

    public function containsSkill(SkillInterface $skill): bool
    {
        return array_key_exists($skill->id()->toString(), $this->skill);
    }
}
