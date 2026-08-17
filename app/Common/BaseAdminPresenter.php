<?php declare(strict_types=1);

namespace App\Common;

use Nette\Application\Attributes\Persistent;
use Nette\Utils\Random;

abstract class BaseAdminPresenter extends BasePresenter
{
    /** Jazyk editovaného obsahu, drží se ve všech odkazech i v akci formulářů. */
    #[Persistent]
    public string $lang = 'cs';

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

        if (!in_array($this->lang, ['cs', 'en'], true)) {
            $this->lang = 'cs';
        }

        $this->template->csrfToken = $this->getCsrfToken();
        $this->template->adminContentLang = $this->getAdminContentLang();
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

    protected function getAdminContentLang(): string
    {
        return in_array($this->lang, ['cs', 'en'], true) ? $this->lang : 'cs';
    }

    /**
     * @param array<int, mixed> $items
     * @return array<int, mixed>
     */
    protected function filterByAdminContentLang(array $items): array
    {
        $lang = $this->getAdminContentLang();

        return array_values(array_filter($items, static function ($item) use ($lang): bool {
            return isset($item->lang) && (string) $item->lang === $lang;
        }));
    }

    protected function redirectToDefaultWithContentLang(?string $lang = null, array $extraParams = []): void
    {
        $targetLang = in_array($lang, ['cs', 'en'], true) ? $lang : $this->getAdminContentLang();
        $this->redirect('default', array_merge(['lang' => $targetLang], $extraParams));
    }
}
