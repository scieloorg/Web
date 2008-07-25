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
		$s = str_replace(chr(32).chr(150).chr(32), '&#32;&#150;&#32;', $s);
		$s = str_replace('–', '&#150;', $s);		
	
		$s = str_replace('', '', $s);		
		$s = str_replace('&#x2028;', '<p/>', $s);
		$s = str_replace('&#710;', '^', $s);
		/* 
		$s = str_replace(' < ', '&lt; ', $s);
		$s = str_replace(' > ', ' &gt;', $s);
		*/
		$s = str_replace(' & ', ' &amp; ', $s);

		return $s;
	}

	function replaceThisByContent($parXML){
		$xml = $parXML;
		
		$filename = $this->getContent('replace-this-by-content', $xml);
		
		if ($filename){
			$filecontent = $this->returnBody($this->read($filename));

			$body = $this->getContent('part1', $filecontent);
			if ($body){
				$references = $this->getContent('refs', $filecontent);
				$back = $this->getContent('part2', $filecontent);
				
				if ($references){
					$array_ref_original = explode('<!-- ref -->',$xml);
					$array_ref_translation = explode('[citation]',$references);

					$k =0 ;
					foreach ($array_ref_original as $item){
						if ($k){
							$newItem = substr($item, 0, strpos($item, '<!-- end-ref -->'));
							$oldItem = substr($array_ref_translation[$k], 0, strpos($array_ref_translation[$k], '[/citation]'));
							$references = str_replace('[citation]'.$oldItem.'[/citation]', $newItem, $references);
						}
						$k ++;
					}
				}
				$filecontent = '<!-- inicio arquivo -->'.$body.$references.$back.'<!-- fim arquivo -->';
				$xml = $this->replaceBody($xml, $filecontent);
			} else {
				$body = $filecontent;
				$xml = str_replace('[replace-this-by-content]'.$filename.'[/replace-this-by-content]', '<!-- inicio arquivo -->'.$body.'<!-- fim arquivo -->', $xml);
				$xml = $this->replaceThisByContent($xml);
			}
		} 
		return $xml;
	}

	function old_replaceThisByContent($parXML){
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
		$s = file_get_contents($filename);
		return $s;
	}
	function getContent($tag, $s){		
		$p = strpos($s, "[$tag]");
		if ($p){
			$x = substr($s,$p+ strlen("[$tag]"));
			$p = strpos($x, "[/$tag]");
			if ($p) {
				$x = substr($x,0,$p);
			}
		}
		return $x;
	}
function replaceBody($xml, $body){
                $p = strpos($xml, "<BODY>");
                if ($p){
                        $xmlNovo1 = substr($xml,0,$p)."<BODY><![CDATA[";
                        $p = strpos($xml, "</BODY>");

                        $xmlNovo2 = "]]>".substr($xml,$p);
                } else {
                        $p = strpos($xml, "<fulltext ");
                        if ($p){
                                $s = substr($xml, 0, $p);
                                $p = $p + strpos($s, ">");
                                $xmlNovo1 = substr($xml,0,$p);
                                $p = strpos($xml, "</fulltext>");
                                $xmlNovo2 = substr($xml,$p);
                        }
                }
                return $xmlNovo1.$body.$xmlNovo2;
        }
	function returnBody($body){
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
		return $body;
	}
}
?>