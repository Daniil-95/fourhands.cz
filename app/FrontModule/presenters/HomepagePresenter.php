<?php declare(strict_types=1);

namespace App\FrontModule\Presenters;

use App\Common\BasePresenter;
use App\Model\ContentRepository;
use App\Model\EventRepository;
use App\Model\MediaRepository;
use App\Model\ProgramRepository;
use App\Model\TestimonialRepository;
use Nette\Application\UI\Form;

final class HomepagePresenter extends BasePresenter
{
    public function __construct(
        private ContentRepository $contentRepository,
        private EventRepository $eventRepository,
        private MediaRepository $mediaRepository,
        private ProgramRepository $programRepository,
        private TestimonialRepository $testimonialRepository,
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
        $this->template->programs = $this->programRepository->getActiveByLocale($locale);
        $this->template->references = $this->testimonialRepository->getActiveByLocale($locale);
    }

    protected function createComponentInquiryForm(): Form
    {
        $form = new Form();
        $form->addText('name', $this->trans('Name and surname'))->setRequired();
        $form->addEmail('email', $this->trans('Email'))->setRequired();
        $form->addSelect('eventType', $this->trans('Event type'), [
            'wedding' => $this->trans('Wedding'),
            'corporate' => $this->trans('Corporate event'),
            'concert' => $this->trans('Concert'),
            'private' => $this->trans('Private event'),
        ])->setPrompt($this->trans('Select event type'));
        $form->addText('date', $this->trans('Event date'))->setHtmlType('date');
        $form->addTextArea('message', $this->trans('Your message'))->setRequired();
        $form->addSubmit('send', $this->trans('Send inquiry'));
        $presenter = $this;
        $form->onSuccess[] = function () use ($presenter): void {
            $presenter->flashMessage($presenter->trans('Thank you for your inquiry. We will get back to you soon.'), 'success');
            $presenter->redirect('this#kontakt');
        };

        return $form;
    }
}
