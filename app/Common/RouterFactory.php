<?php declare(strict_types=1);

namespace App\Common;

use Nette\Application\Routers\Route;
use Nette\Application\Routers\RouteList;

final class RouterFactory
{
    public static function createRouter(): RouteList
    {
        $router = new RouteList();

        $router->addRoute('admin[/<presenter>[/<action>[/<id>]]]', [
            'module' => 'Admin',
            'presenter' => 'Dashboard',
            'action' => 'default',
        ]);

        foreach ([
            'artists' => 'Artists',
            'clenky' => 'Artists',
            'umelkyne' => 'Artists',
            'gallery' => 'Gallery',
            'galerie' => 'Gallery',
            'fotogalerie' => 'Gallery',
            'videos' => 'Videos',
            'videa' => 'Videos',
            'video-galerie' => 'Videos',
            'from-stage' => 'FromStage',
            'z-podia' => 'FromStage',
            'repertoire' => 'Repertoire',
            'repertoar' => 'Repertoire',
            'koncertni-program' => 'Repertoire',
            'events-archive' => 'EventsArchive',
            'archiv-udalosti' => 'EventsArchive',
            'contact' => 'Homepage',
            'kontakt' => 'Homepage',
            'about' => 'About',
            'o-nas' => 'About',
        ] as $slug => $presenter) {
            $router->addRoute('[<locale=cs cs|en>/]' . $slug, [
                'module' => 'Front',
                'presenter' => $presenter,
                'action' => 'default',
            ]);
        }

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
