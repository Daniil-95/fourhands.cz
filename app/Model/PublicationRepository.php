<?php declare(strict_types=1);

namespace App\Model;

use Nette\Database\Explorer;
use Nette\Database\Table\ActiveRow;

final class PublicationRepository
{
    public function __construct(private Explorer $db)
    {
    }

    public function getActiveByLocale(string $locale): array
    {
        return $this->db->table('publications')
            ->where('lang', $locale)
            ->where('active', 1)
            ->order('publish_date DESC, sort_order, id DESC')
            ->fetchAll();
    }

    public function getAll(): array
    {
        return $this->db->table('publications')->order('lang ASC, publish_date DESC, sort_order, id DESC')->fetchAll();
    }

    public function getById(int $id): ?ActiveRow
    {
        return $this->db->table('publications')->get($id);
    }

    public function save(array $data, ?int $id = null): void
    {
        $payload = [
            'lang' => $data['lang'],
            'title' => $data['title'],
            'source' => $data['source'],
            'short_description' => $data['short_description'],
            'url' => $data['url'],
            'image_path' => $data['image_path'],
            'publish_date' => $data['publish_date'] ?: new \DateTimeImmutable(),
            'sort_order' => (int) ($data['sort_order'] ?? 100),
            'active' => $data['active'] ? 1 : 0,
        ];

        if ($id !== null) {
            $this->db->table('publications')->where('id', $id)->update($payload);
            return;
        }

        $payload['created'] = new \DateTimeImmutable();
        $this->db->table('publications')->insert($payload);
    }

    public function delete(int $id): void
    {
        $this->db->table('publications')->where('id', $id)->delete();
    }
}
