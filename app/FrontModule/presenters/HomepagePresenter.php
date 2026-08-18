<?php declare(strict_types=1);

namespace App\FrontModule\Presenters;

use App\Common\BasePresenter;
use App\Model\EventRepository;
use App\Model\InquiryRepository;
use App\Model\MediaRepository;
use Nette\Application\UI\Form;

final class HomepagePresenter extends BasePresenter
{
    public function __construct(
        private EventRepository $eventRepository,
        private MediaRepository $mediaRepository,
        private InquiryRepository $inquiryRepository,
    ) {
        parent::__construct();
    }

    public function renderDefault(): void
    {
        $locale = $this->getLocale();
        $this->template->events = $this->eventRepository->getByLocale($locale);
        $eventPreview = array_merge(
            $this->template->events['upcoming'],
            $this->template->events['past'],
        );
        $this->template->upcomingEvents = array_slice($eventPreview, 0, 3);
        $this->template->photos = $this->mediaRepository->getByLocaleAndType($locale, 'photo');
        $this->template->videos = $this->mediaRepository->getByLocaleAndType($locale, 'video');
    }

    protected function createComponentInquiryForm(): Form
    {
        $form = new Form();
        $form->addProtection();
        $form->addText('name', $this->trans('Name and surname'))->setRequired();
        $form->addEmail('email', $this->trans('Email'))->setRequired();
        $form->addTextArea('message', $this->trans('Your message'))->setRequired();
        $form->addSubmit('send', $this->trans('Send'));
        $form->onSuccess[] = [$this, 'inquiryFormSucceeded'];

        return $form;
    }

    public function inquiryFormSucceeded(Form $form, \stdClass $values): void
    {
        $data = [
            'name' => $values->name,
            'email' => $values->email,
            'message' => $values->message,
            'locale' => $this->getLocale(),
        ];

        $this->inquiryRepository->save($data);
        $this->sendInquiryNotification($data);

        $this->flashMessage($this->trans('Thank you for your inquiry. We will get back to you soon.'), 'success');
        $this->redirect('this#kontakt');
    }

    private function sendInquiryNotification(array $data): bool
    {
        $siteSettings = $this->getTemplate()->siteSettings ?? [];
        $recipient = $siteSettings['email'] ?? 'info@fourhands.cz';
        $fromEmail = filter_var($data['email'], FILTER_VALIDATE_EMAIL) ? $data['email'] : ($siteSettings['email'] ?? 'info@fourhands.cz');
        // defense-in-depth proti header injection, i když filter_var už CR/LF v e-mailu odmítá
        $fromEmail = str_replace(["\r", "\n"], '', (string) $fromEmail);
        $subject = $this->trans('New inquiry from website');
        $body = sprintf(
            "%s\n%s\n\n%s\n%s\n%s\n\n%s\n\n%s\n",
            $this->trans('New inquiry received'),
            '=========================','Name: ' . $data['name'],
            'Email: ' . $data['email'],
            'Message: ' . $data['message'],
        );
        $headers = [];
        $headers[] = 'Content-Type: text/plain; charset=utf-8';
        $headers[] = 'From: ' . $fromEmail;
        $headers[] = 'Reply-To: ' . $fromEmail;
        $headers[] = 'X-Mailer: PHP/' . phpversion();

        return @mail($recipient, $subject, $body, implode("\r\n", $headers));
    }
}
