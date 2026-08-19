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
        $items = [];
        foreach ($this->db->table('media_translations')->where('lang', $locale)->where('active', 1)->order('sort_order, id DESC')->fetchAll() as $row) {
            $asset = $this->db->table('media_assets')->get((int) $row->asset_id);
            if ($asset && (string) $asset->type === $type) {
                $item = $this->mapRow($row, $asset, $type === 'video');
                if ($type === 'video') {
                    $item->sort_order = $this->getCzechVideoSortOrder((int) $asset->id, (int) $row->sort_order);
                } else {
                    $item->sort_order = $this->getCzechPhotoSortOrder((int) $asset->id, (int) $row->sort_order);
                }
                $items[] = (array) $item;
            }
        }
        if (in_array($type, ['photo', 'video'], true)) {
            usort($items, static fn (array $first, array $second): int => $first['sort_order'] <=> $second['sort_order'] ?: $second['id'] <=> $first['id']);
        }
        return $items;
    }

    public function getAll(): array
    {
        $items = [];
        foreach ($this->db->table('media_translations')->order('lang, sort_order, id DESC')->fetchAll() as $row) {
            $asset = $this->db->table('media_assets')->get((int) $row->asset_id);
            if ($asset) {
                $item = $this->mapRow($row, $asset, (string) $asset->type === 'video');
                if ((string) $asset->type === 'video') {
                    $item->sort_order = $this->getCzechVideoSortOrder((int) $asset->id, (int) $row->sort_order);
                } elseif ((string) $asset->type === 'photo') {
                    $item->sort_order = $this->getCzechPhotoSortOrder((int) $asset->id, (int) $row->sort_order);
                }
                $items[] = $item;
            }
        }
        usort($items, static function (object $first, object $second): int {
            $languageOrder = strcmp((string) $first->lang, (string) $second->lang);
            if ($languageOrder !== 0) {
                return $languageOrder;
            }

            return (int) $first->sort_order <=> (int) $second->sort_order
                ?: (int) $second->id <=> (int) $first->id;
        });
        return $items;
    }

    public function getNextTopSortOrder(string $type): int
    {
        $minSortOrder = $this->db->query(
            'SELECT MIN(mt.sort_order) AS min_sort_order
             FROM media_translations mt
             INNER JOIN media_assets ma ON ma.id = mt.asset_id
             WHERE ma.type = ?',
            $type,
        )->fetch();

        if (!$minSortOrder || $minSortOrder->min_sort_order === null) {
            return 100;
        }

        return (int) $minSortOrder->min_sort_order - 1;
    }

    public function getById(int $id): ?object
    {
        $isVideo = $id >= self::VIDEO_ID_OFFSET;
        $assetId = $isVideo ? $id - self::VIDEO_ID_OFFSET : $id;
        $row = $this->db->table('media_translations')->where('asset_id', $assetId)->fetch();
        $asset = $row ? $this->db->table('media_assets')->get($assetId) : null;
        if (!$row || !$asset || ((string) $asset->type === 'video') !== $isVideo) {
            return null;
        }
        return $this->mapRow($row, $asset, $isVideo);
    }

    public function save(array $data, int $userId, ?int $id = null): void
    {
        $type = (string) $data['type'];
        $isVideo = $type === 'video';
        $language = (string) $data['lang'];
        $assetId = $id !== null ? ($isVideo ? $id - self::VIDEO_ID_OFFSET : $id) : null;
        $assetData = $isVideo
            ? ['type' => 'video', 'embed_url' => $data['url'] ?: null, 'thumbnail_path' => $this->normalizePath((string) ($data['image_path'] ?? '')) ?: null]
            : ['type' => 'photo', 'file' => $this->normalizePath((string) ($data['image_path'] ?? '')) ?: null];

        if ($assetId === null) {
            $asset = $isVideo
                ? $this->db->table('media_assets')->where('type', 'video')->where('embed_url', $assetData['embed_url'])->fetch()
                : ($assetData['file'] !== null ? $this->db->table('media_assets')->where('type', 'photo')->where('file', $assetData['file'])->fetch() : null);
            if ($asset) {
                $assetId = (int) $asset->id;
            } else {
                $assetData['users_id'] = $userId;
                $assetData['created'] = new \DateTimeImmutable();
                $assetId = (int) $this->db->table('media_assets')->insert($assetData)->id;
            }
        } else {
            $this->db->table('media_assets')->where('id', $assetId)->update($assetData);
        }

        $translation = [
            'asset_id' => $assetId,
            'lang' => $language,
            'title' => $data['title'],
            'description' => $data['description'],
            'alt_text' => $data['alt_text'] ?? null,
            'sort_order' => $isVideo
                ? $this->getCzechVideoSortOrder($assetId, (int) $data['sort_order'])
                : $this->getCzechPhotoSortOrder($assetId, (int) $data['sort_order']),
            'active' => $data['active'] ? 1 : 0,
        ];
        $existing = $this->db->table('media_translations')->where('asset_id', $assetId)->where('lang', $language)->fetch();
        if ($existing) {
            $this->db->table('media_translations')->where('id', $existing->id)->update($translation);
        } else {
            $translation['created'] = new \DateTimeImmutable();
            $this->db->table('media_translations')->insert($translation);
        }

        $this->db->table('media_translations')->where('asset_id', $assetId)->update(['sort_order' => (int) $data['sort_order']]);

        $this->ensureCounterpartTranslationExists(
            $assetId,
            $language,
            (int) $data['sort_order'],
            (bool) $data['active'],
        );
    }

    public function delete(int $id): void
    {
        $assetId = $id >= self::VIDEO_ID_OFFSET ? $id - self::VIDEO_ID_OFFSET : $id;
        $this->db->table('media_translations')->where('asset_id', $assetId)->delete();
        if (!$this->db->table('media_translations')->where('asset_id', $assetId)->fetch()) {
            $this->db->table('media_assets')->where('id', $assetId)->delete();
        }
    }

    private function mapRow(object $row, object $asset, bool $isVideo): object
    {
        $path = $isVideo ? $this->normalizeVideoThumb((string) ($asset->thumbnail_path ?? '')) : $this->normalizePath((string) ($asset->file ?? ''));
        $url = $isVideo ? (string) ($asset->embed_url ?? '') : '';
        $item = [
            'id' => $isVideo ? self::VIDEO_ID_OFFSET + (int) $asset->id : (int) $asset->id,
            'lang' => (string) $row->lang,
            'type' => $isVideo ? 'video' : 'photo',
            'title' => (string) ($row->title ?? ''),
            'description' => (string) ($row->description ?? ''),
            'image_path' => $path,
            'url' => $url,
            'sort_order' => (int) $row->sort_order,
            'active' => (bool) $row->active,
            'alt_text' => (string) ($row->alt_text ?? ''),
        ];
        if ($isVideo) {
            $item['youtube_thumb'] = $this->getYoutubeThumbnail($url, 'hqdefault');
            $item['youtube_thumb_fallback'] = $this->getYoutubeThumbnail($url, 'mqdefault');
        } else {
            $item['gallery_path'] = $this->getOptimizedImagePath($path, 1200);
            $item['thumbnail_path'] = $this->getOptimizedImagePath($path, 480);
        }
        return (object) $item;
    }

    private function getCzechVideoSortOrder(int $assetId, int $fallback): int
    {
        $czechTranslation = $this->db->table('media_translations')
            ->where('asset_id', $assetId)
            ->where('lang', 'cs')
            ->fetch();

        return $czechTranslation ? (int) $czechTranslation->sort_order : $fallback;
    }

    private function getCzechPhotoSortOrder(int $assetId, int $fallback): int
    {
        $czechTranslation = $this->db->table('media_translations')
            ->where('asset_id', $assetId)
            ->where('lang', 'cs')
            ->fetch();

        return $czechTranslation ? (int) $czechTranslation->sort_order : $fallback;
    }

    private function ensureCounterpartTranslationExists(int $assetId, string $language, int $sortOrder, bool $active): void
    {
        $counterpartLanguage = $language === 'cs' ? 'en' : ($language === 'en' ? 'cs' : null);
        if ($counterpartLanguage === null) {
            return;
        }

        $counterpartTranslation = $this->db->table('media_translations')
            ->where('asset_id', $assetId)
            ->where('lang', $counterpartLanguage)
            ->fetch();

        if ($counterpartTranslation) {
            return;
        }

        $this->db->table('media_translations')->insert([
            'asset_id' => $assetId,
            'lang' => $counterpartLanguage,
            'title' => '',
            'description' => '',
            'alt_text' => '',
            'sort_order' => $sortOrder,
            'active' => $active ? 1 : 0,
            'created' => new \DateTimeImmutable(),
        ]);
    }

    private function normalizePath(string $path): string
    {
        $trimmed = trim($path);
        return $trimmed === '' ? '' : (str_starts_with($trimmed, 'images/') ? $trimmed : 'images/' . ltrim($trimmed, '/'));
    }

    private function normalizeVideoThumb(string $thumb): string
    {
        return trim($thumb) === '' || trim($thumb) === '16:9' ? '' : $this->normalizePath($thumb);
    }

    public function getOptimizedImagePath(string $path, int $maxWidth = 1200): string
    {
        $normalized = $this->normalizePath($path);
        return $normalized === '' ? '' : ImageOptimizer::getDerivativePath($normalized, $maxWidth);
    }

    public function getYoutubeThumbnail(string $url, string $variant = 'maxresdefault'): string
    {
        if (preg_match('~(?:youtube\.com/(?:watch\?v=|embed/|shorts/)|youtu\.be/)([A-Za-z0-9_-]{11})~i', trim($url), $matches) === 1) {
            return 'https://img.youtube.com/vi/' . $matches[1] . '/' . $variant . '.jpg';
        }
        return '';
    }
}