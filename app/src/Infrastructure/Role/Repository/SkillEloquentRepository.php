<?php
declare(strict_types=1);

namespace Infrastructure\Role\Repository;

use App\AvayaSkill as SkillEloquent;
use Domain\Role\Exception\SkillNotFoundException;
use Domain\Role\Model\Skill;
use Domain\Role\Model\SkillInterface;
use Domain\Role\Repository\SkillRepository;
use Domain\Role\ValueObject\SkillId;
use Illuminate\Database\Eloquent\ModelNotFoundException;

final class SkillEloquentRepository implements SkillRepository
{
    public function findOne(SkillId $id): SkillInterface
    {
        try {
            /** @var SkillEloquent $skill */
            $skill = (new SkillEloquent())->newQuery()->findOrFail($id);

            return Skill::create(
                new SkillId($skill->getAttribute('id')),
                $skill->name(),
                $skill->group()
            );
        } catch (ModelNotFoundException $exception) {
            throw SkillNotFoundException::byId($id, $exception);
        }
    }

    public function save(SkillInterface $skill): void
    {
        if ($skill instanceof Skill) {
            $model = new SkillEloquent();
            $model->setAttribute('name', $skill->name());

            $skill = $model;
        }

        /** @var SkillEloquent $skill */
        $skill->save();
    }
}
