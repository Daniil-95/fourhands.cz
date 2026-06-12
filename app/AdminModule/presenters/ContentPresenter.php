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
                $this->error('Blok obsahu nenalezen.');
            }

            $this['contentForm']->setDefaults([
                'lang' => $item->lang,
                'key_name' => $item->code,
                'title' => $item->code,
                'category' => $item->category,
                'content_html' => $item->content,
                'sort_order' => $item->sort_order,
                'active' => (bool) $item->active,
            ]);
        }
    }

    protected function createComponentContentForm(): Form
    {
        $form = new Form();
        $form->addProtection('Platnost formuláře vypršela. Odešlete jej znovu.');
        $form->addSelect('lang', 'Jazyk', ['cs' => 'Čeština', 'en' => 'Angličtina'])->setRequired();
        $form->addText('key_name', 'Technický klíč')->setRequired()->addRule($form::Pattern, 'Použijte pouze malá písmena, čísla a podtržítko.', '[a-z0-9_]+');
        $form->addText('title', 'Název bloku')->setRequired();
        $form->addSelect('category', 'Skupina', ['content' => 'Obsah', 'page' => 'Stránka', 'seo' => 'SEO'])->setRequired();
        $form->addTextArea('content_html', 'Obsah')->setHtmlAttribute('rows', 14);
        $form->addInteger('sort_order', 'Pořadí')->setDefaultValue(100);
        $form->addCheckbox('active', 'Aktivní')->setDefaultValue(true);
        $form->addSubmit('save', 'Uložit');

        $form->onSuccess[] = $this->contentFormSucceeded(...);
        return $form;
    }

    private function contentFormSucceeded(Form $form, \stdClass $values): void
    {
        $this->contentRepository->save([
            'lang' => $values->lang,
            'key_name' => $values->key_name,
            'title' => $values->title,
            'category' => $values->category,
            'content_html' => $values->content_html,
            'sort_order' => $values->sort_order ?? 100,
            'active' => $values->active,
        ], $this->editingId);

        $this->flashMessage('Obsah byl uložen.', 'success');
        $this->redirect('default');
    }

    /** @throws AbortException */
    public function actionDelete(int $id): void
    {
        $token = $this->getParameter('_token');
        if (!is_string($token) || !$this->checkCsrfToken($token)) {
            $this->error('Neplatný bezpečnostní token.', 403);
        }

        $this->contentRepository->delete($id);
        $this->flashMessage('Obsah byl smazán.', 'success');
        $this->redirect('default');
    }

    protected function createComponentDeleteForm(): Form
    {
        $form = new Form();
        $form->addProtection();
        $form->addHidden('id')->setRequired();
        $form->addSubmit('delete', 'Smazat');
        $form->onSuccess[] = function (Form $form, \stdClass $values): void {
            $this->contentRepository->delete((int) $values->id);
            $this->flashMessage('Obsah byl smazán.', 'success');
            $this->redirect('default');
        };
        return $form;
    }
}
