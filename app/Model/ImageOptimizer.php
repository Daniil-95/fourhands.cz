<?php declare(strict_types=1);

namespace App\Model;

final class ImageOptimizer
{
    public static function getDerivativePath(string $sourcePath, int $maxWidth): string
    {
        $normalized = trim($sourcePath);
        if ($normalized === '' || $maxWidth <= 0) {
            return $normalized;
        }

        $root = dirname(__DIR__, 2) . '/www/';
        $source = $root . ltrim($normalized, '/');
        $target = dirname($source) . '/optimized/' . pathinfo($source, PATHINFO_FILENAME) . '--w' . $maxWidth . '.jpg';

        return is_file($target) ? self::toWebPath($target) : $normalized;
    }

    public static function createDerivative(string $sourcePath, int $maxWidth, int $quality = 72): string
    {
        $normalized = trim($sourcePath);
        if ($normalized === '' || $maxWidth <= 0) {
            return $normalized;
        }

        $root = dirname(__DIR__, 2) . '/www/';
        $source = $root . ltrim($normalized, '/');

        if (!is_file($source) || !self::isSupportedImage($source)) {
            return $normalized;
        }

        $dimensions = @getimagesize($source);
        if ($dimensions === false || $dimensions[0] <= 0 || $dimensions[1] <= 0) {
            return $normalized;
        }

        $cacheDir = dirname($source) . '/optimized';
        if (!is_dir($cacheDir) && !mkdir($cacheDir, 0777, true) && !is_dir($cacheDir)) {
            return $normalized;
        }

        $fileName = pathinfo($source, PATHINFO_FILENAME) . '--w' . $maxWidth . '.jpg';
        $target = $cacheDir . '/' . $fileName;

        if (is_file($target)) {
            return self::toWebPath($target);
        }

        $sourceImage = self::createImageFromFile($source, $dimensions[2]);
        if ($sourceImage === false) {
            return $normalized;
        }

        $newWidth = min($maxWidth, $dimensions[0]);
        $newHeight = (int) round($dimensions[1] * ($newWidth / $dimensions[0]));

        $resized = imagecreatetruecolor($newWidth, $newHeight);
        if ($resized === false) {
            imagedestroy($sourceImage);
            return $normalized;
        }

        imagealphablending($resized, false);
        imagesavealpha($resized, true);

        $transparent = imagecolorallocatealpha($resized, 255, 255, 255, 127);
        imagefilledrectangle($resized, 0, 0, $newWidth, $newHeight, $transparent);
        imagecopyresampled($resized, $sourceImage, 0, 0, 0, 0, $newWidth, $newHeight, $dimensions[0], $dimensions[1]);

        $saved = imagejpeg($resized, $target, $quality);

        imagedestroy($sourceImage);
        imagedestroy($resized);

        if (!$saved) {
            return $normalized;
        }

        return self::toWebPath($target);
    }

    private static function isSupportedImage(string $path): bool
    {
        if (!function_exists('mime_content_type')) {
            return false;
        }

        $mime = @mime_content_type($path);
        if ($mime === false) {
            return false;
        }

        return in_array($mime, ['image/jpeg', 'image/png', 'image/webp', 'image/gif'], true);
    }

    private static function createImageFromFile(string $sourcePath, int $imageType): \GdImage|false
    {
        return match ($imageType) {
            IMAGETYPE_JPEG => imagecreatefromjpeg($sourcePath),
            IMAGETYPE_PNG => imagecreatefrompng($sourcePath),
            IMAGETYPE_WEBP => imagecreatefromwebp($sourcePath),
            IMAGETYPE_GIF => imagecreatefromgif($sourcePath),
            default => false,
        };
    }

    private static function toWebPath(string $absolutePath): string
    {
        $relative = str_replace(dirname(__DIR__, 2) . '/www/', '', $absolutePath);
        return str_replace('\\', '/', $relative);
    }
}