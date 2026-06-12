<?php declare(strict_types=1);

namespace App\AdminModule\Presenters;

use App\Common\BaseAdminPresenter;
use App\Model\NavigationRepository;
use Nette\Application\AbortException;
use Nette\Application\UI\Form;

final class NavigationPresenter extends BaseAdminPresenter
{
    private ?int $editingId = null;

    public function __construct(private NavigationRepository $navigationRepository)
    {
        parent::__construct();
    }

    public function renderDefault(): void
    {
        $this->template->items = $this->navigationRepository->getAll();
    }

    public function renderEdit(): void
    {
        $this->template->editingId = $this->editingId;
    }

    /** @throws AbortException */
    public function actionEdit(?int $id = null): void
    {
        $this->editingId = $id;

        if ($id !== null) {
            $item = $this->navigationRepository->getById($id);
            if (!$item) {
                $this->error('Položka menu nenalezena.');
            }

            $this['navigationForm']->setDefaults([
                'lang' => $item->lang,
                'title' => $item->title,
                'url' => $item->url,
                'sort_order' => $item->sort_order,
                'active' => (bool) $item->active,
            ]);
        }
    }

    protected function createComponentNavigationForm(): Form
    {
        $form = new Form();
        $form->addProtection();
        $form->addSelect('lang', 'Jazyk', ['cs' => 'Čeština', 'en' => 'Angličtina'])->setRequired();
        $form->addText('title', 'Název položky')->setRequired();
        $form->addText('url', 'URL adresa')->setRequired()->addRule($form::Pattern, 'Zadejte platnou URL začínající /', '^\/.*');
        $form->addInteger('sort_order', 'Pořadí')->setDefaultValue(100);
        $form->addCheckbox('active', 'Aktivní')->setDefaultValue(true);
        $form->addSubmit('save', 'Uložit');

        $form->onSuccess[] = $this->navigationFormSucceeded(...);
        return $form;
    }

    private function navigationFormSucceeded(Form $form, \stdClass $values): void
    {
        $this->navigationRepository->save([
            'lang' => $values->lang,
            'title' => $values->title,
            'url' => $values->url,
            'sort_order' => $values->sort_order ?? 100,
            'active' => $values->active,
        ], $this->editingId);

        $this->flashMessage('Položka menu byla uložena.', 'success');
        $this->redirect('default');
    }

    /** @throws AbortException */
    public function actionDelete(int $id): void
    {
        $token = $this->getParameter('_token');
        if (!is_string($token) || !$this->checkCsrfToken($token)) {
            $this->error('Neplatný bezpečnostní token.', 403);
        }

        $this->navigationRepository->delete($id);
        $this->flashMessage('Položka menu byla smazána.', 'success');
        $this->redirect('default');
    }

    protected function createComponentDeleteForm(): Form
    {
        $form = new Form();
        $form->addProtection();
        $form->addHidden('id')->setRequired();
        $form->addSubmit('delete', 'Smazat');
        $form->onSuccess[] = function (Form $form, \stdClass $values): void {
            $this->navigationRepository->delete((int) $values->id);
            $this->flashMessage('Položka menu byla smazána.', 'success');
            $this->redirect('default');
        };
        return $form;
    }
}
