<?php declare(strict_types=1);

namespace App\FrontModule\Presenters;

use App\Common\BasePresenter;
use App\Model\EventRepository;
use App\Model\InquiryRepository;
use App\Model\MediaRepository;
use Nette\Application\UI\Form;

final class HomepagePresenter extends BasePresenter
{
    private const MAIL_SENDER_ADDRESS = 'info@fourhands.cz';

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
        $notificationSent = $this->sendInquiryNotification($data);

        $this->flashMessage(
            $notificationSent
                ? $this->trans('Thank you for your inquiry. We will get back to you soon.')
                : $this->trans('Your inquiry was saved, but the email notification could not be sent.'),
            $notificationSent ? 'success' : 'warning',
        );
        $this->redirect('this#kontakt');
    }

    private function sendInquiryNotification(array $data): bool
    {
        $siteSettings = $this->getTemplate()->siteSettings ?? [];
        $recipient = $siteSettings['email'] ?? self::MAIL_SENDER_ADDRESS;
        // odesílatel musí zůstat adresou vlastní domény, jinak zprávu zablokuje SPF/DKIM
        $sender = self::MAIL_SENDER_ADDRESS;
        $replyTo = filter_var($data['email'], FILTER_VALIDATE_EMAIL) ? $data['email'] : $sender;
        // defense-in-depth proti header injection, i když filter_var už CR/LF v e-mailu odmítá
        $replyTo = str_replace(["\r", "\n"], '', (string) $replyTo);
        $subject = '=?UTF-8?B?' . base64_encode($this->trans('New inquiry from website')) . '?=';
        $body = sprintf(
            "%s\n%s\n\n%s\n%s\n%s\n",
            $this->trans('New inquiry received'),
            '=========================','Name: ' . $data['name'],
            'Email: ' . $data['email'],
            'Message: ' . $data['message'],
        );
        $headers = [];
        $headers[] = 'MIME-Version: 1.0';
        $headers[] = 'Content-Type: text/plain; charset=utf-8';
        $headers[] = 'Content-Transfer-Encoding: 8bit';
        $headers[] = 'From: =?UTF-8?B?' . base64_encode('Fourhands web') . '?= <' . $sender . '>';
        $headers[] = 'Reply-To: ' . $replyTo;

        return mail($recipient, $subject, $body, implode("\r\n", $headers), '-f' . $sender);
    }
}
