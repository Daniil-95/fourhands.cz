<?php declare(strict_types=1);

namespace App\Common;

use Nette\Application\Routers\Route;
use Nette\Application\Routers\RouteList;

final class RouterFactory
{
    public static function createRouter(): RouteList
    {
        $router = new RouteList();

        $router->addRoute('admin/<presenter>/<action>[/<id>]', [
            'module' => 'Admin',
            'presenter' => 'Dashboard',
            'action' => 'default',
        ]);

        $router->addRoute('admin', [
            'module' => 'Admin',
            'presenter' => 'Dashboard',
            'action' => 'default',
        ]);

        $router->addRoute('[<locale=cs cs|en>/]<presenter>/<action>[/<id>]', [
            'module' => 'Front',
            'presenter' => 'Homepage',
            'action' => 'default',
        ]);

        $router->addRoute('[<locale=cs cs|en>]', [
            'module' => 'Front',
            'presenter' => 'Homepage',
            'action' => 'default',
        ]);

        return $router;
    }
}
