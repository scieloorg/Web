<?php

    ini_set("include_path",".");

    $DirNameLocal=dirname(__FILE__);
	
    require_once("../classes/MyProfileArticle.php");
    require_once("langs.php");
    require_once("functions.php");    
    require_once("../../../php/include.php");

	$bvsSiteIni = parse_ini_file(dirname(__FILE__)."/../../../bvs-site-conf.php",true);

	$baseDir = "";

	if($bvsSiteIni['ENVIRONMENT']['LETTER_UNIT'] != null){
		$baseDir = $bvsSiteIni['ENVIRONMENT']['LETTER_UNIT'].$bvsSiteIni['ENVIRONMENT']['DATABASE_PATH'];
	}else{
		$baseDir = $bvsSiteIni['ENVIRONMENT']['DATABASE_PATH'];
	}

    $site = parse_ini_file($DirNameLocal."../ini/" . $lang . "/bvs.ini", true);

	$dir = dirname(__FILE__);
	$ini = parse_ini_file($dir."/../scielo.def.php" , true);

	$home = $ini['this']['url'];

    if(!isset($_COOKIE['userID']))
        header("Location: ".$url);

    $article_profile = new MyProfileArticle();
    $article_profile->setUserID($_COOKIE['userID']);
    $article_profile_list = $article_profile->getMyProfileArticleList();
    $profile_list = $article_profile->getMyProfiles();

    if (count($profile_list)>0)
    {
        if (isset($_GET['profile_id']))
        {
            //die(var_dump($profile_list));
            //die("f:".array_search(88,$profile_list[88]));
            $profile_id = $_GET['profile_id'];
            while (list($key, $array_value) = each($profile_list)) {
                if ($profile_id == $array_value['profile_id']) break;
            }
            $profile_name = $profile_list[$key]['profile_name'];

        }
        else
        {
            $profile_id = $profile_list[0]['profile_id'];
            $profile_name = $profile_list[0]['profile_name'];
        }
    }

//$article_profile = new MyProfileArticle();
//$article_profile->setUserID($_COOKIE['userID']);
//$article_profile_list = $article_profile->getMyProfileArticleList();
//die(var_dump($article_profile_list[$profile_id]));
//die(var_dump($profile_id));

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
						<a href="/">
							home
						</a>
						&gt; <?=MY_ARTICLE_PROFILE?>
					</div>					
					<div class="content">
						<h3>
							<span>
								<?
								
								echo count($article_profile_list[$profile_id])." ";
								echo (isset($_GET['new'])?MY_NEW_ARTICLE_PROFILE:MY_ARTICLE_PROFILE);
								echo ": ".$profile_name." ";
	
								if($_GET['order'] == "relevance")
								{
									echo " - ".ORDER_BY." ".RELEVANCE;
								}else if ($_GET['order'] == "date"){
									echo " - ".ORDER_BY." ".DATE;
								}
	
								?>
							</span>
						</h3>
						<div class="articleList">
							<?
		
							//$profile_id = $list_profile['profile_id'];
							//echo "<div>".PROFILE.": ".$list_profile['profile_name']."</div>";
							echo "<ul>";
							//die(var_dump($article_profile_list[$profile_id]));
							//echo $article_profile_list[$profile_id][1];die;
							for($i = 0; $i < count($article_profile_list[$profile_id]); $i++)
							{
								$article = $article_profile_list[$profile_id][$i][1];
								$articleTitle = getTitle($article->getTitle());
								$articleAuthors = getAutors($article->getAuthorXML(),true,$article->getURL());
		
								if(($articleTitle == "") || ($articleAuthors == "")){
									continue;
								}
		
								//if ($profile_id == $article_profile_list[$i][0]) 
								//{
									
									//var_dump($article);die;
									//echo '<li>'.getTitle($article->getTitle()).'</li>';
									$url = $article->getURL()."/scielo.php?script=sci_arttext&pid=".$article->getPID()."&lng=".$lang."&tlng=".$lang."&nrm=iso";
									echo '<li><b><a target="_blank" href="'.$url.'">';
									/*
									pegando o título do artigo no Lang corrente, se não pega o titulo q tiver hehehe
									do arquivo functions.php
									*/
									echo $articleTitle;
									echo '</a></b><br />'."\n";
									echo '<i>';
									/*
									criando a lista de Autores do artigo
									do arquivo functions.php
									*/
									echo $articleAuthors;
									echo '</i><br />';
									echo '<i>'.$article->getSerial(). ', '.$article->getYear().', vol:'.$article->getVolume();
									echo ', n. '.$article->getNumber().', ISSN '.substr($article->getPID(),1,9).'</i><br/>'."\n";
									if ($_GET['order'] == "relevance"){
										echo 'relevance: '.$article->getRelevance()."<br/>";
									} else {
										$months = split(",",MONTH_LIST);
										
		
										$dateISO = $article->getPublicationDate();
		
										$year = intval(substr($dateISO,0,4));
										$month = intval(substr($dateISO,4,2));
										$day = intval(substr($dateISO,6,2));
		
										echo DATE.": ";
		
		
										if($day){
											print  $day ." -" ;
										}
		
										if($month){
											print $months[$month-1] . " - ";
										}
		
										if($year){
											print $year;
										}
		
										print "<br />";
		
									}
							}
							echo "</ul>";
							?>
						</div>
						<!-- a href="/"><?=BUTTON_BACK?></a -->
					</div>
					
					<div class="serviceColumn">
						<div class="webServices">
							<h3>
								<span>
									<?=PROFILES?>
								</span>
							</h3>
							<div id="sortedBy">
								<ul>
								<?
								$url_new = (isset($_GET['new'])?'&new':null);
								reset($profile_list);
								while (list($id, $info_array) = each($profile_list)) {
									if($info_array['profile_name'] != '')
									{
									   echo "<li><a   href=\"?profile_id=".$info_array['profile_id'].$url_new."\">".$info_array['profile_name']."</a></li>\n";
									}
								}
								?>
								</ul>
							</div>
						</div>
						<div class="webServices">
							<h3>
								<span>
									<?=VIEW_BY?>
								</span>
							</h3>
							
							<div id="sortedBy">
								<ul>
								<?
								$url_new = (isset($_GET['new'])?'&new':null);
								if (isset($_GET['profile_id']))
								{
									$href_rele = "?profile_id=".$_GET['profile_id']."&order=relevance".$url_new;
									$href_date = "?profile_id=".$_GET['profile_id']."&order=date".$url_new;
								}
								else
								{
									$href_rele = "?order=relevance".$url_new;
									$href_date = "?order=date".$url_new;
								}
								?>
									<li><a href="<?=$href_rele?>" class="closed"><?=RELEVANCE?></a></li>
									<li><a href="<?=$href_date?>" class="closed"><?=DATE?></a></li>
								</ul>
							</div>
						</div>
						<div class="webServices">
							<h3>
								<span>
									<?=TOOLS?>
								</span>
							</h3>
							<div id="info">
								<ul>
									<li><a href="userProfile.php?id=<?=$_COOKIE['userID']?>" class="closed"><?=EDIT_USER_DATA?> - <?=PROFILES?></a></li>
								</ul>
							</div>
						</div>
					</div>

	
				</div>
			</div>
			<div class="copyright">
				BVS Site 4.0-rc4 &copy; <a href="http://www.bireme.br/" target="_blank">BIREME/OPS/OMS</a>
			</div>
		<?require_once(dirname(__FILE__)."/../sgu/traker.php")?>
		</div>
    </body>
</html>

<?
ob_end_flush();
?>
