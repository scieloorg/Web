<?php

	$DirNameLocal=dirname(__FILE__).'/';

	include_once(dirname(__FILE__)."/../classes/XML_XSL/XML_XSL.inc.php");
	include_once(dirname(__FILE__)."/../users/DBClass.php");
	include_once(dirname(__FILE__)."/../users/langs.php");
	include_once(dirname(__FILE__)."/../../../php/include.php");


	$bvsSiteIni = parse_ini_file(dirname(__FILE__)."/../../../bvs-site-conf.php",true);

	$baseDir = "";

	if($bvsSiteIni['ENVIRONMENT']['LETTER_UNIT'] != null){
		$baseDir = $bvsSiteIni['ENVIRONMENT']['LETTER_UNIT'].$bvsSiteIni['ENVIRONMENT']['DATABASE_PATH'];
	}else{
		$baseDir = $bvsSiteIni['ENVIRONMENT']['DATABASE_PATH'];
	}

	
	$site = parse_ini_file($DirNameLocal."../ini/" . $lang . "/bvs.ini", true);
	$scieloAppdef = parse_ini_file(dirname(__FILE__)."/../scielo.def.php", true);
	$DirHtml = realpath(dirname(__FILE__) . "..") . "/html/" .$lang . "/";

	if ($scieloAppdef['this']['url']!=$scieloAppdef['scielo_org_urls']['home']){
		$condition = "and collection='".$scieloAppdef['this']['name']."'";
	}
	$query = "SELECT * FROM teste WHERE title LIKE '%".$_REQUEST['expression']."%' ".$condition." ORDER BY collection,title";

	ob_start("ob_gzhandler");

	session_start();
	$transformer = new XSL_XML();
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<title>
			<?= $site['title']?>
		</title>
		<? require_once($DirNameLocal."./head.php"); ?>
		<SCRIPT language="JavaScript" src="<?=PATH_DATA?>js/httpAjaxHandler.js"></SCRIPT>	
	</head>
	<body>
		<div class="container">	
			<div class="level2">
			<? require_once($baseDir."/html/" . $lang . "/bvs.html"); ?>
			<div class="middle">
			<!--Middle-->
			<?
					$db = new DBClass();

					$arr = $db->databaseQuery($query);

			?>
				<div id="breadCrumb">
					    <a href="/index.php?lang=<?=$lang?>"><?=HOME?></a>&gt; <?=SEARCH_JOURNALS?>
				</div>
				<div class="content">
					    <h3><span><?=SEARCH_JOURNALS?> - <?=$_REQUEST['expression']?> - <?=FIND_RESULTS?> <?=count($arr)?></span></h3>
						<ul>
			<?

						foreach($arr as $reg)
						{
							echo "<li>\n";
							
							echo '<a target="_blank" href="'.$reg['domain'].'/scielo.php?script=sci_serial&pid='.$reg['ISSN'].'&nrm=iso&lng='.$lang.'">';
							echo $reg['title'];
							echo '</a>';
							if (!$condition) {
								echo '<span class="collectionName"> ['.$reg['collection'].']</span>';
							}
							echo "\n";

							echo "</li>\n";
						}
			?>
						</ul>


				</div>

			<?
					
					print("<!-- END MIDDLE -->");
			?>	
			<!--End of Middle-->
			</div>
			</div>
		</div>
		<div class="copyright">
			BVS Site <?= VERSION ?> &copy; <a href="http://www.bireme.br/" target="_blank">BIREME/OPS/OMS</a>
		</div>
	</body>
</html>

<?
ob_end_flush();
?>

