<?php declare(strict_types=1);

namespace App\Model;

use Nette\Database\Explorer;
use Nette\Database\Table\ActiveRow;

final class InquiryRepository
{
    public function __construct(private Explorer $db)
    {
    }

    public function save(array $data, ?int $id = null): void
    {
        $payload = [
            'lang' => $data['locale'] ?? 'cs',
            'name' => $data['name'],
            'email' => $data['email'],
            'event_type' => $data['eventType'] ?? null,
            'event_date' => $data['date'] ?? null,
            'message' => $data['message'],
            'created' => new \DateTimeImmutable(),
        ];

        if ($id !== null) {
            $this->db->table('inquiries')->where('id', $id)->update($payload);
            return;
        }

        $this->db->table('inquiries')->insert($payload);
    }

    public function getAll(): array
    {
        return $this->db->table('inquiries')->order('created DESC')->fetchAll();
    }

    public function getById(int $id): ?ActiveRow
    {
        return $this->db->table('inquiries')->get($id);
    }

    public function delete(int $id): void
    {
        $this->db->table('inquiries')->where('id', $id)->delete();
    }
}
