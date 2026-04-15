<?php declare(strict_types=1);

function firstNode(DOMXPath $xpath, string $query, ?DOMNode $context = null): ?DOMNode
{
    $list = $xpath->query($query, $context);
    return $list !== false && $list->length > 0 ? $list->item(0) : null;
}

function nodeText(?DOMNode $node): string
{
    $text = $node?->textContent ?? '';
    return trim((string) preg_replace('/\s+/u', ' ', $text));
}

function innerHtml(DOMNode $node): string
{
    $html = '';
    foreach ($node->childNodes as $child) {
        $html .= $node->ownerDocument->saveHTML($child);
    }
    return trim($html);
}

function parseDateTimeFromEventLine(string $line): string
{
    if (!preg_match('/^\s*(\d{1,2})\.(\d{1,2})\.(\d{4})/u', $line, $m)) {
        return (new DateTimeImmutable())->format('Y-m-d H:i:s');
    }

    $day = str_pad($m[1], 2, '0', STR_PAD_LEFT);
    $month = str_pad($m[2], 2, '0', STR_PAD_LEFT);
    $year = $m[3];

    $hour = '19';
    $minute = '00';
    if (preg_match('/v\s*(\d{1,2})(?::(\d{2}))?\s*h/iu', $line, $tm)) {
        $hour = str_pad($tm[1], 2, '0', STR_PAD_LEFT);
        $minute = isset($tm[2]) ? str_pad($tm[2], 2, '0', STR_PAD_LEFT) : '00';
    }

    return "{$year}-{$month}-{$day} {$hour}:{$minute}:00";
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

function loadDocument(string $source): DOMDocument
{
    $html = @file_get_contents($source);
    if ($html === false) {
        throw new RuntimeException("Cannot read {$source}");
    }

    libxml_use_internal_errors(true);
    $dom = new DOMDocument();
    $dom->loadHTML('<?xml encoding="UTF-8">' . $html);
    libxml_clear_errors();

    return $dom;
}

function importLanguage(PDO $pdo, string $lang, string $source): void
{
    $dom = loadDocument($source);
    $xpath = new DOMXPath($dom);

    $upsertSnippet = $pdo->prepare(
        'INSERT INTO text_snippets (code, lang, content, created)
         VALUES (:code, :lang, :content, NOW())
         ON DUPLICATE KEY UPDATE content = VALUES(content)'
    );

    $deleteNews = $pdo->prepare('DELETE FROM news WHERE lang = :lang');
    $insertNews = $pdo->prepare(
        'INSERT INTO news (title, publish_date, articles_id, lang, active, created)
         VALUES (:title, :publish_date, NULL, :lang, 1, NOW())'
    );

    $about = firstNode($xpath, '//*[@id="about"]');
    $aboutBody = firstNode($xpath, './/*[contains(@class, "about-text")]', $about);
    $upsertSnippet->execute([
        'code' => 'about',
        'lang' => $lang,
        'content' => $aboutBody ? innerHtml($aboutBody) : '',
    ]);

    $upsertSnippet->execute([
        'code' => 'performances',
        'lang' => $lang,
        'content' => '',
    ]);

    $performance = firstNode($xpath, '//*[@id="performance"]');
    $columns = $xpath->query('.//div[contains(@class, "item-content")]', $performance);
    $deleteNews->execute(['lang' => $lang]);
    if ($columns !== false) {
        foreach ($columns as $column) {
            $items = $xpath->query('.//p', $column);
            if ($items === false) {
                continue;
            }
            foreach ($items as $p) {
                $line = nodeText($p);
                if ($line === '') {
                    continue;
                }
                $insertNews->execute([
                    'title' => $line,
                    'publish_date' => parseDateTimeFromEventLine($line),
                    'lang' => $lang,
                ]);
            }
        }
    }

    $artists = $xpath->query('(//section[contains(@class, "box-1")])[1]//div[contains(@class, "col-1-2")]');
    if ($artists !== false && $artists->length >= 2) {
        $katerinaPs = $xpath->query('.//p', $artists->item(0));
        $irenaPs = $xpath->query('.//p', $artists->item(1));

        $katerinaHtml = '';
        if ($katerinaPs !== false) {
            foreach ($katerinaPs as $p) {
                $katerinaHtml .= $dom->saveHTML($p);
            }
        }

        $irenaHtml = '';
        if ($irenaPs !== false) {
            foreach ($irenaPs as $p) {
                $irenaHtml .= $dom->saveHTML($p);
            }
        }

        $upsertSnippet->execute([
            'code' => 'artist_katerina',
            'lang' => $lang,
            'content' => trim($katerinaHtml),
        ]);
        $upsertSnippet->execute([
            'code' => 'artist_irena',
            'lang' => $lang,
            'content' => trim($irenaHtml),
        ]);
    }

    $program = firstNode($xpath, '//*[@id="program"]');
    $programContent = firstNode($xpath, './/div[contains(@class, "item-content")]', $program);
    $upsertSnippet->execute([
        'code' => 'program',
        'lang' => $lang,
        'content' => $programContent ? innerHtml($programContent) : '',
    ]);

    $contacts = firstNode($xpath, '//*[@id="contacts"]');
    $contactsBody = firstNode($xpath, './/div[contains(@class, "row")][2]', $contacts);
    $upsertSnippet->execute([
        'code' => 'contacts',
        'lang' => $lang,
        'content' => $contactsBody ? innerHtml($contactsBody) : '',
    ]);

    $copyrightNodes = $xpath->query('//footer//div[contains(@class, "row")]//span');
    $copyrightParts = [];
    if ($copyrightNodes !== false) {
        foreach ($copyrightNodes as $node) {
            $part = nodeText($node);
            if ($part !== '') {
                $copyrightParts[] = $part;
            }
        }
    }
    $upsertSnippet->execute([
        'code' => 'copyright',
        'lang' => $lang,
        'content' => implode('<br>', $copyrightParts),
    ]);
}

function importMediaFromCzech(PDO $pdo, string $source): void
{
    $dom = loadDocument($source);
    $xpath = new DOMXPath($dom);

    $adminId = (int) $pdo->query("SELECT id FROM users WHERE username = 'admin' LIMIT 1")->fetchColumn();
    if ($adminId <= 0) {
        $adminId = (int) $pdo->query("SELECT id FROM users ORDER BY id ASC LIMIT 1")->fetchColumn();
    }
    if ($adminId <= 0) {
        throw new RuntimeException('Cannot import media: no user in `users` table.');
    }

    $pdo->exec('DELETE FROM images');
    $pdo->exec('DELETE FROM videos');

    $insertImage = $pdo->prepare(
        'INSERT INTO images (users_id, file, title, subtitle, crop, created)
         VALUES (:users_id, :file, :title, :subtitle, 0, NOW())'
    );
    $insertVideo = $pdo->prepare(
        'INSERT INTO videos (users_id, title, file, embed, ratio, created)
         VALUES (:users_id, :title, :file, :embed, :ratio, NOW())'
    );

    $photoImgs = $xpath->query('//*[@id="fotogallery"]//img[@src]');
    $seenPhotoSrc = [];
    if ($photoImgs !== false) {
        foreach ($photoImgs as $img) {
            if (!$img instanceof DOMElement) {
                continue;
            }
            $src = trim((string) $img->getAttribute('src'));
            if ($src === '' || isset($seenPhotoSrc[$src])) {
                continue;
            }
            $seenPhotoSrc[$src] = true;

            $insertImage->execute([
                'users_id' => $adminId,
                'file' => $src,
                'title' => '',
                'subtitle' => '',
            ]);
        }
    }

    $videoItems = $xpath->query(
        '//*[@id="videogallery"]//div[contains(concat(" ", normalize-space(@class), " "), " wrap-col ")
            and contains(concat(" ", normalize-space(@class), " "), " item ")]'
    );
    $seenVideoUrls = [];
    if ($videoItems !== false) {
        foreach ($videoItems as $item) {
            $title = nodeText(firstNode($xpath, './/span', $item));
            $subtitle = nodeText(firstNode($xpath, './/p', $item));
            $link = firstNode($xpath, './/a[@href]', $item);
            $url = $link instanceof DOMElement ? trim((string) $link->getAttribute('href')) : '';
            $img = firstNode($xpath, './/img', $item);
            $thumb = $img instanceof DOMElement ? trim((string) $img->getAttribute('src')) : '';

            if ($url === '') {
                continue;
            }
            if (isset($seenVideoUrls[$url])) {
                continue;
            }
            $seenVideoUrls[$url] = true;

            $insertVideo->execute([
                'users_id' => $adminId,
                'title' => $title !== '' ? $title : $subtitle,
                'file' => $url,
                'embed' => $url,
                'ratio' => $thumb !== '' ? $thumb : '16:9',
            ]);
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
]);

$csSource = 'https://fourhands.cz/';
$enSource = 'https://fourhands.cz/index-en.html';

importLanguage($pdo, 'cs', $csSource);
importLanguage($pdo, 'en', $enSource);
importMediaFromCzech($pdo, $csSource);

echo "Static content imported into borovice schema (cs/en + media)." . PHP_EOL;
