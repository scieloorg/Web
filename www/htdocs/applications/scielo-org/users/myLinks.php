<?php
	ini_set("display_errors","1");
	error_reporting(E_ALL ^ E_NOTICE);
	
	ini_set("include_path",".");

	require_once(dirname(__FILE__)."/../classes/Links.php");
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

	$acao = $cgi["acao"];
	
	switch($acao)
	{
		case "remover":	
			$link = new Links();
			$link->setLink_id($cgi["linkId"]);
			$link->setUser_id($_COOKIE['userID']);
			$linkList = $link->removeLink();
			header("Location: myLinks.php");
		break;
		case "addInHome":
			$link = new Links();
			$link->setLink_id($cgi["linkId"]);
			$link->setUser_id($_COOKIE['userID']);
			$link->setInHome(1);
			$linkList = $link->addInHome();
			header("Location: myLinks.php");
		break;
		case "deleteFromHome":
			$link = new Links();
			$link->setLink_id($cgi["linkId"]);
			$link->setUser_id($_COOKIE['userID']);
			$link->setInHome(0);
			$linkList = $link->deleteFromHome();
			header("Location: myLinks.php");
		break;
	}
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
						&gt; <?=MY_LINKS?>
					</div>
					<div class="content">
						<h3>
							<span>
								<?=MY_LINKS?> <?=($params["sort"]=="rate" ? SHOW_BY_RATE : SHOW_BY_DATE)?>
							</span>
						</h3>
						<div class="articleList">
							<div class="topicFolder">
							<?
								//echo "DIRECTORY_ID ".$_COOKIE['directory_id'];
								$link = new Links();
								$link->setUser_id($_COOKIE['userID']);
								$total = $link->getTotalPages();
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

								$linkList = $link->getLinkList($page,$params);
								echo "<ul>";
								for($i = 0; $i < count($linkList); $i++)
								{
									$link_id = $linkList[$i]->getLink_id();
									$name = $linkList[$i]->getName();
									$description = $linkList[$i]->getDescription();
									$rate = $linkList[$i]->getRate();
									$url = $linkList[$i]->getUrl();
									$inHome = $linkList[$i]->getInHome();
								?>
								<li>
									<div class="rank">
										<A href="javascript: void(0);"><IMG id="star<?=$i?>_1" src="../image/public/skins/classic/common/starOff.gif" onClick="doImage('star<?=$i?>_1','../image/public/skins/classic/common/starOn.gif');doImage('star<?=$i?>_2','../image/public/skins/classic/common/starOff.gif');doImage('star<?=$i?>_3','../image/public/skins/classic/common/starOff.gif');callUpdateLinkRate(<?=$link_id?>,1);"/></A><A href="javascript: void(0);"><IMG id="star<?=$i?>_2" src="../image/public/skins/classic/common/starOff.gif" onClick="doImage('star<?=$i?>_1','../image/public/skins/classic/common/starOn.gif');doImage('star<?=$i?>_2','../image/public/skins/classic/common/starOn.gif');doImage('star<?=$i?>_3','../image/public/skins/classic/common/starOff.gif');callUpdateLinkRate(<?=$link_id?>,2);"/></A><A href="javascript: void(0);"><IMG id="star<?=$i?>_3" src="../image/public/skins/classic/common/starOff.gif" onClick="doImage('star<?=$i?>_1','../image/public/skins/classic/common/starOn.gif');doImage('star<?=$i?>_2','../image/public/skins/classic/common/starOn.gif');doImage('star<?=$i?>_3','../image/public/skins/classic/common/starOn.gif');callUpdateLinkRate(<?=$link_id?>,3);"/></A>
										<script>
										lightingStars(<?=$i?>,<?=$rate?>);
										</script>
									</div>
									<div class="articleBlock">
										<b>
											<a href="<?=$url?>" target="_blank">
												<?=$name?>
											</a>
										</b>
										<br/>
										<i>
											<?=$url?>
										</i>
										<br/>
										<div class="comments">
											<?=$description?>
										</div>
										<p class="actions">
											<a class="deleteLink" href="myLinks.php?linkId=<?=$link_id?>&acao=remover" onclick="javascript: as=confirm('<?=DO_YOU_REALY_WANT_TO_REMOVE_IT?>'); if(as!=true) return false;"><?=REMOVE_LINK?></a> | 
											<a class="editLink" href="javascript: void(0);" onclick="window.open('editLink.php?linkId=<?=$link_id?>&acao=editar','','resizable=no,scrollbars=1,width=420,height=420')"><?=EDIT_LINK?></a> |
											<?if ($inHome == 1){?>
												<a class="removeFromHome" href="myLinks.php?linkId=<?=$link_id?>&acao=deleteFromHome" onclick="javascript: as=confirm('<?=DO_YOU_REALY_WANT_TO_REMOVE_IT?>'); if(as!=true) return false;"><?=REMOVE_FROM_HOME_PAGE?></a> <!--PUBLISH_IN_HOME_PAGE--> <!--addHome-->
											<?}else{?>
												<a class="addToHome" href="myLinks.php?linkId=<?=$link_id?>&acao=addInHome"><?=PUBLISH_IN_HOME_PAGE?></a> <!--PUBLISH_IN_HOME_PAGE--> <!--addHome-->											
											<?}?>
										</p>
									</div>
								</li>
								<?}?><!-- fim do for -->
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
					
					<DIV class="serviceColumn">
						<DIV class="webServices"><H3><SPAN><?=TOOLS?></SPAN></H3>
							<DIV id="rssFeeds">
								<UL>
									<LI>
										<A href="javascript: void(0);" onclick="window.open('editLink.php','','resizable=no,scrollbars=1,width=420,height=400')">
										<IMG src="../image/public/skins/classic/common/link_add.gif"/>
										<?=ADD_LINK?>
										</A>
									</LI>

								</UL>
							</DIV>
						</DIV> <!-- end webServices -->
						<DIV class="webServices"><H3><SPAN><?=VIEW_BY?></SPAN></H3>
							<DIV id="sortedBy">
								<UL>
									<LI><A href="?sort=date">
												<?=DATE_SORT?>
											</A></LI>
									<LI><A href="?sort=rate">
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
