<?php declare(strict_types=1);

namespace App\AdminModule\Presenters;

use App\Common\BaseAdminPresenter;
use App\Model\ContentRepository;
use App\Model\EventRepository;
use App\Model\MediaRepository;
use App\Model\TestimonialRepository;
use App\Model\NavigationRepository;
use App\Model\SettingRepository;

final class DashboardPresenter extends BaseAdminPresenter
{
    public function __construct(
        private ContentRepository $contentRepository,
        private EventRepository $eventRepository,
        private MediaRepository $mediaRepository,
        private TestimonialRepository $testimonialRepository,
        private NavigationRepository $navigationRepository,
        private SettingRepository $settingRepository,
    ) {
        parent::__construct();
    }

    public function renderDefault(): void
    {
        $this->template->contentCount = count($this->contentRepository->getAll());
        $this->template->eventCount = count($this->eventRepository->getAll());
        $this->template->mediaCount = count($this->mediaRepository->getAll());
        $this->template->testimonialCount = count($this->testimonialRepository->getAll());
        $this->template->navigationCount = count($this->navigationRepository->getAll());
        $this->template->settingCount = count($this->settingRepository->getAll());
    }
}
