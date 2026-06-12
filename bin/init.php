<?php declare(strict_types=1);

$tempDir = __DIR__ . '/../temp';
$logDir = __DIR__ . '/../log';

if (!is_dir($tempDir)) {
    mkdir($tempDir, 0777, true);
}

if (!is_dir($logDir)) {
    mkdir($logDir, 0777, true);
}
