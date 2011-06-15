<?
/**
*@package	Scielo.org
*@version      1.0
*@author       Andr� Otero(andre.otero@bireme.org)
*@copyright     BIREME
*/

/**
*Servi�o "Avise-me quando for citado"
*
*caso o artigo j� esta na prateleira, seta o cited_stat para 1
*se o artigo n�o estiver na prateleira adiciona o artigo na prateleira,
*coloca visible = 0 e access_stat para 1
*
*@package	Scielo.org
*@version      1.0
*@author       Andr� Otero(andre.otero@bireme.org)
*@copyright     BIREME
*/
ini_set("display_errors","1");
error_reporting(1);

require_once(dirname(__FILE__)."/../users/langs.php");
require_once(dirname(__FILE__)."/../classes/Article.php");
require_once(dirname(__FILE__)."/../classes/Shelf.php");
require_once(dirname(__FILE__)."/../classes/services/ArticleServices.php");

$_data['PID'] = $_REQUEST['PID'];
$_data['url'] = $_REQUEST['url'];
$_data['userID'] = $_REQUEST['userID'];
$_data['cited_stat'] = 1;
$scielodef = parse_ini_file(dirname(__FILE__)."/../scielo.def.php", true);

/*
fazendo a consistencia de usu�rio logado/n�o logado
*/
if($_data['userID']){
/*
a url do servi�o que retorna os meta-dados do artigo
� o dom�nio de onde o usu�rio esta vendo o artigo
*/
	$domain = str_replace("http://","",$_data['url']);
	$domain = substr($domain,0,strpos($domain,"/"));

/*
chamando o servi�o (ele devolve um objeto Article)
*/
	$articleService = new ArticleService($domain);

	$articleService->setParams($_data['PID']);

	$article = 	$articleService->getArticle();

	$article->setURL($domain);

//die(var_dump($article->getPID()));

	$article->addArticle();

	$shelf = new Shelf();

	$shelf->setUserID($_data['userID']);
	$shelf->setPID($_data['PID']);
	$shelf->setCitedStat($_data['cited_stat']);

	if($shelf->isInShelf()){
		$shelf->updateArticleInShelf();	
	}else{
		$shelf->setVisible(0);
		$shelf->addArticleToShelf();
	}
	$message = ALERT_CITED_OK;
}else{
	$message = NOT_LOGED;
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
                                <?=$message?>
                        </p>
                </div>
        </div>
	</div>
	</body>
</html>