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
        $this->template->quickActions = [
            [
                'title' => 'Události',
                'description' => 'Správa koncertů a termínů.',
                'href' => ':Admin:Event:default',
            ],
            [
                'title' => 'Z pódia',
                'description' => 'Publikace, články a zmínky.',
                'href' => ':Admin:Publication:default',
            ],
            [
                'title' => 'Fotogalerie',
                'description' => 'Fotografie a jejich pořadí.',
                'href' => ':Admin:Media:default',
                'params' => ['type' => 'photo'],
            ],
            [
                'title' => 'Videogalerie',
                'description' => 'YouTube videa a náhledy.',
                'href' => ':Admin:Media:default',
                'params' => ['type' => 'video'],
            ],
            [
                'title' => 'Zprávy',
                'description' => 'Zprávy z kontaktního formuláře.',
                'href' => ':Admin:Inquiry:default',
            ],
            [
                'title' => 'Navigační menu',
                'description' => 'Položky menu pro web.',
                'href' => ':Admin:Navigation:default',
            ],
            [
                'title' => 'Nastavení webu',
                'description' => 'Kontakty, odkazy a obecná nastavení.',
                'href' => ':Admin:Setting:default',
            ],
            [
                'title' => 'SEO',
                'description' => 'Metadata a náhledy při sdílení.',
                'href' => ':Admin:Setting:seo',
            ],
        ];
    }
}
