<?php
ini_set("display_errors","1");
error_reporting(E_ALL ^E_NOTICE);

$lang = isset($_REQUEST['lang'])?($_REQUEST['lang']):"";

require_once(dirname(__FILE__)."/../class.XSLTransformer.php");

$xml = '<?xml version="1.0" encoding="UTF-8"?>';
$xml .= '<ERROR>';
$xml .= '<CONTROLINFO>';
$xml .= '<LANGUAGE>'.$lang.'</LANGUAGE>';
$xml .= '<SCIELO_INFO>';
$xml .= '<SERVER>'.$_SERVER['SERVER_NAME'].'</SERVER>';
$xml .= '<PATH_DATA>/</PATH_DATA>';
$xml .= '<PATH_GENIMG>/img/</PATH_GENIMG>';
$xml .= '</SCIELO_INFO>';
$xml .= '</CONTROLINFO>';
$xml .= '<EMAIL>scielo@bireme.br</EMAIL>';
$xml .= '</ERROR>';

$xsl = dirname(__FILE__)."/../xsl/sci_error.xsl";
$transformer = new XSLTransformer();
$transformer->setXslBaseUri(dirname(__FILE__));
$transformer->setXML($xml);
$transformer->setXSL($xsl);
$transformer->transform();
$output = $transformer->getOutput();
$output = str_replace('&amp;','&',$output);
$output = str_replace('&lt;','<',$output);
$output = str_replace('&gt;','>',$output);
$output = str_replace('&quot;','"',$output);
$output = str_replace('<p>',' ',$output);
$output = str_replace('</p>',' ',$output);				
echo (utf8_decode($output));
?>	
