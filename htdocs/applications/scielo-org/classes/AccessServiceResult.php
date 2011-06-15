<?php

require_once(dirname(__FILE__)."/ServiceResult.php");
require_once(dirname(__FILE__)."/../ArticleStats.php");
require_once(dirname(__FILE__)."/../ArticleRequests.php");

class AccessServiceResult extends ServiceResult {

    /* ===================================================================== */
    function AccessServiceResult($stringXml){
    	$this->ServiceResult($stringXml);
    }
	
	function getStats(){
		$articleStats = new ArticleStats();
		
		$tmp = &$this->domLiteDocument->getElementsByPath("//STATPARAM"); 
		
		for ($i=0;$i<$tmp->getLength();$i++){
			$item = $tmp->item($i);     
			$articleStats->setStartDate($this->getNodeText($item, 'START_DATE'));
			$articleStats->setCurrentDate($this->getNodeText($item, 'CURRENT_DATE'));
		}
		
		$tmp = &$this->domLiteDocument->getElementsByPath("//ARTICLE"); 
		for ($i=0;$i<$tmp->getLength();$i++){
			$articleRequests = new ArticleRequests();

			$item = $tmp->item($i);     
			$articleRequests->setLang($this->getNodeAttribute($item, 'TEXT_LANG'));
			$articleRequests->setYear($this->getNodeAttribute($item, 'ANO'));
			$articleRequests->setMonth($this->getNodeAttribute($item, 'MES'));
			$articleRequests->setNumberOfRequests($this->getNodeAttribute($item, 'REQUESTS'));
			
			$arrayArticleRequests[] = $articleRequests;
		}
		$articleStats->setRequests($arrayArticleRequests);
		return $articleStats;
	}
	

}//class


?>
