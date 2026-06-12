<?php declare(strict_types=1);

namespace App\Model;

use Nette\Database\Explorer;
use Nette\Database\Table\ActiveRow;

final class NavigationRepository
{
    public function __construct(private Explorer $db)
    {
    }

    public function getActiveByLocale(string $locale): array
    {
        return $this->db->table('navigation_items')->where('lang', $locale)->where('active', 1)->order('sort_order, id')->fetchAll();
    }

    public function getAll(): array
    {
        return $this->db->table('navigation_items')->order('lang, sort_order, id')->fetchAll();
    }

    public function getById(int $id): ?ActiveRow
    {
        return $this->db->table('navigation_items')->get($id);
    }

    public function save(array $data, ?int $id): void
    {
        $payload = [
            'lang' => $data['lang'],
            'title' => $data['title'],
            'url' => $data['url'],
            'sort_order' => $data['sort_order'],
            'active' => $data['active'] ? 1 : 0,
        ];
        if ($id) {
            $this->db->table('navigation_items')->where('id', $id)->update($payload);
        } else {
            $payload['created'] = new \DateTimeImmutable();
            $this->db->table('navigation_items')->insert($payload);
        }
    }

    public function delete(int $id): void
    {
        $this->db->table('navigation_items')->where('id', $id)->delete();
    }
}
