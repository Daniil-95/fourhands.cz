<?php declare(strict_types=1);

namespace App\FrontModule\Presenters;

use App\Common\BasePresenter;

final class ErrorPresenter extends BasePresenter
{
    public function renderDefault(): void
    {
        $this->setView('default');
    }
}
