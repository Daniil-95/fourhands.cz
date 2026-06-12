<?php declare(strict_types=1);

namespace App\AdminModule\Presenters;

use App\Common\BaseAdminPresenter;
use App\Model\MediaRepository;
use Nette\Application\AbortException;
use Nette\Application\UI\Form;
use Nette\Http\FileUpload;
use Nette\Utils\Strings;

final class MediaPresenter extends BaseAdminPresenter
{
    private ?int $editingId = null;
    private ?string $editingType = null;

    public function __construct(private MediaRepository $mediaRepository)
    {
        parent::__construct();
    }

    public function renderDefault(): void
    {
        $this->template->items = $this->mediaRepository->getAll();
    }

    /** @throws AbortException */
    public function actionEdit(?int $id = null): void
    {
        $this->editingId = $id;

        if ($id !== null) {
            $item = $this->mediaRepository->getById($id);
            if (!$item) {
                $this->error('Médium nenalezeno.');
            }
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
        $form->addText('url', 'URL videa')->addConditionOn($form['type'], $form::Equal, 'video')->addRule($form::Url, 'Zadejte platnou URL videa.');
        $form->addInteger('sort_order', 'Pořadí')->setDefaultValue(100);
        $form->addCheckbox('active', 'Publikovat')->setDefaultValue(true);
        $form->addSubmit('save', 'Uložit');

        $form->onSuccess[] = $this->mediaFormSucceeded(...);
        return $form;
    }

    private function mediaFormSucceeded(Form $form, \stdClass $values): void
    {
        if ($this->editingId !== null) {
            $item = $this->mediaRepository->getById($this->editingId);
            if (!$item) {
                $this->error('Médium nebylo nalezeno.');
            }
            $values->type = $item->type;
        }

        /** @var FileUpload $upload */
        $upload = $values->upload;
        if ($upload->hasFile()) {
            if (!$upload->isOk() || !$upload->isImage() || $upload->getSize() > 8 * 1024 * 1024) {
                $form->addError('Nahrajte platný obrázek JPG, PNG, GIF nebo WebP do velikosti 8 MB.');
                return;
            }
            $base = Strings::webalize(pathinfo($upload->getSanitizedName(), PATHINFO_FILENAME)) ?: 'image';
            $extension = strtolower(pathinfo($upload->getSanitizedName(), PATHINFO_EXTENSION));
            $filename = $base . '-' . date('Ymd-His') . '.' . $extension;
            $upload->move(__DIR__ . '/../../../www/images/' . $filename);
            $values->image_path = 'images/' . $filename;
        }

        $this->mediaRepository->save([
            'lang' => $values->lang,
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
        $this->redirect('default');
    }

    /** @throws AbortException */
    public function actionDelete(int $id): void
    {
        $token = $this->getParameter('_token');
        if (!is_string($token) || !$this->checkCsrfToken($token)) {
            $this->error('Neplatný bezpečnostní token.', 403);
        }

        $this->mediaRepository->delete($id);
        $this->flashMessage('Médium bylo smazáno.', 'success');
        $this->redirect('default');
    }

    protected function createComponentDeleteForm(): Form
    {
        $form = new Form();
        $form->addProtection();
        $form->addHidden('id')->setRequired();
        $form->addSubmit('delete', 'Smazat');
        $form->onSuccess[] = function (Form $form, \stdClass $values): void {
            $this->mediaRepository->delete((int) $values->id);
            $this->flashMessage('Médium bylo smazáno.', 'success');
            $this->redirect('default');
        };
        return $form;
    }
}
