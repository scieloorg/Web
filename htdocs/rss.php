<?php
error_reporting(E_ALL ^ E_WARNING ^ E_NOTICE);

ob_start();

require_once(dirname(__FILE__)."/class.XSLTransformer.php");
require_once(dirname(__FILE__)."/security.php");

$config = parse_ini_file(__DIR__ . '/scielo.def.php', true);
$internalHost = scielo_internal_host_from_config($config);

$pid = $_REQUEST['pid'];
$lang = $_REQUEST['lang'];
$debug = isset($_REQUEST['debug']) ? $_REQUEST['debug'] : '';
$pRelease = $_REQUEST['prelease'];
$dateStart = $_REQUEST['dateStart'];
$dateStop = $_REQUEST['dateStop'];
$count = $_REQUEST['count'];
$date = $_REQUEST['date'];

/**
 *
 * RSS de press-release para artigo e fascículo
 * 
 */
if($pRelease){
  
  $url = 'http://' . $internalHost . '/cgi-bin/wxis.exe/?' . http_build_query(array(
    'IsisScript' => 'ScieloXML/pressreleaserss.xis',
    'def' => 'scielo.def.php',
    'sln' => $lang,
    'script' => 'sci_serial',
    'pid' => $pid,
    'lng' => $lang,
    'nrm' => 'iso',
    'dateStart' => $dateStart,
    'dateStop' => $dateStop,
    'prelease' => $pRelease,
    'count' => $count,
    'date' => $date,
  ));
  $rss = file_get_contents($url);
  echo $rss;
  die();
}

/**
 * se no PID vier o ISSN xxxx-xxxx
 * procura pelo current
 */
if(strlen($pid) == 9){

  $pid = substr($pid,0,9);

  $url = 'http://' . $internalHost . '/cgi-bin/wxis.exe/?' . http_build_query(array(
    'IsisScript' => 'ScieloXML/sci_issues.xis',
    'def' => 'scielo.def.php',
    'sln' => $lang,
    'script' => 'sci_issues',
    'pid' => $pid,
    'lng' => $lang,
    'nrm' => 'iso',
  ));

  $xml = file_get_contents($url);
  $cortado = strstr($xml, '<CURRENT PID="');

  if($cortado != "") {
    $posInicio = strpos($cortado,"\"");
    $posFim = strpos($cortado,"\"",$posInicio+1);
    $pid = substr($cortado, $posInicio+1, $posFim-$posInicio-1);
  }
}



  /* CHANGE: alterado em 20080314 para utilização do script sci_issuerss.xis (adiconado abstract ao XML) no lugar de sci_issuetoc.xis */
$url = 'http://' . $internalHost . '/cgi-bin/wxis.exe/?' . http_build_query(array(
  'IsisScript' => 'ScieloXML/sci_issuerss.xis',
  'def' => 'scielo.def.php',
  'sln' => 'en',
  'script' => 'sci_issuetoc',
  'pid' => $pid,
  'lng' => $lang,
  'nrm' => 'iso',
));

$xml = file_get_contents($url);
$xsl = dirname(__FILE__)."/xsl/createRSS.xsl";

if ($debug !== '' && scielo_diagnostic_mode_allowed($debug)) {

  header('Content-Type: text/plain; charset=UTF-8');
  echo "XML\n";
  echo $xml;
  echo "\nXSL\n";
  echo $xsl;
  die();
}

if ($debug !== '') {
  scielo_audit_event(
    'access.denied',
    'unauthorized',
    'diagnostics',
    null,
    array('reason' => 'remote_rss_debug_disabled')
  );
}

$t = new XSLTransformer();
$t->setXml($xml);
$t->setXslFile($xsl);
$t->transform();
$result = $t->getOutput();

echo $result;

ob_flush();

?>
