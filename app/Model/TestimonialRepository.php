<?php declare(strict_types=1);

namespace App\Model;

use Nette\Database\Explorer;
use Nette\Database\Table\ActiveRow;

final class TestimonialRepository
{
    public function __construct(private Explorer $db)
    {
    }

    public function getActiveByLocale(string $locale): array
    {
        return $this->db->table('testimonials')->where('lang', $locale)->where('active', 1)->order('sort_order, id')->fetchAll();
    }

    public function getAll(): array
    {
        return $this->db->table('testimonials')->order('lang, sort_order, id')->fetchAll();
    }

    public function getById(int $id): ?ActiveRow
    {
        return $this->db->table('testimonials')->get($id);
    }

    public function save(array $data, ?int $id): void
    {
        $payload = [
            'lang' => $data['lang'],
            'client_name' => $data['client_name'],
            'project_name' => $data['project_name'] ?: null,
            'quote_text' => $data['quote_text'],
            'event_date' => $data['event_date'] ?: null,
            'image_path' => $data['image_path'] ?: null,
            'sort_order' => $data['sort_order'],
            'active' => $data['active'] ? 1 : 0,
        ];
        if ($id) {
            $this->db->table('testimonials')->where('id', $id)->update($payload);
        } else {
            $payload['created'] = new \DateTimeImmutable();
            $this->db->table('testimonials')->insert($payload);
        }
    }

    public function delete(int $id): void
    {
        $this->db->table('testimonials')->where('id', $id)->delete();
    }
}
