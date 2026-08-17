<?php declare(strict_types=1);

namespace App\AdminModule\Presenters;

use App\Common\BaseAdminPresenter;
use Nette\Application\AbortException;

final class ContentPresenter extends BaseAdminPresenter
{
    /** @throws AbortException */
    public function actionDefault(): void
    {
        $this->redirect(':Admin:Page:default', ['lang' => $this->getAdminContentLang()]);
    }

    /** @throws AbortException */
    public function actionEdit(): void
    {
        $this->redirect(':Admin:Page:default', ['lang' => $this->getAdminContentLang()]);
    }

    /** @throws AbortException */
    public function actionDelete(): void
    {
        $this->redirect(':Admin:Page:default', ['lang' => $this->getAdminContentLang()]);
    }
}