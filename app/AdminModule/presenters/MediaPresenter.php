<?php declare(strict_types=1);

namespace App\AdminModule\Presenters;

use App\Common\BaseAdminPresenter;
use App\Model\MediaRepository;
use Nette\Application\AbortException;
use Nette\Application\UI\Form;

final class MediaPresenter extends BaseAdminPresenter
{
    private ?int $editingId = null;

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
                $this->error('Media item not found.');
            }

            $this['mediaForm']->setDefaults([
                'lang' => $item->lang,
                'type' => $item->type,
                'title' => $item->title,
                'description' => $item->description,
                'image_path' => $item->image_path,
                'url' => $item->url,
                'sort_order' => $item->sort_order,
            ]);
        }
    }

    public function actionDelete(int $id): void
    {
        $this->mediaRepository->delete($id);
        $this->flashMessage('Media item deleted.', 'success');
        $this->redirect('default');
    }

    protected function createComponentMediaForm(): Form
    {
        $form = new Form();
        $form->addSelect('lang', 'Language', ['cs' => 'Czech', 'en' => 'English'])->setRequired();
        $form->addSelect('type', 'Type', ['photo' => 'Photo', 'video' => 'Video'])->setRequired();
        $form->addText('title', 'Title')->setRequired();
        $form->addTextArea('description', 'Description')->setHtmlAttribute('rows', 3);
        $form->addText('image_path', 'Image path (e.g. images/kids1-thumb.jpg)');
        $form->addText('url', 'URL (for video link)');
        $form->addInteger('sort_order', 'Sort order')->setDefaultValue(100);
        $form->addSubmit('save', 'Save');

        $form->onSuccess[] = $this->mediaFormSucceeded(...);
        return $form;
    }

    private function mediaFormSucceeded(Form $form, \stdClass $values): void
    {
        $this->mediaRepository->save([
            'lang' => $values->lang,
            'type' => $values->type,
            'title' => $values->title,
            'description' => $values->description,
            'image_path' => $values->image_path,
            'url' => $values->url,
            'sort_order' => $values->sort_order ?? 100,
        ], $this->editingId);

        $this->flashMessage('Media item saved.', 'success');
        $this->redirect('default');
    }
}
