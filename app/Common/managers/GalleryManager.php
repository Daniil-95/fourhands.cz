<?php

namespace App\Managers;

use Nette;
use Nette\Database\Explorer;
use Oxit\Managers\BaseManager;

class GalleryManager extends BaseManager
{
	use Nette\SmartObject;

	protected Explorer $database;

	protected $tableName = 'gallery';
	protected $defaultOrder = 'order ASC';

	public function __construct(Explorer $database)
	{
		$this->database = $database;
	}

	public function getTable(): \Nette\Database\Table\Selection
	{
		return $this->database->table($this->tableName);
	}

	public function getById(int $id): ?\Nette\Database\Table\ActiveRow
	{
		return $this->database->table('gallery')->get($id);
	}

	public function getGalleryImages(int $galleryId): array
	{
		$rows = $this->database->table('gallery2images')
			->where('gallery_id', $galleryId)
			->order('`order` ASC, id ASC')
			->fetchAll();

		$images = [];
		foreach ($rows as $row) {
			$image = $row->ref('images', 'images_id');
			if ($image) {
				$images[] = (object)[
					'url' => '/images/' . $image->file,
					'title' => $image->title ?? '',
					'subtitle' => $row->subtitle_override ?? $image->subtitle ?? '',
				];
			}
		}
		return $images;
	}
}
