<?php declare(strict_types=1);

use Nette\Bootstrap\Configurator;

require __DIR__ . '/vendor/autoload.php';

$configurator = new Configurator();

$configurator->setTempDirectory(__DIR__ . '/temp');

$configurator->enableTracy(__DIR__ . '/log');

$configurator->setDebugMode(true);

$configurator->createRobotLoader()
    ->addDirectory(__DIR__ . '/app')
    ->register();

$configurator->addConfig(__DIR__ . '/app/config/common.neon');
$configurator->addConfig(__DIR__ . '/app/config/local.neon');

return $configurator->createContainer();