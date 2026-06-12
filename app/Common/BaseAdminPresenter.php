<?php declare(strict_types=1);

namespace App\Common;

abstract class BaseAdminPresenter extends BasePresenter
{
    protected function startup(): void
    {
        parent::startup();

        if (!$this->getUser()->isLoggedIn() && $this->getName() !== 'Admin:Sign') {
            $this->flashMessage('Please sign in first.', 'warning');
            $this->redirect(':Admin:Sign:default');
        }
    }
}
