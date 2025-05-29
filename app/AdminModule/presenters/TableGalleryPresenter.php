<?php

namespace App\AdminModule\Presenters;

use App\Managers\GalleryManager;
use Oxit\AdminModule\Presenters\TablePresenter;

/**
 * Gallery table presenter
 */
class TableGalleryPresenter extends TablePresenter
{
	/** @var GalleryManager @inject */
	public $manager;

	public $listFields = [
		'title' => [
			'label' => 'Název galerie',
			'search' => [],
		],
		'background' => [
			'label' => 'Barva pozadí',
			'search' => [],
		],
	];

	public $editFields = [
		'title' => [
			'label' => 'Název galerie',
			'type' => 'text',
		],
		'background' => [
			'label' => 'Barva pozadí',
			'type' => 'select',
			'items' => [
				'default' => 'Bílý',
				'gray' => 'Šedý',
				'brown' => 'Hnědý',
			],
			'required' => false,
		],
	];

	public function startup()
	{
		parent::startup();
	}

	public function renderEdit($id, $activeTab = 'basic')
	{
		parent::renderEdit($id, $activeTab);

		// Instalace šablony pro vykreslování edit.latte
		$this->template->setFile(__DIR__ . '/../templates/TableGallery/edit.latte');
	}
}
