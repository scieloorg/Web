<?php
declare(strict_types=1);

$lang = isset($_GET['lang']) ? strtolower((string)$_GET['lang']) : 'pt';
if (!in_array($lang, ['pt', 'es', 'en'], true)) {
    $lang = 'pt';
}

$t = [
    'pt' => [
        'title' => 'Sobre este site',
        'subtitle' => 'Links e informações institucionais do SciELO Brasil',
        'back' => 'Voltar para a página inicial',
        'heading' => 'Sobre',
        'intro' => 'Acesse os principais conteúdos institucionais do SciELO Brasil:',
        'lang' => 'Idioma',
        'links' => [
            ['label' => 'Sobre o SciELO Brasil', 'href' => 'https://www.scielo.br/about/'],
            ['label' => 'Sobre este site', 'href' => 'https://www.scielo.br/about/#about-this-site'],
            ['label' => 'Coleção SciELO Brasil', 'href' => 'https://www.scielo.br/about/#scielo-brazil-collection'],
            ['label' => 'Rede SciELO', 'href' => 'https://www.scielo.br/about/#scielo-network'],
            ['label' => 'Critérios de indexação', 'href' => 'https://www.scielo.br/about/#criteria'],
            ['label' => 'Política de acesso aberto', 'href' => 'https://www.scielo.br/about/#open-access'],
            ['label' => 'Contato', 'href' => 'https://www.scielo.br/about/#contact'],
        ],
    ],
    'es' => [
        'title' => 'Sobre este sitio',
        'subtitle' => 'Enlaces e información institucional de SciELO Brasil',
        'back' => 'Volver a la página inicial',
        'heading' => 'Acerca de',
        'intro' => 'Acceda a los principales contenidos institucionales de SciELO Brasil:',
        'lang' => 'Idioma',
        'links' => [
            ['label' => 'Acerca de SciELO Brasil', 'href' => 'https://www.scielo.br/about/'],
            ['label' => 'Acerca de este sitio', 'href' => 'https://www.scielo.br/about/#about-this-site'],
            ['label' => 'Colección SciELO Brasil', 'href' => 'https://www.scielo.br/about/#scielo-brazil-collection'],
            ['label' => 'Red SciELO', 'href' => 'https://www.scielo.br/about/#scielo-network'],
            ['label' => 'Criterios de indexación', 'href' => 'https://www.scielo.br/about/#criteria'],
            ['label' => 'Política de acceso abierto', 'href' => 'https://www.scielo.br/about/#open-access'],
            ['label' => 'Contacto', 'href' => 'https://www.scielo.br/about/#contact'],
        ],
    ],
    'en' => [
        'title' => 'About this site',
        'subtitle' => 'Institutional links and information for SciELO Brazil',
        'back' => 'Back to home page',
        'heading' => 'About',
        'intro' => 'Access the main institutional content of SciELO Brazil:',
        'lang' => 'Language',
        'links' => [
            ['label' => 'About SciELO Brazil', 'href' => 'https://www.scielo.br/about/'],
            ['label' => 'About this site', 'href' => 'https://www.scielo.br/about/#about-this-site'],
            ['label' => 'SciELO Brazil collection', 'href' => 'https://www.scielo.br/about/#scielo-brazil-collection'],
            ['label' => 'SciELO Network', 'href' => 'https://www.scielo.br/about/#scielo-network'],
            ['label' => 'Indexing criteria', 'href' => 'https://www.scielo.br/about/#criteria'],
            ['label' => 'Open access policy', 'href' => 'https://www.scielo.br/about/#open-access'],
            ['label' => 'Contact', 'href' => 'https://www.scielo.br/about/#contact'],
        ],
    ],
];

$page = $t[$lang];
header('Content-Type: text/html; charset=UTF-8');
?>
<!doctype html>
<html lang="<?php echo htmlspecialchars($lang, ENT_QUOTES, 'UTF-8'); ?>">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title><?php echo htmlspecialchars($page['title'], ENT_QUOTES, 'UTF-8'); ?> - SciELO</title>
  <link rel="stylesheet" type="text/css" href="/design-system/1.0.0/css/bootstrap.css">
  <link rel="stylesheet" type="text/css" href="/design-system/1.0.0/css/article.css">
  <link rel="stylesheet" type="text/css" href="/css/scielo-ds-bridge.css">
</head>
<body class="about-page">
  <main class="about-wrap">
    <header class="about-head">
      <img class="about-logo" alt="SciELO" src="/img/revistas/scielobrp.gif">
      <div>
        <h1><?php echo htmlspecialchars($page['title'], ENT_QUOTES, 'UTF-8'); ?></h1>
        <p><?php echo htmlspecialchars($page['subtitle'], ENT_QUOTES, 'UTF-8'); ?></p>
      </div>
    </header>

    <nav class="about-toolbar">
      <a class="serials-ghost-btn" href="/scielo.php?script=sci_home&amp;lng=<?php echo htmlspecialchars($lang, ENT_QUOTES, 'UTF-8'); ?>&amp;nrm=iso">
        <?php echo htmlspecialchars($page['back'], ENT_QUOTES, 'UTF-8'); ?>
      </a>
      <div class="about-lang">
        <span><?php echo htmlspecialchars($page['lang'], ENT_QUOTES, 'UTF-8'); ?>:</span>
        <a href="/about/?lang=pt">Português</a>
        <a href="/about/?lang=es">Español</a>
        <a href="/about/?lang=en">English</a>
      </div>
    </nav>

    <section class="about-links">
      <h2><?php echo htmlspecialchars($page['heading'], ENT_QUOTES, 'UTF-8'); ?></h2>
      <p><?php echo htmlspecialchars($page['intro'], ENT_QUOTES, 'UTF-8'); ?></p>
      <ul>
        <?php foreach ($page['links'] as $item): ?>
          <li>
            <a href="<?php echo htmlspecialchars($item['href'], ENT_QUOTES, 'UTF-8'); ?>" target="_blank" rel="noopener noreferrer">
              <?php echo htmlspecialchars($item['label'], ENT_QUOTES, 'UTF-8'); ?>
            </a>
          </li>
        <?php endforeach; ?>
      </ul>
    </section>
  </main>
</body>
</html>
