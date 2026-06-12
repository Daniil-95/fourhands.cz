<?php declare(strict_types=1);

namespace App\FrontModule\Presenters;

use App\Common\BasePresenter;
use App\Model\ContentRepository;
use App\Model\EventRepository;
use App\Model\MediaRepository;
use Nette\Application\UI\Form;

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
        $this->template->references = $this->contentRepository->getReferences($locale);
    }

    protected function createComponentInquiryForm(): Form
    {
        $form = new Form();
        $form->addText('name', 'Jméno a příjmení')->setRequired();
        $form->addEmail('email', 'E-mail')->setRequired();
        $form->addSelect('eventType', 'Typ akce', [
            'wedding' => 'Svatba',
            'corporate' => 'Firemní akce',
            'concert' => 'Koncert',
            'private' => 'Soukromá akce',
        ])->setPrompt('Vyberte typ akce');
        $form->addText('date', 'Datum akce')->setHtmlType('date');
        $form->addTextArea('message', 'Vaše zpráva')->setRequired();
        $form->addSubmit('send', 'Odeslat poptávku');
        $form->onSuccess[] = function (): void {
            $this->flashMessage('Děkujeme za poptávku. Brzy se vám ozveme.', 'success');
            $this->redirect('this#kontakt');
        };

        return $form;
    }
}
