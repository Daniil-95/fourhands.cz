<?php declare(strict_types=1);

namespace App\FrontModule\Presenters;

use App\Common\BasePresenter;
use App\Model\PublicationRepository;

final class ZpodiaPresenter extends BasePresenter
{
    public function __construct(private PublicationRepository $publicationRepository)
    {
        parent::__construct();
    }

    public function renderDefault(): void
    {
        $this->template->publications = $this->publicationRepository->getActiveByLocale($this->getLocale());
    }
}
