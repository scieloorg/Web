<?php

require_once(dirname(__FILE__)."/ServiceResult.php");
require_once(dirname(__FILE__)."/../Article.php");

class ArticleServicesResult extends ServiceResult {

    /* ===================================================================== */
    function ArticleServicesResult($stringXml){
    	$this->ServiceResult($stringXml);
    }
	function getArticle(){
		$article = new Article();

		if (!$this->domLiteDocument) die("not domLiteDocument...");
		$temp = &$this->domLiteDocument->getElementsByPath("/SERIAL"); 
		for ($i=0;$i<$temp->getLength();$i++){
			$item = $temp->item($i);     

			$article->setSerial($this->getNodeText($item, 'TITLEGROUP/TITLE'));
		}
		$temp = &$this->domLiteDocument->getElementsByPath("//ISSUEINFO"); 
		for ($i=0;$i<$temp->getLength();$i++){
			$item = $temp->item($i);
			$article->setVolume($this->getNodeAttribute($item, 'VOL'));
			$article->setNumber($this->getNodeAttribute($item, 'NUM'));
			$article->setSuppl($this->getNodeAttribute($item, 'SUPPL'));
			$article->setYear($this->getNodeAttribute($item, 'YEAR'));
		}
		
		$temp = &$this->domLiteDocument->getElementsByPath("//ARTICLE"); 
		for ($i=0;$i<$temp->getLength();$i++){
			$item = $temp->item($i);     
			$article->setPublicationDate($this->getNodeText($item, 'publication-date'));
			$article->setTitle($this->getNodeXML($item, 'TITLES'));
			$article->setAuthorXML($this->getNodeXML($item, 'AUTHORS'));
			$article->setKeywordXML($this->getNodeXML($item, 'KEYWORDS'));
			$article->setAbstractXML($this->getNodeXML($item, 'ABSTRACT'));
		}
		return $article;
	}

}//class


?>