<?php declare(strict_types=1);

namespace App\Common;

use Nette\Application\UI\Presenter;
use Nette\Application\UI\Template;
use App\Model\NavigationRepository;
use App\Model\PageSectionRepository;
use App\Model\SettingRepository;

abstract class BasePresenter extends Presenter
{
    private ?SettingRepository $settingRepository = null;
    private ?NavigationRepository $navigationRepository = null;
    private ?Translator $translator = null;
    private ?PageSectionRepository $pageSectionRepository = null;

    public function injectSiteData(SettingRepository $settingRepository, NavigationRepository $navigationRepository): void
    {
        $this->settingRepository = $settingRepository;
        $this->navigationRepository = $navigationRepository;
    }

    public function injectPageSections(PageSectionRepository $pageSectionRepository): void
    {
        $this->pageSectionRepository = $pageSectionRepository;
    }

    protected function startup(): void
    {
        parent::startup();

        $response = $this->getHttpResponse();
        $response->setHeader('X-Content-Type-Options', 'nosniff');
        $response->setHeader('Referrer-Policy', 'strict-origin-when-cross-origin');
        $response->setHeader('Permissions-Policy', 'camera=(), microphone=(), geolocation=()');
        if ($this->getHttpRequest()->isSecured()) {
            $response->setHeader('Strict-Transport-Security', 'max-age=31536000; includeSubDomains');
        }

        // Start the session before template rendering to prevent late CSRF session init.
        $this->getSession()->start();

        $locale = $this->getParameter('locale');
        if (!is_string($locale) || !in_array($locale, ['cs', 'en'], true)) {
            $locale = 'cs';
        }

        $this->translator = new Translator($locale);
        $this->template->locale = $locale;
        $this->template->eventMonth = function (\DateTimeInterface $date) use ($locale): string {
            $months = $locale === 'cs'
                ? ['led', 'úno', 'bře', 'dub', 'kvě', 'čvn', 'čvc', 'srp', 'zář', 'říj', 'lis', 'pro']
                : ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

            return $months[(int) $date->format('n') - 1] . ' ' . $date->format('Y');
        };
        $this->template->switchLocale = $locale === 'cs' ? 'en' : 'cs';
        $this->template->isAdmin = str_starts_with($this->getName(), 'Admin:');
        $this->template->siteSettings = $this->settingRepository?->getByLocale($locale) ?? [];
        $this->template->navigation = $this->navigationRepository?->getActiveByLocale($locale) ?? [];
        $this->template->pageSections = $this->pageSectionRepository?->getByLocale($locale) ?? [];
        $stylePath = dirname(__DIR__, 2) . '/www/css/style.css';
        $this->template->styleVersion = is_file($stylePath) ? (string) filemtime($stylePath) : (string) time();
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
