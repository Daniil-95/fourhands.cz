<?php declare(strict_types=1);

namespace App\AdminModule\Presenters;

use App\Common\BaseAdminPresenter;
use App\Model\PageSectionRepository;

final class DashboardPresenter extends BaseAdminPresenter
{
    public function __construct(
        private PageSectionRepository $pageSectionRepository,
    ) {
        parent::__construct();
    }

    public function renderDefault(): void
    {
        $this->template->pages = PageSectionRepository::PAGES;
    }
}
