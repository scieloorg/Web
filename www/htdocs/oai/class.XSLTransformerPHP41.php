<?php
/*
XSLTranformer -- Class to transform XML files using XSL with the Sablotron libraries.
Justin Grant (2000-07-30)
Thanks to Bill Humphries for the original examples on using the Sablotron module.
*/
/*
ini_set("display_errors","1");
error_reporting(E_ALL);
*/

class XSLTransformerPHP41 {
        var $xsl, $xml, $output, $error, $errorcode, $processor, $uri, $host, $port, $byJava;   //socket

	/* Constructor  */	 
	function XSLTransformerPHP41() {
	    $this->processor = xslt_create(); 
	} 
	function setXslBaseUri($uri){	
		if ($uri != ""){			
			if (strpos(' '.$uri,'file://')==0) $uri = 'file://'.$uri; // eh obrigatorio file:// para Windows 
			xslt_set_base($this->processor, $uri);
		}	
		return true;
	}
 	/* Destructor */ 
	function destroy() { 
		xslt_free ($this->processor); 
	} 

	/* transform method */
    function transform($xml, $xsl, &$error)
    {
       	$args = array ( '/_xml' => $xml, '/_xsl' => $xsl );
		$result = xslt_process ($this->processor, 'arg:/_xml', 'arg:/_xsl', NULL, $args);
		if (!$result) {
       	    $error = "Error: " . xslt_error ($this->processor) . " Errorcode: " . xslt_errno ($this->processor);
		} else {
			$result = $result;
		}
		return $result;
    }
}
?>
