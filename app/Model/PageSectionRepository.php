<?php declare(strict_types=1);

namespace App\Model;

use Nette\Database\Explorer;
use Nette\Database\Table\ActiveRow;

final class PageSectionRepository
{
    public const PAGES = [
        'homepage' => 'Hlavní stránka',
        'about' => 'O nás',
        'artists' => 'Umělkyně',
        'repertoire' => 'Repertoár',
        'from_stage' => 'Z pódia',
    ];

    public const SECTIONS = [
        'homepage' => [
            'hero' => 'První obrazovka',
            'videos' => 'Videogalerie',
            'gallery' => 'Fotogalerie',
            'contact' => 'Kontakt',
        ],
        'about' => ['hero' => 'První obrazovka', 'content' => 'Obsah stránky'],
        'artists' => ['hero' => 'První obrazovka', 'katerina' => 'Kateřina Konopová', 'irena' => 'Irena Andruško'],
        'repertoire' => ['hero' => 'První obrazovka', 'content' => 'Obsah stránky'],
            'from_stage' => ['hero' => 'Z pódia'],
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

    public function save(int $id, array $data): void
    {
        $this->db->table('page_sections')->where('id', $id)->update([
            'lang' => $data['lang'],
            'title' => $data['title'],
            'subtitle' => $data['subtitle'],
            'content' => $data['content'],
            'button_text' => $data['button_text'],
            'button_url' => $data['button_url'],
            'image_path' => $data['image_path'],
            'active' => $data['active'] ? 1 : 0,
        ]);
    }
}