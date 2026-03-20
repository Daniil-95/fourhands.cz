<?php declare(strict_types=1);

namespace App\Presentation\Admin\Sign;

use App\Core\BaseAdminPresenter;
use Nette\Application\UI\Form;

final class SignPresenter extends BaseAdminPresenter
{
    public function renderDefault(): void
    {
    }

    protected function createComponentSignInForm(): Form
    {
        $form = new Form();
        $form->addText('username', 'Username')->setRequired();
        $form->addPassword('password', 'Password')->setRequired();
        $form->addSubmit('send', 'Sign in');
        $form->onSuccess[] = $this->signInSucceeded(...);

        return $form;
    }

    public function actionOut(): void
    {
        $this->getUser()->logout();
        $this->flashMessage('Signed out.', 'info');
        $this->redirect('default');
    }

    private function signInSucceeded(Form $form, \stdClass $values): void
    {
        try {
            $this->getUser()->login($values->username, $values->password);
            $this->redirect(':Admin:Dashboard:default');
        } catch (\Throwable $e) {
            $form->addError('Invalid credentials.');
        }
    }
}
