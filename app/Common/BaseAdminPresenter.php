<?php declare(strict_types=1);

namespace App\Common;

abstract class BaseAdminPresenter extends BasePresenter
{
    protected function startup(): void
    {
        parent::startup();

        if (!$this->getUser()->isLoggedIn() && $this->getName() !== 'Admin:Sign') {
            $this->flashMessage('Nejprve se přihlaste.', 'warning');
            $this->redirect(':Admin:Sign:default');
        }

        if ($this->getUser()->isLoggedIn() && !$this->getUser()->isInRole('admin')) {
            $this->getUser()->logout(true);
            $this->error('Nemáte oprávnění pro přístup do administrace.', 403);
        }
    }
}
