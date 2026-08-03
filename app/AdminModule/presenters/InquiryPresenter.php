<?php declare(strict_types=1);

namespace App\AdminModule\Presenters;

use App\Common\BaseAdminPresenter;
use App\Model\InquiryRepository;
use Nette\Application\AbortException;
use Nette\Application\UI\Form;

final class InquiryPresenter extends BaseAdminPresenter
{
    public function __construct(private InquiryRepository $inquiryRepository)
    {
        parent::__construct();
    }

    public function renderDefault(): void
    {
        $this->template->items = $this->inquiryRepository->getAll();
    }

    /** @throws AbortException */
    public function actionDelete(int $id): void
    {
        $token = $this->getParameter('_token');
        if (!is_string($token) || !$this->checkCsrfToken($token)) {
            $this->error('Neplatný bezpečnostní token.', 403);
        }

        $this->inquiryRepository->delete($id);
        $this->flashMessage('Zpráva byla smazána.', 'success');
        $this->redirect('default');
    }

    protected function createComponentDeleteForm(): Form
    {
        $form = new Form();
        $form->addProtection();
        $form->addHidden('id')->setRequired();
        $form->addSubmit('delete', 'Smazat');
        $form->onSuccess[] = function (Form $form, \stdClass $values): void {
            $this->inquiryRepository->delete((int) $values->id);
            $this->flashMessage('Zpráva byla smazána.', 'success');
            $this->redirect('default');
        };
        return $form;
    }
}
