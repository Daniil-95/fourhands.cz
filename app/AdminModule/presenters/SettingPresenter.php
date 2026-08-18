<?php declare(strict_types=1);

namespace App\AdminModule\Presenters;

use App\Common\BaseAdminPresenter;
use App\Model\SettingRepository;
use Nette\Application\AbortException;
use Nette\Application\UI\Form;

final class SettingPresenter extends BaseAdminPresenter
{
    private ?int $editingId = null;
    private string $editReturnAction = 'default';

    public function __construct(private SettingRepository $settingRepository)
    {
        parent::__construct();
    }

    public function renderDefault(): void
    {
        $items = $this->filterByAdminContentLang($this->settingRepository->getAll());
        $groupOrder = ['general', 'contact', 'social'];
        $groups = [];

        foreach ($groupOrder as $groupName) {
            $groups[$groupName] = array_values(array_filter(
                $items,
                static fn($item): bool => (string) $item->group_name === $groupName,
            ));
        }

        $this->template->groups = $groups;
        $this->template->groupLabels = [
            'general' => 'Obecné nastavení',
            'contact' => 'Kontaktní údaje',
            'social' => 'Sociální sítě a odkazy',
            'seo' => 'SEO a sdílení',
        ];
        $this->template->groupDescriptions = [
            'general' => 'Texty a hodnoty, které se používají napříč webem.',
            'contact' => 'Údaje, podle kterých vás návštěvníci mohou kontaktovat.',
            'social' => 'Odkazy na sociální sítě, zásady ochrany údajů a cookies.',
        ];
    }

    public function renderSeo(): void
    {
        $items = $this->filterByAdminContentLang($this->settingRepository->getAll());
        $seoItems = array_values(array_filter(
            $items,
            static fn($item): bool => (string) $item->group_name === 'seo',
        ));
        $emptyKeys = [];

        foreach ($seoItems as $item) {
            if (trim((string) $item->value_text) === '') {
                $emptyKeys[] = (string) $item->key_name;
            }
        }

        $this->template->seoItems = $seoItems;
        $this->template->emptySeoKeys = $emptyKeys;
    }

    public function renderEdit(): void
    {
        $this->template->editingId = $this->editingId;
        $this->template->editReturnAction = $this->editReturnAction;
    }

    /** @throws AbortException */
    public function actionEdit(?int $id = null, ?string $from = null): void
    {
        $this->editingId = $id;
        $this->editReturnAction = $from === 'seo' ? 'seo' : 'default';

        if ($id !== null) {
            $item = $this->settingRepository->getById($id);
            if (!$item) {
                $this->error('Nastavení nenalezeno.');
            }
            $this->assertAdminContentLanguage($item);

            $this['settingForm']->setDefaults([
                'lang' => $item->lang,
                'group_name' => $item->group_name,
                'key_name' => $item->key_name,
                'label' => $item->label,
                'value_text' => $item->value_text,
                'sort_order' => $item->sort_order,
            ]);
            $this['settingForm']['lang']->setDisabled();
        } else {
            $this['settingForm']->setDefaults([
                'lang' => $this->getAdminContentLang(),
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
        // pole 'lang' je při editaci disabled, Nette ho proto do $values vůbec nezahrne
        $language = $this->getAdminContentLang();
        if ($this->editingId !== null) {
            $item = $this->settingRepository->getById($this->editingId);
            if (!$item) {
                $this->error('Nastavení nenalezeno.');
            }
            $this->assertAdminContentLanguage($item);
            $language = (string) $item->lang;
        } else {
            $language = $values->lang;
        }

        $this->settingRepository->save([
            'lang' => $language,
            'group_name' => $values->group_name,
            'key_name' => $values->key_name,
            'label' => $values->label,
            'value_text' => $values->value_text,
            'sort_order' => $values->sort_order ?? 100,
        ], $this->editingId);

        $this->flashMessage('Nastavení bylo uloženo.', 'success');
        if ($this->editReturnAction === 'seo') {
            $this->redirect('seo', ['lang' => $language]);
        }
        $this->redirectToDefaultWithContentLang($language);
    }

    /** @throws AbortException */
    public function actionDelete(int $id): void
    {
        $this->requirePostWithCsrf();
        $item = $this->settingRepository->getById($id);
        if (!$item) {
            $this->error('Nastavení nenalezeno.');
        }
        $this->assertAdminContentLanguage($item);

        $this->settingRepository->delete($id);
        $this->flashMessage('Nastavení bylo smazáno.', 'success');
        $this->redirectToDefaultWithContentLang();
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
            $this->redirectToDefaultWithContentLang();
        };
        return $form;
    }
}
