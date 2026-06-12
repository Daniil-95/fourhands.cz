<?php declare(strict_types=1);

namespace App\FrontModule\Presenters;

use App\Common\BasePresenter;
use App\Model\ContentRepository;

final class ClenkyPresenter extends BasePresenter
{
    public function __construct(private ContentRepository $contentRepository)
    {
        parent::__construct();
    }

    public function renderDefault(): void
    {
        $this->template->content = $this->contentRepository->getByLocale($this->getLocale());
    }
}
