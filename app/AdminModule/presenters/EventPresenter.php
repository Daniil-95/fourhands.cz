<?php declare(strict_types=1);

namespace App\AdminModule\Presenters;

use App\Common\BaseAdminPresenter;
use App\Model\EventRepository;
use Nette\Application\AbortException;
use Nette\Application\UI\Form;

final class EventPresenter extends BaseAdminPresenter
{
    private ?int $editingId = null;

    public function __construct(private EventRepository $eventRepository)
    {
        parent::__construct();
    }

    public function renderDefault(): void
    {
        $this->template->items = $this->filterByAdminContentLang($this->eventRepository->getAll());
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
            $item = $this->eventRepository->getById($id);
            if (!$item) {
                $this->error('Událost nenalezena.');
            }
            $this->assertAdminContentLanguage($item);

            $this['eventForm']->setDefaults([
                'lang' => $item->lang,
                'event_date' => $item->publish_date ? $item->publish_date->format('Y-m-d') : '',
                'description' => $item->title,
                'sort_order' => $item->sort_order,
                'active' => (bool) $item->active,
            ]);
            $this['eventForm']['lang']->setDisabled();
        } else {
            $this['eventForm']->setDefaults([
                'lang' => $this->getAdminContentLang(),
            ]);
        }
    }

    protected function createComponentEventForm(): Form
    {
        $form = new Form();
        $form->addProtection();
        $form->addSelect('lang', 'Jazyk', ['cs' => 'Čeština', 'en' => 'Angličtina'])->setRequired();
        $form->addText('event_date', 'Datum')->setHtmlType('date')->setRequired();
        $form->addTextArea('description', 'Název a popis akce')->setRequired()->setHtmlAttribute('rows', 5);
        $form->addInteger('sort_order', 'Pořadí')->setDefaultValue(100);
        $form->addCheckbox('active', 'Publikovat')->setDefaultValue(true);
        $form->addSubmit('save', 'Uložit');

        $form->onSuccess[] = $this->eventFormSucceeded(...);
        return $form;
    }

    private function eventFormSucceeded(Form $form, \stdClass $values): void
    {
        $language = $values->lang;
        if ($this->editingId !== null) {
            $item = $this->eventRepository->getById($this->editingId);
            if (!$item) {
                $this->error('Událost nenalezena.');
            }
            $this->assertAdminContentLanguage($item);
            $language = (string) $item->lang;
        }

        $date = null;
        if (is_string($values->event_date) && trim($values->event_date) !== '') {
            $date = $values->event_date;
        }

        $this->eventRepository->save([
            'lang' => $language,
            'event_date' => $date,
            'description' => $values->description,
            'sort_order' => $values->sort_order ?? 100,
            'active' => $values->active,
        ], $this->editingId);

        $this->flashMessage('Akce byla uložena.', 'success');
        $this->redirectToDefaultWithContentLang($language);
    }

    /** @throws AbortException */
    public function actionDelete(int $id): void
    {
        $this->requirePostWithCsrf();
        $item = $this->eventRepository->getById($id);
        if (!$item) {
            $this->error('Událost nenalezena.');
        }
        $this->assertAdminContentLanguage($item);

        $this->eventRepository->delete($id);
        $this->flashMessage('Akce byla smazána.', 'success');
        $this->redirectToDefaultWithContentLang();
    }

    protected function createComponentDeleteForm(): Form
    {
        $form = new Form();
        $form->addProtection();
        $form->addHidden('id')->setRequired();
        $form->addSubmit('delete', 'Smazat');
        $form->onSuccess[] = function (Form $form, \stdClass $values): void {
            $this->eventRepository->delete((int) $values->id);
            $this->flashMessage('Akce byla smazána.', 'success');
            $this->redirectToDefaultWithContentLang();
        };
        return $form;
    }
}
