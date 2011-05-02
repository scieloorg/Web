<?php
header("Content-type: application/xml");

require_once(dirname(__FILE__)."/../class.XSLTransformer.php");
require_once(dirname(__FILE__)."/../classDefFile.php");

$defFile = parse_ini_file(dirname(__FILE__)."/../scielo.def.php");

$applServer = $defFile["SERVER_SCIELO"];
$databasePath = $defFile["PATH_DATABASE"];


$xml = "http://".$applServer."/cgi-bin/wxis.exe/?IsisScript=ScieloXML/sci_xmlcrossrefoutput.xis&def=scielo.def&database=ARTIGO&search=HR=".$_REQUEST['pid'].
        "&prefix=".$defFile["DOI_PREFIX"]."&depname=".$defFile["DEPOSITOR_NAME"].
        "&depmail=".$defFile["DEPOSITOR_MAIL"]."&depdomain=".$defFile["DEPOSITOR_DOMAIN"];
$xml = utf8_encode(file_get_contents($xml));

echo ($xml);	
?>
