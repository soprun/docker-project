<?php
declare(strict_types=1);

namespace Domain\Employee\ValueObject;


use Domain\SharedKernel\ValueObject\State;

final class NotificationState extends State
{
    private const IN_WORK = 'in work';
    private const COMPLETED = 'completed';

    private static $conditions = [
        self::IN_WORK => [
            self::COMPLETED,
        ],
    ];

    public static function inWork(): self
    {
        return new self(self::IN_WORK);
    }

    public static function completed(): self
    {
        return new self(self::COMPLETED);
    }
}
