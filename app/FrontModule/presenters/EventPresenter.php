<?php declare(strict_types=1);

namespace App\FrontModule\Presenters;

use App\Common\BasePresenter;
use App\Model\EventRepository;

final class EventPresenter extends BasePresenter
{
    public function __construct(private EventRepository $eventRepository)
    {
        parent::__construct();
    }

    public function actionDetail(int $id): void
    {
        $event = $this->eventRepository->getByIdAndLocale($id, $this->getLocale());
        if (!$event) {
            $this->error('Událost nenalezena.', 404);
        }

        $this->template->event = $event;
    }
}