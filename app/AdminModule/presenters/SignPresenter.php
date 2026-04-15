<?php declare(strict_types=1);

namespace App\AdminModule\Presenters;

use App\Common\BaseAdminPresenter;
use Nette\Application\UI\Form;
use Nette\Security\AuthenticationException;

final class SignPresenter extends BaseAdminPresenter
{
    public function renderDefault(): void
    {
    }

    protected function createComponentSignInForm(): Form
    {
        $form = new Form();
        $form->addText('username', 'Username or email')->setRequired();
        $form->addPassword('password', 'Password')->setRequired();
        $form->addCheckbox('remember', 'Remember me for 30 days');
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
            $this->getUser()->setExpiration(
                $values->remember ? '30 days' : '30 minutes',
                !$values->remember,
            );
            $this->getUser()->login($values->username, $values->password);
            $this->redirect(':Admin:Dashboard:default');
        } catch (AuthenticationException $e) {
            $form->addError($e->getMessage());
        }
    }
}
