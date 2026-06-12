<?php declare(strict_types=1);

namespace App\AdminModule\Presenters;

use App\Common\BaseAdminPresenter;
use App\Model\SettingRepository;
use Nette\Application\AbortException;
use Nette\Application\UI\Form;

final class SettingPresenter extends BaseAdminPresenter
{
    private ?int $editingId = null;

    public function __construct(private SettingRepository $settingRepository)
    {
        parent::__construct();
    }

    public function renderDefault(): void
    {
        $this->template->items = $this->settingRepository->getAll();
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
            $item = $this->settingRepository->getById($id);
            if (!$item) {
                $this->error('Nastavení nenalezeno.');
            }

            $this['settingForm']->setDefaults([
                'lang' => $item->lang,
                'group_name' => $item->group_name,
                'key_name' => $item->key_name,
                'label' => $item->label,
                'value_text' => $item->value_text,
                'sort_order' => $item->sort_order,
            ]);
        }
    }

    protected function createComponentSettingForm(): Form
    {
        $form = new Form();
        $form->addProtection();
        $form->addSelect('lang', 'Jazyk', ['cs' => 'Čeština', 'en' => 'Angličtina'])->setRequired();
        $form->addSelect('group_name', 'Skupina', [
            'general' => 'Obecné',
            'contact' => 'Kontakt',
            'social' => 'Sociální sítě',
            'seo' => 'SEO',
        ])->setRequired();
        $form->addText('key_name', 'Technický klíč')->setRequired()->addRule($form::Pattern, 'Použijte pouze malá písmena, čísla a podtržítko.', '[a-z0-9_]+');
        $form->addText('label', 'Popisek')->setRequired();
        $form->addTextArea('value_text', 'Hodnota')->setHtmlAttribute('rows', 3);
        $form->addInteger('sort_order', 'Pořadí')->setDefaultValue(100);
        $form->addSubmit('save', 'Uložit');

        $form->onSuccess[] = $this->settingFormSucceeded(...);
        return $form;
    }

    private function settingFormSucceeded(Form $form, \stdClass $values): void
    {
        $this->settingRepository->save([
            'lang' => $values->lang,
            'group_name' => $values->group_name,
            'key_name' => $values->key_name,
            'label' => $values->label,
            'value_text' => $values->value_text,
            'sort_order' => $values->sort_order ?? 100,
        ], $this->editingId);

        $this->flashMessage('Nastavení bylo uloženo.', 'success');
        $this->redirect('default');
    }

    /** @throws AbortException */
    public function actionDelete(int $id): void
    {
        $token = $this->getParameter('_token');
        if (!is_string($token) || !$this->checkCsrfToken($token)) {
            $this->error('Neplatný bezpečnostní token.', 403);
        }

        $this->settingRepository->delete($id);
        $this->flashMessage('Nastavení bylo smazáno.', 'success');
        $this->redirect('default');
    }

    protected function createComponentDeleteForm(): Form
    {
        $form = new Form();
        $form->addProtection();
        $form->addHidden('id')->setRequired();
        $form->addSubmit('delete', 'Smazat');
        $form->onSuccess[] = function (Form $form, \stdClass $values): void {
            $this->settingRepository->delete((int) $values->id);
            $this->flashMessage('Nastavení bylo smazáno.', 'success');
            $this->redirect('default');
        };
        return $form;
    }
}
