<?php

	require_once(dirname(__FILE__)."/../domit-1/xml_domit_lite_include.inc.php"); 
	
	class ServiceResult {
	    var $domLiteDocument ;
    	var $_stringXml ;

		function ServiceResult($xml){
			$this->_date = date("YmdHis");
			$this->_stringXml = $xml;

	    	$this->domLiteDocument =& new DOMIT_Lite_Document() ;
    		$this->domLiteDocument->parseXML($xml) ;  
			
		}
	function getNodeAttribute(&$node, $name){
		if ($node->hasAttribute($name)){
			$value = $node->getAttribute($name);
		}		
		return $value;
	}
	function getNodeText(&$node, $xpath){
		$tmp  =& $node->getElementsByPath($xpath); 
		$item = $tmp->item(0);     
		if ($item)	return $item->getText();
		return ;
	}
	function getNodeXML(&$node, $xpath){
		$tmp  =& $node->getElementsByPath($xpath); 
		$item = $tmp->item(0);     
		if ($item)	return $item->toString(false,true);
	}
/* ========================================================================= */
// x
/* ========================================================================= */
   function getLanguageDependentData(&$node, $xpath) {
   
      $tmp  =& $node->getElementsByPath($xpath); 

	  for ($i=0;$i<$tmp->getLength();$i++){
		  	$item = $tmp->item($i);     
		  	
		  	$lang = "";
			if ($item->hasAttribute('lang')){
				$lang = $item->getAttribute('lang');
			} else {
				$lang = $originalLang;
			}
		  	if ($lang){
				$data[$lang] = $item->getText();
		  	}
	  }
      return $data;
      
   }//x()
	}
?>
