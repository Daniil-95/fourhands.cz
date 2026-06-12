<?php declare(strict_types=1);

namespace App\AdminModule\Presenters;

use App\Common\BaseAdminPresenter;
use App\Model\ContentRepository;
use Nette\Application\AbortException;
use Nette\Application\UI\Form;

final class ContentPresenter extends BaseAdminPresenter
{
    private ?int $editingId = null;

    public function __construct(private ContentRepository $contentRepository)
    {
        parent::__construct();
    }

    public function renderDefault(): void
    {
        $this->template->items = $this->contentRepository->getAll();
    }

    /** @throws AbortException */
    public function actionEdit(?int $id = null): void
    {
        $this->editingId = $id;

        if ($id !== null) {
            $item = $this->contentRepository->getById($id);
            if (!$item) {
                $this->error('Content block not found.');
            }

            $this['contentForm']->setDefaults([
                'lang' => $item->lang,
                'key_name' => $item->code,
                'title' => $item->code,
                'content_html' => $item->content,
                'sort_order' => 0,
            ]);
        }
    }

    public function actionDelete(int $id): void
    {
        $this->contentRepository->delete($id);
        $this->flashMessage('Content block deleted.', 'success');
        $this->redirect('default');
    }

    protected function createComponentContentForm(): Form
    {
        $form = new Form();
        $form->addSelect('lang', 'Language', ['cs' => 'Czech', 'en' => 'English'])->setRequired();
        $form->addText('key_name', 'Key (unique per language)')->setRequired();
        $form->addText('title', 'Title')->setRequired();
        $form->addTextArea('content_html', 'HTML content')->setRequired()->setHtmlAttribute('rows', 12);
        $form->addInteger('sort_order', 'Sort order')->setDefaultValue(100);
        $form->addSubmit('save', 'Save');

        $form->onSuccess[] = $this->contentFormSucceeded(...);
        return $form;
    }

    private function contentFormSucceeded(Form $form, \stdClass $values): void
    {
        $this->contentRepository->save([
            'lang' => $values->lang,
            'key_name' => $values->key_name,
            'title' => $values->title,
            'content_html' => $values->content_html,
            'sort_order' => $values->sort_order ?? 100,
        ], $this->editingId);

        $this->flashMessage('Content block saved.', 'success');
        $this->redirect('default');
    }
}
