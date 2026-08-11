<?php declare(strict_types=1);

namespace App\FrontModule\Presenters;

use App\Common\BasePresenter;
use App\Model\EventRepository;

final class ArchivUdalostiPresenter extends BasePresenter
{
    public function __construct(private EventRepository $eventRepository)
    {
        parent::__construct();
    }

    public function renderDefault(): void
    {
        $this->template->events = $this->eventRepository->getByLocale($this->getLocale());
    }
}
