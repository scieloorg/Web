<?php
	class StringXML {

		function getContent($tag, $s){		
			$p = strpos($s, "<$tag>");
			$rest = substr($s, $p+ strlen("<$tag>"));
			if ($p){
				$x = substr($s,$p+ strlen("<$tag>"));
				$p = strpos($x, "</$tag>");
				if ($p) {
					$r = substr($x,0,$p);

				}
			}
			return $r;
		}

	}
?>