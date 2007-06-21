<?php

	$DirNameLocal=dirname(__FILE__).'/';

	include_once(dirname(__FILE__)."/../classes/XML_XSL/XML_XSL.inc.php");
	include_once(dirname(__FILE__)."/../users/DBClass.php");
	include_once(dirname(__FILE__)."/../users/langs.php");
	include_once(dirname(__FILE__)."/../../../php/include.php");
	
	$DirHtml = realpath($DirNameLocal . "..") . "/html/" .$lang . "/";
	$site = parse_ini_file($DirNameLocal."../ini/" . $lang . "/bvs.ini", true);
	$scielodef = parse_ini_file($DirNameLocal."../scielo.def", true);
	$DirHtml = realpath(dirname(__FILE__) . "..") . "/html/" .$lang . "/";



	if ($scielodef['this']['url']!=$scielodef['scielo_org_urls']['home']){
		$condition = "and collection='".$scielodef['this']['name']."'";
	}

	$query = "SELECT * FROM teste WHERE title LIKE '%".$_REQUEST['expression']."%' ORDER BY collection,title";


ob_start("ob_gzhandler");
//ob_start();

	session_start();
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
			<? require_once(dirname(__FILE__)."/../../../../bases/site/html/" . $lang . "/bvs.html"); ?>
			<div class="middle">
			<!--Middle-->
				<div id="breadCrumb">
					    <a href="/index.php?lang=<?=$lang?>"><?=HOME?></a> &gt; <?=NUMBERS?>
				</div>
				<div class="content">
					<h3><span><?=CITATION?></span></h3>

					<ul>
						<li><a href="http://www.scielo.br/stat_biblio/index.php?lang=<?php echo $lang ?>" target="_blank"><?=BRASIL?></a></li>
						<li><a href="http://www.scielo.cl/stat_biblio/index.php?lang=<?php echo $lang ?>" target="_blank"><?=CHILE?></a></li>
						<li><a href="http://www.scielo.sld.cu/stat_biblio/index.php?lang=<?php echo $lang ?>" target="_blank"><?=CUBA?></a></li>
						<li><a href="http://www.scielosp.org/stat_biblio/index.php?lang=<?php echo $lang ?>"  target="_blank"><?=PUBLIC_HEALTH?></a></li>
						<li><a href="http://www.scielo.org.ve/stat_biblio/index.php?lang=<?php echo $lang ?>" target="_blank"><?=VENEZUELA?></a></li>
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
