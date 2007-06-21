<?php
	ini_set("display_errors","1");

	require_once(dirname(__FILE__)."/../classes/News.php");
	require_once(dirname(__FILE__)."/../includes/lastRSS/lastRSS.php");
	require_once(dirname(__FILE__)."/../../../php/include.php");
	require_once(dirname(__FILE__)."/langs.php");
	require_once(dirname(__FILE__)."/functions.php");

	$bvsSiteIni = parse_ini_file(dirname(__FILE__)."/../../../bvs-site-conf.php",true);

	$baseDir = "";

	if($bvsSiteIni['ENVIRONMENT']['LETTER_UNIT'] != null){
		$baseDir = $bvsSiteIni['ENVIRONMENT']['LETTER_UNIT'].$bvsSiteIni['ENVIRONMENT']['DATABASE_PATH'];
	}else{
		$baseDir = $bvsSiteIni['ENVIRONMENT']['DATABASE_PATH'];
	}

	if($_COOKIE['userID'] == "")
	{
		Header("Location: /");
	}

	$DirNameLocal=dirname(__FILE__).'/';
	
	/*
		adicionando a noticia pelo postBack
	*/

	if(isset($_GET['remove_home_page']))
	{
		$news = new News();
		$news->setUserID($_COOKIE['userID']);
		$news->setID($_GET['remove_home_page']);
		$news->setInHome('0');
		$news->updateNews();
		header("Location: http://" . $_SERVER['HTTP_HOST']. dirname($_SERVER['PHP_SELF']). "/myNews.php");
		exit;
 	}

	if(isset($_POST['rss_url']))
	{
		$news = new News();
		$news->setUserID($_COOKIE['userID']);
		$news->setRSSURL($_POST['rss_url']);
		$news->setInHome(false);
		$news->addNews();
		header("Location: http://" . $_SERVER['HTTP_HOST']. dirname($_SERVER['PHP_SELF']). "/myNews.php");
		exit;
 	}

	if(isset($_POST['remove_news_id']))
	{
		$news = new News();
		$news->setUserID($_COOKIE['userID']);
		$news->setID($_POST['remove_news_id']);
		$news->removeNews();
		header("Location: http://" . $_SERVER['HTTP_HOST']. dirname($_SERVER['PHP_SELF']). "/myNews.php");
		exit;
 	}


	if(isset($_GET['feed']))
	{
		$news = new News();
		$news->setUserID($_COOKIE['userID']);
		$news->setID($_GET['feed']);
		$news->showInHome();
		header("Location: http://" . $_SERVER['HTTP_HOST']. dirname($_SERVER['PHP_SELF']). "/myNews.php?news_id=".$_GET['feed']);
		exit;
 	}

	$site = parse_ini_file(dirname(__FILE__)."/../../../ini/" . $lang . "/bvs.ini", true);

	$ini = parse_ini_file($DirNameLocal."../scielo.def", true);

	$home = $ini['this']['url'];

	if(!isset($_COOKIE['userID']))
		header("Location: ".$home);

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
		<? include(dirname(__FILE__)."/../../../php/head.php"); ?>

		<script language="JavaScript" src="../js/validator.js"></script>
		
		<script language="JavaScript1.2">

			function confirmDelete(rss_id,question) {
				if (confirm(question)) {
					document.removeNews.remove_news_id.value = rss_id;
					document.removeNews.submit();
				} else {
				  return false;
				}
			}
		</script>
		<meta http-equiv="Pragma" content="no-cache" />
		<meta http-equiv="Expires" content="-1"/>
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
						&gt; <?=MY_NEWS?> 
					</div>
					<div class="content">
							<h3>
								<span>
									<?=MY_NEWS?>
								</span>
							</h3>
						<div class="myNews">
						<form name="removeNews" id="removeNews" method="post" action="myNews.php" onsubmit="alert('asd')">
							<input type="hidden" name="remove_news_id" />
						</form>
							<?

							$news = new News();
							$news->setUserID($_COOKIE['userID']);
							$newsList = $news->getNewsList($page);

							$rss = new lastRSS;
							$rss->cache_dir = $baseDir."/rss/";
							$rss->cache_time = 1200;
							$rss->CDATA = "content";

							echo "<ul>";
							
							$titlesRSS = array();

/**
*	Correndo todos os RSSs e pegando o titulo para mostrar na caixa auxiliar
*/

							for($i = 0; $i < count($newsList); $i++)
							{
								$news = $newsList[$i];

								/**
								*	Pegando a URL do RSS
								*/
								$url = $news->getRSSURL();

								/**
								*	descobrindo o encoding do RSS . . .
								*/
								$fp = fopen($url,"rb");
								$line = fgets($fp,1024);
								fclose($fp);
								$line = trim($line);
								$line = substr($line,2,	strpos($line,'>')-1);
								$arr = split("\ ",$line);
								$encoding = split("\=",$arr[2]);
								$encoding = str_replace("\"","",$encoding[1]);
								$encoding = strtolower(str_replace("?>","",$encoding));

								// Set cache dir and cache time limit (1200 seconds)
								// (don't forget to chmod cahce dir to 777 to allow writing)
								$rss->cache_dir = $baseDir."/rss/";
								$rss->cache_time = 1200;
								$rss->CDATA = "content";

								if ($rs = $rss->get($url)) {
							
									if ($encoding=='utf-8'){
										$titleRSS = utf8_decode($rs[title]);
									}else{
										$titleRSS = $rs[title];
									}

									array_push($titlesRSS,array($titleRSS,$news->getID()));
								}
							}

/**
*	Exibindo os RSSs de acordo com o critério, Todos ou Um selecionado, ou o 1o da lista (qnd se entra na pagina na 1a vez)
*/
							for($i = 0; $i < count($newsList); $i++)
							{
								$news = $newsList[$i];

								/**
								*	Pegando a URL do RSS
								*/
								$url = $news->getRSSURL();

								/**
								*	descobrindo o encoding do RSS . . .
								*/
								$fp = fopen($url,"rb");
								$line = fgets($fp,1024);
								fclose($fp);
								$line = trim($line);
								$line = substr($line,2,	strpos($line,'>')-1);
								$arr = split("\ ",$line);
								$encoding = split("\=",$arr[2]);
								$encoding = str_replace("\"","",$encoding[1]);
								$encoding = strtolower(str_replace("?>","",$encoding));


								if ($rs = $rss->get($url)) {
							
									if ($encoding=='utf-8'){
										$titleRSS = utf8_decode($rs[title]);
									}else{
										$titleRSS = $rs[title];
									}

									if(
										(($news->getID() != $_GET['news_id']) && isset($_GET['news_id']))
//											||
//										((!$news->getInHome()) && (!isset($_GET['all'])))
									)
										continue;

?>
							<h4>
								<span>
<?

									if ($rs[image_url] != '') {
										echo "<img src=\"$rs[image_url]\" alt=\"$rs[image_title]\" vspace=\"1\" border=\"0\" />\n";
									}
								
									echo 	$titleRSS;

									?>
								</span>
							</h4>
							<div class="folderTools">
								<ul>
									<li>
									<?
										if(!$news->getInHome())
									{?>
											<a href="?feed=<?=$news->getID()?>"><img src="../image/public/skins/classic/common/addToHome.gif"><?=PUBLISH_IN_HOME_PAGE?></img></a>
									<?}else{?>
											<a href="?remove_home_page=<?=$news->getID()?>"><img src="../image/public/skins/classic/common/removeFromHome.gif"><?=REMOVE_FROM_HOME_PAGE?></img></a >
									<?}?>
									</li>
									<li>
										<a href="#" onclick="javascript:confirmDelete('<?=$news->getID()?>','<?=REMOVE_FEED_CONFIRM?>')"><img src="../image/public/skins/classic/common/folder_delete.gif"><?=REMOVE_FEED?></a>
									</li>
								</ul>
							</div>
							<?
									echo "<ul>\n";
									/**
									*	constantes para a conversao de entidades HTML &lt; &quot; etc... para os caracteres "verdadeiros" 
									*	mantendo assim a formatação original do Item
									*/
									$trans = get_html_translation_table(HTML_ENTITIES);
									$trans = array_flip($trans);

									foreach($rs['items'] as $item) {
										$original = strtr($encoded, $trans);

										$description = strtr($item['description'], $trans);
										$title = $item['title'];

										if($encoding == "utf-8"){
											$description = utf8_decode($description);
											$title = utf8_decode($title);
										}
										echo "\t<li><strong><a href=\"$item[link]\" target=\"_balnk\">".$title."</a></strong><br />".$description."</li>\n";
									}
									echo "</ul>\n";
								}else {
									if($url != '')
									{
										?>
										<h4>
											<span>
												<?=RSS_PROBLEM." - ".$url?>
											</span>
										</h4>
										<div class="folderTools">
											<ul>
												<li>
												<?
													if(!$news->getInHome())
												{?>
														<a href="?feed=<?=$news->getID()?>"><img src="../image/public/skins/classic/common/addToHome.gif"><?=PUBLISH_IN_HOME_PAGE?></img></a>
												<?}else{?>
														<a href="?remove_home_page=<?=$news->getID()?>"><img src="../image/public/skins/classic/common/removeFromHome.gif"><?=REMOVE_FROM_HOME_PAGE?></img></a >
												<?}?>
												</li>
												<li>
													<a href="#" onclick="javascript:confirmDelete('<?=$news->getID()?>','<?=REMOVE_FEED_CONFIRM?>')"><img src="../image/public/skins/classic/common/folder_delete.gif"><?=REMOVE_FEED?></a>
												</li>
											</ul>
										</div>									
									<?
									}

								} 
							}
							?>
							</ul>
						</div>

					</div>
					<div class="serviceColumn">
					<div class="webServices">
						<h3>
							<span>
								<?=TOOLS?>
							</span>
						</h3>
						<div id="rssFeeds">
							<ul>
								<li>
									<img src="../image/public/skins/classic/common/add-item-red.gif"> <?=ADD_FEED?>
									<div id="addRSS">
										<form name="addRssFeed" action="" method="post" onsubmit="return v.exec();">
											<input name="rss_url" class="expression" type="text">
											<span id="emailMsg" class="tfvNormal"><?=FIELD_EMAIL_ERROR_DESCRIPTION?></span>
											<input value="<?=ADD?>" name="submit" class="submit" type="submit">
										</form>
									</div>
								</li>
							</ul>
						</div>
					</div>
					<?
					if(count($titlesRSS) > 0)
					{
					?>
					<div class="webServices">
						<h3>
							<span>
								Visualizar RSS
							</span>
						</h3>
						<ul>
							<?

							foreach($titlesRSS as $obj){
							?>
								<li>
									<a href="?news_id=<?=$obj[1]?>" > <?=$obj[0]?></a>
								</li>
							<?
							}
							?>
								<li>
									<a href="?all" ><?=ALL_FEEDS?></a>
								</li>
						</ul>
						<?
						}
						?>
					</div>					
				</div>
			</div>
			<div class="copyright">
				BVS Site 4.0-rc4 &copy; <a href="http://www.bireme.br/" target="_blank">BIREME/OPS/OMS</a>
			</div>
		</div>
<!--
JS para a validação do formulário
-->
			<script>
			// form fields description structure
			var a_fields = {
				'rss_url': {
					'l': 'Feed Url',  // label
					'r': true,    // required
					'f': 'url',  // format (see below)
					't': 'emailMsg',// id of the element to highlight if input not validated
					'm': null,     // must match specified form field
					'mn': 3,       // minimum length
					'mx': 1000       // maximum length
				}
			};

			o_config = {
				'to_disable' : [],
				'alert' : 1
			};

			// validator constructor call
			var v = new validator('addRssFeed', a_fields, o_config);

			</script>
		<?require_once(dirname(__FILE__)."/../sgu/traker.php")?>
	</body>
</html>
<?
ob_end_flush();
?>
