<?
/**
*@package	Scielo.org
*@version      1.0
*@author       André Otero(andre.otero@bireme.org)
*@copyright     BIREME
*/
/**
*Serviço "Remover Aviso de Citação de Artigo"
*
*remove a notificação de citação de um artigo
*se o artigo tem visible = 1 apenas seta o flag cited_stat para 0
*se o artigo tem visible = 0 apaga esse artigo do Shelf do usuário
*
*@package	Scielo.org
*@version      1.0
*@author       André Otero(andre.otero@bireme.org)
*@copyright     BIREME
*/

ini_set("display_errors","1");
error_reporting(1);

require_once(dirname(__FILE__)."/../classes/Article.php");
require_once(dirname(__FILE__)."/../classes/Shelf.php");
require_once(dirname(__FILE__)."/../users/langs.php");
require_once(dirname(__FILE__)."/../classes/services/ArticleServices.php");
$scielodef = parse_ini_file(dirname(__FILE__) . '/../scielo.def', true);

$_data['PID'] = $_REQUEST['pid'];

$shelf = new Shelf();

$shelf->setUserID($_COOKIE['userID']);
$shelf->setPID($_data['PID']);
$shelf->getShelfItem();

$cited_stat = intval($shelf->getCitedStat());

$access_stat = intval($shelf->getAccessStat());

$visible = $shelf->getVisible();

if($visible || $access_stat)
{
	$shelf->setCitedStat(0);
	$shelf->UpdateArticleInShelf();

}else{
	$shelf->removeArticleFromShelf();
}

?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	    <meta http-equiv="Pragma" content="no-cache">
	    <meta http-equiv="Expires" content="Mon, 06 Jan 1990 00:00:01 GMT">
		<script type="text/javascript">

		function refreshOpener(){
			window.opener.location.reload();
			delay();
		}
		
		function fecha()
		{
			self.close();
		}

		function delay()
		{
			setTimeout("fecha()", 3000);
		}
		</script>
		<link rel="stylesheet" href="<?=$scielodef['this']['relpath']?>/css/public/print.css" type="text/css" media="print"/>
		<link rel="stylesheet" href="<?=$scielodef['this']['relpath']?>/css/public/style-<?=$lang?>.css" type="text/css" media="screen"/>
	</head>

	<body onload="refreshOpener()">
	<div class="container">
        <div class="level2">
                <div class="top">
                        <div id="parent">
                                <img src="<?=$scielodef['this']['relpath']?>/image/public/skins/classic/<?=$lang?>/banner.jpg" />
                        </div>
                </div>
        </div>
        <div class="middle">
                <div class="content">
                        <p align="center">
                                <?=REMOVE_CITED_ALERT_OK?>
                        </p>
                </div>
        </div>
	</div>
	</body>
</html>