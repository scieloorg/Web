<?php

	require_once(dirname(__FILE__)."/../classes/Shelf.php");

	require_once(dirname(__FILE__)."/../../../php/include.php");

	$DirHtml = realpath(dirname(__FILE__) . "..") . "/html/" .$lang . "/";
	$site = parse_ini_file(dirname(__FILE__)."/../../../../ini/" . $lang . "/bvs.ini", true);

	require_once(dirname(__FILE__)."/langs.php");
	require_once(dirname(__FILE__)."/functions.php");

	$bvsSiteIni = parse_ini_file(dirname(__FILE__)."/../../../bvs-site-conf.php",true);

	$baseDir = "";

	if($bvsSiteIni['ENVIRONMENT']['LETTER_UNIT'] != null){
		$baseDir = $bvsSiteIni['ENVIRONMENT']['LETTER_UNIT'].$bvsSiteIni['ENVIRONMENT']['DATABASE_PATH'];
	}else{
		$baseDir = $bvsSiteIni['ENVIRONMENT']['DATABASE_PATH'];
	}

	$DirNameLocal = dirname(__FILE__).'/';
	
	$ini = parse_ini_file($DirNameLocal."../scielo.def", true);

	$home = $ini['this']['url'];

	if(!isset($_COOKIE['userID']))
		header("Location: ".$home);

/*
compressão GZip da página
*/
	ob_start("ob_gzhandler");
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
	</head>
	<body>
		<div class="container">
			<div class="level2">
				<? require_once($baseDir."html/" . $lang . "/bvs.html"); ?>
				<div class="middle">
					<div id="breadCrumb">
						<a href="../">
							home
						</a>
						&gt; <?=MY_SHELF?> 
					</div>
					<div class="content">
							<h3>
								<span>
									<?=MY_SHELF?>
								</span>
							</h3>
						<div class="articleList">
							<ul>
							<?
							$shelf = new Shelf();
		
							$shelf->setUserID($_COOKIE['userID']);
		
							$shelfList = $shelf->getListShelf();
		
							for($i = 0; $i < count($shelfList); $i++)
							{
								$article = $shelfList[$i]->getArticle();
								echo '<li><b><a target="_blank" href="'.$article->getURL().'">';
		
		/*
		pegando o título do artigo no Lang corrente, se não pega o titulo q tiver hehehe
		do arquivo functions.php
		*/
								echo getTitle($article->getTitle());
								echo '</a></b><br />'."\n";
								echo '<i>';
		/*
		criando a lista de Autores do artigo
		do arquivo functions.php
		*/
								echo getAutors($article->getAuthorXML());
		
								echo '</i><br />';
								
								echo '<i>'.$article->getSerial(). ', '.$article->getYear().', vol:'.$article->getVolume();
								echo ', n. '.$article->getNumber().', ISSN '.substr($article->getPID(),1,9).'</i><br/>'."\n";
								
								echo '<a href="/services/removeArticleFromShelf.php?PID='.$article->getPID().'">'.REMOVE_FROM_SHELF."</a>\n";
		
								if($shelfList[$i]->getAccessStat() == 1)
								{
									echo " <br><b><i>Esse artigo esta com os acessos monitorados</i></b> \n";
								}
		
								if($shelfList[$i]->getCitedStat() == 1)
								{
									echo " <br><b><i>Esse artigo esta com as citações monitoradas</i></b> \n";
								}
		
								echo("</li>"."\n");
							}
							?>
							</ul>
						</div>
						<a href="/index.php"><?=BUTTON_BACK?></a>
					</div>
					<div class="copyright">
						BVS Site 4.0-rc4 &copy; <a href="http://www.bireme.br/" target="_blank">BIREME/OPS/OMS</a>
					</div>
				</div>
			</div>
		</div>
	</body>
</html>

<?
ob_end_flush();
?>
