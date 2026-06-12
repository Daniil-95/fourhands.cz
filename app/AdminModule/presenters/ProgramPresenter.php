<?php declare(strict_types=1);

namespace App\AdminModule\Presenters;

use App\Common\BaseAdminPresenter;
use App\Model\ProgramRepository;
use Nette\Application\AbortException;
use Nette\Application\UI\Form;

final class ProgramPresenter extends BaseAdminPresenter
{
    private ?int $editingId = null;

    public function __construct(private ProgramRepository $programRepository)
    {
        parent::__construct();
    }

    public function renderDefault(): void
    {
        $this->template->items = $this->programRepository->getAll();
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
            $item = $this->programRepository->getById($id);
            if (!$item) {
                $this->error('Program nenalezen.');
            }

            $this['programForm']->setDefaults([
                'lang' => $item->lang,
                'title' => $item->title,
                'description' => $item->description,
                'icon' => $item->icon,
                'image_path' => $item->image_path,
                'sort_order' => $item->sort_order,
                'active' => (bool) $item->active,
            ]);
        }
    }

    protected function createComponentProgramForm(): Form
    {
        $form = new Form();
        $form->addProtection();
        $form->addSelect('lang', 'Jazyk', ['cs' => 'Čeština', 'en' => 'Angličtina'])->setRequired();
        $form->addText('title', 'Název')->setRequired();
        $form->addTextArea('description', 'Popis')->setHtmlAttribute('rows', 3);
        $form->addSelect('icon', 'Ikona', [
            'heart' => '♥ Srdce',
            'diamond' => '♦ Kosočtverec',
            'note' => '♫ Nota',
            'star' => '★ Hvězda',
        ])->setRequired();
        $form->addText('image_path', 'Cesta k obrázku')->setDefaultValue('images/');
        $form->addInteger('sort_order', 'Pořadí')->setDefaultValue(100);
        $form->addCheckbox('active', 'Aktivní')->setDefaultValue(true);
        $form->addSubmit('save', 'Uložit');

        $form->onSuccess[] = $this->programFormSucceeded(...);
        return $form;
    }

    private function programFormSucceeded(Form $form, \stdClass $values): void
    {
        $this->programRepository->save([
            'lang' => $values->lang,
            'title' => $values->title,
            'description' => $values->description,
            'icon' => $values->icon,
            'image_path' => $values->image_path,
            'sort_order' => $values->sort_order ?? 100,
            'active' => $values->active,
        ], $this->editingId);

        $this->flashMessage('Program byl uložen.', 'success');
        $this->redirect('default');
    }

    /** @throws AbortException */
    public function actionDelete(int $id): void
    {
        $token = $this->getParameter('_token');
        if (!is_string($token) || !$this->checkCsrfToken($token)) {
            $this->error('Neplatný bezpečnostní token.', 403);
        }

        $this->programRepository->delete($id);
        $this->flashMessage('Program byl smazán.', 'success');
        $this->redirect('default');
    }
}
