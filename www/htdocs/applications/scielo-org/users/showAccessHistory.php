<?
	
	require_once(dirname(__FILE__)."/../classes/Article.php");
	require_once(dirname(__FILE__)."/functions.php");
	include_once(dirname(__FILE__)."/../include.php");
	include_once(dirname(__FILE__)."/langs.php");
	
	$dir = dirname(__FILE__);

	$site = parse_ini_file($dir."/../../../../ini/" . $lang . "/bvs.ini", true);

	$pid = $_GET['pid'];

	$bvsSiteIni = parse_ini_file(dirname(__FILE__)."/../../../bvs-site-conf.php",true);

	$baseDir = "";

	if($bvsSiteIni['ENVIRONMENT']['LETTER_UNIT'] != null){
		$baseDir = $bvsSiteIni['ENVIRONMENT']['LETTER_UNIT'].$bvsSiteIni['ENVIRONMENT']['DATABASE_PATH'];
	}else{
		$baseDir = $bvsSiteIni['ENVIRONMENT']['DATABASE_PATH'];
	}

	$article = new Article();

	$article->setPID($pid);
	$article->loadArticle();
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<title>
			<?= $site['title']?>
		</title>
		<? include($DirNameLocal."./head.php"); ?>
	</head>
	<body>
		<div class="container">	
				<? require_once($baseDir."html/" . $lang . "/bvs.html"); ?>
			<div class="content">
					<h3>
						<span>
							<?=ACCESS_STATS?>
						</span>
					</h3>
					<div>
					<?
							echo '<a target="_blank" href="'.$article->getUrl().'" >'.getTitle($article->getTitle())."<a/><br>\n";
							echo '</a></b>'."\n";
							echo '<i>';
							echo getAutors($article->getAuthorXML());
							echo '</i><br />';
							echo '<i>'.$article->getSerial(). ', '.$article->getYear().', vol:'.$article->getVolume();
							echo ', n. '.$article->getNumber().', ISSN '.substr($article->getPID(),1,9).'</i><br/><br/>'."\n";
						?>
					</div>
					<div>
						<img src="createAccessChart.php?pid=<?=$pid?>" />
						<br /><br />
					</div>
					<div>
						<a href="/users/myAlerts.php"><?=BUTTON_BACK?></a>
					</div>

			</div>
		<?require_once(dirname(__FILE__)."/../sgu/traker.php")?>
	</body>
</html>