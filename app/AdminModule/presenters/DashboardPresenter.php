<?php declare(strict_types=1);

namespace App\AdminModule\Presenters;

use App\Common\BaseAdminPresenter;
use App\Model\EventRepository;
use App\Model\MediaRepository;
use App\Model\NavigationRepository;
use App\Model\PageSectionRepository;
use App\Model\SettingRepository;

final class DashboardPresenter extends BaseAdminPresenter
{
    public function __construct(
        private EventRepository $eventRepository,
        private MediaRepository $mediaRepository,
        private NavigationRepository $navigationRepository,
        private PageSectionRepository $pageSectionRepository,
        private SettingRepository $settingRepository,
    ) {
        parent::__construct();
    }

    public function renderDefault(): void
    {
        $this->template->pageCount = count(PageSectionRepository::PAGES);
        $this->template->eventCount = count($this->eventRepository->getAll());
        $this->template->mediaCount = count($this->mediaRepository->getAll());
        $this->template->navigationCount = count($this->navigationRepository->getAll());
        $this->template->settingCount = count($this->settingRepository->getAll());

        $this->template->latestMedia = $this->mediaRepository->getLatest(5);
        $this->template->latestEvents = array_slice($this->eventRepository->getAll(), 0, 5);
    }
}
