<?php declare(strict_types=1);

namespace App\AdminModule\Presenters;

use App\Common\BaseAdminPresenter;
use App\Model\PageSectionRepository;
use App\Model\PublicationRepository;
use Nette\Application\AbortException;
use Nette\Application\UI\Form;

final class PublicationPresenter extends BaseAdminPresenter
{
    private ?int $editingId = null;

    public function __construct(
        private PublicationRepository $publicationRepository,
        private PageSectionRepository $pageSectionRepository,
    )
    {
        parent::__construct();
    }

    public function renderDefault(): void
    {
        $language = $this->getAdminContentLang();
        $this->template->items = $this->filterByAdminContentLang($this->publicationRepository->getAll());
        $this->template->pageHero = $this->pageSectionRepository->getByPageSection('from_stage', 'hero', $language);
        if ($this->template->pageHero) {
            $this['publicationPageForm']->setDefaults([
                'title' => $this->template->pageHero->title,
                'subtitle' => $this->template->pageHero->subtitle,
            ]);
        }
    }

    public function renderEdit(): void
    {
        $this->template->editingId = $this->editingId;
    }

    /** @throws AbortException */
    public function actionEdit(?int $id = null): void
    {
        $this->editingId = $id;

        if ($id !== null) {
            $item = $this->publicationRepository->getById($id);
            if (!$item) {
                $this->error('Publikace nenalezena.');
            }
            $this->assertAdminContentLanguage($item);

            $this['publicationForm']->setDefaults([
                'lang' => $item->lang,
                'title' => $item->title,
                'source' => $item->source,
                'short_description' => $item->short_description,
                'url' => $item->url,
                'image_path' => $item->image_path,
                'publish_date' => $item->publish_date ? $item->publish_date->format('Y-m-d') : '',
                'sort_order' => $item->sort_order,
                'active' => (bool) $item->active,
            ]);
            $this['publicationForm']['lang']->setDisabled();
        } else {
            $this['publicationForm']->setDefaults([
                'lang' => $this->getAdminContentLang(),
            ]);
        }
    }

    protected function createComponentPublicationForm(): Form
    {
        $form = new Form();
        $form->addProtection();
        $form->addSelect('lang', 'Jazyk', ['cs' => 'Čeština', 'en' => 'Angličtina'])->setRequired();
        $form->addText('title', 'Název')->setRequired();
        $form->addText('source', 'Zdroj / publikace');
        $form->addTextArea('short_description', 'Krátký popis')->setHtmlAttribute('rows', 4);
        $form->addText('url', 'Externí URL')->setHtmlType('url');
        $form->addText('image_path', 'Cesta k obrázku');
        $form->addText('publish_date', 'Datum')->setHtmlType('date');
        $form->addInteger('sort_order', 'Pořadí')->setDefaultValue(100);
        $form->addCheckbox('active', 'Aktivní')->setDefaultValue(true);
        $form->addSubmit('save', 'Uložit');

        $form->onSuccess[] = $this->publicationFormSucceeded(...);
        return $form;
    }

    protected function createComponentPublicationPageForm(): Form
    {
        $form = new Form();
        $form->addProtection();
        $form->addText('title', 'Nadpis')->setRequired();
        $form->addText('subtitle', 'Podnadpis');
        $form->addSubmit('save', 'Uložit');
        $form->onSuccess[] = $this->publicationPageFormSucceeded(...);

        return $form;
    }

    private function publicationPageFormSucceeded(Form $form, \stdClass $values): void
    {
        $language = $this->getAdminContentLang();
        $hero = $this->pageSectionRepository->getByPageSection('from_stage', 'hero', $language);
        if (!$hero) {
            $form->addError('Úvodní sekce stránky Z pódia nebyla nalezena.');
            return;
        }

        $this->pageSectionRepository->updateTitleAndSubtitle(
            (int) $hero->id,
            (string) $values->title,
            (string) ($values->subtitle ?? ''),
        );

        $this->flashMessage('Úvodní text stránky Z pódia byl uložen.', 'success');
        $this->redirectToDefaultWithContentLang($language);
    }

    private function publicationFormSucceeded(Form $form, \stdClass $values): void
    {
        // pole 'lang' je při editaci disabled, Nette ho proto do $values vůbec nezahrne
        $language = $this->getAdminContentLang();
        if ($this->editingId !== null) {
            $item = $this->publicationRepository->getById($this->editingId);
            if (!$item) {
                $this->error('Publikace nenalezena.');
            }
            $this->assertAdminContentLanguage($item);
            $language = (string) $item->lang;
        } else {
            $language = $values->lang;
        }

        $this->publicationRepository->save([
            'lang' => $language,
            'title' => $values->title,
            'source' => $values->source,
            'short_description' => $values->short_description,
            'url' => $values->url,
            'image_path' => $values->image_path,
            'publish_date' => $values->publish_date,
            'sort_order' => $values->sort_order ?? 100,
            'active' => $values->active,
        ], $this->editingId);

        $this->flashMessage('Publikace byla uložena.', 'success');
        $this->redirectToDefaultWithContentLang($language);
    }

    /** @throws AbortException */
    public function actionDelete(int $id): void
    {
        $this->requirePostWithCsrf();
        $item = $this->publicationRepository->getById($id);
        if (!$item) {
            $this->error('Publikace nenalezena.');
        }
        $this->assertAdminContentLanguage($item);

        $this->publicationRepository->delete($id);
        $this->flashMessage('Publikace byla smazána.', 'success');
        $this->redirectToDefaultWithContentLang();
    }
}
