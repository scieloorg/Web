<?php
declare(strict_types=1);

header('Content-Type: application/json; charset=utf-8');
header('Cache-Control: public, max-age=300');

$lang = isset($_GET['lang']) ? (string)$_GET['lang'] : 'pt';
$limit = isset($_GET['limit']) ? (int)$_GET['limit'] : 8;

if (!in_array($lang, array('pt', 'en', 'es'), true)) {
    $lang = 'pt';
}
if ($limit < 1) {
    $limit = 1;
}
if ($limit > 12) {
    $limit = 12;
}

$baseByLang = array(
    'pt' => 'https://pressreleases.scielo.org/wp-json/wp/v2/posts',
    'en' => 'https://pressreleases.scielo.org/en/wp-json/wp/v2/posts',
    'es' => 'https://pressreleases.scielo.org/es/wp-json/wp/v2/posts',
);

$url = $baseByLang[$lang] . '?per_page=' . $limit . '&_embed';
$context = stream_context_create(array(
    'http' => array(
        'method' => 'GET',
        'timeout' => 8,
        'header' => "User-Agent: SciELO-Web/1.0\r\nAccept: application/json\r\n",
    ),
));

$raw = @file_get_contents($url, false, $context);
if ($raw === false) {
    http_response_code(502);
    echo json_encode(array('lang' => $lang, 'posts' => array(), 'error' => 'fetch_failed'));
    exit;
}

$decoded = json_decode($raw, true);
if (!is_array($decoded)) {
    http_response_code(502);
    echo json_encode(array('lang' => $lang, 'posts' => array(), 'error' => 'invalid_json'));
    exit;
}

$posts = array();
foreach ($decoded as $item) {
    if (!is_array($item)) {
        continue;
    }

    $title = '';
    if (isset($item['title']) && is_array($item['title']) && isset($item['title']['rendered'])) {
        $title = trim(strip_tags((string) $item['title']['rendered']));
    }

    $link = isset($item['link']) ? (string) $item['link'] : '';
    $date = isset($item['date']) ? (string) $item['date'] : '';
    $image = '';

    if (isset($item['_embedded']['wp:featuredmedia'][0]) && is_array($item['_embedded']['wp:featuredmedia'][0])) {
        $media = $item['_embedded']['wp:featuredmedia'][0];
        if (isset($media['media_details']['sizes']) && is_array($media['media_details']['sizes'])) {
            $sizes = $media['media_details']['sizes'];
            if (isset($sizes['medium_large']['source_url'])) {
                $image = (string) $sizes['medium_large']['source_url'];
            } elseif (isset($sizes['medium']['source_url'])) {
                $image = (string) $sizes['medium']['source_url'];
            } elseif (isset($sizes['thumbnail']['source_url'])) {
                $image = (string) $sizes['thumbnail']['source_url'];
            }
        }
        if ($image === '' && isset($media['source_url'])) {
            $image = (string) $media['source_url'];
        }
    }

    if ($title === '' || $link === '') {
        continue;
    }

    $posts[] = array(
        'title' => $title,
        'link' => $link,
        'date' => $date,
        'image' => $image,
    );
}

echo json_encode(
    array(
        'lang' => $lang,
        'posts' => $posts,
    ),
    JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES
);

