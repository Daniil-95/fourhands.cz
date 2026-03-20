<?php declare(strict_types=1);

function innerHtml(DOMNode $node): string
{
    $html = '';
    foreach ($node->childNodes as $child) {
        $html .= $node->ownerDocument->saveHTML($child);
    }
    return trim($html);
}

function firstNode(DOMXPath $xpath, string $query, ?DOMNode $context = null): ?DOMNode
{
    $list = $xpath->query($query, $context);
    return $list !== false && $list->length > 0 ? $list->item(0) : null;
}

function nodeText(?DOMNode $node): string
{
    return trim(preg_replace('/\s+/', ' ', $node?->textContent ?? ''));
}

function parseLocalNeon(string $path): array
{
    $data = ['dsn' => '', 'user' => '', 'password' => ''];
    foreach (file($path, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES) as $line) {
        $line = trim($line);
        if (str_starts_with($line, 'dsn:')) {
            $data['dsn'] = trim((string) preg_replace('/^dsn:\s*/', '', $line), "'\"");
        }
        if (str_starts_with($line, 'user:')) {
            $data['user'] = trim((string) preg_replace('/^user:\s*/', '', $line), "'\"");
        }
        if (str_starts_with($line, 'password:')) {
            $data['password'] = trim((string) preg_replace('/^password:\s*/', '', $line), "'\"");
        }
    }

    return $data;
}

function importLanguage(PDO $pdo, string $projectRoot, string $lang, string $fileName): void
{
    $html = file_get_contents($projectRoot . DIRECTORY_SEPARATOR . $fileName);
    if ($html === false) {
        throw new RuntimeException("Cannot read {$fileName}");
    }

    libxml_use_internal_errors(true);
    $dom = new DOMDocument();
    $dom->loadHTML(mb_convert_encoding($html, 'HTML-ENTITIES', 'UTF-8'));
    libxml_clear_errors();

    $xpath = new DOMXPath($dom);

    $upsertContent = $pdo->prepare(
        'INSERT INTO content_blocks (`lang`, key_name, title, content_html, sort_order)
         VALUES (:lang, :key_name, :title, :content_html, :sort_order)
         ON DUPLICATE KEY UPDATE title = VALUES(title), content_html = VALUES(content_html), sort_order = VALUES(sort_order)'
    );

    $insertEvent = $pdo->prepare(
        'INSERT INTO events (`lang`, type, event_date, description, sort_order)
         VALUES (:lang, :type, :event_date, :description, :sort_order)'
    );

    $insertMedia = $pdo->prepare(
        'INSERT INTO media_items (`lang`, type, title, description, image_path, url, sort_order)
         VALUES (:lang, :type, :title, :description, :image_path, :url, :sort_order)'
    );

    $about = firstNode($xpath, '//*[@id="about"]');
    $aboutTitle = nodeText(firstNode($xpath, './/h3', $about));
    $aboutBody = innerHtml(firstNode($xpath, './/*[contains(@class, "about-text")]', $about) ?? $about);
    $upsertContent->execute([
        'lang' => $lang,
        'key_name' => 'about',
        'title' => $aboutTitle !== '' ? $aboutTitle : ($lang === 'cs' ? 'O nás' : 'About us'),
        'content_html' => $aboutBody,
        'sort_order' => 10,
    ]);

    $performance = firstNode($xpath, '//*[@id="performance"]');
    $performanceTitle = nodeText(firstNode($xpath, './/h2', $performance));
    $upsertContent->execute([
        'lang' => $lang,
        'key_name' => 'performances',
        'title' => $performanceTitle,
        'content_html' => '',
        'sort_order' => 20,
    ]);

    $pdo->prepare('DELETE FROM events WHERE `lang` = :lang')->execute(['lang' => $lang]);
    $eventColumns = $xpath->query('.//div[contains(@class, "item-content")]', $performance);
    if ($eventColumns !== false && $eventColumns->length >= 2) {
        $upcomingItems = $xpath->query('.//p', $eventColumns->item(0));
        if ($upcomingItems !== false) {
            $i = 10;
            foreach ($upcomingItems as $p) {
                $text = nodeText($p);
                if ($text === '') {
                    continue;
                }

                $insertEvent->execute([
                    'lang' => $lang,
                    'type' => 'upcoming',
                    'event_date' => null,
                    'description' => $text,
                    'sort_order' => $i,
                ]);
                $i += 10;
            }
        }

        $pastItems = $xpath->query('.//p', $eventColumns->item(1));
        if ($pastItems !== false) {
            $i = 10;
            foreach ($pastItems as $p) {
                $text = nodeText($p);
                if ($text === '') {
                    continue;
                }

                $insertEvent->execute([
                    'lang' => $lang,
                    'type' => 'past',
                    'event_date' => null,
                    'description' => $text,
                    'sort_order' => $i,
                ]);
                $i += 10;
            }
        }
    }

    $artistSection = firstNode($xpath, '(//section[contains(@class, "box-1")])[1]');
    $artists = $xpath->query('.//div[contains(@class, "col-1-2")]', $artistSection);
    if ($artists !== false && $artists->length >= 2) {
        $kNode = $artists->item(0);
        $iNode = $artists->item(1);

        $upsertContent->execute([
            'lang' => $lang,
            'key_name' => 'artist_katerina',
            'title' => nodeText(firstNode($xpath, './/h1', $kNode)),
            'content_html' => innerHtml($kNode),
            'sort_order' => 30,
        ]);

        $upsertContent->execute([
            'lang' => $lang,
            'key_name' => 'artist_irena',
            'title' => nodeText(firstNode($xpath, './/h1', $iNode)),
            'content_html' => innerHtml($iNode),
            'sort_order' => 40,
        ]);
    }

    $program = firstNode($xpath, '//*[@id="program"]');
    $upsertContent->execute([
        'lang' => $lang,
        'key_name' => 'program',
        'title' => nodeText(firstNode($xpath, './/h2', $program)),
        'content_html' => innerHtml(firstNode($xpath, './/div[contains(@class, "row")][2]', $program) ?? $program),
        'sort_order' => 50,
    ]);

    $contacts = firstNode($xpath, '//*[@id="contacts"]');
    $upsertContent->execute([
        'lang' => $lang,
        'key_name' => 'contacts',
        'title' => nodeText(firstNode($xpath, './/h2', $contacts)),
        'content_html' => innerHtml(firstNode($xpath, './/div[contains(@class, "row")][2]', $contacts) ?? $contacts),
        'sort_order' => 60,
    ]);

    $copyrightText = nodeText(firstNode($xpath, '//footer//div[contains(@class, "row")][1]//span'));
    $upsertContent->execute([
        'lang' => $lang,
        'key_name' => 'copyright',
        'title' => 'Copyright',
        'content_html' => $copyrightText,
        'sort_order' => 99,
    ]);

    $pdo->prepare('DELETE FROM media_items WHERE `lang` = :lang')->execute(['lang' => $lang]);

    $photoGallery = firstNode($xpath, '//*[@id="fotogallery"]');
    $photoItems = $xpath->query('.//div[contains(@class, "item")]', $photoGallery);
    if ($photoItems !== false) {
        $i = 10;
        foreach ($photoItems as $item) {
            $title = nodeText(firstNode($xpath, './/span', $item));
            $desc = nodeText(firstNode($xpath, './/p', $item));
            $img = firstNode($xpath, './/img', $item);
            $imgPath = $img instanceof DOMElement ? (string) $img->getAttribute('src') : null;

            if ($title === '' && !$imgPath) {
                continue;
            }

            $insertMedia->execute([
                'lang' => $lang,
                'type' => 'photo',
                'title' => $title !== '' ? $title : 'Photo',
                'description' => $desc,
                'image_path' => $imgPath,
                'url' => null,
                'sort_order' => $i,
            ]);
            $i += 10;
        }
    }

    $videoGallery = firstNode($xpath, '//*[@id="videogallery"]');
    $videoItems = $xpath->query('.//div[contains(@class, "item")]', $videoGallery);
    if ($videoItems !== false) {
        $i = 10;
        foreach ($videoItems as $item) {
            $title = nodeText(firstNode($xpath, './/span', $item));
            $desc = nodeText(firstNode($xpath, './/p', $item));
            $img = firstNode($xpath, './/img', $item);
            $imgPath = $img instanceof DOMElement ? (string) $img->getAttribute('src') : null;
            $a = firstNode($xpath, './/a[@href]', $item);
            $url = $a instanceof DOMElement ? (string) $a->getAttribute('href') : null;

            if ($title === '' && !$url) {
                continue;
            }

            $insertMedia->execute([
                'lang' => $lang,
                'type' => 'video',
                'title' => $title !== '' ? $title : 'Video',
                'description' => $desc,
                'image_path' => $imgPath,
                'url' => $url,
                'sort_order' => $i,
            ]);
            $i += 10;
        }
    }
}

$root = dirname(__DIR__);
$config = parseLocalNeon($root . '/app/config/local.neon');
if ($config['dsn'] === '') {
    throw new RuntimeException('DSN was not found in app/config/local.neon');
}

$pdo = new PDO($config['dsn'], $config['user'], $config['password'], [
    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
]);

importLanguage($pdo, $root, 'cs', 'index.html');
importLanguage($pdo, $root, 'en', 'index-en.html');

echo "Static content imported for cs/en." . PHP_EOL;
