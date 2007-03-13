<?
ini_set('display_errors', 'On');
//alterando o path para a procura de includes, assim
//achamos o ADODB em lib . . .
error_reporting(E_ALL ^ E_NOTICE );

	$DirNameLocal=dirname(__FILE__).'/';
	require_once($DirNameLocal."../classes/services/ArticleServices.php");
	require_once($DirNameLocal."../users/functions.php");
	include_once($DirNameLocal."../php/include.php");
	include_once($DirNameLocal."../users/langs.php");

	$DirHtml = $DirNameLocal."../html/" .$lang . "/";
	$site = parse_ini_file($DirNameLocal."../ini/" . $lang . "/bvs.ini", true);
	$scielodef = parse_ini_file($DirNameLocal."../scielo.def", true);

	$pid = $_REQUEST['pid'];
	$caller = $_REQUEST["caller"];
	
	$articleService = new ArticleService($caller);
	$articleService->setParams($pid);
	$article = $articleService->getArticle();
?>
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
    <script language="JavaScript" src="http://regional.bvsalud.org/js/showHide.js"></script>
    <link rel="stylesheet" href="<?=$scielodef['this']['url']?>/css/screen2.css" type="text/css" media="screen">
  </head>
  <body>
    <div class="container">
      <div class="level2">
        <div class="bar"></div>
        <div class="top">
          <div id="parent"><img src="<?=$scielodef['this']['url']?>/image/public/skins/classic/pt/banner.jpg" alt="SciELO - Scientific Electronic Librery Online"></div>
          <div id="identification">
            <h1><span>SciELO.org - Scientific Electronic Library Online</span></h1>

          </div>
        </div>
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
						<img src="<?=$scielodef['this']['url']?>/pages/services/articleRequestGraphic.php?pid=<?=$pid?>" />
				
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
