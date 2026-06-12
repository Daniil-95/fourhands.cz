<?php declare(strict_types=1);

namespace App\Model;

use Nette\Database\Explorer;
use Nette\Database\Table\ActiveRow;

final class ProgramRepository
{
    public function __construct(private Explorer $db)
    {
    }

    public function getActiveByLocale(string $locale): array
    {
        return $this->db->table('programs')
            ->where('lang', $locale)
            ->where('active', 1)
            ->order('sort_order, id')
            ->fetchAll();
    }

    public function getAll(): array
    {
        return $this->db->table('programs')->order('lang, sort_order, id')->fetchAll();
    }

    public function getById(int $id): ?ActiveRow
    {
        return $this->db->table('programs')->get($id);
    }

    public function save(array $data, ?int $id = null): void
    {
        $payload = [
            'lang' => $data['lang'],
            'title' => $data['title'],
            'description' => $data['description'],
            'icon' => $data['icon'],
            'image_path' => $data['image_path'],
            'sort_order' => (int) $data['sort_order'],
            'active' => $data['active'] ? 1 : 0,
        ];

        if ($id !== null) {
            $this->db->table('programs')->where('id', $id)->update($payload);
            return;
        }

        $payload['created'] = new \DateTimeImmutable();
        $this->db->table('programs')->insert($payload);
    }

    public function delete(int $id): void
    {
        $this->db->table('programs')->where('id', $id)->delete();
    }
}
