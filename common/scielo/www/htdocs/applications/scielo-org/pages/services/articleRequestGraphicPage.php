<?
ini_set('display_errors', '1');
error_reporting(1);
	$DirNameLocalGraphPage=dirname(__FILE__).'/';

	require_once($DirNameLocalGraphPage."../../users/functions.php");
	require_once($DirNameLocalGraphPage."../../users/langs.php");
	require_once($DirNameLocalGraphPage."../../../../php/include.php");
	require_once($DirNameLocalGraphPage."../../classes/services/ArticleServices.php");
	require_once(dirname(__FILE__)."/../../classes/services/AccessServiceBar.php");
	require_once(dirname(__FILE__)."/../../classes/Open_Flash_Chart/ofc-library/open_flash_chart_object.php");

	$DirHtml = $DirNameLocalGraphPage."../html/" .$lang . "/";
	$site = parse_ini_file($DirNameLocalGraphPage."/../../../../ini/" . $lang . "/bvs.ini", true);
	$scielodef = parse_ini_file($DirNameLocalGraphPage."/../../scielo.def", true);
	
	$pid = $_REQUEST['pid'];
	$caller = $_REQUEST["caller"];
	$startYear = $_REQUEST['startYear'];
	$lastYear = $_REQUEST['lastYear'];
	
	$articleService = new ArticleService($caller);
	$articleService->setParams($pid);
	$article = $articleService->getArticle();
?>
<!DOCTYPE html
  PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="Expires" content="-1">
    <meta http-equiv="pragma" content="no-cache">
    <meta name="robots" content="all">
    <meta name="MSSmartTagsPreventParsing" content="true">
    <meta name="generator" content="BVS-Site 4.0-rc4">
	
    <script language="JavaScript">lang = '<?=$lang?>';</script>
    <script language="JavaScript" src="<?=$scielodef['this']['url']?>/js/functions.js"></script>
    <script language="JavaScript" src="<?=$scielodef['this']['url']?>/js/showHide.js"></script>
    <script language="JavaScript" src="<?=$scielodef['this']['url']?>/js/metasearch.js"></script>
    <script language="JavaScript" src="<?=$scielodef['this']['url']?>/js/showHide.js"></script>
	<script language="Javascript" src="flash.js"></script>
	<script language="JavaScript" src="graphVerif.js"></script>

    <link rel="stylesheet" href="<?=$scielodef['this']['url']?>/css/screen2.css" type="text/css" media="screen">
    <link rel="stylesheet" href="<?=$scielodef['this']['url']?>/css/common/styles.css" type="text/css">
  </head>
  <body>
    <div class="container">
      <div class="level2">
		<? require_once(dirname(__FILE__)."/../../html/" . $lang . "/headerInstancesServices.html"); ?>
        <div class="middle">
          <div id="collection">
            <h3><span><?=ACCESS_STATS?></span></h3>
			<!-- Formulário de opção de estatísticas por data -->
			<form action="articleRequestGraphicPage.php" name="form1" method="get" onSubmit="return valida_form();">
				<p><b><?=CHOOSE_PERIOD?></b><br/>
				<?php
					$accessService = new AccessService();
					$accessService->setParams($_REQUEST['pid']);
					$years = array();
					$years = $accessService->getYears($accessService->getStats());
				?>
				<?=START_YEAR?> 
				<select id="startYear" name="startYear"> 	
				<?php
					for($i = 0; $i < count($years) - 1; $i++)
					{
						echo '<option value="'.$years[$i].'">'.$years[$i].'</option>'; 	
					}
					echo '<option  selected value="'.$years[$i].'">'.$years[$i].'</option>'; 	
				?>
				</select> 
				<?=LAST_YEAR?>
				<select id="lastYear" name="lastYear">
				<?php
					for($i = 0; $i < count($years) -1; $i++)
					{
						echo '<option value="'.$years[$i].'">'.$years[$i].'</option>'; 	
					}
					echo '<option  selected value="'.$years[$i].'">'.$years[$i].'</option>'; 	
				?>
				</select>
				<input type="submit" class="submit" value="<?=BUTTON_REFRESH?>">
				<input type="hidden" id="lang" name="lang" value="<?=$lang?>">
				<input type="hidden" id="caller" name="caller" value="<?=$caller?>">
				<input type="hidden" id="pid" name="pid" value="<?=$pid?>">
			</form>

            <div class="content">
				<div>
					<?
							$domain = "http://".str_replace("http://","",$_GET['caller']);
							echo getTitle($article->getTitle())."<br>\n";
							echo '</a></b>'."\n";
							echo '<i>';
							echo getAutors($article->getAuthorXML());
							echo '</i><br />';
							echo '<i>'.$article->getSerial(). ', '.$article->getYear().', vol.'.$article->getVolume();
							echo ', n. '.$article->getNumber().', ISSN '.substr($article->getPID(),1,9).'</i><br/>'."\n";
						?>
				</div>
				<div>
					<!-- Monta o gráfico -->
					<?php 
						$urlFlash = ''.$scielodef['this']['url'].$scielodef['this']['relpath'].'/pages/services/articleRequestGraphic.php?pid='.$pid.'&startYear='.$startYear.'&lastYear='.$lastYear.'';
						echo '<!-- URL FLASH: '.$urlFlash.'-->';
						echo "<div align='center' style='width:760px; height:5px;padding-top:6px;' ><b>".ARTICLE_ACCESS."</b></div>";
					?>
					<script type="text/javascript">
						GerarSWF('<?php echo flashentities($urlFlash)?>',760,350);
					</script>
				</div>
			</div>
            <div style="clear: both;float: none;width: 100%;"></div>
          </div>
        </div>
      </div>
    </div>
    <div class="copyright">BVS Site 4.0-rc4 copy <a href="http://www.bireme.br/" target="_blank">BIREME/OPS/OMS</a>
    </div>
	<?
		$def = parse_ini_file('../../../../scielo.def',true);
		if($def['LOG']['ACTIVATE_LOG'] == '1') {
	?>
	<script src="http://www.google-analytics.com/urchin.js" type="text/javascript"></script>
	<script type="text/javascript">
		_uacct = "UA-604844-1";
		urchinTracker();
	</script>
	<?}?>
</body>
</html>
