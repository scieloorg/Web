<?php
/**
 * XML do PubMed Central no serviço "Artigo em formato XML"
 *
 * Concatenação de dois XML
 * @author Deivid Martins 
 *
 ******************************************************************/
header('Content-type: text/xml');
ini_set("display_errors","1");
error_reporting(E_ALL ^E_NOTICE);
$lang = isset($_REQUEST['lang'])?($_REQUEST['lang']):"";
$pid = isset($_REQUEST['pid'])?($_REQUEST['pid']):"";
$text = isset($_REQUEST['text'])?($_REQUEST['text']):"";

require_once(dirname(__FILE__)."/../../applications/scielo-org/users/functions.php");
require_once(dirname(__FILE__)."/../../applications/scielo-org/users/langs.php");	
require_once(dirname(__FILE__)."/../../classDefFile.php");
require_once(dirname(__FILE__)."/../../class.XSLTransformer.php");

$defFile = parse_ini_file(dirname(__FILE__)."/../../scielo.def");
$applServer = $defFile["SERVER_SCIELO"];
$databasePath = $defFile["PATH_DATABASE"];


// Contem o artigo da revista
$xml1 = "http://".$applServer."/cgi-bin/wxis.exe/?IsisScript=ScieloXML/";
$xml1 .="sci_xmloutput.xis&database=artigo&search=IV=". $pid ."\$"; 
$xml1 = file_get_contents($xml1);


// Contem o elemento <BODY> </BODY>
$xml2 = "http://".$applServer."/cgi-bin/wxis.exe/?IsisScript=ScieloXML/";
$xml2 .= "sci_arttext.xis&def=scielo.def&pid=".$pid;
$xml2 = file_get_contents($xml2);


// Pegando o conteudo entre as tags <BODY> ... </BODY>
$posicaoInicial = strpos($xml2, "<BODY>");
$posicaoFinal= strpos($xml2, "</ARTICLE>") - $posicaoInicial;
$body = substr($xml2, strpos($xml2, "<BODY>"), $posicaoFinal-1);
$body = str_replace("<BODY>","<body>",$body);
$body = str_replace("</BODY>","</body>", $body);


// Retirando <wxis-modules até o comeco de front
$tagWxis = strpos($xml1, "<article xmlns");
$tagSearch = strpos($xml1, "<search mfn");
$temp = $xml1;
$xml1 = '<?xml version="1.0" encoding="ISO-8859-1"?>';
$xml1 .= substr($temp, $tagWxis, $tagSearch -$tagWxis);


// Criando o XML no formato exigido pela PubMed
$posFimFront = strpos($xml1, "</front>");
$posComBack = strpos($xml1, "<back>");
$xmlPubMed =  substr($xml1, 0, $posFimFront + strlen("</front>"));
$xmlPubMed .= $body;

// Em algumas bases não existe referencia então o back não existe
if($posComBack != false)
{
	$xmlPubMed .= substr($xml1, $posComBack, strlen($xml1));
}
else
{
	$xmlPubMed .= substr($xml1, $posFimFront + strlen("</front>"), strlen($xml1));
}

echo $xmlPubMed;

?>