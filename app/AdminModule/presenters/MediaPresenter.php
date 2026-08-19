<?php declare(strict_types=1);

namespace App\AdminModule\Presenters;

use App\Common\BaseAdminPresenter;
use App\Model\MediaRepository;
use App\Model\PageSectionRepository;
use Nette\Application\AbortException;
use Nette\Application\UI\Form;
use Nette\Http\FileUpload;

final class MediaPresenter extends BaseAdminPresenter
{
    private ?int $editingId = null;
    private ?string $editingType = null;
    private ?string $presetType = null;

    public function __construct(
        private MediaRepository $mediaRepository,
        private PageSectionRepository $pageSectionRepository,
    )
    {
        parent::__construct();
    }

    public function renderDefault(): void
    {
        $allItems = $this->filterByAdminContentLang($this->mediaRepository->getAll());
        $photos = [];
        $videos = [];

        foreach ($allItems as $item) {
            if ($item->type === 'video') {
                $videos[] = $item;
                continue;
            }

            $photos[] = $item;
        }

        $tab = $this->getParameter('type');
        $activeTab = is_string($tab) && $tab === 'video' ? 'video' : 'photo';
        $sectionKey = $activeTab === 'video' ? 'videos' : 'gallery';
        $section = $this->pageSectionRepository->getByPageSection('homepage', $sectionKey, $this->getAdminContentLang());
        $this->template->activeTab = $activeTab;
        $this->template->mediaSectionTitle = $section?->title ?? '';
        $this->template->mediaSectionSubtitle = $section?->subtitle ?? '';
        $this['mediaSectionForm']->setDefaults([
            'type' => $activeTab,
            'title' => $section?->title ?? '',
            'subtitle' => $section?->subtitle ?? '',
        ]);
        $this->template->photos = $photos;
        $this->template->videos = $videos;
    }

    protected function createComponentMediaSectionForm(): Form
    {
        $form = new Form();
        $form->addProtection();
        // 'type' se ukládá jako skryté pole, protože parametr URL není persistentní a při odeslání formuláře by se ztratil
        $form->addHidden('type', 'photo');
        $form->addText('title', 'Titulek')->setRequired();
        $form->addText('subtitle', 'Podtitulek');
        $form->addSubmit('save', 'Uložit texty');
        $form->onSuccess[] = $this->mediaSectionFormSucceeded(...);
        return $form;
    }

    private function mediaSectionFormSucceeded(Form $form, \stdClass $values): void
    {
        $sectionKey = $values->type === 'video' ? 'videos' : 'gallery';
        $section = $this->pageSectionRepository->getByPageSection(
            'homepage',
            $sectionKey,
            $this->getAdminContentLang(),
        );
        if (!$section) {
            $this->error('Texty sekce nebyly nalezeny.');
        }

        $this->pageSectionRepository->updateTitleAndSubtitle(
            (int) $section->id,
            (string) $values->title,
            (string) $values->subtitle,
        );
        $this->flashMessage('Texty sekce byly uloženy.', 'success');
        $this->redirectToDefaultWithContentLang($this->getAdminContentLang(), [
            'type' => $sectionKey === 'videos' ? 'video' : 'photo',
        ]);
    }

    public function renderEdit(): void
    {
        $this->template->editingId = $this->editingId;
        $this->template->editingType = $this->editingType;
        $this->template->presetType = $this->presetType;
    }

    /** @throws AbortException */
    public function actionEdit(?int $id = null, ?string $type = null): void
    {
        $this->editingId = $id;
        $this->presetType = is_string($type) && in_array($type, ['photo', 'video'], true) ? $type : null;

        if ($id !== null) {
            $item = $this->mediaRepository->getById($id);
            if (!$item) {
                $this->error('Médium nenalezeno.');
            }
            $this->assertAdminContentLanguage($item);
            $this->editingType = $item->type;

            $this['mediaForm']->setDefaults([
                'lang' => $item->lang,
                'type' => $item->type,
                'title' => $item->title,
                'description' => $item->description,
                'image_path' => $item->image_path,
                'url' => $item->url,
                'sort_order' => $item->sort_order,
                'active' => $item->active,
                'alt_text' => $item->alt_text ?? '',
            ]);
            $this['mediaForm']['lang']->setDisabled();
            $this['mediaForm']['type']->setDisabled();

            $this->template->currentImagePath = $item->image_path;
        } else {
            $this->template->currentImagePath = null;
            $newType = $this->presetType ?? 'photo';
            $defaults = [
                'lang' => $this->getAdminContentLang(),
                'type' => $newType,
                'sort_order' => $this->mediaRepository->getNextTopSortOrder($newType),
            ];
            $this['mediaForm']->setDefaults($defaults);
        }
    }

    protected function createComponentMediaForm(): Form
    {
        $form = new Form();
        $form->addProtection();
        $form->addSelect('lang', 'Jazyk', ['cs' => 'Čeština', 'en' => 'Angličtina'])->setRequired();
        $form->addSelect('type', 'Typ', ['photo' => 'Fotografie', 'video' => 'Video'])->setRequired();
        $form->addText('title', 'Název')->setRequired();
        $form->addTextArea('description', 'Popis')->setHtmlAttribute('rows', 3);
        $form->addText('alt_text', 'Alternativní text obrázku');
        $form->addUpload('upload', 'Nahrát obrázek');
        $form->addText('image_path', 'Existující cesta k obrázku')->setOption('description', 'Použijte pouze pokud nechcete nahrát nový soubor.');
        $form->addText('url', 'URL videa')->addConditionOn($form['type'], $form::Equal, 'video')->addRule($form::URL, 'Zadejte platnou URL videa.');
        $form->addInteger('sort_order', 'Pořadí')->setDefaultValue(100);
        $form->addCheckbox('active', 'Publikovat')->setDefaultValue(true);
        $form->addSubmit('save', 'Uložit');

        $form->onSuccess[] = $this->mediaFormSucceeded(...);
        return $form;
    }

    private function mediaFormSucceeded(Form $form, \stdClass $values): void
    {
        // pole 'lang' i 'type' jsou při editaci disabled, Nette je proto do $values vůbec nezahrne
        $language = $this->getAdminContentLang();
        if ($this->editingId !== null) {
            $item = $this->mediaRepository->getById($this->editingId);
            if (!$item) {
                $this->error('Médium nebylo nalezeno.');
            }
            $this->assertAdminContentLanguage($item);
            $values->type = $item->type;
            $language = (string) $item->lang;
        } else {
            $language = $values->lang;
        }

        /** @var FileUpload $upload */
        $upload = $values->upload;
        if ($upload->hasFile()) {
            if (!$upload->isOk() || !$upload->isImage() || $upload->getSize() > 8 * 1024 * 1024) {
                $form->addError('Nahrajte platný obrázek JPG, PNG, GIF nebo WebP do velikosti 8 MB.');
                return;
            }
            $imagePath = $this->storeImageUpload($upload, 'media');
            if ($imagePath === null) {
                $form->addError('Nahrajte platný obrázek JPG, PNG, GIF nebo WebP do velikosti 8 MB.');
                return;
            }
            $values->image_path = $imagePath;
        } elseif (is_string($values->image_path) && (
            str_contains($values->image_path, '..')
            || str_contains($values->image_path, '\\')
            || preg_match('~^(?:[a-z][a-z0-9+.-]*:|//)~i', trim($values->image_path)) === 1
        )) {
            $form->addError('Zadejte pouze bezpečnou lokální cestu k obrázku.');
            return;
        }

        $mediaUrl = trim((string) ($values->url ?? ''));
        if ($values->type === 'video' && $mediaUrl !== '') {
            $parts = parse_url($mediaUrl);
            if (
                filter_var($mediaUrl, FILTER_VALIDATE_URL) === false
                || !is_array($parts)
                || !in_array(strtolower((string) ($parts['scheme'] ?? '')), ['http', 'https'], true)
            ) {
                $form->addError('Zadejte platný odkaz na video začínající http:// nebo https://.');
                return;
            }
        }

        $this->mediaRepository->save([
            'lang' => $language,
            'type' => $values->type,
            'title' => $values->title,
            'description' => $values->description,
            'alt_text' => $values->alt_text,
            'image_path' => $values->image_path,
            'url' => $mediaUrl !== '' ? $mediaUrl : null,
            'sort_order' => $values->sort_order ?? 100,
            'active' => $values->active,
        ], (int) $this->getUser()->getId(), $this->editingId);

        $this->flashMessage('Médium bylo uloženo.', 'success');
        $this->redirectToDefaultWithContentLang($language, ['type' => $values->type]);
    }

    /** @throws AbortException */
    public function actionDelete(int $id): void
    {
        $this->requirePostWithCsrf();
        $tab = $this->getParameter('type');
        $item = $this->mediaRepository->getById($id);
        if (!$item) {
            $this->error('Médium nenalezeno.');
        }
        $this->assertAdminContentLanguage($item);
        if (is_string($tab) && in_array($tab, ['photo', 'video'], true) && $item->type !== $tab) {
            $this->error('Médium nepatří do zvolené galerie.', 404);
        }

        $this->mediaRepository->delete($id);
        $this->flashMessage('Médium bylo smazáno.', 'success');
        $this->redirectToDefaultWithContentLang(null, ['type' => is_string($tab) ? $tab : null]);
    }

    protected function createComponentDeleteForm(): Form
    {
        $form = new Form();
        $form->addProtection();
        $form->addHidden('id')->setRequired();
        $form->addSubmit('delete', 'Smazat');
        $form->onSuccess[] = function (Form $form, \stdClass $values): void {
            $item = $this->mediaRepository->getById((int) $values->id);
            if (!$item) {
                $this->error('Médium nenalezeno.');
            }
            $this->assertAdminContentLanguage($item);
            $this->mediaRepository->delete((int) $values->id);
            $this->flashMessage('Médium bylo smazáno.', 'success');
            $this->redirectToDefaultWithContentLang();
        };
        return $form;
    }

}
