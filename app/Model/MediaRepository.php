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
            return $this->photos();
        }

        return $this->videos();
    }

    public function getAll(): array
    {
        $items = [];

        foreach ($this->db->table('images')->order('id DESC')->fetchAll() as $row) {
            $items[] = (object) [
                'id' => (int) $row->id,
                'lang' => 'cs',
                'type' => 'photo',
                'title' => (string) ($row->title ?? ''),
                'description' => (string) ($row->subtitle ?? ''),
                'image_path' => $this->normalizePath((string) ($row->file ?? '')),
                'url' => '',
            ];
        }

        foreach ($this->db->table('videos')->order('id DESC')->fetchAll() as $row) {
            $items[] = (object) [
                'id' => self::VIDEO_ID_OFFSET + (int) $row->id,
                'lang' => 'cs',
                'type' => 'video',
                'title' => (string) ($row->title ?? ''),
                'description' => '',
                'image_path' => $this->normalizeVideoThumb((string) ($row->ratio ?? '')),
                'url' => (string) (($row->embed ?: $row->file) ?? ''),
            ];
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
                'lang' => 'cs',
                'type' => 'video',
                'title' => (string) ($row->title ?? ''),
                'description' => '',
                'image_path' => $this->normalizeVideoThumb((string) ($row->ratio ?? '')),
                'url' => (string) (($row->embed ?: $row->file) ?? ''),
                'sort_order' => 0,
            ];
        }

        $row = $this->db->table('images')->get($id);
        if (!$row) {
            return null;
        }

        return (object) [
            'id' => (int) $row->id,
            'lang' => 'cs',
            'type' => 'photo',
            'title' => (string) ($row->title ?? ''),
            'description' => (string) ($row->subtitle ?? ''),
            'image_path' => $this->normalizePath((string) ($row->file ?? '')),
            'url' => '',
            'sort_order' => 0,
        ];
    }

    public function save(array $data, ?int $id = null): void
    {
        if ($data['type'] === 'video') {
            $payload = [
                'title' => $data['title'],
                'embed' => $data['url'] ?: null,
                'file' => $data['url'] ?: null,
                'ratio' => $this->normalizePath((string) ($data['image_path'] ?? '')),
            ];

            if ($id !== null) {
                $videoId = $id >= self::VIDEO_ID_OFFSET ? $id - self::VIDEO_ID_OFFSET : $id;
                $this->db->table('videos')->where('id', $videoId)->update($payload);
                return;
            }

            $payload['created'] = new \DateTimeImmutable();
            $this->db->table('videos')->insert($payload);
            return;
        }

        $payload = [
            'title' => $data['title'],
            'subtitle' => $data['description'],
            'file' => $this->normalizePath((string) ($data['image_path'] ?? '')),
            'crop' => 0,
        ];

        if ($id !== null) {
            $this->db->table('images')->where('id', $id)->update($payload);
            return;
        }

        $payload['created'] = new \DateTimeImmutable();
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

    private function photos(): array
    {
        $items = [];
        foreach ($this->db->table('images')->order('id DESC')->fetchAll() as $row) {
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

    private function videos(): array
    {
        $items = [];
        foreach ($this->db->table('videos')->order('id DESC')->fetchAll() as $row) {
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
