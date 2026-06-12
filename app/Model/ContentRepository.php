<?php declare(strict_types=1);

namespace App\Model;

use Nette\Database\Explorer;
use Nette\Database\Table\ActiveRow;

final class ContentRepository
{
    private const TITLE_MAP = [
        'cs' => [
            'about' => 'O nás',
            'performances' => 'Naše vystoupení',
            'artist_katerina' => 'Kateřina Konopová',
            'artist_irena' => 'Irena Andruško',
            'program' => 'Nabídka programů',
            'contacts' => 'Kontakty',
            'copyright' => 'Copyright',
        ],
        'en' => [
            'about' => 'About us',
            'performances' => 'Performances',
            'artist_katerina' => 'Katerina Konopova',
            'artist_irena' => 'Irena Andrusko',
            'program' => 'Programmes',
            'contacts' => 'Contacts',
            'copyright' => 'Copyright',
        ],
    ];

    public function __construct(private Explorer $db)
    {
    }

    public function getByLocale(string $locale): array
    {
        $rows = $this->db->table('text_snippets')
            ->where('lang', $locale)
            ->where('active', 1)
            ->order('sort_order ASC, code ASC, id ASC')
            ->fetchAll();

        $items = [];
        foreach ($rows as $row) {
            $items[$row->code] = [
                'id' => (int) $row->id,
                'key_name' => $row->code,
                'title' => $row->title ?: (self::TITLE_MAP[$locale][$row->code] ?? $row->code),
                'content_html' => $row->content,
                'sort_order' => (int) $row->sort_order,
            ];
        }

        return $items;
    }

    public function getAll(): array
    {
        return $this->db->table('text_snippets')->order('lang ASC, category ASC, sort_order ASC, code ASC')->fetchAll();
    }

    public function getById(int $id): ?ActiveRow
    {
        return $this->db->table('text_snippets')->get($id);
    }

    public function save(array $data, ?int $id = null): void
    {
        $payload = [
            'lang' => $data['lang'],
            'code' => $data['key_name'],
            'title' => $data['title'],
            'category' => $data['category'],
            'content' => $data['content_html'],
            'sort_order' => $data['sort_order'],
            'active' => $data['active'] ? 1 : 0,
        ];

        if ($id !== null) {
            $this->db->table('text_snippets')->where('id', $id)->update($payload);
            return;
        }

        $payload['created'] = new \DateTimeImmutable();
        $this->db->table('text_snippets')->insert($payload);
    }

    public function delete(int $id): void
    {
        $this->db->table('text_snippets')->where('id', $id)->delete();
    }
}
