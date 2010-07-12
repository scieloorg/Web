<?

	$DirNameLocalGraphPage=dirname(__FILE__).'/';

	require_once($DirNameLocalGraphPage."../../users/functions.php");
	require_once($DirNameLocalGraphPage."../../users/langs.php");
	require_once($DirNameLocalGraphPage."../../../../php/include.php");
	require_once($DirNameLocalGraphPage."../../classes/services/ArticleServices.php");
	require_once(dirname(__FILE__)."/../../classes/services/AccessServiceBar.php");
	require_once(dirname(__FILE__)."/../../classes/Open_Flash_Chart/ofc-library/open_flash_chart_object.php");

	$DirHtml = $DirNameLocalGraphPage."../html/" .$lang . "/";
	$site = parse_ini_file($DirNameLocalGraphPage."/../../../../ini/" . $lang . "/bvs.ini", true);
	$scielodef = parse_ini_file($DirNameLocalGraphPage."/../../scielo.def.php", true);
  	$scielomaindef = parse_ini_file($DirNameLocalGraphPage."/../../../../scielo.def.php", true);

	$pid = $_REQUEST['pid'];
	$caller = $_REQUEST["caller"];
		
	$articleService = new ArticleService($caller);
	$articleService->setParams($pid);
	$article = $articleService->getArticle();
	
	$accessService = new AccessService();
	$accessService->setParam('pid',$_REQUEST['pid']);
	$accessService->setParam('app',$scielomaindef["SITE_INFO"][APP_NAME]);
	$years = array();
	$years = $accessService->getYears($accessService->getStats());
	
	$yearsLastIndex = (count($years) - 1);
	
	$startYear = $_REQUEST['startYear'] ? $_REQUEST['startYear'] : $years[$yearsLastIndex];
	$lastYear = $_REQUEST['lastYear'] ? $_REQUEST['lastYear'] :  $years[$yearsLastIndex];	
      ?>
<!DOCTYPE html
  PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="Expires" content="-1">
    <meta http-equiv="pragma" content="no-cache">
    <meta name="robots" content="all">
	
    <script language="JavaScript">lang = '<?=$lang?>';</script>
    <script language="JavaScript" src="<?=$scielodef['this']['url']?>/js/functions.js"></script>
    <script language="JavaScript" src="<?=$scielodef['this']['url']?>/js/showHide.js"></script>
    <script language="JavaScript" src="<?=$scielodef['this']['url']?>/js/metasearch.js"></script>
    <script language="JavaScript" src="<?=$scielodef['this']['url']?>/js/showHide.js"></script>
	<script language="Javascript" src="flash.js"></script>
	<script language="JavaScript" src="graphVerif.js"></script>

    <link rel="stylesheet" href="<?=$scielodef['this']['url']?>/css/screen2.css" type="text/css" media="screen">
    <link rel="stylesheet" href="<?=$scielodef['this']['url']?>/css/common/styles.css" type="text/css">
	<link rel="stylesheet" href="<?=$scielodef['this']['url']?>/applications/scielo-org/css/public/style-<?=$lang?>.css" type="text/css" media="screen"/>
  </head>
  <body>
    <div class="container">
      <div class="level2">
		<? require_once(dirname(__FILE__)."/../../html/" . $lang . "/headerInstancesServices.html"); ?>
        <div class="middle">
          <div id="collection">
            <h3><span><?=ACCESS_STATS?></span></h3>
			<div class="content">
				<TABLE border="0" cellpadding="0" cellspacing="2" width="760" align="center">
					<TR>
						<TD colspan="2">
							<h3><span style="font-weight:100;font-size: 70%; background:none;">
							<?php
                                                            $author = getAutors($article->getAuthorXML());
                                                            $pos = strrpos($author, ";");
                                                            $author[$pos] = " ";

                                                            echo $author;
                                                            echo '<i><b>';
                                                            echo getTitle($article->getTitle(), $lang).". ";
                                                            echo ('</b></i>');
                                                            echo utf8_encode($article->getSerial(). ', '.$article->getYear().', vol.'.$article->getVolume());
                                                            echo utf8_encode(', n. '.$article->getNumber().', ISSN '.substr($article->getPID(),1,9).'.<br/><br/>'."\n");
							?>
							</span></h3>
						</TD>
					</TR>	
				</TABLE>
				<!-- Formul�rio de op��o de estat�sticas por data -->
				<form action="articleRequestGraphicPage.php" name="form1" method="get" onSubmit="return valida_form();">
					<p><b><?=CHOOSE_PERIOD?></b><br/>
					
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
			</div>
            <div class="content">
				<div>
					<!-- Monta o gr�fico -->
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
		$def = parse_ini_file('../../../../scielo.def.php',true);
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
