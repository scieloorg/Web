<?php
error_reporting(E_ALL ^ E_WARNING ^ E_NOTICE);

ob_start();

require_once(dirname(__FILE__)."/class.XSLTransformer.php");

$pid = isset($_REQUEST['pid']) ? $_REQUEST['pid'] : '';
$lang = isset($_REQUEST['lang']) ? $_REQUEST['lang'] : 'en';
$debug = isset($_REQUEST['debug']) ? $_REQUEST['debug'] : '';
$pRelease = isset($_REQUEST['prelease']) ? $_REQUEST['prelease'] : '';
$dateStart = isset($_REQUEST['dateStart']) ? $_REQUEST['dateStart'] : '';
$dateStop = isset($_REQUEST['dateStop']) ? $_REQUEST['dateStop'] : '';
$count = isset($_REQUEST['count']) ? $_REQUEST['count'] : '';
$date = isset($_REQUEST['date']) ? $_REQUEST['date'] : '';

function _rss_build_url($parts) {
  $scheme = isset($parts['scheme']) ? $parts['scheme'] : 'http';
  $host = isset($parts['host']) ? $parts['host'] : '127.0.0.1';
  $port = isset($parts['port']) ? ':' . $parts['port'] : '';
  $path = isset($parts['path']) ? $parts['path'] : '';
  $query = isset($parts['query']) ? '?' . $parts['query'] : '';
  return $scheme . '://' . $host . $port . $path . $query;
}

function _rss_fetch($url) {
  $xml = @file_get_contents($url);
  if ($xml !== false && trim($xml) !== '') {
    return $xml;
  }

  $parts = @parse_url($url);
  if (!$parts || !isset($parts['host'])) {
    return '';
  }

  $fallbackUrls = array();

  if (isset($parts['port']) && (int)$parts['port'] === 8080) {
    $u = $parts;
    unset($u['port']);
    $fallbackUrls[] = _rss_build_url($u);
  }

  if ($parts['host'] === 'localhost') {
    $u = $parts;
    $u['host'] = '127.0.0.1';
    if (isset($u['port']) && (int)$u['port'] === 8080) {
      unset($u['port']);
    }
    $fallbackUrls[] = _rss_build_url($u);
  }

  foreach ($fallbackUrls as $fallbackUrl) {
    $xml = @file_get_contents($fallbackUrl);
    if ($xml !== false && trim($xml) !== '') {
      return $xml;
    }
  }

  $xml = _rss_fetch_local_wxis($url);
  if ($xml !== '') {
    return $xml;
  }

  return '';
}

function _rss_fetch_local_wxis($url) {
  $query = parse_url($url, PHP_URL_QUERY);
  if (!$query) {
    return '';
  }

  $wxisBinary = dirname(__FILE__) . '/../cgi-bin/wxis.exe';
  if (!is_file($wxisBinary)) {
    return '';
  }

  $args = explode('&', $query);
  $safeArgs = array();
  foreach ($args as $arg) {
    $arg = trim($arg);
    if ($arg === '') {
      continue;
    }
    $safeArgs[] = escapeshellarg($arg);
  }
  $safeArgs[] = escapeshellarg('PATH_TRANSLATED=' . dirname(__FILE__) . '/');

  $cmd = escapeshellcmd($wxisBinary) . ' ' . implode(' ', $safeArgs);
  $output = @shell_exec($cmd);
  if (!$output) {
    return '';
  }

  $xml = strstr($output, '<');
  if ($xml === false) {
    return '';
  }
  return trim($xml);
}

function _rss_error($message) {
  header('Content-Type: application/rss+xml; charset=UTF-8');
  $safe = htmlspecialchars($message, ENT_QUOTES, 'UTF-8');
  return '<?xml version="1.0" encoding="UTF-8"?>'
    . '<rss version="2.0"><channel>'
    . '<title>SciELO RSS</title>'
    . '<description>' . $safe . '</description>'
    . '<item><title>' . $safe . '</title></item>'
    . '</channel></rss>';
}

/*
 * RSS de press-release para artigo e fasciculo
 */
if ($pRelease) {
  $url = "http://" . $_SERVER['HTTP_HOST'] . "/cgi-bin/wxis.exe/?IsisScript=ScieloXML/pressreleaserss.xis&def=scielo.def.php&sln=$lang&script=sci_serial&pid=$pid&lng=$lang&nrm=iso&dateStart=$dateStart&dateStop=$dateStop&prelease=$pRelease&count=$count&date=$date";
  $rss = _rss_fetch($url);
  if (!$rss) {
    echo _rss_error('RSS backend is temporarily unavailable');
    die();
  }
  echo $rss;
  die();
}

/*
 * se no PID vier o ISSN xxxx-xxxx
 * procura pelo current
 */
if (strlen($pid) == 9) {
  $pid = substr($pid, 0, 9);

  $url = "http://" . $_SERVER['HTTP_HOST'] . "/cgi-bin/wxis.exe/?IsisScript=ScieloXML/sci_issues.xis&def=scielo.def.php&sln=$lang&script=sci_issues&pid=$pid&lng=$lang&nrm=iso";

  $xml = _rss_fetch($url);
  $cortado = strstr($xml, '<CURRENT PID="');

  if ($cortado != '') {
    $posInicio = strpos($cortado, '"');
    $posFim = strpos($cortado, '"', $posInicio + 1);
    $pid = substr($cortado, $posInicio + 1, $posFim - $posInicio - 1);
  }
}

/* CHANGE: alterado em 20080314 para utilizacao do script sci_issuerss.xis */
$url = "http://" . $_SERVER['HTTP_HOST'] . "/cgi-bin/wxis.exe/?IsisScript=ScieloXML/sci_issuerss.xis&def=scielo.def.php&sln=en&script=sci_issuetoc&pid=$pid&lng=$lang&nrm=iso";

$xml = _rss_fetch($url);
$xsl = dirname(__FILE__) . "/xsl/createRSS.xsl";

if (isset($debug) && $debug !== '') {
  echo '<h1>XML</h1>';
  echo '<textarea cols="120" rows="18">' . "\n";
  echo $xml;
  echo '</textarea>';

  echo '<h1>XSL</h1>';
  echo '<textarea cols="120" rows="18">' . "\n";
  echo $xsl;
  echo '</textarea>';
  die();
}

if (!$xml) {
  echo _rss_error('RSS backend is temporarily unavailable');
  die();
}

$t = new XSLTransformer();
$t->setXml($xml);
$t->setXslFile($xsl);
$t->transform();
$result = $t->getOutput();

if (!$result || trim($result) === '') {
  echo _rss_error('RSS transformation failed');
  die();
}

echo $result;

ob_flush();
?>
