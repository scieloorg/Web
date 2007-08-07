<?php

class XMLFromIsisScript {
	var $_xml;
	function XMLFromIsisScript($xml){
		$this->_xml = $xml;
	}
	function getXml(){
		$this->_xml = $this->fixUtfEntities($this->_xml); // 200603
		$this->_xml= $this->replaceThisByContent($this->_xml); // 200603
		return $this->_xml;
	}
	function getSpecialXSL(){
		if (strpos($this->_xml, '<mml:math ')>0){
			$xsl = "_mathml";
		} else {
			$xsl = "_html";
		}
		return $xsl;
	}
	function fixUtfEntities($s){
		$s = str_replace('&#x2028;', '<p/>', $s);
		$s = str_replace('&#710;', '^', $s);
		
		return $s;
	}

	function replaceThisByContent($parXML){
		$xml = $parXML;
		
		$p = strpos($xml, '[replace-this-by-content]');
		if ($p >0) {
			$pf = strpos($xml, '[/replace-this-by-content]');
			$expression = substr($xml,$p, $pf-$p).'[/replace-this-by-content]';
			$filename = str_replace('[replace-this-by-content]', '', str_replace('[/replace-this-by-content]', '', $expression));
			$body = $this->read($filename);

			$bodyBegin = strpos(strtolower($body), '<body');
			if ($bodyBegin>0){
				$body = substr($body, $bodyBegin);
				$bodyBegin = strpos($body, '>');
				$body = substr($body, $bodyBegin+1);
			}
			$bodyEnd = strpos(strtolower($body), '</body>');
			if ($bodyEnd >0){
				$body = substr($body, 0, $bodyEnd);
			}

			$xml = str_replace($expression, '<!-- inicio arquivo -->'.$body.'<!-- fim arquivo -->', $xml);
			$xml = $this->replaceThisByContent($xml);
		} 
		return $xml;
	}
	function read($filename){
		$f = fopen($filename, "r");
		$s = fread($f, 100*1024);
		return $s;
	}
}
?>