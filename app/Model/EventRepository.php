<?php declare(strict_types=1);

namespace App\Model;

use Nette\Database\Explorer;
use Nette\Database\Table\ActiveRow;

final class EventRepository
{
    public function __construct(private Explorer $db)
    {
    }

    public function getByLocale(string $locale): array
    {
        $rows = $this->db->table('news')
            ->where('lang', $locale)
            ->where('active', 1)
            ->order('publish_date DESC, id DESC')
            ->fetchAll();

        $upcoming = [];
        $past = [];
        $now = new \DateTimeImmutable('today');

        foreach ($rows as $row) {
            $publishDate = $row->publish_date instanceof \DateTimeInterface
                ? new \DateTimeImmutable($row->publish_date->format('Y-m-d H:i:s'))
                : null;

            $item = [
                'id' => (int) $row->id,
                'description' => (string) $row->title,
                'event_date' => $publishDate,
            ];

            if ($publishDate !== null && $publishDate >= $now) {
                $upcoming[] = $item;
            } else {
                $past[] = $item;
            }
        }

        return ['upcoming' => $upcoming, 'past' => $past];
    }

    public function getAll(): array
    {
        return $this->db->table('news')->order('lang ASC, publish_date DESC, id DESC')->fetchAll();
    }

    public function getById(int $id): ?ActiveRow
    {
        return $this->db->table('news')->get($id);
    }

    public function save(array $data, ?int $id = null): void
    {
        $payload = [
            'lang' => $data['lang'],
            'title' => $data['description'],
            'publish_date' => $data['event_date'] ?: new \DateTimeImmutable(),
            'active' => 1,
            'sort_order' => $data['sort_order'],
        ];
        $payload['active'] = $data['active'] ? 1 : 0;

        if ($id !== null) {
            $this->db->table('news')->where('id', $id)->update($payload);
            return;
        }

        $payload['created'] = new \DateTimeImmutable();
        $this->db->table('news')->insert($payload);
    }

    public function delete(int $id): void
    {
        $this->db->table('news')->where('id', $id)->delete();
    }
}
