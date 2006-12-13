<?php

define('XML_PROCESSING_INSTRUCTION','<?xml version="1.0" encoding="iso-8859-1"?>');

class XSL_XML  {

	function XSL_XML($xslBaseUri=''){
		$this->xslBaseUri = $xslBaseUri;
	}
	
	function xml_xsl ( $xml, $xsl, $debug="" )
	{
		$hidden='';

		$xslBaseUri = $this->xslBaseUri;
		if ($xml=='') die("falta o XML");
		if ($xsl=='') die("falta XSL para transformar\n");
		if ( $debug == "XML" ) { die($xml); }
		if ( $debug == "XSL" ) { die($xsl.'<!--'.$xslBaseUri.$xsl.'-->'); }

		if (!file_exists($xsl)){die($xsl." not found.");}
		$transform = new XSLTransformer();
		
		if (strpos(' '.$xml, '/')==1 || strpos(' '.$xml, 'http://')==1 || strpos(' '.$xml, 'ftp://')==1){	
		} else {
			$xml = $this->insertProcessingInstruction(trim($xml));		
		} 
		if ($xslBaseUri){
			$transform->setXslBaseUri("file://" . $xslBaseUri);
		}
		
		if ($transform->setXml($xml) == false)
		       die($transform->getErrorMessage());
		if ($transform->setXsl($xsl) == false)
		       die($transform->getErrorMessage());
		if ($transform->transform() == false){
		       $r = $transform->getErrorMessage();
		}else{
			//transform sempre retorna UTF-8
			$r = $transform->getOutput();
			if (!$this->isUTF8($xml)){
				//necessario fazer utf8_decode
		       $r = utf8_decode($r);
			   $r = preg_replace("/UTF-8/i",$this->find($xml,' encoding="','"'),$r);			   
			}			
		}
		
		return $r.$hidden;
	}
	function isUTF8($xml){
		$processInstruction = substr($xml,0,strpos($xml,'?>'));
		$processInstruction = strtoupper($processInstruction);
		return (strpos($processInstruction,'UTF-8')>0);
	}
	function returnContent($fileName){
		if (file_exists($fileName)) {
			$fp = fopen ($fileName,"r");
			if ($fp) {
				$content = fread($fp,filesize($fileName));
			}
		}
		return $content;
	}			


	function returnXML_HTTP_INFO($HTTP_POST_VARS,$HTTP_GET_VARS, $HTTP_SERVER_VARS, $scriptVars, $root='http-info') {
		$i = 0;	
		if ($HTTP_POST_VARS) $VARS = $HTTP_POST_VARS;
		if ($HTTP_GET_VARS) $VARS = $HTTP_GET_VARS;
		
	    $VARS['currentDate'] = date('YmdHisD');

		$xmlList[$i++] = $this->returnHTTP_VARS($VARS,'cgi', $scriptVars);	
		$xmlList[$i++] = $this->returnHTTP_VARS($HTTP_SERVER_VARS,'server');
						
		return $this->concatXML($xmlList,$root);
	}


	function returnHTTP_VARS($HTTP_VARS, $root='HTTP_VARS', $scriptVars) {
		//$HTTP_VARS may be $HTTP_GET_VARS or $HTTP_POST_VARS
	
	       $xmlString = "<$root>\n";
		   $xmlString .= $this->arrayToXml($HTTP_VARS);
		   $xmlString .= $this->arrayToXml($scriptVars);	
	       $xmlString .= "</$root>";
	
	       return $xmlString;
	
	}

	function arrayToXml($HTTP_VARS){
		if (is_array($HTTP_VARS)){
	        reset($HTTP_VARS);
	
	        $myKey =  key($HTTP_VARS);
	        while ($myKey){
	             if (count($HTTP_VARS[$myKey]) <= 1) {
	                $xmlString .= "		<$myKey>" . $this->correctValue($HTTP_VARS[$myKey]) . "</$myKey>\n";
	             } else {
	                for($i = 0; $i < count($HTTP_VARS[$myKey]); $i++) {
	                  $xmlString .= "		<$myKey>" . $this->correctValue($HTTP_VARS[$myKey][$i]) . "</$myKey>\n";
	                }
	             }
	             next ($HTTP_VARS);
	             $myKey = key($HTTP_VARS);
	       }
		}
		return $xmlString;
	}

	
	function correctValue ($value){
		$value = str_replace("&amp;","&",stripslashes($value));
		$value = str_replace("&","&amp;",$value);
	
		return $value;
	}

	
	
	function concatXML($array_of_xml, $root = "root") {
		$content = XML_PROCESSING_INSTRUCTION;
		if ($root)		$content .= "\n<" . $root . ">\n";
		
		for ($i = 0; $i < count($array_of_xml); $i++) {
			$content .= $this->extractContent($array_of_xml[$i]) . "\n";
		}
		if ($root)		$content .= "</" . $root . ">";
		
		return trim($content);
	}

	

	function insertProcessingInstruction($xml) {
		if ($this->isUTF8($xml)){
		
		} else {
			$xml = utf8_encode($xml);
			$xml = trim($this->extractContent($xml));
			$xml = XML_PROCESSING_INSTRUCTION.$xml;
		}
//		if (substr(trim($xml),0,5) != substr(XML_PROCESSING_INSTRUCTION,0,5)){
	
//		}
		return trim($xml);
	}

	
	
	function debugScript ($param, $xml, $xsl) {
		$param = strtolower($param);
		switch ($param) {
			case "xml":
				die($xml);
			case "xsl":
				die($xsl);
			case "phpinfo":
				die(phpinfo());
			default:
				die("invalid option to debug parameter!");
		}
	}

	function getProcessInstruction($xml){
		$temp = ' '.trim($xml);
		$p_invalid_character = strpos($temp,'ÿþ');
		$return = '';
		if (!$p_invalid_character){
			$return = $xml;
			$p = strpos($temp,'<?xml');
			$p2 = strpos($temp,'?>');
			if (($p>0) && ($p2>0)){
				$return = substr($temp,0,$p2+2);
			}
		}		
		return trim($return);
	}
	
	
	function extractContent($xml, $teste=''){
/*		if (!$this->isUTF8($xml)){
			$xml = utf8_encode($xml);
		}*/
		$return = $xml;
		$temp = ' '.trim($xml);
		
		$p_invalid_character = strpos($temp,'ÿþ');
		if (!$p_invalid_character){
			$return = $xml;
			$p = strpos($temp,'<?xml');
			$p2 = strpos($temp,'?>');
			if ($p>0){			
				if ($p2>0){
					$return = substr($temp,$p2+2);
				}
			}
			$return = trim($return);
	
			while (substr($return,0,2)=='<!'){
				$p = strpos($return, '>');
				if ($p){
					$return = substr($return, $p+1);
				} else {
					$return = '';
				}
			}
			$return = trim($return);
		}
		return $return;
	}

	function new_recursiveFind($xml, $init, $end, $trim=true){
		$i = 0;
		$res = array();
		$r = $this->new_find($xml, $init, $end, $pNext);
		if ($trim) $r = trim($r);
		if ($r!=''){
			$res[$i++] = $r;	
		}

		while ($pNext){
			$xml = substr($xml, $pNext);
			$r = $this->new_find($xml, $init, $end, $pNext);
			if ($trim) $r = trim($r);
			if ($r!=''){
				$res[$i++] = $r;
			}
		}
		return $res;
	}
	//  retorna o conteúdo de um elemento cujo inicio é $ini e cujo fim é $end 
	function new_find($xml, $init, $end, &$pNext){
		$pNext = 0;
		$r = '';
		$p = strpos($xml,$init);
		
		if (($p) || (strcmp($init, substr($xml,$p,strlen($init)))==0) ){
			$pNext = $p;
			$r = substr($xml,$p + strlen($init));
			$p = strpos($r,$end);
			if (($p) || (strcmp($end, substr($r,$p,strlen($end)))==0) ){
				$r = substr($r,0,$p);
				$pNext = $pNext + strlen($init.$r.$end);
			}
		}
		return $r;
	}



	// retorna o conteúdo de um elemento cujo inicio é $ini e cujo fim é $end 
	function find($xml, $init, $end){		
//		return $this->old_find($xml, $init, $end, $foundElement);
//		$foundElement =0;
		return $this->new_find($xml, $init, $end, $foundElement);
	}

	
	
	function recursiveFind($xml, $init, $end, $trim=true){
//		return $this->old_recursiveFind($xml, $init, $end);
		return $this->new_recursiveFind($xml, $init, $end, $trim);
	}

	
	
	function old_find($xml, $init, $end, &$foundElement){
		$foundElement = false;
		$r = '';
		$p = strpos($xml,$init);
		if (($p) || (strcmp($init, substr($xml,$p,strlen($init)))==0) ){
			$r = substr($xml,$p + strlen($init));
			$p = strpos($r,$end);
			$r = substr($r,0,$p);
			$foundElement = true;
		}
		return $r;
	}

	function old_recursiveFind($xml, $init, $end){
		$i = 0;
		$res = array();
		$r = $this->old_find($xml, $init, $end);
		if ($r!=''){
			$res[$i++] = $r;	
		}
		while ($r!=''){
			$pos = strpos($xml, $init.$r.$end)+strlen($init.$r.$end);
			$xml = substr($xml,$pos);
			$r = $this->old_find($xml, $init, $end);
			if ($r!=''){
				$res[$i++] = $r;	
			}
		}
		return $res;
	}

	function insertElement($content, $element="root", $stringAttributes=""){
		$xml = "<".$element;
		if ($stringAttributes){
			$xml .= ' '.$stringAttributes;
		}
		$xml .= ">";
		$xml .= $this->extractContent($content)."</".$element.">";
		return $xml;
	}

	function deleteElement($xml, $element){
		$content = "<".$element.">".$this->find($xml, "<".$element.">", "</".$element.">")."</".$element.">";
		$r = str_replace($content, '', $xml);
		return $r;
	}

	function setAttribute($xml, $nodePath, $position, $attrName, $attrValue, $mode='', $setNameSpace=''){
		if ($attrValue || ($mode=='update')){

			$xmlList[count($xmlList)] = "<xml>".$this->extractContent($xml)."</xml>";
			$xmlList[count($xmlList)] = "<setNameSpace>".$setNameSpace."</setNameSpace>";		
			$xmlList[count($xmlList)] = "<selection>";					
			$xmlList[count($xmlList)] = "<nodePath>".$nodePath."</nodePath>";		
			$xmlList[count($xmlList)] = "<position>".$position."</position>";
			$xmlList[count($xmlList)] = "<attribute>".$attrName."</attribute>";
			if ($attrValue=='none'){
				$attrValue = '';
			}
			
			$xmlList[count($xmlList)] = "<value>".$attrValue."</value>";
			$xmlList[count($xmlList)] = "</selection>";
			$xml = $this->xml_xsl($this->concatXML($xmlList), $this->getXslAttribute());
		}
		return $xml;
	}
	
	function setElement($xml, $nodePath, $position, $elementName="", $arrayElementValue, $mode='add', $setNameSpace=''){

		$open = '';
		$close = '';
		
		if ($arrayElementValue || ($mode=='update')){
			$xmlList[count($xmlList)] = "<xml>".$this->extractContent($xml)."</xml>";
			$xmlList[count($xmlList)] = "<setNameSpace>".$setNameSpace."</setNameSpace>";		

			$xmlList[count($xmlList)] = "<selection>";		
			
			$xmlList[count($xmlList)] = "<nodePath>".$nodePath."</nodePath>";		
			$xmlList[count($xmlList)] = "<position>".$position."</position>";
			$xmlList[count($xmlList)] = "<elementName>".$elementName."</elementName>";
			$xmlList[count($xmlList)] = "<elementValue>";
			
			if (is_array($arrayElementValue)){
				foreach ($arrayElementValue as $elementValue){
					if ($elementValue=='none'){
						$elementValue = '';
					}
					if ($elementName && (strpos($elementValue, "</".$elementName.">")==0)){
						$open = "<".$elementName.">";
						$close = "</".$elementName.">";
					}					
					$xmlList[count($xmlList)] = $open.$elementValue.$close;
				}
			} else {
				if ($arrayElementValue=='none'){
					$arrayElementValue = '';
				}
				if ($elementName && (strpos($arrayElementValue, "</".$elementName.">")==0)){
					$open = "<".$elementName.">";
					$close = "</".$elementName.">";
				}	
				$xmlList[count($xmlList)] = $open.$arrayElementValue.$close;
			}
			$xmlList[count($xmlList)] = "</elementValue>";
			$xmlList[count($xmlList)] = "<mode>".$mode."</mode>";
			
			$xmlList[count($xmlList)] = "</selection>";
			
			$xml = $this->xml_xsl($this->concatXML($xmlList), $this->getXslAttribute());
		}
		return $xml;
	}
	
	function getElemOrAttrValue($xml, $xpaths){
		$xmlList[count($xmlList)] = '<xml>'.$this->extractContent($xml).'</xml>';
		$separator = 'QUEBRA_DE_TEXTO';		
		if (strpos($xml, $separator)==0){
			$xmlList[count($xmlList)] = '<separator>'.$separator.'</separator>';
		} 

		foreach ($xpaths as $xpath){
			$xmlList[count($xmlList)] = '<xpaths>';
			$arrayXpath = explode('/',$xpath);
			foreach ($arrayXpath as $xpath){
				if (strlen($xpath)>0){
					$xmlList[count($xmlList)] = '<xpath>'.$xpath.'</xpath>';
				}
			}
			$xmlList[count($xmlList)] = '</xpaths>';
		}

		$DIR = dirname(__FILE__) ;
		$result = $this->extractContent( $this->xml_xsl($this->concatXML($xmlList), $DIR.'/xsl_xml_getElemOrAttrValue.xsl'));
		$result = str_replace($separator.$separator, $separator, $result);
		$result = substr($result,0, strlen($result)-strlen($separator));

		$arrayAttrValue = explode($separator, $result);
		return $arrayAttrValue;
	}
	
		function getXslAttribute(){
			$version = split ("\.", phpversion());
			$DIR = dirname(__FILE__) ;
	    	if ( $version[0] > 4 || ($version[0] == 4 && $version[1] >= 1) ) {
				$r = $DIR.'/xml_setElementOrAttribute.xsl';
			} else {
				$r = $DIR.'/xml_setElementOrAttribute__vPHP4.0.xsl';
			}
			return $r;
		}	
}
?>