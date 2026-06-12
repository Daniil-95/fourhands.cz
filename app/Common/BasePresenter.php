<?php declare(strict_types=1);

namespace App\Common;

use Nette\Application\UI\Presenter;
use Nette\Application\UI\Template;
use App\Model\NavigationRepository;
use App\Model\SettingRepository;

abstract class BasePresenter extends Presenter
{
    private ?SettingRepository $settingRepository = null;
    private ?NavigationRepository $navigationRepository = null;
    private ?Translator $translator = null;

    public function injectSiteData(SettingRepository $settingRepository, NavigationRepository $navigationRepository): void
    {
        $this->settingRepository = $settingRepository;
        $this->navigationRepository = $navigationRepository;
    }

    protected function startup(): void
    {
        parent::startup();

        $locale = $this->getParameter('locale');
        if (!is_string($locale) || !in_array($locale, ['cs', 'en'], true)) {
            $locale = 'cs';
        }

        $this->translator = new Translator($locale);
        $this->template->locale = $locale;
        $this->template->switchLocale = $locale === 'cs' ? 'en' : 'cs';
        $this->template->isAdmin = str_starts_with($this->getName(), 'Admin:');
        $this->template->siteSettings = $this->settingRepository?->getByLocale($locale) ?? [];
        $this->template->navigation = $this->navigationRepository?->getActiveByLocale($locale) ?? [];
    }

    protected function getLocale(): string
    {
        $locale = $this->getParameter('locale');
        return is_string($locale) && in_array($locale, ['cs', 'en'], true) ? $locale : 'cs';
    }

    protected function trans(string $key): string
    {
        return $this->translator?->translate($key) ?? $key;
    }

    protected function createTemplate(?string $class = null): Template
    {
        $template = parent::createTemplate($class);
        $template->setTranslator($this->translator);
        return $template;
    }
}
