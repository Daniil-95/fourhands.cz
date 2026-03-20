<?php declare(strict_types=1);

namespace App\Model;

use Nette\Database\Explorer;

final class MediaRepository
{
    public function __construct(private Explorer $db)
    {
    }

    public function getByLocaleAndType(string $locale, string $type): array
    {
        $rows = $this->db->table('media_items')
            ->where('lang', $locale)
            ->where('type', $type)
            ->order('sort_order ASC, id ASC')
            ->fetchAll();

        $items = [];
        foreach ($rows as $row) {
            $items[] = [
                'id' => (int) $row->id,
                'title' => $row->title,
                'description' => $row->description,
                'image_path' => $row->image_path,
                'url' => $row->url,
            ];
        }

        return $items;
    }

    public function getAll(): array
    {
        return $this->db->table('media_items')->order('lang ASC, type ASC, sort_order ASC, id ASC')->fetchAll();
    }

    public function getById(int $id): ?\Nette\Database\Table\ActiveRow
    {
        return $this->db->table('media_items')->get($id);
    }

    public function save(array $data, ?int $id = null): void
    {
        if ($id !== null) {
            $this->db->table('media_items')->where('id', $id)->update($data);
            return;
        }

        $this->db->table('media_items')->insert($data);
    }

    public function delete(int $id): void
    {
        $this->db->table('media_items')->where('id', $id)->delete();
    }
}
