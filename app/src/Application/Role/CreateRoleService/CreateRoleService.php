<?php
declare(strict_types=1);

namespace Application\Role\CreateRoleService;

use Application\SharedKernel\ApplicationRequest;
use Application\SharedKernel\ApplicationService;
use Application\SharedKernel\Exception\RuntimeException;
use Domain\Role\Factory\RoleFactory;
use Domain\Role\Model\RoleInterface;
use Domain\Role\Repository\RoleRepository;
use Domain\Role\Repository\SkillRepository;
use Domain\Role\ValueObject\SkillId;

final class CreateRoleService implements ApplicationService
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
        if (!$request instanceof CreateRoleRequest) {
            throw new RuntimeException(
                'The request does not meet expectations.'
            );
        }

        $skill = [];

        foreach ($request->getSkill() as $id) {
            $skill[] = $this->skillRepository->findOne(
                new SkillId($id)
            );
        }

        $role = RoleFactory::create(
            $request->getName()
        );

        $role = $this->roleRepository->save($role);

        foreach ($skill as $item) {
            $role->attachSkill($item);
        }

        $role = $this->roleRepository->save($role);

        return $role;
    }
}
