<?php declare(strict_types=1);

use Nette\Bootstrap\Configurator;

require __DIR__ . '/vendor/autoload.php';

$configurator = new Configurator();

$configurator->setTempDirectory(__DIR__ . '/temp');

/**
 * Debug mode
 * Host header is client-controlled, therefore everything except an explicit
 * development host is treated as production.
 */
$host = strtolower(explode(':', (string) ($_SERVER['HTTP_HOST'] ?? ''), 2)[0]);
$devHosts = ['fourhands.local', 'localhost', '127.0.0.1', '::1'];
$isProduction = PHP_SAPI !== 'cli' && !in_array($host, $devHosts, true);
$configurator->setDebugMode(!$isProduction);
$configurator->enableTracy(__DIR__ . '/log');

/**
 * Environment variables available in config as %env.NAME%
 */
$configurator->addDynamicParameters(['env' => getenv()]);

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
$configurator->addConfig(__DIR__ . ($isProduction ? '/app/config/www.neon' : '/app/config/local.neon'));

/**
 * Secrets kept outside the repository (created manually on the server)
 */
if (is_file(__DIR__ . '/app/config/secret.neon')) {
    $configurator->addConfig(__DIR__ . '/app/config/secret.neon');
}

return $configurator->createContainer();