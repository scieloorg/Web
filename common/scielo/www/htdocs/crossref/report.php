<?php
ini_set("display_errors","1");
error_reporting(E_ALL ^E_NOTICE);
$lang = $_REQUEST['lang'];


require_once(dirname(__FILE__)."/../class.XSLTransformer.php");

//require_once(dirname(__FILE__)."/../applications/scielo-org/users/langs.php");	

require_once(dirname(__FILE__)."/../classDefFile.php");

$defFile = parse_ini_file(dirname(__FILE__)."/../scielo.def");

$applServer = $defFile["SERVER_SCIELO"];
$databasePath = $defFile["PATH_DATABASE"];

$serviceUrl = "http://" . $applServer . "/cgi-bin/wxis.exe/webservices/wxis/?IsisScript=search.xis&database=/home/scielo/www/bases/doi/crossref_DOIReport&search=ST=".$_REQUEST['stat'];
$xmlFile = file_get_contents($serviceUrl);
$xml = '<?xml version="1.0" encoding="ISO-8859-1"?>';
$xml .='<root>';
$xml .='<vars><from>'.$_REQUEST['from'].'</from><to>'.$_REQUEST['to'].'</to><domain>'.$applServer.'</domain><lang>'.$lang.'</lang></vars>';
$xml .= str_replace('<?xml version="1.0" encoding="ISO-8859-1"?>','',$xmlFile);
$xml .='</root>';

if($_REQUEST['getXML'] == "true"){
				die($xml);
			}
?>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
		<!-- <link rel="stylesheet" href="/applications/scielo-org/css/public/style-<?=$lang?>.css" type="text/css" media="screen"/> -->
	</head>
	<body>
		<?php
			
						
			$xsl = dirname(__FILE__)."/report.xsl";
			$transformer = new XSLTransformer();
			$transformer->setXslBaseUri(dirname(__FILE__));
			$transformer->setXML($xml);
			$transformer->setXSL($xsl);
			$transformer->transform();
			$output = $transformer->getOutput();
			echo (utf8_decode($output));
			?>
	</body>
</html>
