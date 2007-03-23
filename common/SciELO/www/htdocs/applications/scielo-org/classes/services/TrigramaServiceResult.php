<?php
require_once(dirname(__FILE__)."/ServiceResult.php");
require_once(dirname(__FILE__)."/ArticleServices.php");

class TrigramaServiceResult extends ServiceResult {

    /* ===================================================================== */
    function TrigramaServiceResult($stringXml){
    	$this->ServiceResult($stringXml);
    }
	function getPIDs($articleMetadataServer, $articleDomain){
		$articleServices = new ArticleService($articleMetadataServer, $articleDomain);
		$tmp = &$this->domLiteDocument->getElementsByPath("//similarlist/similar"); 
		for ($i=0;$i<$tmp->getLength();$i++){
			$item = $tmp->item($i);     

			$pid = $item->getText();

			$relevance = $this->getNodeAttribute($item, 's');

			$articleServices->setParams($pid);

			$article = $articleServices->getArticle();
			$article->setPID($pid);
			$article->setRelevance($relevance);
			$articles[] = $article;

		}
		return $articles;
	}
	function getArticles(){
		$tmp = &$this->domLiteDocument->getElementsByPath("//collection"); 
		for ($i=0;$i<$tmp->getLength();$i++){
			$item = $tmp->item($i); 
			$path = explode('.',$this->getNodeAttribute($item, 'path'));
			$serverCountry = $path[0].'.'.$path[1];
			$this->getURL($serverCountry, $articleMetadataServer, $articleDomain);
			$articles = $this->getPIDs($articleMetadataServer, $articleDomain);
		}
		return $articles;
	}
	function oldgetArticles(){
		$tmp = &$this->domLiteDocument->getElementsByPath("/related/relatedlist/article"); 
		for ($i=0;$i<$tmp->getLength();$i++){
			$item = $tmp->item($i);     

			$article = new Article();

			$article->setPID($this->getNodeAttribute($item, 'pid'));
			
			$article->setURL($this->getURL($this->getNodeAttribute($item, 'source'), $this->getNodeAttribute($item, 'country'),$article->getPID()));
			$article->setTitle($this->getNodeXML($item, 'titles'));
			$article->setSerial($this->getNodeText($item, 'serial'));
			$article->setVolume($this->getNodeText($item, 'volume'));
			$article->setNumber($this->getNodeText($item, 'number'));
			$article->setSuppl($this->getNodeText($item, 'supplement'));
			$article->setYear($this->getNodeText($item, 'year'));
			$article->setAuthorXML($this->getNodeXML($item, 'authors'));
			$article->setKeywordXML($this->getNodeXML($item, 'keywords'));
			
			$articles[] = $article;
		}
		return $articles;
	}
	function getURL($source_country, &$articleMetadataServer, &$articleDomain){
		$f = dirname(__FILE__);
		$ini = parse_ini_file($f."/../../scielo.def", true);

		$articleMetadataServer = $ini['article_metadata_server'][$source_country];
		$articleDomain = $ini['article_server'][$source_country];
	}

}//class


?>
