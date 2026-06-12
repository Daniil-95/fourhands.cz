<?php declare(strict_types=1);

namespace App\Model;

use Nette\Database\Explorer;

final class MediaRepository
{
    private const VIDEO_ID_OFFSET = 100000000;

    public function __construct(private Explorer $db)
    {
    }

    public function getByLocaleAndType(string $locale, string $type): array
    {
        if ($type === 'photo') {
            return $this->photos($locale);
        }

        return $this->videos($locale);
    }

    public function getAll(): array
    {
        $items = [];

        foreach ($this->db->table('images')->order('id DESC')->fetchAll() as $row) {
            $items[] = (object) [
                'id' => (int) $row->id,
                'lang' => (string) $row->lang,
                'type' => 'photo',
                'title' => (string) ($row->title ?? ''),
                'description' => (string) ($row->subtitle ?? ''),
                'image_path' => $this->normalizePath((string) ($row->file ?? '')),
                'url' => '',
                'sort_order' => (int) $row->sort_order,
                'active' => (bool) $row->active,
                'alt_text' => (string) ($row->alt_text ?? ''),
            ];
        }

        foreach ($this->db->table('videos')->order('id DESC')->fetchAll() as $row) {
            $items[] = (object) [
                'id' => self::VIDEO_ID_OFFSET + (int) $row->id,
                'lang' => (string) $row->lang,
                'type' => 'video',
                'title' => (string) ($row->title ?? ''),
                'description' => '',
                'image_path' => $this->normalizeVideoThumb((string) ($row->ratio ?? '')),
                'url' => (string) (($row->embed ?: $row->file) ?? ''),
                'sort_order' => (int) $row->sort_order,
                'active' => (bool) $row->active,
                'alt_text' => '',
            ];
        }

        return $items;
    }

    public function getLatest(int $limit = 5): array
    {
        $items = [];

        foreach ($this->db->table('images')->order('id DESC')->limit($limit)->fetchAll() as $row) {
            $items[] = (object) [
                'id' => (int) $row->id,
                'lang' => (string) $row->lang,
                'type' => 'photo',
                'title' => (string) ($row->title ?? ''),
                'image_path' => $this->normalizePath((string) ($row->file ?? '')),
                'active' => (bool) $row->active,
            ];
        }

        if (count($items) < $limit) {
            foreach ($this->db->table('videos')->order('id DESC')->limit($limit - count($items))->fetchAll() as $row) {
                $items[] = (object) [
                    'id' => self::VIDEO_ID_OFFSET + (int) $row->id,
                    'lang' => (string) $row->lang,
                    'type' => 'video',
                    'title' => (string) ($row->title ?? ''),
                    'image_path' => '',
                    'active' => (bool) $row->active,
                ];
            }
        }

        return $items;
    }

    public function getById(int $id): ?object
    {
        if ($id >= self::VIDEO_ID_OFFSET) {
            $videoId = $id - self::VIDEO_ID_OFFSET;
            $row = $this->db->table('videos')->get($videoId);
            if (!$row) {
                return null;
            }

            return (object) [
                'id' => $id,
                'lang' => (string) ($row->lang ?? 'cs'),
                'type' => 'video',
                'title' => (string) ($row->title ?? ''),
                'description' => '',
                'image_path' => $this->normalizeVideoThumb((string) ($row->ratio ?? '')),
                'url' => (string) (($row->embed ?: $row->file) ?? ''),
                'sort_order' => 0,
                'active' => (bool) $row->active,
                'alt_text' => '',
            ];
        }

        $row = $this->db->table('images')->get($id);
        if (!$row) {
            return null;
        }

        return (object) [
            'id' => (int) $row->id,
            'lang' => (string) ($row->lang ?? 'cs'),
            'type' => 'photo',
            'title' => (string) ($row->title ?? ''),
            'description' => (string) ($row->subtitle ?? ''),
            'image_path' => $this->normalizePath((string) ($row->file ?? '')),
            'url' => '',
            'sort_order' => 0,
            'active' => (bool) $row->active,
            'alt_text' => (string) ($row->alt_text ?? ''),
        ];
    }

    public function save(array $data, int $userId, ?int $id = null): void
    {
        if ($data['type'] === 'video') {
            $payload = [
                'title' => $data['title'],
                'lang' => $data['lang'],
                'description' => $data['description'],
                'embed' => $data['url'] ?: null,
                'file' => $data['url'] ?: null,
                'ratio' => $this->normalizePath((string) ($data['image_path'] ?? '')),
                'sort_order' => $data['sort_order'],
                'active' => $data['active'] ? 1 : 0,
            ];

            if ($id !== null) {
                $videoId = $id >= self::VIDEO_ID_OFFSET ? $id - self::VIDEO_ID_OFFSET : $id;
                $this->db->table('videos')->where('id', $videoId)->update($payload);
                return;
            }

            $payload['created'] = new \DateTimeImmutable();
            $payload['users_id'] = $userId;
            $this->db->table('videos')->insert($payload);
            return;
        }

        $payload = [
            'title' => $data['title'],
            'lang' => $data['lang'],
            'subtitle' => $data['description'],
            'alt_text' => $data['alt_text'],
            'file' => $this->normalizePath((string) ($data['image_path'] ?? '')),
            'crop' => 0,
            'sort_order' => $data['sort_order'],
            'active' => $data['active'] ? 1 : 0,
        ];

        if ($id !== null) {
            $this->db->table('images')->where('id', $id)->update($payload);
            return;
        }

        $payload['created'] = new \DateTimeImmutable();
        $payload['users_id'] = $userId;
        $this->db->table('images')->insert($payload);
    }

    public function delete(int $id): void
    {
        if ($id >= self::VIDEO_ID_OFFSET) {
            $this->db->table('videos')->where('id', $id - self::VIDEO_ID_OFFSET)->delete();
            return;
        }

        $this->db->table('images')->where('id', $id)->delete();
    }

    private function photos(string $locale): array
    {
        $items = [];
        foreach ($this->db->table('images')->where('lang', $locale)->where('active', 1)->order('sort_order, id DESC')->fetchAll() as $row) {
            $items[] = [
                'id' => (int) $row->id,
                'title' => (string) ($row->title ?? ''),
                'description' => (string) ($row->subtitle ?? ''),
                'image_path' => $this->normalizePath((string) ($row->file ?? '')),
                'url' => '',
            ];
        }

        return $items;
    }

    private function videos(string $locale): array
    {
        $items = [];
        foreach ($this->db->table('videos')->where('lang', $locale)->where('active', 1)->order('sort_order, id DESC')->fetchAll() as $row) {
            $items[] = [
                'id' => self::VIDEO_ID_OFFSET + (int) $row->id,
                'title' => (string) ($row->title ?? ''),
                'description' => '',
                'image_path' => $this->normalizeVideoThumb((string) ($row->ratio ?? '')),
                'url' => (string) (($row->embed ?: $row->file) ?? ''),
            ];
        }

        return $items;
    }

    private function normalizePath(string $path): string
    {
        $trimmed = trim($path);
        if ($trimmed === '') {
            return '';
        }

        if (str_starts_with($trimmed, 'images/')) {
            return $trimmed;
        }

        return 'images/' . ltrim($trimmed, '/');
    }

    private function normalizeVideoThumb(string $thumb): string
    {
        $trimmed = trim($thumb);
        if ($trimmed === '' || $trimmed === '16:9') {
            return '';
        }

        return $this->normalizePath($trimmed);
    }
}
