<?php declare(strict_types=1);

namespace App\Common;

use Nette\Localization\Translator as NetteTranslator;

class Translator implements NetteTranslator
{
    private array $translations = [];

    public function __construct(string $locale)
    {
        $file = __DIR__ . '/../translations/front_' . $locale . '.csv';
        if (!is_file($file)) {
            return;
        }

        $fh = fopen($file, 'r');
        if ($fh === false) {
            return;
        }

        while (($row = fgetcsv($fh, 0, ';')) !== false) {
            if (isset($row[0], $row[1]) && $row[0] !== '') {
                $this->translations[$row[0]] = $row[1];
            }
        }

        fclose($fh);
    }

    public function translate(string|\Stringable $message, mixed ...$parameters): string|\Stringable
    {
        $key = (string) $message;
        return $this->translations[$key] ?? $key;
    }
}
