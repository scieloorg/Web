<?
/**
*@package	Scielo.org
*@version      1.0
*@author       André Otero(andre.otero@bireme.org)
*@copyright     BIREME
*/

/**
*Serviço "Remover artigo da prateleita"
*
*remove um artigo da prateleira
*se o artigo não tem "avise-me"'s cadastrados ele apaga da tabela user_shelf,
*se o artigo tiver algum "avise-me" altera o campo visivble para 0
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
$scielodef = parse_ini_file(dirname(__FILE__) . '/../scielo.def.php', true);

$_data['PID'] = $_REQUEST['PID'];
$_data['url'] = $scielodef['scielo_org_urls']['home']."/users/shelf.php";

$shelf = new Shelf();

$shelf->setUserID($_COOKIE['userID']);
$shelf->setPID($_data['PID']);

if($shelf->hasAlerts())
{
	$shelf->setVisible(0);
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

	<body onload="delay()">
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
                                <?=REMOVE_FROM_SHELF_OK?>
                        </p>
                </div>
        </div>
	</div>
	</body>
</html>