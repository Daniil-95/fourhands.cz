<?php declare(strict_types=1);

namespace App\AdminModule\Presenters;

use App\Common\BaseAdminPresenter;
use App\Model\MediaRepository;
use Nette\Application\AbortException;
use Nette\Application\UI\Form;
use Nette\Http\FileUpload;

final class MediaPresenter extends BaseAdminPresenter
{
    private ?int $editingId = null;
    private ?string $editingType = null;
    private ?string $presetType = null;

    public function __construct(private MediaRepository $mediaRepository)
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
                $item->youtube_thumb = $this->buildYoutubeThumb((string) $item->url);
                $videos[] = $item;
                continue;
            }

            $photos[] = $item;
        }

        $tab = $this->getParameter('type');
        $this->template->activeTab = is_string($tab) && $tab === 'video' ? 'video' : 'photo';
        $this->template->photos = $photos;
        $this->template->videos = $videos;
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
            $defaults = [
                'lang' => $this->getAdminContentLang(),
            ];
            if ($this->presetType !== null) {
                $defaults['type'] = $this->presetType;
            }
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
        $language = $values->lang;
        if ($this->editingId !== null) {
            $item = $this->mediaRepository->getById($this->editingId);
            if (!$item) {
                $this->error('Médium nebylo nalezeno.');
            }
            $this->assertAdminContentLanguage($item);
            $values->type = $item->type;
            $language = (string) $item->lang;
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
        }

        $this->mediaRepository->save([
            'lang' => $language,
            'type' => $values->type,
            'title' => $values->title,
            'description' => $values->description,
            'alt_text' => $values->alt_text,
            'image_path' => $values->image_path,
            'url' => $values->url,
            'sort_order' => $values->sort_order ?? 100,
            'active' => $values->active,
        ], (int) $this->getUser()->getId(), $this->editingId);

        $this->flashMessage('Médium bylo uloženo.', 'success');
        $this->redirectToDefaultWithContentLang($values->lang, ['type' => $values->type]);
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

    private function buildYoutubeThumb(string $url): string
    {
        $trimmed = trim($url);
        if ($trimmed === '') {
            return '';
        }

        if (preg_match('~(?:youtube\.com/watch\?v=|youtu\.be/|youtube\.com/embed/)([A-Za-z0-9_-]{8,})~', $trimmed, $matches) !== 1) {
            return '';
        }

        $videoId = $matches[1];
        return 'https://img.youtube.com/vi/' . $videoId . '/hqdefault.jpg';
    }
}
