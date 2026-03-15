<?php
declare(strict_types=1);

require_once __DIR__ . '/search_mvp_lib.php';

$lang = (string)($_GET['lang'] ?? 'pt');
if (!in_array($lang, ['pt', 'es', 'en'], true)) {
    $lang = 'pt';
}

$labels = [
    'pt' => [
        'title' => 'Busca por Índice (MVP)',
        'subtitle' => 'Filtro por título, resumo, autor, periódico e ano',
        'back' => 'Voltar para a Home',
        'search' => 'Buscar',
        'term' => 'Digite termo de busca',
        'all_fields' => 'Todos os campos',
        'title_field' => 'Título',
        'abstract_field' => 'Resumo',
        'author_field' => 'Autor',
        'journal_field' => 'Periódico',
        'year' => 'Ano',
        'author_filter' => 'Filtro autor',
        'journal_filter' => 'Filtro periódico/ISSN',
        'total' => 'Total',
        'page' => 'Página',
        'of' => 'de',
        'pid' => 'PID',
        'journal' => 'Periódico',
        'authors' => 'Autores',
        'prev' => '← Anterior',
        'next' => 'Próxima →',
        'no_results' => 'Nenhum resultado encontrado para os filtros informados.',
    ],
    'es' => [
        'title' => 'Búsqueda por Índice (MVP)',
        'subtitle' => 'Filtro por título, resumen, autor, revista y año',
        'back' => 'Volver al inicio',
        'search' => 'Buscar',
        'term' => 'Ingrese término de búsqueda',
        'all_fields' => 'Todos los campos',
        'title_field' => 'Título',
        'abstract_field' => 'Resumen',
        'author_field' => 'Autor',
        'journal_field' => 'Revista',
        'year' => 'Año',
        'author_filter' => 'Filtro autor',
        'journal_filter' => 'Filtro revista/ISSN',
        'total' => 'Total',
        'page' => 'Página',
        'of' => 'de',
        'pid' => 'PID',
        'journal' => 'Revista',
        'authors' => 'Autores',
        'prev' => '← Anterior',
        'next' => 'Siguiente →',
        'no_results' => 'No se encontraron resultados para los filtros informados.',
    ],
    'en' => [
        'title' => 'Indexed Search (MVP)',
        'subtitle' => 'Filter by title, abstract, author, journal and year',
        'back' => 'Back to Home',
        'search' => 'Search',
        'term' => 'Enter search term',
        'all_fields' => 'All fields',
        'title_field' => 'Title',
        'abstract_field' => 'Abstract',
        'author_field' => 'Author',
        'journal_field' => 'Journal',
        'year' => 'Year',
        'author_filter' => 'Author filter',
        'journal_filter' => 'Journal/ISSN filter',
        'total' => 'Total',
        'page' => 'Page',
        'of' => 'of',
        'pid' => 'PID',
        'journal' => 'Journal',
        'authors' => 'Authors',
        'prev' => '← Previous',
        'next' => 'Next →',
        'no_results' => 'No results found for the selected filters.',
    ],
];
$t = $labels[$lang];

$query = [
    'q' => (string)($_GET['q'] ?? ''),
    'field' => (string)($_GET['field'] ?? 'all'),
    'year' => (string)($_GET['year'] ?? ''),
    'author' => (string)($_GET['author'] ?? ''),
    'journal' => (string)($_GET['journal'] ?? ''),
    'page' => (int)($_GET['page'] ?? 1),
    'per_page' => 20,
];

$result = search_mvp_search($query);

function esc(string $v): string
{
    return htmlspecialchars($v, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
}
?>
<!doctype html>
<html lang="<?= esc($lang) ?>">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title><?= esc($t['title']) ?></title>
  <link rel="stylesheet" type="text/css" href="/design-system/1.0.0/css/bootstrap.css">
  <link rel="stylesheet" type="text/css" href="/design-system/1.0.0/css/article.css">
  <link rel="stylesheet" type="text/css" href="/css/scielo-ds-bridge.css">
  <style>
    body { max-width: none; margin: 0; padding: 0; background: #f5f5f5; }
    .mvp-shell { max-width: 1200px; margin: 0 auto; padding: 20px 16px 36px; }
    .mvp-head { border: 1px solid #d6dde7; border-radius: 12px; background: #fff; padding: 18px 20px; margin-bottom: 14px; }
    .mvp-head-top { display: flex; align-items: center; justify-content: space-between; gap: 12px; }
    .mvp-logo { width: 108px; height: auto; }
    .mvp-back { color: #2f5ec4; font-size: 14px; font-weight: 600; }
    .mvp-title { margin: 10px 0 2px; font-size: 28px; color: #083a5a; font-weight: 700; }
    .mvp-subtitle { margin: 0; color: #5f6b7a; font-size: 15px; }
    .mvp-card { border: 1px solid #d6dde7; border-radius: 12px; background: #fff; padding: 16px; margin-bottom: 14px; }
    .mvp-form { display: grid; grid-template-columns: 2fr 1fr 1fr 1fr 1fr auto; gap: 8px; }
    .mvp-form input, .mvp-form select, .mvp-form button { height: 40px; border: 1px solid #c7c7c7; border-radius: 4px; font-size: 14px; padding: 0 10px; }
    .mvp-form button { background: #3f68c7; border-color: #3f68c7; color: #fff; font-weight: 600; }
    .mvp-meta { margin-top: 12px; color: #475569; font-size: 14px; }
    .mvp-item { border-top: 1px solid #e4e9f0; padding: 14px 0; }
    .mvp-item:first-child { border-top: 0; padding-top: 4px; }
    .mvp-item-title { margin: 0 0 6px; font-size: 20px; line-height: 1.3; }
    .mvp-item-title a { color: #1f3f88; }
    .mvp-sub { color: #3b4a5e; font-size: 13px; margin-bottom: 4px; }
    .mvp-abs { color: #1f2937; font-size: 14px; line-height: 1.5; }
    .mvp-empty { color: #475569; padding: 8px 0 4px; }
    .mvp-pager { margin-top: 10px; display: flex; gap: 14px; font-size: 14px; }
    .mvp-pager a { color: #2f5ec4; font-weight: 600; }
    @media (max-width: 992px) { .mvp-form { grid-template-columns: 1fr; } .mvp-title { font-size: 22px; } }
  </style>
</head>
<body>
  <div class="mvp-shell">
    <header class="mvp-head">
      <div class="mvp-head-top">
        <img class="mvp-logo" alt="SciELO" src="/img/revistas/scielobrp.gif">
        <a class="mvp-back" href="/scielo.php?lng=<?= esc($lang) ?>"><?= esc($t['back']) ?></a>
      </div>
      <h1 class="mvp-title"><?= esc($t['title']) ?></h1>
      <p class="mvp-subtitle"><?= esc($t['subtitle']) ?></p>
    </header>

    <section class="mvp-card">
      <form class="mvp-form" method="get" action="/search_mvp.php">
        <input type="hidden" name="lang" value="<?= esc($lang) ?>">
        <input type="text" name="q" placeholder="<?= esc($t['term']) ?>" value="<?= esc($query['q']) ?>">
        <select name="field">
          <option value="all" <?= $query['field'] === 'all' ? 'selected' : '' ?>><?= esc($t['all_fields']) ?></option>
          <option value="title" <?= $query['field'] === 'title' ? 'selected' : '' ?>><?= esc($t['title_field']) ?></option>
          <option value="abstract" <?= $query['field'] === 'abstract' ? 'selected' : '' ?>><?= esc($t['abstract_field']) ?></option>
          <option value="author" <?= $query['field'] === 'author' ? 'selected' : '' ?>><?= esc($t['author_field']) ?></option>
          <option value="journal" <?= $query['field'] === 'journal' ? 'selected' : '' ?>><?= esc($t['journal_field']) ?></option>
        </select>
        <input type="text" name="year" placeholder="<?= esc($t['year']) ?>" value="<?= esc($query['year']) ?>">
        <input type="text" name="author" placeholder="<?= esc($t['author_filter']) ?>" value="<?= esc($query['author']) ?>">
        <input type="text" name="journal" placeholder="<?= esc($t['journal_filter']) ?>" value="<?= esc($query['journal']) ?>">
        <button type="submit"><?= esc($t['search']) ?></button>
      </form>
      <div class="mvp-meta">
        <?= esc($t['total']) ?>: <strong><?= (int)$result['total'] ?></strong> |
        <?= esc($t['page']) ?> <strong><?= (int)$result['page'] ?></strong> <?= esc($t['of']) ?> <strong><?= max(1, (int)$result['pages']) ?></strong>
      </div>
    </section>

    <section class="mvp-card">
      <?php if (empty($result['items'])): ?>
        <div class="mvp-empty"><?= esc($t['no_results']) ?></div>
      <?php endif; ?>
      <?php foreach ($result['items'] as $item): ?>
        <article class="mvp-item">
          <h2 class="mvp-item-title">
            <a href="<?= esc((string)$item['article_url']) ?>" target="_blank" rel="noopener noreferrer">
              <?= esc((string)$item['title']) ?>
            </a>
          </h2>
          <div class="mvp-sub">
            <?= esc($t['pid']) ?>: <?= esc((string)$item['pid']) ?> |
            <?= esc($t['journal']) ?>: <?= esc((string)$item['journal_title']) ?> (<?= esc((string)$item['journal_issn']) ?>) |
            <?= esc($t['year']) ?>: <?= esc((string)$item['pub_year']) ?>
          </div>
          <div class="mvp-sub"><?= esc($t['authors']) ?>: <?= esc((string)$item['authors']) ?></div>
          <div class="mvp-abs"><?= esc((string)$item['abstract_text']) ?></div>
        </article>
      <?php endforeach; ?>
      <?php
      $page = (int)$result['page'];
      $pages = max(1, (int)$result['pages']);
      $qs = $_GET;
      ?>
      <div class="mvp-pager">
        <?php if ($page > 1): ?>
          <?php $qs['page'] = $page - 1; ?>
          <a href="/search_mvp.php?<?= esc(http_build_query($qs)) ?>"><?= esc($t['prev']) ?></a>
        <?php endif; ?>
        <?php if ($page < $pages): ?>
          <?php $qs['page'] = $page + 1; ?>
          <a href="/search_mvp.php?<?= esc(http_build_query($qs)) ?>"><?= esc($t['next']) ?></a>
        <?php endif; ?>
      </div>
    </section>
  </div>
</body>
</html>
