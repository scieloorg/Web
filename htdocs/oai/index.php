<?php
declare(strict_types=1);

$lang = (string)($_GET['lang'] ?? 'pt');
if (!in_array($lang, ['pt', 'es', 'en'], true)) {
    $lang = 'pt';
}

if (isset($_GET['verb']) && $_GET['verb'] !== '') {
    $params = $_GET;
    unset($params['lang']);
    $target = '/oai/scielo-oai.php';
    if ($params) {
        $target .= '?' . http_build_query($params);
    }
    header('Location: ' . $target, true, 302);
    exit;
}

$labels = [
    'pt' => [
        'title' => 'Explorer OAI-PMH',
        'subtitle' => 'Interface para testar o endpoint OAI-PMH',
        'endpoint' => 'Endpoint',
        'verb' => 'Verbo',
        'metadata_prefix' => 'Metadata Prefix',
        'identifier' => 'Identifier',
        'set' => 'Set',
        'from' => 'From (YYYY-MM-DD)',
        'until' => 'Until (YYYY-MM-DD)',
        'resumption' => 'Resumption Token',
        'run' => 'Executar consulta',
        'examples' => 'Exemplos rápidos',
        'notes' => 'Se acessar /oai/?verb=... o sistema redireciona automaticamente para /oai/scielo-oai.php',
    ],
    'es' => [
        'title' => 'Explorador OAI-PMH',
        'subtitle' => 'Interfaz para probar el endpoint OAI-PMH',
        'endpoint' => 'Endpoint',
        'verb' => 'Verbo',
        'metadata_prefix' => 'Metadata Prefix',
        'identifier' => 'Identifier',
        'set' => 'Set',
        'from' => 'From (YYYY-MM-DD)',
        'until' => 'Until (YYYY-MM-DD)',
        'resumption' => 'Resumption Token',
        'run' => 'Ejecutar consulta',
        'examples' => 'Ejemplos rápidos',
        'notes' => 'Si accede a /oai/?verb=... el sistema redirige automáticamente a /oai/scielo-oai.php',
    ],
    'en' => [
        'title' => 'OAI-PMH Explorer',
        'subtitle' => 'Interface to test the OAI-PMH endpoint',
        'endpoint' => 'Endpoint',
        'verb' => 'Verb',
        'metadata_prefix' => 'Metadata Prefix',
        'identifier' => 'Identifier',
        'set' => 'Set',
        'from' => 'From (YYYY-MM-DD)',
        'until' => 'Until (YYYY-MM-DD)',
        'resumption' => 'Resumption Token',
        'run' => 'Run query',
        'examples' => 'Quick examples',
        'notes' => 'If you access /oai/?verb=... it automatically redirects to /oai/scielo-oai.php',
    ],
];
$t = $labels[$lang];

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
  <style>
    :root { --bg:#f4f6fb; --card:#fff; --txt:#1f2937; --muted:#5f6b7a; --line:#d8dfeb; --blue:#2f5ec4; }
    html, body { margin:0; padding:0; background:var(--bg); color:var(--txt); font-family:"Noto Sans", Arial, sans-serif; }
    .shell { max-width: 1000px; margin: 0 auto; padding: 24px 16px 30px; }
    .card { background:var(--card); border:1px solid var(--line); border-radius:12px; padding:18px; margin-bottom:14px; }
    .head { display:flex; justify-content:space-between; align-items:center; gap:12px; }
    .head img { width:100px; height:auto; }
    h1 { margin:10px 0 2px; font-size:30px; color:#083a5a; }
    .subtitle { margin:0; color:var(--muted); }
    .lang a { color:var(--blue); text-decoration:none; margin-left:10px; font-weight:600; }
    .lang .active { color:#111827; text-decoration:underline; }
    .grid { display:grid; grid-template-columns: 1fr 1fr; gap:10px; }
    .full { grid-column: 1 / -1; }
    label { display:block; margin:0 0 4px; font-size:13px; color:#334155; }
    input, select, button { width:100%; box-sizing:border-box; height:40px; border:1px solid #c4cddc; border-radius:6px; padding:0 10px; font-size:14px; }
    button { border-color:#3f68c7; background:#3f68c7; color:#fff; font-weight:700; cursor:pointer; }
    .examples a { display:block; color:var(--blue); text-decoration:none; margin:5px 0; word-break:break-all; }
    .notes { color:var(--muted); font-size:13px; margin-top:8px; }
    @media (max-width: 760px) { .grid { grid-template-columns: 1fr; } h1 { font-size:24px; } }
  </style>
</head>
<body>
  <div class="shell">
    <div class="card">
      <div class="head">
        <img src="/img/revistas/scielobrp.gif" alt="SciELO">
        <div class="lang">
          <a href="/oai/index.php?lang=pt" class="<?= $lang === 'pt' ? 'active' : '' ?>">Português</a>
          <a href="/oai/index.php?lang=es" class="<?= $lang === 'es' ? 'active' : '' ?>">Español</a>
          <a href="/oai/index.php?lang=en" class="<?= $lang === 'en' ? 'active' : '' ?>">English</a>
        </div>
      </div>
      <h1><?= esc($t['title']) ?></h1>
      <p class="subtitle"><?= esc($t['subtitle']) ?></p>
    </div>

    <div class="card">
      <form method="get" action="/oai/scielo-oai.php" target="_blank">
        <div class="grid">
          <div class="full">
            <label><?= esc($t['endpoint']) ?></label>
            <input type="text" value="/oai/scielo-oai.php" readonly>
          </div>
          <div>
            <label><?= esc($t['verb']) ?></label>
            <select name="verb" id="verb">
              <option value="Identify">Identify</option>
              <option value="ListMetadataFormats">ListMetadataFormats</option>
              <option value="ListSets">ListSets</option>
              <option value="ListIdentifiers">ListIdentifiers</option>
              <option value="ListRecords">ListRecords</option>
              <option value="GetRecord">GetRecord</option>
            </select>
          </div>
          <div>
            <label><?= esc($t['metadata_prefix']) ?></label>
            <select name="metadataPrefix" id="metadataPrefix">
              <option value="">(none)</option>
              <option value="oai_dc">oai_dc</option>
              <option value="oai_dc_agris">oai_dc_agris</option>
              <option value="oai_dc_openaire">oai_dc_openaire</option>
              <option value="oai_dc_scielo">oai_dc_scielo</option>
            </select>
          </div>
          <div>
            <label><?= esc($t['identifier']) ?></label>
            <input type="text" name="identifier" id="identifier" placeholder="oai:scielo:S0100-879X2008000100002">
          </div>
          <div>
            <label><?= esc($t['set']) ?></label>
            <input type="text" name="set" id="set" placeholder="0100-879X">
          </div>
          <div>
            <label><?= esc($t['from']) ?></label>
            <input type="text" name="from" id="from" placeholder="2008-01-01">
          </div>
          <div>
            <label><?= esc($t['until']) ?></label>
            <input type="text" name="until" id="until" placeholder="2008-12-31">
          </div>
          <div class="full">
            <label><?= esc($t['resumption']) ?></label>
            <input type="text" name="resumptionToken" id="resumptionToken" placeholder="token">
          </div>
          <div class="full">
            <button type="submit"><?= esc($t['run']) ?></button>
          </div>
        </div>
      </form>
      <div class="notes"><?= esc($t['notes']) ?></div>
    </div>

    <div class="card examples">
      <strong><?= esc($t['examples']) ?></strong>
      <a href="/oai/scielo-oai.php?verb=Identify" target="_blank">/oai/scielo-oai.php?verb=Identify</a>
      <a href="/oai/scielo-oai.php?verb=ListMetadataFormats" target="_blank">/oai/scielo-oai.php?verb=ListMetadataFormats</a>
      <a href="/oai/scielo-oai.php?verb=ListSets" target="_blank">/oai/scielo-oai.php?verb=ListSets</a>
      <a href="/oai/scielo-oai.php?verb=ListRecords&amp;metadataPrefix=oai_dc" target="_blank">/oai/scielo-oai.php?verb=ListRecords&amp;metadataPrefix=oai_dc</a>
      <a href="/oai/scielo-oai.php?verb=GetRecord&amp;metadataPrefix=oai_dc&amp;identifier=oai:scielo:S0100-879X2008000100002" target="_blank">/oai/scielo-oai.php?verb=GetRecord&amp;metadataPrefix=oai_dc&amp;identifier=oai:scielo:S0100-879X2008000100002</a>
    </div>
  </div>
</body>
</html>

