<?php declare(strict_types=1);

namespace App\AdminModule\Presenters;

use App\Common\BaseAdminPresenter;
use App\Model\PageSectionRepository;
use Nette\Application\AbortException;
use Nette\Application\UI\Form;
use Nette\Http\FileUpload;

final class PagePresenter extends BaseAdminPresenter
{
    private ?int $editingId = null;
    private ?string $editingPageKey = null;
    private ?string $editingSectionKey = null;
    private ?string $editingLang = null;
    private bool $showBackLink = true;

    public function __construct(private PageSectionRepository $pageSectionRepository)
    {
        parent::__construct();
    }

    /** @throws AbortException */
    public function actionDefault(?string $page = null): void
    {
        $pageKey = is_string($page) && isset(PageSectionRepository::PAGES[$page]) ? $page : 'about';
        $sectionKeys = array_keys(PageSectionRepository::SECTIONS[$pageKey]);
        if (count($sectionKeys) === 1) {
            $this->redirect('section', ['page' => $pageKey, 'section' => $sectionKeys[0]]);
        }

        // úvodní sekce se edituje rovnou zde, seznam níže obsahuje jen zbylé sekce
        $hero = $this->pageSectionRepository->getByPageSection($pageKey, 'hero', $this->getAdminContentLang());
        if ($hero) {
            $this->editingId = (int) $hero->id;
            $this->editingPageKey = $pageKey;
            $this->editingSectionKey = 'hero';
            $this->editingLang = (string) $hero->lang;
            $this->fillSectionEditor($hero);
        }
    }

    public function renderDefault(?string $page = null): void
    {
        $pageKey = is_string($page) && isset(PageSectionRepository::PAGES[$page]) ? $page : 'about';
        $sections = $this->pageSectionRepository->getAllGroupedByPage($this->getAdminContentLang());
        $listed = array_filter(
            $sections[$pageKey] ?? [],
            static fn($section): bool => (string) $section->section_key !== 'hero',
        );

        $this->template->pageKey = $pageKey;
        $this->template->pageTitle = PageSectionRepository::PAGES[$pageKey];
        $this->template->sections = $listed;
        $this->template->sectionLabels = PageSectionRepository::SECTIONS[$pageKey];
        $this->template->hasHeroForm = $this->editingId !== null;
    }

    public function renderEdit(): void
    {
        $this->template->editingId = $this->editingId;
        $this->template->pageKey = $this->editingPageKey;
        $this->template->showBackLink = $this->showBackLink;
    }

    public function renderHero(): void
    {
        $this->template->editingId = $this->editingId;
    }

    /** @throws AbortException */
    public function actionHero(): void
    {
        $lang = $this->getAdminContentLang();
        $item = $this->pageSectionRepository->getByPageSection('homepage', 'hero', $lang);
        if (!$item) {
            $this->error('Úvodní sekce pro tento jazyk nebyla nalezena.');
        }

        $this->editingId = (int) $item->id;
        $this->editingPageKey = (string) $item->page_key;
        $this->editingSectionKey = (string) $item->section_key;
        $this->editingLang = (string) $item->lang;

        $this->fillSectionEditor($item);
    }

    /** @throws AbortException */
    public function actionEdit(int $id): void
    {
        $this->editingId = $id;
        $item = $this->pageSectionRepository->getById($id);
        if (!$item || !isset(PageSectionRepository::SECTIONS[$item->page_key][$item->section_key])) {
            $this->error('Sekce nenalezena.');
        }

        $this->editingPageKey = (string) $item->page_key;
        $this->editingSectionKey = (string) $item->section_key;
        $this->editingLang = (string) $item->lang;

        // přepínač jazyka nahoře musí otevřít odpovídající záznam druhé jazykové mutace
        if ($this->getAdminContentLang() !== $this->editingLang && !$this->getHttpRequest()->isMethod('POST')) {
            $sibling = $this->pageSectionRepository->getByPageSection(
                $this->editingPageKey,
                $this->editingSectionKey,
                $this->getAdminContentLang(),
            );
            if ($sibling) {
                $this->redirect('edit', ['id' => (int) $sibling->id]);
            }
            $this->lang = $this->editingLang;
            $this->template->adminContentLang = $this->editingLang;
            $this->flashMessage('Tato sekce zatím nemá druhou jazykovou verzi.', 'warning');
        }

        if ($this->getAdminContentLang() === $this->editingLang) {
            $this->assertAdminContentLanguage($item);
        }

        $this->fillSectionEditor($item);
    }

    /**
     * Přímé editace sekce podle klíčů – používá se pro stránky s jedinou sekcí (např. O nás).
     * @throws AbortException
     */
    public function actionSection(string $page, string $section): void
    {
        if (!isset(PageSectionRepository::SECTIONS[$page][$section])) {
            $this->error('Sekce nenalezena.');
        }

        $item = $this->pageSectionRepository->getByPageSection($page, $section, $this->getAdminContentLang());
        if (!$item) {
            $this->error('Sekce pro tento jazyk nebyla nalezena.');
        }

        $this->editingId = (int) $item->id;
        $this->editingPageKey = $page;
        $this->editingSectionKey = $section;
        $this->editingLang = (string) $item->lang;
        $this->showBackLink = count(PageSectionRepository::SECTIONS[$page]) > 1;

        $this->fillSectionEditor($item);
        $this->setView('edit');
    }

    private function fillSectionEditor(\Nette\Database\Table\ActiveRow $item): void
    {
        $this['sectionForm']->setDefaults([
            'title' => $item->title,
            'subtitle' => $item->subtitle,
            'content' => $item->content,
        ]);
        $this->template->pageTitle = PageSectionRepository::PAGES[$item->page_key];
        $this->template->sectionTitle = PageSectionRepository::SECTIONS[$item->page_key][$item->section_key];
        $this->template->currentImagePath = $item->image_path;
    }

    /** @return string[] */
    private function currentSectionFields(): array
    {
        $action = $this->getAction();
        $pageKey = $action === 'hero' ? 'homepage' : ($this->editingPageKey ?? $this->getParameter('page'));
        $sectionKey = match ($action) {
            'hero', 'default' => 'hero',
            default => $this->editingSectionKey ?? $this->getParameter('section'),
        };

        return PageSectionRepository::SECTION_FIELDS[$pageKey][$sectionKey] ?? ['title', 'subtitle', 'content', 'image'];
    }

    protected function createComponentSectionForm(): Form
    {
        $fields = $this->currentSectionFields();

        $form = new Form();
        $form->addProtection();
        $form->addText('title', 'Nadpis');

        if (in_array('subtitle', $fields, true)) {
            $form->addText('subtitle', 'Podnadpis');
        }

        if (in_array('content', $fields, true)) {
            if ($this->getAction() === 'hero') {
                $form->addText('content', 'Nadtitulek');
            } else {
                $form->addTextArea('content', 'Obsah')->setHtmlAttribute('rows', 10);
            }
        }

        if (in_array('image', $fields, true)) {
            $form->addUpload('upload', 'Nový obrázek');
        }

        $form->addSubmit('save', 'Uložit');
        $form->onSuccess[] = $this->sectionFormSucceeded(...);
        return $form;
    }

    private function sectionFormSucceeded(Form $form, \stdClass $values): void
    {
        $current = $this->pageSectionRepository->getById((int) $this->editingId);
        if (!$current) {
            $this->error('Sekce nenalezena.');
        }
        $this->assertAdminContentLanguage($current);

        $imagePath = (string) $current->image_path;
        $imageWasUploaded = false;

        /** @var FileUpload|null $upload */
        $upload = $values->upload ?? null;
        if ($upload && $upload->hasFile()) {
            if (!$upload->isOk() || !$upload->isImage() || $upload->getSize() > 8 * 1024 * 1024) {
                $form->addError('Nahrajte platný obrázek JPG, PNG, GIF nebo WebP do velikosti 8 MB.');
                return;
            }
            $storedImagePath = $this->storeImageUpload($upload, 'section');
            if ($storedImagePath === null) {
                $form->addError('Nahrajte platný obrázek JPG, PNG, GIF nebo WebP do velikosti 8 MB.');
                return;
            }
            $imagePath = $storedImagePath;
            $imageWasUploaded = true;
        }

        $lang = (string) $this->editingLang;

        $this->pageSectionRepository->save($this->editingId, [
            'title' => $values->title,
            'subtitle' => $values->subtitle ?? $current->subtitle,
            'content' => $values->content ?? $current->content,
            'image_path' => $imagePath,
        ]);

        if (
            $imageWasUploaded
            && is_string($this->editingPageKey)
            && is_string($this->editingSectionKey)
        ) {
            $this->pageSectionRepository->syncImageAcrossLocales(
                $this->editingPageKey,
                $this->editingSectionKey,
                $imagePath,
            );
        }

        $this->flashMessage('Sekce byla uložena.', 'success');

        if ($this->getAction() === 'default') {
            $this->redirect('default', ['page' => $this->editingPageKey, 'lang' => $lang]);
        }

        if ($this->editingPageKey === 'homepage' && $this->editingSectionKey === 'hero') {
            $this->redirect('hero', ['lang' => $lang]);
        }

        $this->redirect('section', [
            'page' => $this->editingPageKey,
            'section' => $this->editingSectionKey,
            'lang' => $lang,
        ]);
    }
}
