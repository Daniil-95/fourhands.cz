<?php declare(strict_types=1);

namespace App\FrontModule\Presenters;

use App\Common\BasePresenter;
use App\Model\MediaRepository;

final class VideaPresenter extends BasePresenter
{
    public function __construct(private MediaRepository $mediaRepository)
    {
        parent::__construct();
    }

    public function renderDefault(): void
    {
        $this->template->videos = $this->mediaRepository->getByLocaleAndType($this->getLocale(), 'video');
    }
}
