<?php declare(strict_types=1);

namespace App\Common;

use Nette\Application\Attributes\Persistent;
use Nette\Http\FileUpload;
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

    protected function requirePostWithCsrf(): void
    {
        if (!$this->getHttpRequest()->isMethod('POST')) {
            $this->error('Tato akce vyžaduje požadavek POST.', 405);
        }

        $token = $this->getHttpRequest()->getPost('_token');
        if (!is_string($token) || !$this->checkCsrfToken($token)) {
            $this->error('Neplatný bezpečnostní token.', 403);
        }
    }

    protected function assertAdminContentLanguage(object $item): void
    {
        if (!isset($item->lang) || (string) $item->lang !== $this->getAdminContentLang()) {
            $this->error('Záznam nepatří do aktuálně zvoleného jazyka.', 404);
        }
    }

    protected function storeImageUpload(FileUpload $upload, string $prefix): ?string
    {
        $extensions = [
            'image/jpeg' => 'jpg',
            'image/png' => 'png',
            'image/gif' => 'gif',
            'image/webp' => 'webp',
        ];
        $extension = $extensions[$upload->getContentType()] ?? null;

        if (!$upload->isOk() || !$upload->isImage() || $upload->getSize() > 8 * 1024 * 1024 || $extension === null) {
            return null;
        }

        $temporaryFile = $upload->getTemporaryFile();
        $imagesDirectory = __DIR__ . '/../../www/images/';
        $uploadedHash = is_file($temporaryFile) ? hash_file('sha256', $temporaryFile) : false;
        if ($uploadedHash !== false) {
            foreach (new \DirectoryIterator($imagesDirectory) as $existingFile) {
                if (!$existingFile->isFile() || !preg_match('~\.(?:jpe?g|png|gif|webp)$~i', $existingFile->getFilename())) {
                    continue;
                }

                if (hash_file('sha256', $existingFile->getPathname()) === $uploadedHash) {
                    $existingPath = 'images/' . $existingFile->getFilename();
                    \App\Model\ImageOptimizer::createDerivative($existingPath, 1200, 72);
                    \App\Model\ImageOptimizer::createDerivative($existingPath, 480, 72);
                    return $existingPath;
                }
            }
        }

        $filename = $prefix . '-' . date('Ymd-His') . '-' . Random::generate(12, 'abcdefghijklmnopqrstuvwxyz0123456789') . '.' . $extension;
        $upload->move($imagesDirectory . $filename);

        \App\Model\ImageOptimizer::createDerivative('images/' . $filename, 1200, 72);
        \App\Model\ImageOptimizer::createDerivative('images/' . $filename, 480, 72);

        return 'images/' . $filename;
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
