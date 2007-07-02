<?php
header("Content-type: application/xml");

require_once(dirname(__FILE__)."/../class.XSLTransformer.php");
require_once(dirname(__FILE__)."/../classDefFile.php");

$defFile = parse_ini_file(dirname(__FILE__)."/../scielo.def");

$applServer = $defFile["SERVER_SCIELO"];
$databasePath = $defFile["PATH_DATABASE"];


$xml = "http://".$applServer."/cgi-bin/wxis.exe/?IsisScript=ScieloXML/";
$xml .= "sci_xmlcrossrefoutput.xis&def=scielo.def&database=ARTIGO&search=HR=".$_REQUEST['pid'];
$xml = file_get_contents($xml);

echo ($xml);	
?>
