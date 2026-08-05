<?php declare(strict_types=1);

use Nette\Bootstrap\Configurator;

require __DIR__ . '/vendor/autoload.php';

$configurator = new Configurator();

$configurator->setTempDirectory(__DIR__ . '/temp');

$configurator->enableTracy(__DIR__ . '/log');

/**
 * Debug mode
 */
$configurator->setDebugMode(!isset($_SERVER['HTTP_HOST']) || $_SERVER['HTTP_HOST'] !== 'fourhands.cz');

/**
 * RobotLoader
 */
$configurator->createRobotLoader()
    ->addDirectory(__DIR__ . '/app')
    ->register();

/**
 * Common configuration
 */
$configurator->addConfig(__DIR__ . '/app/config/common.neon');

/**
 * Environment configuration
 */
if (
    isset($_SERVER['HTTP_HOST'])
    && in_array($_SERVER['HTTP_HOST'], ['fourhands.cz', 'www.fourhands.cz'], true)
) {
    $configurator->addConfig(__DIR__ . '/app/config/www.neon');
} else {
    $configurator->addConfig(__DIR__ . '/app/config/local.neon');
}

return $configurator->createContainer();