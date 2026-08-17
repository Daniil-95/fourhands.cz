<?php declare(strict_types=1);

namespace App\Model;

use Nette\Database\Explorer;
use Nette\Database\Table\ActiveRow;

final class PublicationRepository
{
    private bool $publicationsTableEnsured = false;

    public function __construct(private Explorer $db)
    {
    }

    public function getActiveByLocale(string $locale): array
    {
        $this->ensurePublicationsTable();

        return $this->db->table('publications')
            ->where('lang', $locale)
            ->where('active', 1)
            ->order('publish_date DESC, sort_order, id DESC')
            ->fetchAll();
    }

    public function getAll(): array
    {
        $this->ensurePublicationsTable();

        return $this->db->table('publications')->order('lang ASC, publish_date DESC, sort_order, id DESC')->fetchAll();
    }

    public function getById(int $id): ?ActiveRow
    {
        $this->ensurePublicationsTable();

        return $this->db->table('publications')->get($id);
    }

    public function save(array $data, ?int $id = null): void
    {
        $this->ensurePublicationsTable();

        $payload = [
            'lang' => $data['lang'],
            'title' => $data['title'],
            'source' => $data['source'],
            'short_description' => $data['short_description'],
            'url' => $data['url'],
            'image_path' => $data['image_path'],
            'publish_date' => $data['publish_date'] ?: new \DateTimeImmutable(),
            'sort_order' => (int) ($data['sort_order'] ?? 100),
            'active' => $data['active'] ? 1 : 0,
        ];

        if ($id !== null) {
            $this->db->table('publications')->where('id', $id)->update($payload);
            return;
        }

        $payload['created'] = new \DateTimeImmutable();
        $this->db->table('publications')->insert($payload);
    }

    public function delete(int $id): void
    {
        $this->ensurePublicationsTable();

        $this->db->table('publications')->where('id', $id)->delete();
    }

    private function ensurePublicationsTable(): void
    {
        if ($this->publicationsTableEnsured) {
            return;
        }

        $this->db->query(<<<'SQL'
            CREATE TABLE IF NOT EXISTS publications (
              id INT UNSIGNED NOT NULL AUTO_INCREMENT,
              lang CHAR(2) NOT NULL DEFAULT 'cs',
              title VARCHAR(255) NOT NULL,
              source VARCHAR(255) DEFAULT NULL,
              short_description TEXT DEFAULT NULL,
              url VARCHAR(500) DEFAULT NULL,
              image_path VARCHAR(255) DEFAULT NULL,
              publish_date DATE DEFAULT NULL,
              sort_order INT NOT NULL DEFAULT 100,
              active TINYINT(1) NOT NULL DEFAULT 1,
              created DATETIME NOT NULL,
              PRIMARY KEY (id),
              KEY idx_publications_lang_active (lang, active, publish_date),
              KEY idx_publications_sort (sort_order)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
            SQL);

        $this->publicationsTableEnsured = true;
    }
}
