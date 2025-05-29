<?php

declare(strict_types=1);

namespace App\Services\Router;

use Nette;
use Nette\Application\Routers\Route;
use Nette\Application\Routers\RouteList;


class RouterFactory extends \Oxit\Services\Router\RouterFactory
{

	public static function createRouter(string $defaultLang): RouteList
	{
		$router = new RouteList();

		$router->add(new Route('[!<lang='.$defaultLang.' [a-z]{2}>/]kontakt', [
			'presenter' =>'Contact',
			'action' =>'default',
			'module' =>'Front'
		]));

		self::addOxitWebRoutes($router, $defaultLang);

		return $router;
	}
}
