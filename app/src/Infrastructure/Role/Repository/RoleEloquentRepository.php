<?php
declare(strict_types=1);

namespace Infrastructure\Role\Repository;

use App\Role as RoleEloquent;
use Domain\Role\Exception\RoleNotFoundException;
use Domain\Role\Model\Role;
use Domain\Role\Model\RoleInterface;
use Domain\Role\Repository\RoleRepository;
use Domain\Role\ValueObject\RoleId;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use function count;

final class RoleEloquentRepository implements RoleRepository
{
    public function findOne(RoleId $id): RoleInterface
    {
        try {
            /** @var RoleEloquent $role */
            $role = (new RoleEloquent())->newQuery()
                ->where('uuid', $id)
                ->firstOrFail();

            return new Role(
                $role->id(),
                $role->name(),
                ...$role->allSkill()
            );
        } catch (ModelNotFoundException $exception) {
            throw RoleNotFoundException::byId($id, $exception);
        }
    }

    public function save(RoleInterface $role): RoleInterface
    {
        if ($role instanceof RoleEloquent) {
            $role->setAttribute('uuid', $role->id()->toString());
            $role->save();

            return $role;
        }

        $id = $role->id()->toString();

        $model = (new RoleEloquent())
            ->newQuery()
            ->where('uuid', $id)
            ->first();

        if ($model === null) {
            $model = new RoleEloquent();
        }

        $model->setAttribute('name', $role->name());
        $model->setAttribute('uuid', $id);
        $model->save();

        $skillIds = [];
        $inputIds = [];

        foreach ($model->allSkill() as $skill) {
            $skillIds[] = $skill->id()->toString();
        }

        foreach ($role->allSkill() as $skill) {
            $inputIds[] = $skill->id()->toString();
        }

        $detach = array_diff($skillIds, $inputIds);
        $attach = array_diff($inputIds, array_intersect($skillIds, $inputIds));

        foreach ($detach as $id) {
            $model->avayaSkills()->detach($id);
        }

        foreach ($attach as $id) {
            $model->avayaSkills()->attach($id);
        }

        return $model;
    }
}
