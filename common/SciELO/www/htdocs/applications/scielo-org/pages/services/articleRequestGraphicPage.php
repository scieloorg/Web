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
    <link rel="stylesheet" href="<?=$scielodef['this']['url']?>/css/screen2.css" type="text/css" media="screen">
  </head>
  <body>
    <div class="container">
      <div class="level2">
		<? require_once(dirname(__FILE__)."/../../html/" . $lang . "/headerInstancesServices.html"); ?>
        <div class="middle">
          <div id="collection">
            <h3><span><?=ACCESS_STATS?></span></h3>
            <div class="content">
				<div>
					<?
							$domain = "http://".str_replace("http://","",$_GET['caller']);
							echo '<a target="_blank" href="'.$domain.'/scielo.php?script=sci_arttext&pid='.$article->getPID().'&lng='.$lang.'&nrm=iso&tlng='.$lang.'" >'.getTitle($article->getTitle())."</a><br>\n";
							echo '</a></b>'."\n";
							echo '<i>';
							echo getAutors($article->getAuthorXML());
							echo '</i><br />';
							echo '<i>'.$article->getSerial(). ', '.$article->getYear().', vol:'.$article->getVolume();
							echo ', n. '.$article->getNumber().', ISSN '.substr($article->getPID(),1,9).'</i><br/><br/>'."\n";
						?>
				</div>
				<div>
						<img src="<?=$scielodef['this']['url'].$scielodef['this']['relpath']?>/pages/services/articleRequestGraphic.php?pid=<?=$pid?>" />
				
				</div>
				            </div>

            <div style="clear: both;float: none;width: 100%;"></div>
          </div>
        </div>
      </div>
    </div>
    <div class="copyright">BVS Site 4.0-rc4 copy <a href="http://www.bireme.br/" target="_blank">BIREME/OPS/OMS</a>
    </div>
  </body>

</html>
