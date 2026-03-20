<?php declare(strict_types=1);

namespace App\Presentation\Admin\Event;

use App\Core\BaseAdminPresenter;
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
        $this->template->items = $this->eventRepository->getAll();
    }

    /** @throws AbortException */
    public function actionEdit(?int $id = null): void
    {
        $this->editingId = $id;

        if ($id !== null) {
            $item = $this->eventRepository->getById($id);
            if (!$item) {
                $this->error('Event not found.');
            }

            $this['eventForm']->setDefaults([
                'lang' => $item->lang,
                'type' => $item->type,
                'event_date' => $item->event_date ? $item->event_date->format('Y-m-d') : '',
                'description' => $item->description,
                'sort_order' => $item->sort_order,
            ]);
        }
    }

    public function actionDelete(int $id): void
    {
        $this->eventRepository->delete($id);
        $this->flashMessage('Event deleted.', 'success');
        $this->redirect('default');
    }

    protected function createComponentEventForm(): Form
    {
        $form = new Form();
        $form->addSelect('lang', 'Language', ['cs' => 'Czech', 'en' => 'English'])->setRequired();
        $form->addSelect('type', 'Type', ['upcoming' => 'Upcoming', 'past' => 'Past'])->setRequired();
        $form->addText('event_date', 'Date (YYYY-MM-DD)');
        $form->addTextArea('description', 'Description')->setRequired()->setHtmlAttribute('rows', 4);
        $form->addInteger('sort_order', 'Sort order')->setDefaultValue(100);
        $form->addSubmit('save', 'Save');

        $form->onSuccess[] = $this->eventFormSucceeded(...);
        return $form;
    }

    private function eventFormSucceeded(Form $form, \stdClass $values): void
    {
        $date = null;
        if (is_string($values->event_date) && trim($values->event_date) !== '') {
            $date = $values->event_date;
        }

        $this->eventRepository->save([
            'lang' => $values->lang,
            'type' => $values->type,
            'event_date' => $date,
            'description' => $values->description,
            'sort_order' => $values->sort_order ?? 100,
        ], $this->editingId);

        $this->flashMessage('Event saved.', 'success');
        $this->redirect('default');
    }
}
