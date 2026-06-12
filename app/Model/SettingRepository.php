<?php declare(strict_types=1);

namespace App\Model;

use Nette\Database\Explorer;
use Nette\Database\Table\ActiveRow;

final class SettingRepository
{
    public function __construct(private Explorer $db)
    {
    }

    public function getByLocale(string $locale): array
    {
        $settings = [];
        foreach ($this->db->table('site_settings')->where('lang', $locale)->order('sort_order, id') as $row) {
            $settings[(string) $row->key_name] = (string) ($row->value_text ?? '');
        }
        return $settings;
    }

    public function getAll(): array
    {
        return $this->db->table('site_settings')->order('group_name, sort_order, id')->fetchAll();
    }

    public function getById(int $id): ?ActiveRow
    {
        return $this->db->table('site_settings')->get($id);
    }

    public function save(array $data, ?int $id = null): void
    {
        $payload = [
            'lang' => $data['lang'],
            'group_name' => $data['group_name'],
            'key_name' => $data['key_name'],
            'label' => $data['label'],
            'value_text' => $data['value_text'],
            'sort_order' => $data['sort_order'],
        ];
        $id ? $this->db->table('site_settings')->where('id', $id)->update($payload) : $this->db->table('site_settings')->insert($payload);
    }

    public function delete(int $id): void
    {
        $this->db->table('site_settings')->where('id', $id)->delete();
    }
}
