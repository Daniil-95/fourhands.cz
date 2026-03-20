<?php declare(strict_types=1);

namespace App\Model;

use Nette\Database\Explorer;

final class EventRepository
{
    public function __construct(private Explorer $db)
    {
    }

    public function getByLocale(string $locale): array
    {
        $rows = $this->db->table('events')
            ->where('lang', $locale)
            ->order('type ASC, sort_order ASC, event_date ASC, id ASC')
            ->fetchAll();

        $upcoming = [];
        $past = [];

        foreach ($rows as $row) {
            $item = [
                'id' => (int) $row->id,
                'description' => $row->description,
                'event_date' => $row->event_date,
            ];

            if ($row->type === 'upcoming') {
                $upcoming[] = $item;
            } else {
                $past[] = $item;
            }
        }

        return ['upcoming' => $upcoming, 'past' => $past];
    }

    public function getAll(): array
    {
        return $this->db->table('events')->order('lang ASC, type ASC, sort_order ASC, id ASC')->fetchAll();
    }

    public function getById(int $id): ?\Nette\Database\Table\ActiveRow
    {
        return $this->db->table('events')->get($id);
    }

    public function save(array $data, ?int $id = null): void
    {
        if ($id !== null) {
            $this->db->table('events')->where('id', $id)->update($data);
            return;
        }

        $this->db->table('events')->insert($data);
    }

    public function delete(int $id): void
    {
        $this->db->table('events')->where('id', $id)->delete();
    }
}
