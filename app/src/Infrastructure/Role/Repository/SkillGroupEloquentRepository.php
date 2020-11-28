<?php
declare(strict_types=1);

namespace Infrastructure\Role\Repository;

use App\AvayaSkillGroup as SkillGroupEloquent;
use Domain\Role\Exception\SkillGroupNotFoundException;
use Domain\Role\Model\SkillGroup;
use Domain\Role\Model\SkillGroupInterface;
use Domain\Role\Repository\SkillGroupRepository;
use Illuminate\Database\Eloquent\ModelNotFoundException;

final class SkillGroupEloquentRepository implements SkillGroupRepository
{
    public function findOne(int $id): SkillGroupInterface
    {
        try {
            /** @var SkillGroupEloquent $model */
            $model = (new SkillGroupEloquent())->newQuery()
                ->findOrFail($id);

            return SkillGroup::create(
                $model->getAttribute('id'),
                $model->getAttribute('name')
            );
        } catch (ModelNotFoundException $exception) {
            throw SkillGroupNotFoundException::byId($id, $exception);
        }
    }

    public function save(SkillGroupInterface $group): void
    {
        if ($group instanceof SkillGroup) {
            $model = new SkillGroupEloquent();
            $model->setAttribute('name', $group->name());

            $group = $model;
        }

        /** @var SkillGroupEloquent $group */
        $group->save();
    }
}
