<?php
declare(strict_types=1);

function search_mvp_db_path(): string
{
    return __DIR__ . '/tmpSQL/search_mvp.sqlite';
}

function search_mvp_connect(): PDO
{
    static $pdo = null;
    if ($pdo instanceof PDO) {
        return $pdo;
    }

    $dbPath = search_mvp_db_path();
    $dir = dirname($dbPath);
    if (!is_dir($dir)) {
        mkdir($dir, 0775, true);
    }

    $pdo = new PDO('sqlite:' . $dbPath);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);

    $pdo->exec(
        "CREATE TABLE IF NOT EXISTS search_documents (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            pid TEXT NOT NULL UNIQUE,
            title TEXT NOT NULL DEFAULT '',
            abstract_text TEXT NOT NULL DEFAULT '',
            authors TEXT NOT NULL DEFAULT '',
            journal_title TEXT NOT NULL DEFAULT '',
            journal_issn TEXT NOT NULL DEFAULT '',
            pub_year INTEGER,
            lang TEXT NOT NULL DEFAULT 'en',
            article_url TEXT NOT NULL DEFAULT '',
            abstract_url TEXT NOT NULL DEFAULT '',
            source_issue_pid TEXT NOT NULL DEFAULT '',
            indexed_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
        )"
    );

    return $pdo;
}

function search_mvp_str(?string $value): string
{
    $value = (string)$value;
    $value = html_entity_decode($value, ENT_QUOTES | ENT_HTML5, 'UTF-8');
    $value = preg_replace('/\s+/u', ' ', trim($value)) ?? '';
    return $value;
}

function search_mvp_http_get(string $url): string
{
    $ctx = stream_context_create([
        'http' => [
            'method' => 'GET',
            'timeout' => 20,
            'ignore_errors' => true,
            'header' => "User-Agent: SciELO-MVP-Indexer/1.0\r\n",
        ],
    ]);
    $content = @file_get_contents($url, false, $ctx);
    return $content === false ? '' : $content;
}

function search_mvp_load_xml(string $xmlRaw): ?SimpleXMLElement
{
    if ($xmlRaw === '' || strpos($xmlRaw, '<ERROR></ERROR>') !== false) {
        return null;
    }
    libxml_use_internal_errors(true);
    $xml = simplexml_load_string($xmlRaw);
    if ($xml === false) {
        return null;
    }
    return $xml;
}

function search_mvp_extract_text(SimpleXMLElement $xml, string $xpath): string
{
    $nodes = $xml->xpath($xpath);
    if (!$nodes) {
        return '';
    }
    $parts = [];
    foreach ($nodes as $node) {
        $parts[] = search_mvp_str((string)$node);
    }
    return search_mvp_str(implode(' ', $parts));
}

function search_mvp_insert_or_update(PDO $pdo, array $doc): void
{
    $sql = "INSERT INTO search_documents
            (pid, title, abstract_text, authors, journal_title, journal_issn, pub_year, lang, article_url, abstract_url, source_issue_pid, indexed_at)
            VALUES
            (:pid, :title, :abstract_text, :authors, :journal_title, :journal_issn, :pub_year, :lang, :article_url, :abstract_url, :source_issue_pid, datetime('now'))
            ON CONFLICT(pid) DO UPDATE SET
                title=excluded.title,
                abstract_text=excluded.abstract_text,
                authors=excluded.authors,
                journal_title=excluded.journal_title,
                journal_issn=excluded.journal_issn,
                pub_year=excluded.pub_year,
                lang=excluded.lang,
                article_url=excluded.article_url,
                abstract_url=excluded.abstract_url,
                source_issue_pid=excluded.source_issue_pid,
                indexed_at=datetime('now')";

    $stmt = $pdo->prepare($sql);
    $stmt->execute([
        ':pid' => $doc['pid'] ?? '',
        ':title' => $doc['title'] ?? '',
        ':abstract_text' => $doc['abstract_text'] ?? '',
        ':authors' => $doc['authors'] ?? '',
        ':journal_title' => $doc['journal_title'] ?? '',
        ':journal_issn' => $doc['journal_issn'] ?? '',
        ':pub_year' => $doc['pub_year'] ?? null,
        ':lang' => $doc['lang'] ?? 'en',
        ':article_url' => $doc['article_url'] ?? '',
        ':abstract_url' => $doc['abstract_url'] ?? '',
        ':source_issue_pid' => $doc['source_issue_pid'] ?? '',
    ]);
}

function search_mvp_search(array $params): array
{
    $pdo = search_mvp_connect();

    $q = search_mvp_str($params['q'] ?? '');
    $field = search_mvp_str($params['field'] ?? 'all');
    $year = search_mvp_str($params['year'] ?? '');
    $author = search_mvp_str($params['author'] ?? '');
    $journal = search_mvp_str($params['journal'] ?? '');
    $page = max(1, (int)($params['page'] ?? 1));
    $perPage = min(100, max(1, (int)($params['per_page'] ?? 20)));
    $offset = ($page - 1) * $perPage;

    $where = [];
    $bind = [];

    if ($q !== '') {
        $bind[':q'] = '%' . $q . '%';
        switch ($field) {
            case 'title':
                $where[] = 'title LIKE :q';
                break;
            case 'abstract':
                $where[] = 'abstract_text LIKE :q';
                break;
            case 'author':
                $where[] = 'authors LIKE :q';
                break;
            case 'journal':
                $where[] = 'journal_title LIKE :q';
                break;
            default:
                $where[] = '(title LIKE :q OR abstract_text LIKE :q OR authors LIKE :q OR journal_title LIKE :q)';
                break;
        }
    }

    if ($year !== '' && ctype_digit($year)) {
        $where[] = 'pub_year = :year';
        $bind[':year'] = (int)$year;
    }

    if ($author !== '') {
        $where[] = 'authors LIKE :author';
        $bind[':author'] = '%' . $author . '%';
    }

    if ($journal !== '') {
        $where[] = '(journal_title LIKE :journal OR journal_issn LIKE :journal)';
        $bind[':journal'] = '%' . $journal . '%';
    }

    $whereSql = $where ? ('WHERE ' . implode(' AND ', $where)) : '';

    $countSql = "SELECT COUNT(*) FROM search_documents {$whereSql}";
    $countStmt = $pdo->prepare($countSql);
    $countStmt->execute($bind);
    $total = (int)$countStmt->fetchColumn();

    $listSql = "SELECT pid, title, abstract_text, authors, journal_title, journal_issn, pub_year, lang, article_url, abstract_url, source_issue_pid, indexed_at
                FROM search_documents
                {$whereSql}
                ORDER BY pub_year DESC, journal_title ASC, title ASC
                LIMIT :limit OFFSET :offset";
    $listStmt = $pdo->prepare($listSql);
    foreach ($bind as $key => $value) {
        $listStmt->bindValue($key, $value);
    }
    $listStmt->bindValue(':limit', $perPage, PDO::PARAM_INT);
    $listStmt->bindValue(':offset', $offset, PDO::PARAM_INT);
    $listStmt->execute();
    $rows = $listStmt->fetchAll();

    return [
        'total' => $total,
        'page' => $page,
        'per_page' => $perPage,
        'pages' => max(1, (int)ceil($total / $perPage)),
        'items' => $rows ?: [],
    ];
}
