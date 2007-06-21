<?
ini_set('display_errors', '1');
error_reporting(1);
	$DirNameLocalGraphPage=dirname(__FILE__).'/';

	require_once($DirNameLocalGraphPage."../../users/functions.php");
	require_once($DirNameLocalGraphPage."../../users/langs.php");
	require_once($DirNameLocalGraphPage."../../../../php/include.php");
	require_once($DirNameLocalGraphPage."../../classes/services/ArticleServices.php");

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
	<script language="JavaScript">
		// verifica o tamanho de um input
		function tamanho(objeto) 
		{
			if (objeto.value.length != 4) 
			{
				objeto.focus();
				return false;
			}	
			return true;
		}
		// verifica se o usuario está digitando um numero
		function isNumber(objeto)
		{
			var ValidChars = "0123456789.";
			var Char;
   
			for (i = 0; i < objeto.value.length; i++) 
			{ 
				Char = objeto.value.charAt(i); 
				if (ValidChars.indexOf(Char) == -1) 
				{
					objeto.focus();
					return false;
				}
			}
			return true;
		}
		
		// Verifica se a data é valida
		function dataValida(objeto)
		{
			if(objeto.value < 1950)
			{
				objeto.focus();
				return false;
			}
			else if(objeto.value > 2150)
			{
				objeto.focus();
				return false;
			}
			else
			{
				objeto.focus();
				return true;
			}
		}
		
		// valida o formulário
		function valida_form() 
		{
			if (!tamanho(document.form1.startYear)) 
			{
				return false;
			}
			else if(!isNumber(document.form1.startYear))
			{
				return false;
			}
			else if(!dataValida(document.form1.startYear))
			{
				return false;
			}
			else if(document.form1.lastYear.value.length != 0)
			{
				if(!tamanho(document.form1.lastYear))
				{
					return false;
				}
				else if(!isNumber(document.form1.lastYear))
				{
					return false;
				}
				else if(!dataValida(document.form1.lastYear))
				{
					return false;
				}
				else if( document.form1.startYear.value > document.form1.lastYear.value )
				{
					return false;
				}
				else
				{
					return true;
				}
			}
			// se somente startYear tem valor então lastYear fica com o mesmo valor
			// e pesquisamos a estatisticas de um ano especifico
			else if(document.form1.lastYear.value.length == 0 )
			{
				document.form1.lastYear.value = document.form1.startYear.value;
				return true;
			}
			else 
			{
				return true;
			}
		}
	</script>
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
				<?=START_YEAR?> <input type="text" id="startYear" name="startYear" size="4" maxlength="4"/>
				<?=LAST_YEAR?> <input type="text" id="lastYear" name="lastYear" size="4" maxlength="4"/> 
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
							echo '<i>'.$article->getSerial(). ', '.$article->getYear().', vol:'.$article->getVolume();
							echo ', n. '.$article->getNumber().', ISSN '.substr($article->getPID(),1,9).'</i><br/><br/>'."\n";
						?>
				</div>
				<div>
						<!-- Monta o gráfico -->
						<img src="<?=$scielodef['this']['url'].$scielodef['this']['relpath']?>/pages/services/articleRequestGraphic.php?pid=<?=$pid?>&startYear=<?=$startYear?>&lastYear=<?=$lastYear?>"/>
				
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
