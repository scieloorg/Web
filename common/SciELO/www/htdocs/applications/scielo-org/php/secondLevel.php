<?php
	ini_set("display_errors","1");
	error_reporting(E_ALL );
	include("../classes/XML_XSL/XML_XSL.inc.php");

	$DirNameLocal=dirname(__FILE__).'/';
	include_once(dirname(__FILE__)."/../../../php/include.php");
	$DirHtml = realpath(dirname(__FILE__) . "..") . "/html/" .$lang . "/";
	$site = parse_ini_file(dirname(__FILE__)."/../../../../../bases/site/ini/" . $lang . "/bvs.ini", true);
	$scielodef = parse_ini_file("../scielo.def", true);

	$bvsSiteIni = parse_ini_file(dirname(__FILE__)."/../../../bvs-site-conf.php",true);

	$baseDir = "";

	if($bvsSiteIni['ENVIRONMENT']['LETTER_UNIT'] != null){
		$baseDir = $bvsSiteIni['ENVIRONMENT']['LETTER_UNIT'].$bvsSiteIni['ENVIRONMENT']['DATABASE_PATH'];
	}else{
		$baseDir = $bvsSiteIni['ENVIRONMENT']['DATABASE_PATH'];
	}

ob_start("ob_gzhandler");
//ob_start();

	session_start();
	$transformer = new XSL_XML(dirname(__FILE__));
        $instance = $_REQUEST['instance'];
        $collection = $_REQUEST['collection'];
        $letter = $_REQUEST['letter'];
        $subject = $_REQUEST['subject'];
		
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<title>
			<?= $site['title']?>
		</title>
		<? include($DirNameLocal."./head.php"); ?>
		<SCRIPT language="JavaScript" src="<?=PATH_DATA?>js/httpAjaxHandler.js"></SCRIPT>
	</head>
	<body>
		<div class="container">	
			<div class="level2">
			<? require_once($baseDir."/html/" . $lang . "/bvs.html"); ?>
			<!--Middle content for second level pages -->
			<?
				$xmlFile = realpath(dirname(__FILE__) . "/..")."/webservices/xml/".$_GET["xml"].".xml";
				$xslFile = realpath(dirname(__FILE__) . "/..")."/xsl/".$_GET["xsl"].".xsl";
				if ($handle = fopen($xmlFile,'r')){
					while (!feof($handle)){
						$xmlh.=fgets($handle, 512);
					}
					$xml = "<root>";
					$xml .= "<vars>";
					$xml .= "<DIR>".$scielodef['this']['url']."</DIR>";
					$xml .= "<PATH>file://".$scielodef['this']['path']."</PATH>";
					if ($scielodef['this']['url']==$scielodef['scielo_org_urls']['home']){
						$xml .= "<scielo-portal>yes</scielo-portal>";
					}
					$xml .= "<lang>".$lang."</lang>";
					$xml .= "<letter>".$letter."</letter>";
					$xml .= "<subject>".$subject."</subject>";
					$xml .= "<instance>".$instance."</instance>";
					$xml .= "<collection>".$collection."</collection>";
					$xml .= "</vars>";
					if (strpos(strtolower($xmlh), 'utf-8')){
						$xmlh = utf8_decode($xmlh);
						$xmlh = str_replace('<?xml version="1.0" encoding="utf-8"?>','',$xmlh);
						$xmlh = str_replace('<?xml version="1.0" encoding="UTF-8"?>','',$xmlh);
					}
					$xml .= str_replace('<?xml version="1.0" encoding="ISO-8859-1"?>','',$xmlh);
					$xml .= "</root>";
					print("<!-- BEGIN MIDDLE -->");
					
					if(isset($_GET["debug"]))
					{
						echo '<textarea cols="80" rows="20" >';
					}
		
					print(utf8_decode($transformer->xml_xsl($xml,$xslFile,$_GET["debug"])));

					if(isset($_GET["debug"]))
					{
						echo '</textarea>';
					}
					
					print("<!-- END MIDDLE -->");
				}
				else
				{
					echo "Could not open XML file ".$xmlFile;
				}
			?>			
			<!--End of middle content for second level pages -->
			</div>
		</div>
	</body>
</html>

<?
ob_end_flush();
?>
