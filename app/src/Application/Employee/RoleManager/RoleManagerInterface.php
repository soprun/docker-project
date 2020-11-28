<?php
declare(strict_types=1);

namespace Application\Employee\RoleManager;

interface RoleManagerInterface
{
    public function attachRole(RoleManagerRequest $request): void;

    public function detachRole(RoleManagerRequest $request): void;

    public function overwriteRole(RoleManagerRequest $request): void;
}
