<?php declare(strict_types=1);

namespace App\Presentation\Front;

use App\Core\BasePresenter;

final class ErrorPresenter extends BasePresenter
{
    public function renderDefault(): void
    {
        $this->setView('default');
    }
}
