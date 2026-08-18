<?php declare(strict_types=1);

namespace App\AdminModule\Presenters;

use App\Common\BaseAdminPresenter;
use App\Model\EventRepository;
use App\Model\PageSectionRepository;
use Nette\Application\AbortException;
use Nette\Application\UI\Form;
use Nette\Http\FileUpload;

final class EventPresenter extends BaseAdminPresenter
{
    private ?int $editingId = null;

    public function __construct(
        private EventRepository $eventRepository,
        private PageSectionRepository $pageSectionRepository,
    )
    {
        parent::__construct();
    }

    public function renderDefault(): void
    {
        $language = $this->getAdminContentLang();
        $this->template->items = $this->filterByAdminContentLang($this->eventRepository->getAll());
        $this->template->pageHero = $this->pageSectionRepository->getByPageSection('events', 'hero', $language);
        if ($this->template->pageHero) {
            $this['eventPageForm']->setDefaults([
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
            $item = $this->eventRepository->getById($id);
            if (!$item) {
                $this->error('Událost nenalezena.');
            }
            $this->assertAdminContentLanguage($item);

            $this['eventForm']->setDefaults([
                'lang' => $item->lang,
                'event_date' => $item->publish_date ? $item->publish_date->format('Y-m-d') : '',
                'description' => $item->title,
                'image_path' => $item->image_path ?? '',
                'sort_order' => $item->sort_order,
                'active' => (bool) $item->active,
            ]);
            $this['eventForm']['lang']->setDisabled();
            $this->template->currentImagePath = $item->image_path;
        } else {
            $this['eventForm']->setDefaults([
                'lang' => $this->getAdminContentLang(),
            ]);
            $this->template->currentImagePath = null;
        }
    }

    protected function createComponentEventForm(): Form
    {
        $form = new Form();
        $form->addProtection();
        $form->addSelect('lang', 'Jazyk', ['cs' => 'Čeština', 'en' => 'Angličtina'])->setRequired();
        $form->addText('event_date', 'Datum')->setHtmlType('date')->setRequired();
        $form->addTextArea('description', 'Název a popis akce')->setRequired()->setHtmlAttribute('rows', 5);
        $form->addUpload('upload', 'Fotografie');
        $form->addText('image_path', 'Existující cesta k obrázku')->setOption('description', 'Použijte pouze pokud nechcete nahrát nový soubor.');
        $form->addInteger('sort_order', 'Pořadí')->setDefaultValue(100);
        $form->addCheckbox('active', 'Publikovat')->setDefaultValue(true);
        $form->addSubmit('save', 'Uložit');

        $form->onSuccess[] = $this->eventFormSucceeded(...);
        return $form;
    }

    protected function createComponentEventPageForm(): Form
    {
        $form = new Form();
        $form->addProtection();
        $form->addText('title', 'Nadpis')->setRequired();
        $form->addText('subtitle', 'Podnadpis');
        $form->addSubmit('save', 'Uložit');
        $form->onSuccess[] = $this->eventPageFormSucceeded(...);

        return $form;
    }

    private function eventPageFormSucceeded(Form $form, \stdClass $values): void
    {
        $language = $this->getAdminContentLang();
        $hero = $this->pageSectionRepository->getByPageSection('events', 'hero', $language);
        if (!$hero) {
            $form->addError('Úvodní sekce stránky Události nebyla nalezena.');
            return;
        }

        $this->pageSectionRepository->updateTitleAndSubtitle(
            (int) $hero->id,
            (string) $values->title,
            (string) ($values->subtitle ?? ''),
        );

        $this->flashMessage('Úvodní text stránky byl uložen.', 'success');
        $this->redirectToDefaultWithContentLang($language);
    }

    private function eventFormSucceeded(Form $form, \stdClass $values): void
    {
        // pole 'lang' je při editaci disabled, Nette ho proto do $values vůbec nezahrne
        $language = $this->getAdminContentLang();
        $imagePath = null;
        if ($this->editingId !== null) {
            $item = $this->eventRepository->getById($this->editingId);
            if (!$item) {
                $this->error('Událost nenalezena.');
            }
            $this->assertAdminContentLanguage($item);
            $language = (string) $item->lang;
            $imagePath = $item->image_path;
        } else {
            $language = $values->lang;
        }

        /** @var FileUpload $upload */
        $upload = $values->upload;
        if ($upload->hasFile()) {
            if (!$upload->isOk() || !$upload->isImage() || $upload->getSize() > 8 * 1024 * 1024) {
                $form->addError('Nahrajte platný obrázek JPG, PNG, GIF nebo WebP do velikosti 8 MB.');
                return;
            }
            $storedImagePath = $this->storeImageUpload($upload, 'event');
            if ($storedImagePath === null) {
                $form->addError('Nahrajte platný obrázek JPG, PNG, GIF nebo WebP do velikosti 8 MB.');
                return;
            }
            $imagePath = $storedImagePath;
        } elseif (is_string($values->image_path) && trim($values->image_path) !== '') {
            if (
                str_contains($values->image_path, '..')
                || str_contains($values->image_path, '\\')
                || preg_match('~^(?:[a-z][a-z0-9+.-]*:|//)~i', trim($values->image_path)) === 1
            ) {
                $form->addError('Zadejte pouze bezpečnou lokální cestu k obrázku.');
                return;
            }
            $imagePath = $values->image_path;
        }

        $date = null;
        if (is_string($values->event_date) && trim($values->event_date) !== '') {
            $date = $values->event_date;
        }

        $this->eventRepository->save([
            'lang' => $language,
            'event_date' => $date,
            'description' => $values->description,
            'image_path' => $imagePath,
            'sort_order' => $values->sort_order ?? 100,
            'active' => $values->active,
        ], $this->editingId);

        $this->flashMessage('Akce byla uložena.', 'success');
        $this->redirectToDefaultWithContentLang($language);
    }

    /** @throws AbortException */
    public function actionDelete(int $id): void
    {
        $this->requirePostWithCsrf();
        $item = $this->eventRepository->getById($id);
        if (!$item) {
            $this->error('Událost nenalezena.');
        }
        $this->assertAdminContentLanguage($item);

        $this->eventRepository->delete($id);
        $this->flashMessage('Akce byla smazána.', 'success');
        $this->redirectToDefaultWithContentLang();
    }

    protected function createComponentDeleteForm(): Form
    {
        $form = new Form();
        $form->addProtection();
        $form->addHidden('id')->setRequired();
        $form->addSubmit('delete', 'Smazat');
        $form->onSuccess[] = function (Form $form, \stdClass $values): void {
            $this->eventRepository->delete((int) $values->id);
            $this->flashMessage('Akce byla smazána.', 'success');
            $this->redirectToDefaultWithContentLang();
        };
        return $form;
    }
}
