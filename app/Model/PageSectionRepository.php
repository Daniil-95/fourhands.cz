<?php declare(strict_types=1);

namespace App\Model;

use Nette\Database\Explorer;
use Nette\Database\Table\ActiveRow;

final class PageSectionRepository
{
    public const PAGES = [
        'homepage' => 'Úvodní sekce',
        'about' => 'O nás',
        'artists' => 'Umělkyně',
        'repertoire' => 'Koncertní program',
        'from_stage' => 'Z pódia',
    ];

    public const SECTIONS = [
        'homepage' => ['hero' => 'Úvodní sekce'],
        'about' => ['content' => 'O nás'],
        'artists' => ['hero' => 'První obrazovka', 'katerina' => 'Kateřina Konopová', 'irena' => 'Irena Andruško'],
        'repertoire' => ['hero' => 'První obrazovka', 'content' => 'Obsah stránky'],
        'from_stage' => ['hero' => 'Z pódia'],
    ];

    /** Pole, která daná sekce opravdu používá na webu – řídí formulář v administraci. */
    public const SECTION_FIELDS = [
        'homepage' => ['hero' => ['title', 'subtitle', 'content', 'image']],
        'about' => ['content' => ['title', 'subtitle', 'content', 'image']],
        'artists' => ['hero' => ['title', 'subtitle'], 'katerina' => ['title', 'content', 'image'], 'irena' => ['title', 'content', 'image']],
        'repertoire' => ['hero' => ['title', 'subtitle'], 'content' => ['title', 'content']],
        'from_stage' => ['hero' => ['title', 'subtitle']],
    ];

    public function __construct(private Explorer $db)
    {
    }

    /** @return array<string, array<string, ActiveRow>> */
    public function getByLocale(string $locale): array
    {
        $sections = [];
        foreach ($this->db->table('page_sections')->where('lang', $locale)->where('active', 1)->order('sort_order, id') as $section) {
            $sections[(string) $section->page_key][(string) $section->section_key] = $section;
        }
        return $sections;
    }

    /** @return array<string, array<int, ActiveRow>> */
    public function getAllGroupedByPage(string $locale): array
    {
        $sections = [];
        foreach ($this->db->table('page_sections')->where('lang', $locale)->order('sort_order, id') as $section) {
            $sections[(string) $section->page_key][] = $section;
        }
        return $sections;
    }

    public function getById(int $id): ?ActiveRow
    {
        return $this->db->table('page_sections')->get($id);
    }

    public function getByPageSection(string $pageKey, string $sectionKey, string $locale): ?ActiveRow
    {
        $row = $this->db->table('page_sections')
            ->where('page_key', $pageKey)
            ->where('section_key', $sectionKey)
            ->where('lang', $locale)
            ->fetch();

        return $row ?: null;
    }

    public function save(int $id, array $data): void
    {
        $this->db->table('page_sections')->where('id', $id)->update([
            'title' => $data['title'],
            'subtitle' => $data['subtitle'],
            'content' => $data['content'],
            'image_path' => $data['image_path'],
        ]);
    }

    public function updateTitleAndSubtitle(int $id, string $title, string $subtitle): void
    {
        $this->db->table('page_sections')->where('id', $id)->update([
            'title' => $title,
            'subtitle' => $subtitle,
        ]);
    }

    public function syncImageAcrossLocales(string $pageKey, string $sectionKey, string $imagePath): void
    {
        $this->db->table('page_sections')
            ->where('page_key', $pageKey)
            ->where('section_key', $sectionKey)
            ->update(['image_path' => $imagePath]);
    }
}
