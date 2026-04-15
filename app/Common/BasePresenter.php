<?php declare(strict_types=1);

namespace App\Common;

use Nette\Application\UI\Presenter;

abstract class BasePresenter extends Presenter
{
    protected function startup(): void
    {
        parent::startup();

        $locale = $this->getParameter('locale');
        if (!is_string($locale) || !in_array($locale, ['cs', 'en'], true)) {
            $locale = 'cs';
        }

        $this->template->locale = $locale;
        $this->template->switchLocale = $locale === 'cs' ? 'en' : 'cs';
        $this->template->isAdmin = str_starts_with($this->getName(), 'Admin:');
    }

    protected function getLocale(): string
    {
        $locale = $this->getParameter('locale');
        return is_string($locale) && in_array($locale, ['cs', 'en'], true) ? $locale : 'cs';
    }
}
