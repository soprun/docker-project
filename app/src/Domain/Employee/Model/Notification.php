<?php
declare(strict_types=1);

namespace Domain\Employee\Model;

use Domain\Employee\Event\NotificationStateWasChanged;
use Domain\Employee\Exception\NotificationStateException;
use Domain\Employee\ValueObject\NotificationId;
use Domain\Employee\ValueObject\NotificationState;
use Domain\SharedKernel\Model\AggregateRoot;

final class Notification extends AggregateRoot implements NotificationInterface
{
    private $id;
    private $state;

    protected function __construct(NotificationId $id)
    {
        $this->id = $id;
        $this->state = NotificationState::inWork();
    }

    public static function create(
        NotificationId $id
    ): self
    {
        return new self(
            $id
        );
    }

    public function id(): NotificationId
    {
        return $this->id;
    }

    public function state(): NotificationState
    {
        return $this->state;
    }

    public function stateChangedTo(NotificationState $state): void
    {
        if ($this->state->stateCanBeChangedTo($state) === false) {
            throw NotificationStateException::cannotChange($this, $state);
        }

        $this->state = $state;

        $this->raise(
            new NotificationStateWasChanged($this->id, $state)
        );
    }
}
