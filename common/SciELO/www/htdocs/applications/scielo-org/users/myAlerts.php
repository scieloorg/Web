<?php
	ini_set("display_errors", "1");
	error_reporting(E_ALL ^E_NOTICE);

	ini_set("include_path",".");

	require_once(dirname(__FILE__)."/../classes/Shelf.php");
	require_once(dirname(__FILE__)."/../../../php/include.php");
	require_once(dirname(__FILE__)."/langs.php");
	require_once(dirname(__FILE__)."/functions.php");
	require_once(dirname(__FILE__)."/../classes/Shelf.php");

	$bvsSiteIni = parse_ini_file(dirname(__FILE__)."/../../../bvs-site-conf.php",true);

	$baseDir = "";

	if($bvsSiteIni['ENVIRONMENT']['LETTER_UNIT'] != null){
		$baseDir = $bvsSiteIni['ENVIRONMENT']['LETTER_UNIT'].$bvsSiteIni['ENVIRONMENT']['DATABASE_PATH'];
	}else{
		$baseDir = $bvsSiteIni['ENVIRONMENT']['DATABASE_PATH'];
	}

	$site = parse_ini_file(dirname(__FILE__)."/../../../ini/" . $lang . "/bvs.ini", true);

	$ini = parse_ini_file("../scielo.def", true);

	$home = $ini['this']['url'];

	ob_start("ob_gzhandler");
	session_start();

	if(!isset($_COOKIE['userID']))
		header("Location: ".$home);
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<title>
			<?= $site['title']?>
		</title>
		<? include(dirname(__FILE__)."/../../../php/head.php"); ?>
		
		<style>
			.result{
				overflow:-moz-scrollbars-horizontal;
				overflow-x:hidden;
				overflow-y:scroll;
				width:700px;
				height:200px;
			}
		</style>

		<script language="javascript">
		<!--
			function removeCitedAlert(url){
			/*Credit: JavaScript Kit www.javascriptkit.com more JavaScripts here.*/
			win=window.open(url,"","width=250,height=250,scrollbars=no")
			//interceptacao de erro na abertura da janela
			text = "Se a janela nao estava abrindo\ntalvez seja porque voce tenha um\nprograma bloqueador de pop-up!\nObservacao » O windows XP service pack 2\nbloqueia pop-ups!";
			if(win == null) { alert(text); return; }
			//fim
			win.moveTo(350,350);
			//win2.creator=self;
			}

			function removeAccessAlert(url){
			/*Credit: JavaScript Kit www.javascriptkit.com more JavaScripts here.*/
			win=window.open(url,"","width=250,height=250,scrollbars=no")
			//interceptacao de erro na abertura da janela
			text = "Se a janela nao estava abrindo\ntalvez seja porque voce tenha um\nprograma bloqueador de pop-up!\nObservacao » O windows XP service pack 2\nbloqueia pop-ups!";
			if(win == null) { alert(text); return; }
			//fim
			win.moveTo(350,350);
			//win2.creator=self;
			}
		
		//-->
		</script>
	</head>
	<body>
		<div class="container">
			<div class="level2">
				<? require_once($baseDir."html/" . $lang . "/bvs.html"); ?>
				<div class="middle">
					<div id="breadCrumb">
						<a href="/">
							home
						</a>
						&gt; <?=MY_ALERTS?> 
					</div>
					<div class="content">
							<h3>
								<span>
									<?=MY_ALERTS?>
								</span>
							</h3>
						<div class="articleList">
						<?
							$shelf = new Shelf();
		
							$shelf->setUserID($_COOKIE['userID']);
		
							$cited = $shelf->getCitedAlertList();
		
							$count_cited = count($cited);

							if($count_cited)
							{
								echo("<h5>".CITATIONS."</h5>");
								echo '<ul>'."\n";						
							}
		
							
							for($i = 0; $i < $count_cited; $i++)
							{
		
								$shelfCited = $cited[$i];
								$article = $shelfCited->getArticle();
		
								$article_cited_list = $article->getCitedList();
		
		
								echo '<li>';
								echo '<a target="_blank" href="'.$article->getUrl().'/scielo.php?script=sci_arttext&pid='.$article->getPID().'&lng='.$lang.'&nrm=iso&tlng='.$lang.'" >'.getTitle($article->getTitle())."</a><br/>\n";
								echo '</a></b>'."\n";
								echo '<i>';
								/*
								criando a lista de Autores do artigo
								do arquivo functions.php
								*/
								echo getAutors($article->getAuthorXML());
		
								echo '</i><br />'."\n";
								echo '<i>'.$article->getSerial(). ', '.$article->getYear().', vol:'.$article->getVolume();
								echo ', n. '.$article->getNumber().', ISSN '.substr($article->getPID(),1,9).'</i><br/>'."\n";

//								echo '<a class="remove" href="/services/removeCitedAlert.php?pid='.$article->getPID().'">'.REMOVE_ALERT.'</a> | ';

								//abrindo em um popUp!!!!
								echo '<a class="remove" href="#" onclick="removeCitedAlert(\'/applications/scielo-org/services/removeCitedAlert.php?pid='.$article->getPID().'\')">'.REMOVE_ALERT.'</a> | ';
								$url = (strstr($article->getURL(),"http://"))?($article->getURL()):("http://".$article->getURL());
								echo '<a onclick="javasctipt:window.open(\'\',\'mensagem\',\'toolbar=0,location=0,directories=0,status=0,scrollbars=1,menubar=1,resizable=0,width=800,height=480\');" target="mensagem" href="'.$url.'/scieloOrg/php/citedScielo.php?pid='.$article->getPID().'&lang='.$lang.'">'.CITED_BY.'</a>';
								echo '</li>';

								/*
		
								Retirado em 14/jun/2006 - ira a cessar os servicos on-the-fly, como no artigo, ao invez de acessar os dados do MySQL
								
								
								echo CITED_BY ." " .count($article_cited_list);
		
								if(count($article_cited_list) == 0)
									echo "<br><br>";
								
								if(count($article_cited_list))
								{
								
									echo ' | <a href="#" onclick="showhideLayers(\'cited'.$i.'\',\'ver\')">'.SEE.' <img id="ver" src="/image/common/expand.gif" /></a>' ;
									echo '<div id="cited'.$i.'" class="result" style="display:none;">';
		
									for($citedlist = 0; $citedlist < count($article_cited_list); $citedlist++){
										$art = $article_cited_list[$citedlist];
										echo '<ul class="citedBy">'."\n";
											echo '<a target="_blank" href="'.$art->getUrl().'" >'.getTitle($art->getTitle())."<a/><br>\n";
											echo '</a></b>'."\n";
											echo '<i>';
											/ *
											criando a lista de Autores do artigo
											do arquivo functions.php
											* /
											echo getAutors($art->getAuthorXML());
				
											echo '</i><br />'."\n";
										
											echo '<i>'.$art->getSerial(). ', '.$art->getYear().', vol:'.$art->getVolume();
											echo ', n. '.$art->getNumber().', ISSN '.substr($art->getPID(),1,9).'</i><br/>'."\n";
										echo "</ul>"."\n";
									}
									echo '</div>'."\n";
									echo "</p>"."\n";
								}
							*/
							}
		
							if($count_cited);
							{
								echo '</ul>'."\n";						
							}
		
		
							
							$accessed = $shelf->getAccessedAlertList();
		
							$accessed_count = count($accessed);
		
							if($accessed_count)
							{
								echo("<h5>".ACCESS_STATS."</h5>");
								echo "<ul>";
							}
		
							for($i = 0; $i < $accessed_count; $i++)
							{
		
		
								$shelfAccessed = $accessed[$i];
								$article = $shelfAccessed->getArticle();
		
								$article_accessed_list = $article->getAccessStatistics();
								
								echo '<li>';
								echo '<a target="_blank" href="'.$article->getUrl().'/scielo.php?script=sci_arttext&pid='.$article->getPID().'&lng='.$lang.'&nrm=iso&tlng='.$lang.'" >'.getTitle($article->getTitle())."</a><br>\n";
								echo getAutors($article->getAuthorXML())."<br>";
								$total = 0;
		
								for($c = 0; $c < count($article_accessed_list); $c++){
									$obj = $article_accessed_list[$c];
									$total = $total + intval($obj->getCount());
								}
//								echo '<a class="remove" href="/services/removeAccessAlert.php?pid='.$article->getPID().'">'.REMOVE_ALERT.'</a> | ';
								echo '<a class="remove" href="#" onclick="removeAccessAlert(\'/applications/scielo-org/services/removeAccessAlert.php?pid='.$article->getPID().'\')">'.REMOVE_ALERT.'</a> | ';
								$urlAccess = (strstr($article->getURL(),"http://"))?($article->getURL()):("http://".$article->getURL());
								echo '<a onclick="javasctipt:window.open(\'\',\'mensagem\',\'toolbar=0,location=0,directories=0,status=0,scrollbars=1,menubar=1,resizable=0,width=800,height=480\');" target="mensagem" href="'.$urlAccess.'/applications/scielo-org/pages/services/articleRequestGraphicPage.php?pid='.$article->getPID().'&caller='.$urlAccess.'&lang='.$lang.'" >'.SEE_HISTORY.'</a>';
								
								/*
		
								Retirado em 14/jun/2006 - ira a cessar os servicos on-the-fly, como no artigo, ao invez de acessar os dados do MySQL
		
								echo '<span class="lengthData"><strong>'.$total.'</strong> '.ACCESSES. ' </span> ';
								if($total)
								{
									echo '| <a href="showAccessHistory.php?pid='.$article->getPID().'" >'.SEE_HISTORY.'</a>';
								}
		
								*/
								echo '</li>';
		
							}
		
							if($accessed_count)
							{
								echo "</ul>";
							}
		
		
						?>
						</div>
						<!-- a href="/"><?=BUTTON_BACK?></a -->
					</div>
				</div>
			<div class="copyright">
				BVS Site 4.0-rc4 &copy; <a href="http://www.bireme.br/" target="_blank">BIREME/OPS/OMS</a>
			</div>
		</div>
	</div>
		<?require_once(dirname(__FILE__)."/../sgu/traker.php")?>
	</body>
</html>
<?
ob_end_flush();
?>
