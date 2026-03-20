<?php declare(strict_types=1);

namespace App\Model;

use Nette\Database\Explorer;

final class ContentRepository
{
    public function __construct(private Explorer $db)
    {
    }

    public function getByLocale(string $locale): array
    {
        $rows = $this->db->table('content_blocks')
            ->where('lang', $locale)
            ->order('sort_order ASC, id ASC')
            ->fetchAll();

        $items = [];
        foreach ($rows as $row) {
            $items[$row->key_name] = [
                'id' => (int) $row->id,
                'key_name' => $row->key_name,
                'title' => $row->title,
                'content_html' => $row->content_html,
                'sort_order' => (int) $row->sort_order,
            ];
        }

        return $items;
    }

    public function getAll(): array
    {
        return $this->db->table('content_blocks')->order('lang ASC, sort_order ASC, id ASC')->fetchAll();
    }

    public function getById(int $id): ?\Nette\Database\Table\ActiveRow
    {
        return $this->db->table('content_blocks')->get($id);
    }

    public function save(array $data, ?int $id = null): void
    {
        if ($id !== null) {
            $this->db->table('content_blocks')->where('id', $id)->update($data);
            return;
        }

        $this->db->table('content_blocks')->insert($data);
    }

    public function delete(int $id): void
    {
        $this->db->table('content_blocks')->where('id', $id)->delete();
    }
}
