<?php
declare(strict_types=1);

require_once __DIR__ . '/search_mvp_lib.php';

header('Content-Type: application/json; charset=utf-8');

try {
    $result = search_mvp_search([
        'q' => $_GET['q'] ?? '',
        'field' => $_GET['field'] ?? 'all',
        'year' => $_GET['year'] ?? '',
        'author' => $_GET['author'] ?? '',
        'journal' => $_GET['journal'] ?? '',
        'page' => $_GET['page'] ?? 1,
        'per_page' => $_GET['per_page'] ?? 20,
    ]);

    echo json_encode([
        'ok' => true,
        'query' => [
            'q' => (string)($_GET['q'] ?? ''),
            'field' => (string)($_GET['field'] ?? 'all'),
            'year' => (string)($_GET['year'] ?? ''),
            'author' => (string)($_GET['author'] ?? ''),
            'journal' => (string)($_GET['journal'] ?? ''),
            'page' => (int)($_GET['page'] ?? 1),
            'per_page' => (int)($_GET['per_page'] ?? 20),
        ],
        'result' => $result,
    ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
} catch (Throwable $e) {
    http_response_code(500);
    echo json_encode([
        'ok' => false,
        'error' => $e->getMessage(),
    ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
}

