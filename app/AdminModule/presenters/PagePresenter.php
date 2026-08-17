<?php declare(strict_types=1);

namespace App\AdminModule\Presenters;

use App\Common\BaseAdminPresenter;
use App\Model\PageSectionRepository;
use Nette\Application\AbortException;
use Nette\Application\UI\Form;
use Nette\Http\FileUpload;
use Nette\Utils\Strings;

final class PagePresenter extends BaseAdminPresenter
{
    private ?int $editingId = null;
    private ?string $editingPageKey = null;
    private ?string $editingSectionKey = null;
    private ?string $editingLang = null;

    public function __construct(private PageSectionRepository $pageSectionRepository)
    {
        parent::__construct();
    }

    public function renderDefault(?string $page = null): void
    {
        $pageKey = is_string($page) && isset(PageSectionRepository::PAGES[$page]) ? $page : 'about';
        $sections = $this->pageSectionRepository->getAllGroupedByPage($this->getAdminContentLang());
        $this->template->pageKey = $pageKey;
        $this->template->pageTitle = PageSectionRepository::PAGES[$pageKey];
        $this->template->sections = $sections[$pageKey] ?? [];
        $this->template->sectionLabels = PageSectionRepository::SECTIONS[$pageKey];
    }

    public function renderEdit(): void
    {
        $this->template->editingId = $this->editingId;
        $this->template->pageKey = $this->editingPageKey;
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

        $this['sectionForm']->setDefaults([
            'title' => $item->title,
            'subtitle' => $item->subtitle,
            'content' => $item->content,
            'button_text' => '',
            'button_url' => '',
            'image_path' => $item->image_path,
            'active' => (bool) $item->active,
        ]);

        $this->template->pageTitle = PageSectionRepository::PAGES['homepage'];
        $this->template->sectionTitle = PageSectionRepository::SECTIONS['homepage']['hero'];
        $this->template->currentImagePath = $item->image_path;
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

        $this['sectionForm']->setDefaults([
            'title' => $item->title,
            'subtitle' => $item->subtitle,
            'content' => $item->content,
            'button_text' => $item->button_text,
            'button_url' => $item->button_url,
            'image_path' => $item->image_path,
            'active' => (bool) $item->active,
        ]);
        $this->template->pageTitle = PageSectionRepository::PAGES[$item->page_key];
        $this->template->sectionTitle = PageSectionRepository::SECTIONS[$item->page_key][$item->section_key];
        $this->template->currentImagePath = $item->image_path;
    }

    protected function createComponentSectionForm(): Form
    {
        $form = new Form();
        $form->addProtection();
        $form->addText('title', 'Nadpis');
        $form->addText('subtitle', 'Podnadpis');

        if ($this->getAction() === 'hero') {
            $form->addText('content', 'Nadtitulek');
        } else {
            $form->addTextArea('content', 'Obsah')->setHtmlAttribute('rows', 10);
        }

        if ($this->getAction() === 'hero') {
            $form->addHidden('button_text')->setDefaultValue('');
            $form->addHidden('button_url')->setDefaultValue('');
            $form->addHidden('image_path');
            $form->addHidden('active')->setDefaultValue('1');
        } else {
            $form->addText('button_text', 'Text tlačítka');
            $form->addText('button_url', 'Odkaz tlačítka');
            $form->addText('image_path', 'Cesta k obrázku')->setOption('description', 'Použijte pouze pokud nechcete nahrát nový soubor.');
            $form->addCheckbox('active', 'Aktivní')->setDefaultValue(true);
        }

        $form->addUpload('upload', 'Nový obrázek');
        $form->addSubmit('save', 'Uložit sekci');
        $form->onSuccess[] = $this->sectionFormSucceeded(...);
        return $form;
    }

    private function sectionFormSucceeded(Form $form, \stdClass $values): void
    {
        /** @var FileUpload $upload */
        $upload = $values->upload;
        if ($upload->hasFile()) {
            if (!$upload->isOk() || !$upload->isImage() || $upload->getSize() > 8 * 1024 * 1024) {
                $form->addError('Nahrajte platný obrázek JPG, PNG, GIF nebo WebP do velikosti 8 MB.');
                return;
            }
            $base = Strings::webalize(pathinfo($upload->getSanitizedName(), PATHINFO_FILENAME)) ?: 'section';
            $extension = strtolower(pathinfo($upload->getSanitizedName(), PATHINFO_EXTENSION));
            $filename = $base . '-' . date('Ymd-His') . '.' . $extension;
            $upload->move(__DIR__ . '/../../../www/images/' . $filename);
            $values->image_path = 'images/' . $filename;
        }

        $lang = (string) $this->editingLang;

        $this->pageSectionRepository->save($this->editingId, [
            'title' => $values->title,
            'subtitle' => $values->subtitle,
            'content' => $values->content,
            'button_text' => $values->button_text,
            'button_url' => $values->button_url,
            'image_path' => $values->image_path,
            'active' => $values->active,
        ]);
        $this->flashMessage('Sekce byla uložena.', 'success');
        if ($this->editingPageKey === 'homepage' && $this->editingSectionKey === 'hero') {
            $this->redirect('hero', ['lang' => $lang]);
        }

        $this->redirect('default', ['page' => $this->editingPageKey, 'lang' => $lang]);
    }
}
