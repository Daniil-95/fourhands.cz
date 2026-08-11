<?php declare(strict_types=1);

namespace App\AdminModule\Presenters;

use App\Common\BaseAdminPresenter;
use App\Model\PublicationRepository;
use Nette\Application\AbortException;
use Nette\Application\UI\Form;

final class PublicationPresenter extends BaseAdminPresenter
{
    private ?int $editingId = null;

    public function __construct(private PublicationRepository $publicationRepository)
    {
        parent::__construct();
    }

    public function renderDefault(): void
    {
        $this->template->items = $this->publicationRepository->getAll();
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

    private function publicationFormSucceeded(Form $form, \stdClass $values): void
    {
        $this->publicationRepository->save([
            'lang' => $values->lang,
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
        $this->redirect('default');
    }

    /** @throws AbortException */
    public function actionDelete(int $id): void
    {
        $token = $this->getParameter('_token');
        if (!is_string($token) || !$this->checkCsrfToken($token)) {
            $this->error('Neplatný bezpečnostní token.', 403);
        }

        $this->publicationRepository->delete($id);
        $this->flashMessage('Publikace byla smazána.', 'success');
        $this->redirect('default');
    }
}
