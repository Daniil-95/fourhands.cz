<?php declare(strict_types=1);

namespace App\AdminModule\Presenters;

use App\Common\BaseAdminPresenter;
use App\Model\TestimonialRepository;
use Nette\Application\AbortException;
use Nette\Application\UI\Form;

final class TestimonialPresenter extends BaseAdminPresenter
{
    private ?int $editingId = null;

    public function __construct(private TestimonialRepository $testimonialRepository)
    {
        parent::__construct();
    }

    public function renderDefault(): void
    {
        $this->template->items = $this->testimonialRepository->getAll();
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
            $item = $this->testimonialRepository->getById($id);
            if (!$item) {
                $this->error('Reference nenalezena.');
            }

            $this['testimonialForm']->setDefaults([
                'lang' => $item->lang,
                'client_name' => $item->client_name,
                'project_name' => $item->project_name ?? '',
                'quote_text' => $item->quote_text,
                'event_date' => $item->event_date ? $item->event_date->format('Y-m-d') : '',
                'sort_order' => $item->sort_order,
                'active' => (bool) $item->active,
            ]);
        }
    }

    protected function createComponentTestimonialForm(): Form
    {
        $form = new Form();
        $form->addProtection();
        $form->addSelect('lang', 'Jazyk', ['cs' => 'Čeština', 'en' => 'Angličtina'])->setRequired();
        $form->addText('client_name', 'Jméno klienta')->setRequired();
        $form->addText('project_name', 'Název akce/projektu');
        $form->addTextArea('quote_text', 'Text reference')->setRequired()->setHtmlAttribute('rows', 5);
        $form->addText('event_date', 'Datum akce')->setHtmlType('date');
        $form->addInteger('sort_order', 'Pořadí')->setDefaultValue(100);
        $form->addCheckbox('active', 'Publikovat')->setDefaultValue(true);
        $form->addSubmit('save', 'Uložit');

        $form->onSuccess[] = $this->testimonialFormSucceeded(...);
        return $form;
    }

    private function testimonialFormSucceeded(Form $form, \stdClass $values): void
    {
        $this->testimonialRepository->save([
            'lang' => $values->lang,
            'client_name' => $values->client_name,
            'project_name' => $values->project_name,
            'quote_text' => $values->quote_text,
            'event_date' => $values->event_date ?: null,
            'sort_order' => $values->sort_order ?? 100,
            'active' => $values->active,
        ], $this->editingId);

        $this->flashMessage('Reference byla uložena.', 'success');
        $this->redirect('default');
    }

    /** @throws AbortException */
    public function actionDelete(int $id): void
    {
        $token = $this->getParameter('_token');
        if (!is_string($token) || !$this->checkCsrfToken($token)) {
            $this->error('Neplatný bezpečnostní token.', 403);
        }

        $this->testimonialRepository->delete($id);
        $this->flashMessage('Reference byla smazána.', 'success');
        $this->redirect('default');
    }

    protected function createComponentDeleteForm(): Form
    {
        $form = new Form();
        $form->addProtection();
        $form->addHidden('id')->setRequired();
        $form->addSubmit('delete', 'Smazat');
        $form->onSuccess[] = function (Form $form, \stdClass $values): void {
            $this->testimonialRepository->delete((int) $values->id);
            $this->flashMessage('Reference byla smazána.', 'success');
            $this->redirect('default');
        };
        return $form;
    }
}
