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
        $this->template->items = $this->filterByAdminContentLang($this->inquiryRepository->getAll());
    }

    /** @throws AbortException */
    public function actionDelete(int $id): void
    {
        $this->requirePostWithCsrf();
        $item = $this->inquiryRepository->getById($id);
        if (!$item) {
            $this->error('Zpráva nenalezena.');
        }
        $this->assertAdminContentLanguage($item);

        $this->inquiryRepository->delete($id);
        $this->flashMessage('Zpráva byla smazána.', 'success');
        $this->redirectToDefaultWithContentLang();
    }

    protected function createComponentDeleteForm(): Form
    {
        $form = new Form();
        $form->addProtection();
        $form->addHidden('id')->setRequired();
        $form->addSubmit('delete', 'Smazat');
        $form->onSuccess[] = function (Form $form, \stdClass $values): void {
            $item = $this->inquiryRepository->getById((int) $values->id);
            if (!$item) {
                $this->error('Zpráva nenalezena.');
            }
            $this->assertAdminContentLanguage($item);
            $this->inquiryRepository->delete((int) $values->id);
            $this->flashMessage('Zpráva byla smazána.', 'success');
            $this->redirectToDefaultWithContentLang();
        };
        return $form;
    }
}
