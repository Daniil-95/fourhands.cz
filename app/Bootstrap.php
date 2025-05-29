<?php

declare(strict_types=1);

namespace App;

use Nette\Configurator;


class Bootstrap
{
    public static function boot(): Configurator
    {
        $configurator = new Configurator;

        \Tracy\Debugger::$errorTemplate = __DIR__ . '/../vendor/oxit/oxitweb-core/src/app/FrontModule/templates/Error/500.phtml';

        $configurator->setDebugMode(['77.87.241.31']);
        //$configurator->setDebugMode(false);

        $configurator->enableTracy(__DIR__ . '/../log');

        $configurator->setTimeZone('Europe/Prague');
        $configurator->setTempDirectory(__DIR__ . '/../temp');

        $configurator->createRobotLoader()
            ->addDirectory(__DIR__, __DIR__ . '/../vendor/oxit/oxitweb-core/src/')
            ->register();

        $configurator->addConfig(__DIR__ . '/config/common.neon');

        if ($_SERVER['HTTP_HOST'] === null) { // migrace
            if (file_exists(__DIR__ . '/config/local.neon')) {
                $configurator->addConfig(__DIR__ . '/config/local.neon');
            } else {
                $configurator->addConfig(__DIR__ . '/config/www.neon');
            }
        } elseif (substr($_SERVER['HTTP_HOST'], -5) === 'local') {
            $configurator->addConfig(__DIR__ . '/config/local.neon');
        } else {
            $configurator->addConfig(__DIR__ . '/config/www.neon');
        }

        return $configurator;
    }
}
