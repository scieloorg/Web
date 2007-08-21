<?php

require_once(dirname(__FILE__)."/../users/langs.php");
require_once(dirname(__FILE__)."/../../../php/include.php");

$origem = $_SERVER['HTTP_REFERER'];

$scielodef = parse_ini_file(dirname(__FILE__)."/../scielo.def", true);

if(!$origem)
    $origem = $scielodef['scielo_org_urls']['home'];

	$bvsSiteIni = parse_ini_file(dirname(__FILE__)."/../../../bvs-site-conf.php",true);

	$baseDir = "";

	if($bvsSiteIni['ENVIRONMENT']['LETTER_UNIT'] != null){
		$baseDir = $bvsSiteIni['ENVIRONMENT']['LETTER_UNIT'].$bvsSiteIni['ENVIRONMENT']['DATABASE_PATH'];
	}else{
		$baseDir = $bvsSiteIni['ENVIRONMENT']['DATABASE_PATH'];
	}

ob_start();

?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<title>
			<?=LOGOUT_DONE?>
		</title>
			<? require_once(dirname(__FILE__)."/../../../php/head.php"); ?>
	</head>
	<div class="container">
		<div class="level2">
			<? require_once($baseDir . "/html/" . $lang . "/bvs.html"); ?>
			<div class="middle">
				<div class="content">
					<h3>
						<?=LOGOUT_DONE?>
					</h3>
					<a href="<?=$origem?>"><?=BUTTON_BACK?></a>
				</div>
			</div>
		</div>
	</div>
	<?
		$logouURLs = $scielodef['logout_urls'];

		foreach($logouURLs as $url)
		{
	?>
			<iframe src="<?=$url?>" width="0" height="0" frameborder="0"></iframe>
	<?
		}
	?>
</body>
</html>

<?

ob_flush();

?>