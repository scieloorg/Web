<?php
	ini_set("display_errors","1");
	error_reporting(E_ALL ^ E_NOTICE ^E_WARNING);
	
	ini_set("include_path",".");

	require_once(dirname(__FILE__)."/../classes/Shelf.php");
	require_once(dirname(__FILE__)."/../classes/UserDirectory.php");
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

	$site = parse_ini_file(dirname(__FILE__)."/../../../ini/" . $lang . "/bvs.ini", true);

	$ini = parse_ini_file(dirname(__FILE__)."/../scielo.def.php", true);
	$home = $ini['this']['url'];
	session_start();
	
	if(!isset($_COOKIE['userID']))
		header("Location: ".$home);

	//vars get/post
	$cgi = array_merge($_GET,$_POST);
	
	if(isset($_COOKIE['sortType'])){
		if (isset($cgi["sort"]))
		{
			$params = array("sort" => $cgi["sort"]);
			setcookie("sortType", $cgi["sort"]);
		}else{
			$params = array("sort" => $_COOKIE['sortType']);
		}
	}else{
		if (isset($cgi["sort"]))
		{
			$params = array("sort" => $cgi["sort"]);
			setcookie("sortType",$cgi["sort"]);
		}else{
			$params = array("sort" => "rate");
			setcookie("sortType","rate");
		}
	}
	if (isset($cgi['directory_id']) and ($cgi['directory_id'] != $_COOKIE['directory_id']))
		$_COOKIE['directory_id'] = $cgi['directory_id'];

	ob_start("ob_gzhandler");
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<title>
			<?= $site['title']?>
		</title>
		<? include(dirname(__FILE__)."/../../../php/head.php"); ?>
		
		<script language="javascript">
			function removeFromShelf(url){
			/*Credit: JavaScript Kit www.javascriptkit.com more JavaScripts here.*/
			win=window.open(url,"","width=250,height=250,scrollbars=no")
			//interceptacao de erro na abertura da janela
			text = "Se a janela nao estava abrindo\ntalvez seja porque voce tenha um\nprograma bloqueador de pop-up!\nObservacao » O windows XP service pack 2\nbloqueia pop-ups!";
			if(win == null) { alert(text); return; }
			//fim
			win.moveTo(350,350);
			//win2.creator=self;
			}
		</script>
		<SCRIPT language="JavaScript" src="../js/script.js"></SCRIPT>
		<SCRIPT language="JavaScript" src="../js/httpAjaxHandler.js"></SCRIPT>		
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
						&gt; <?=MY_SHELF?>
					</div>
					<div class="content">
						<h3>
							<span>
								<?=MY_SHELF?> <?=($params["sort"]=="rate" ? SHOW_BY_RATE : SHOW_BY_DATE)?>
							</span>
						</h3>
						<div class="articleList">
							<?
								$directory = new UserDirectory();
								if (isset($_COOKIE['directory_id']) and ($_COOKIE['directory_id'] != 0)){
									$directory->setUser_id($_COOKIE['userID']);
									$directory->setDirectory_id($_COOKIE['directory_id']);
									$directoryItem = $directory->getDirectory($directory);
									if (count($directoryItem) > 0){
										$directoryName = $directoryItem[0]->getName();
									}else{
										$directoryName = INCOMING_FOLDER;
										$_COOKIE['directory_id'] = 0;
									}
								}else{
									$directoryName=INCOMING_FOLDER;
									$_COOKIE['directory_id'] = 0;
								}
								
							?>
							<div class="topicFolder"><H4><IMG src="../image/public/skins/classic/common/articleFolder.gif"/><SPAN><?=$directoryName?></SPAN></H4>
							<? if ($_COOKIE['directory_id'] != 0) {?>
							<div class="folderTools">
								<UL>
									<LI><A href="javascript: void(0);" onclick="window.open('editDirectory.php?acao=editar&directory_id=<?=$_COOKIE['directory_id']?>','','resizable=no,scrollbars=1,width=420,height=280')"><IMG src="../image/public/skins/classic/common/folder_edit.gif"/><?=EDIT_FOLDER?></A></LI>
									<LI><A href="javascript: void(0);" onClick="window.open('removeDirectory.php?acao=editar&removeDir=<?=$_COOKIE['directory_id']?>','','resizable=no,scrollbars=1,width=420,height=280')"><IMG src="../image/public/skins/classic/common/folder_delete.gif"/><?=DELETE_FOLDER?></A></LI>
								</UL>
							</div> <!-- end folderTools -->
							<?}
								//echo "DIRECTORY_ID ".$_COOKIE['directory_id'];
								$shelf = new Shelf();
								$shelf->setUserID($_COOKIE['userID']);
								$shelf->setDirectory($_COOKIE['directory_id']);
								$total = $shelf->getTotalPages();
								$page = $_GET['page']?$_GET['page']:0;
								if($page < 0)
									$page = 0;
								if (($total) && ($page > $total -1)){
									$page = $total - 1;
								}
								if($total > 1)
								{
									echo '<div class="pagination">';
									if($page != 0){
										echo '<a href="?page=0">'.FIRST_PAGE.'</a> ';
									}else{
										echo '<b>'.FIRST_PAGE.'</b> ';
									}
									for($i=0;$i < $total;$i++ ){
										if($page != $i){
											echo ' <a href="?page='.$i.'&directory_id='.$_COOKIE['directory_id'].'">'.($i+1).'</a> ';
										}else{
											echo ' <b>'.($i+1).'</b>';
										}
									}
									if($page != ($total-1)){
										echo ' <a href="?page='.($total-1).'&directory_id='.$_COOKIE['directory_id'].'">'.LAST_PAGE.'</a>';
									}else{
										echo ' <b>'.LAST_PAGE.'</b> ';
									}
									echo "</div>";
								}
								$shelfList = $shelf->getListShelf($page,$params);
								echo "<ul>";
								for($i = 0; $i < count($shelfList); $i++)
								{
									$article = $shelfList[$i]->getArticle();
									$shelf_id = $shelfList[$i]->getShelf_id();
									$rate = $shelfList[$i]->getRate();
			/*
			pegando o título do artigo no Lang corrente, se não pega o titulo q tiver hehehe
			do arquivo functions.php
			*/
									$url = strpos($article->getUrl(),"http://")?$article->getUrl():("http://".$article->getUrl());
									echo '<li>';
									?>
									<div class="rank">
										<A href="javascript: void(0);"><IMG id="star<?=$i?>_1" src="../image/public/skins/classic/common/starOff.gif" onClick="doImage('star<?=$i?>_1','../image/public/skins/classic/common/starOn.gif');doImage('star<?=$i?>_2','../image/public/skins/classic/common/starOff.gif');doImage('star<?=$i?>_3','../image/public/skins/classic/common/starOff.gif');callUpdateArticleRate(<?=$shelf_id?>,1);"/></A><A href="javascript: void(0);"><IMG id="star<?=$i?>_2" src="../image/public/skins/classic/common/starOff.gif" onClick="doImage('star<?=$i?>_1','../image/public/skins/classic/common/starOn.gif');doImage('star<?=$i?>_2','../image/public/skins/classic/common/starOn.gif');doImage('star<?=$i?>_3','../image/public/skins/classic/common/starOff.gif');callUpdateArticleRate(<?=$shelf_id?>,2);"/></A><A href="javascript: void(0);"><IMG id="star<?=$i?>_3" src="../image/public/skins/classic/common/starOff.gif" onClick="doImage('star<?=$i?>_1','../image/public/skins/classic/common/starOn.gif');doImage('star<?=$i?>_2','../image/public/skins/classic/common/starOn.gif');doImage('star<?=$i?>_3','../image/public/skins/classic/common/starOn.gif');callUpdateArticleRate(<?=$shelf_id?>,3);"/></A>
										<script>
										lightingStars(<?=$i?>,<?=$rate?>);
										</script>
									</div>
									<?
									echo '<div class="articleBlock"><b><a target="_blank" href="'.$url.'/scielo.php?script=sci_arttext&pid='.$article->getPID().'&lng='.$lang.'&nrm=iso&tlng='.$lang.'" >'.getTitle($article->getTitle())."</a>\n";
									echo '</a></b><br />'."\n";
									echo '<i>';
			/*
			criando a lista de Autores do artigo
			do arquivo functions.php
			*/
									echo getAutors($article->getAuthorXML(),true,$article->getURL());
									echo '</i><br />';
									
									echo '<i>'.$article->getSerial(). ', '.$article->getYear().', vol:'.$article->getVolume();
									echo ', n. '.$article->getNumber().', ISSN '.substr($article->getPID(),1,9).'</i>';
									?>
									<p class="actions">
									<?if($shelfList[$i]->getAccessStat() == 1)
									{?>
										<span class="trackAccess"><?=MONITORED_ACCESS?></span>
									<?}
									if($shelfList[$i]->getCitedStat() == 1)
									{
									?>								
										<span class="trackCitation"><?=MONITORED_CITATIONS?></span>
									<?}?>
										<br />
										<a class="remove" href="javascript: void(0);" onclick="removeFromShelf('/applications/scielo-org/services/removeArticleFromShelf.php?PID=<?=$article->getPID()?>')"><?=REMOVE_FROM_SHELF?></a> | 
										<a class="move" href="javascript: void(0);" onclick="window.open('moveToDirectory.php?shelf_id=<?=$shelf_id?>','','resizable=no,width=420,height=420')"><?=MOVE_TO?></a>
									</p>
									<?
									echo ("</div>");
									echo("</li>"."\n");
								}
								?>
								</ul>
								<DIV class="empty">	&#160;
								</DIV>								
								<?
								if($total > 1)
								{
	
									echo '<div class="pagination">';
	
									if($page != 0){
										echo '<a href="?page=0">'.FIRST_PAGE.'</a> ';
									}else{
										echo '<b>'.FIRST_PAGE.'</b> ';
									}
	
									for($i=0;$i < $total;$i++ ){
	
										if($page != $i){
											echo ' <a href="?page='.$i.'&directory_id='.$_COOKIE['directory_id'].'">'.($i+1).'</a> ';
										}else{
											echo ' <b>'.($i+1).'</b>';
										}
									}
		
									if($page != ($total-1)){
										echo ' <a href="?page='.($total-1).'&directory_id='.$_COOKIE['directory_id'].'">'.LAST_PAGE.'</a>';
									}else{
										echo ' <b>'.LAST_PAGE.'</b> ';
									}
	
									echo "</div>";
								}
								?>
							</div> <!-- end topicFolder -->
						</div> <!-- end articlelist -->
						<!-- a href="../"><?=BUTTON_BACK?></a -->
					</div> <!-- end content -->
					
					<?
					$directory->setUser_id($_COOKIE['userID']);
					$directoryList = $directory->getDirectoryList($directory);
					?>
					<DIV class="serviceColumn">
						<DIV class="webServices"><H3><SPAN><?=MY_FOLDERS?></SPAN></H3>
							<DIV id="rssFeeds">
								<UL>
									<LI><A href="javascript: void(0);" onclick="window.open('editDirectory.php','','resizable=no,width=420,height=280')"><IMG src="../image/public/skins/classic/common/add-folder-orange.gif"/><?=ADD_FOLDER?></A></LI>								
									<LI><A href="myShelf.php?directory_id=0"><IMG src="../image/public/skins/classic/common/folder.gif"/><?=INCOMING_FOLDER?></A></LI>
									<?
									for($i = 0; $i < count($directoryList); $i++)
									{
										$directoryName = $directoryList[$i]->getName();
										$directory_id = $directoryList[$i]->getDirectory_id();
									?>
										<LI><A href="myShelf.php?directory_id=<?=$directory_id?>"><IMG src="../image/public/skins/classic/common/folder.gif"/><?=$directoryName?></A></LI>
									<?}?>
								</UL>
							</DIV>
						</DIV> <!-- end webServices -->
						<DIV class="webServices"><H3><SPAN><?=VIEW_BY?></SPAN></H3>
							<DIV id="sortedBy">
								<UL>
									<LI><A href="?sort=date&directory_id=<?=$_COOKIE['directory_id']?>">
												<?=DATE_SORT?>
											</A></LI>
									<LI><A href="?sort=rate&directory_id=<?=$_COOKIE['directory_id']?>">
												<?=MY_RANKING?>
											</A></LI>
								</UL>
							</DIV>
						</DIV> <!-- end webServices -->
					</DIV> <!-- end serviceColumn -->				
				</div><!-- end middle -->
			</div> <!-- end level2 -->
			<div class="copyright">
				BVS Site 4.0-rc4 &copy; <a href="http://www.bireme.br/" target="_blank">BIREME/OPS/OMS</a>
			</div> 
		</div><!-- end container -->
		<?require_once(dirname(__FILE__)."/../sgu/traker.php")?>
	</body>
</html>

<?
ob_end_flush();
?>
