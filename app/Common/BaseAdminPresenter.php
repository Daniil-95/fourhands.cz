<?php declare(strict_types=1);

namespace App\Common;

use Nette\Utils\Random;

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

        $this->template->csrfToken = $this->getCsrfToken();
    }

    protected function getCsrfToken(): string
    {
        $section = $this->getSession()->getSection('admin');
        if (!isset($section->csrfToken)) {
            $section->csrfToken = Random::generate(32);
        }
        return $section->csrfToken;
    }

    protected function checkCsrfToken(string $token): bool
    {
        $section = $this->getSession()->getSection('admin');
        return isset($section->csrfToken) && hash_equals($section->csrfToken, $token);
    }
}
