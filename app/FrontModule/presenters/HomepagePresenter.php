<?php declare(strict_types=1);

namespace App\FrontModule\Presenters;

use App\Common\BasePresenter;
use App\Model\ContentRepository;
use App\Model\EventRepository;
use App\Model\MediaRepository;

final class HomepagePresenter extends BasePresenter
{
    public function __construct(
        private ContentRepository $contentRepository,
        private EventRepository $eventRepository,
        private MediaRepository $mediaRepository,
    ) {
        parent::__construct();
    }

    public function renderDefault(): void
    {
        $locale = $this->getLocale();
        $this->template->content = $this->contentRepository->getByLocale($locale);
        $this->template->events = $this->eventRepository->getByLocale($locale);
        $this->template->photos = $this->mediaRepository->getByLocaleAndType($locale, 'photo');
        $this->template->videos = $this->mediaRepository->getByLocaleAndType($locale, 'video');
    }
}
