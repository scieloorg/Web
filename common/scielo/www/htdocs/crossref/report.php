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
$htdocsPath = $defFile["PATH_HTDOCS"];
$viewNum = 20;


if(!isset($_REQUEST['pg'])){
	$pg = 1;
}else{
	$pg = $_REQUEST['pg'];
}

if($pg==1){
	$fim = $viewNum * $pg;
	$inicio = 1;
}else{
	$fim = $viewNum * $pg; 
	$inicio = $fim - $viewNum; 
}

if($_REQUEST['PID']){
	$serviceUrl = "http://" . $applServer . "/cgi-bin/wxis.exe/webservices/wxis/?IsisScript=search.xis&database=".$databasePath."/doi/crossref_DOIReport&search=HR=".$_REQUEST['PID']."&from=".$inicio."&count=".$viewNum;
}else{
	$serviceUrl = "http://" . $applServer . "/cgi-bin/wxis.exe/webservices/wxis/?IsisScript=search.xis&database=".$databasePath."/doi/crossref_DOIReport&search=ST=".$_REQUEST['stat']."%20and%20DT=".$_REQUEST['dateExp']."&from=".$inicio."&count=".$viewNum;
}

$xmlFile = file_get_contents($serviceUrl);
$xml = '<?xml version="1.0" encoding="ISO-8859-1"?>';
$xml .='<root>';
$xml .='<vars><htdocs>'.$htdocsPath.'</htdocs><domain>'.$applServer.'</domain><lang>'.$lang.'</lang></vars>';
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

			if (getenv("ENV_SOCKET")!="true"){  //socket
				$xsl = file_get_contents($xsl);
				//die("socket = false");
			} else {
				$xsl = 'REPORT';
			}
			//die("socket = true");

			$transformer->setXslBaseUri(dirname(__FILE__));
			$transformer->setXML($xml);
			$transformer->setXSL($xsl);
			$transformer->transform();
			$output = $transformer->getOutput();
			echo $output;

			$pgPrevious = $pg - 1;
			$pgNext = $pg + 1;
			$totalPages = (int) ceil((substr($xml,strpos($xml,"Isis_Total")+24,4))/$viewNum);
			$previous = str_replace("&pg=".$pg,"",$_SERVER['REQUEST_URI']);
			$previous .= "&pg=".$pgPrevious;
			$next = str_replace("&pg=".$pg,"",$_SERVER['REQUEST_URI']); 
			$next .= "&pg=".$pgNext; 
			
			if($pg <= $totalPages){
			//if($totalPages!=1){
				if($pgPrevious>0){echo "<a href=$previous>&lt;&lt;</a>";} 
				if($pgNext<=$totalPages){echo " | <a href=$next>&gt;&gt;</a>";}
				echo ("  - Pag ".$pg);
				echo ' / '. $totalPages;
			}
		?>	
	</body>
</html>
