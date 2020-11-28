<?php
declare(strict_types=1);

namespace Application\Role\UpdateRoleService;

use Application\SharedKernel\ApplicationRequest;
use Application\SharedKernel\ApplicationService;
use Application\SharedKernel\Exception\RuntimeException;
use Domain\Role\Model\RoleInterface;
use Domain\Role\Repository\RoleRepository;
use Domain\Role\Repository\SkillRepository;
use Domain\Role\ValueObject\RoleId;
use Domain\Role\ValueObject\SkillId;
use Domain\SharedKernel\Exception\DomainCoreException;
use function count;

final class UpdateRoleService implements ApplicationService
{
    private $roleRepository;
    private $skillRepository;

    public function __construct(
        RoleRepository $roleRepository,
        SkillRepository $skillRepository
    )
    {
        $this->roleRepository = $roleRepository;
        $this->skillRepository = $skillRepository;
    }

    public function execute(?ApplicationRequest $request): RoleInterface
    {
        if (!$request instanceof UpdateRoleRequest) {
            throw new RuntimeException(
                'The request does not meet expectations.'
            );
        }

        $role = $this->roleRepository->findOne(
            RoleId::create($request->getRoleId())
        );

        if ($request->getName() !== '') {
            $role->changeName($request->getName());
        }

        $inputIds = $request->getSkill();
        $skillIds = [];

        foreach ($role->allSkill() as $skill) {
            $skillIds[] = $skill->id()->toString();
        }

        $detach = array_diff($skillIds, $inputIds);
        $attach = array_diff($inputIds, array_intersect($skillIds, $inputIds));

        try {
            foreach ($detach as $id) {
                $skill = $this->skillRepository->findOne(
                    new SkillId($id)
                );

                $role->detachSkill($skill);
            }

            foreach ($attach as $id) {
                $skill = $this->skillRepository->findOne(
                    new SkillId($id)
                );

                $role->attachSkill($skill);
            }
        } catch (DomainCoreException $exception) {
            throw new RuntimeException(
                sprintf(
                    'An error occurred when changing skills, the role ID of "%s".',
                    $role->id()->toString()
                ),
                0,
                $exception
            );
        }

        $role = $this->roleRepository->save($role);

        return $role;
    }
}
