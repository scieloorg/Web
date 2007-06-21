<?php
	$DirNameLocal=dirname(__FILE__).'/';

	include_once($DirNameLocal."../classes/XML_XSL/XML_XSL.inc.php");

	include_once($DirNameLocal."../users/DBClass.php");
	include_once($DirNameLocal."../users/langs.php");
	include_once($DirNameLocal."../../../php/include.php");
	$site = parse_ini_file($DirNameLocal."../ini/" . $lang . "/bvs.ini", true);
	$DirHtml = realpath(dirname(__FILE__) . "..") . "/html/" .$lang . "/";

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
					    <a href="/index.php?lang=pt"><?=HOME?></a> &gt; <?=NUMBERS?>
				</div>
				<div class="content">
				    <h3><span><?=USAGE?></span></h3>

					<ul>
						<li><a href="http://www.scielo.br/scielo.php?script=sci_stat&lng=<?php echo $lang ?>&nrm=iso" target="_blank">Brasil</a></li>
						<li><a href="http://www.scielo.cl/scielo.php?script=sci_stat&lng=<?php echo $lang ?>&nrm=iso" target="_blank">Chile</a></li>
						<li><a href="http://www.scielosp.org/scielo.php?script=sci_stat&lng=<?php echo $lang ?>&nrm=iso" target="_blank">Saúde Pública</a></li>
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
