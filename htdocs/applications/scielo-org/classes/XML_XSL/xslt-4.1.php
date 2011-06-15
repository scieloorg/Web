<?php 

/*
XSLTranformer -- Class to transform XML files using XSL with the Sablotron libraries.
Justin Grant (2000-07-30)
Thanks to Bill Humphries for the original examples on using the Sablotron module.

Ultima atualiza��o: 13/01/2005 
Analista :  Vinicius Andrade  (SCI)
Descri��o:

1. Permite realizar replaces de strings nos arquivos XML e XSL antes de realizar a transforma��o
    -> Utilizar m�todo setReplacements() para informar array do tipo 
   	  array ("string troca 1" => "string nova 1", "string troca 2" => "string nova 2", ...)

2. Permite o uso de caminhos relativos no XSL para o elemento include e fun��o document()
   -> Utilizar m�todo setXslBaseUri() 
      ex. 
	  setXslBaseUri('file://home/bvs/htdocs')
	  XSL: <include href="xsl/home.xsl">

*/

class XSLTransformer {
	var $xsl, $xml, $output, $error, $processor, $errorcode, $replacements, $xslBaseUri;

	/* Constructor  */	 
	function XSLTransformer() { 
		$this->processor = xslt_create(); 
	} 

 	/* Destructor */ 
	function destroy() { 
		xslt_free ($this->processor); 
	} 

	/* output methods */
	function setOutput ($string) {
		$this->output = $string;
	}

	function getOutput() {
		return $this->output;
	}

	/* set methods */
	function setXml ($xml) { 
		if ($this->isXmlContent($xml))
		{
 			$this->xml = $xml;
			return true;
		}else{
			$doc = new docReader($xml);
			if ( $doc->readDoc() == true ) 
			{ 
				$xml = $doc->getString();
				if ($this->replacements != ""){
					$xml = $this->processReplace($xml);
				}
				$this->xml	= $xml; 
				return true; 
			} else 	{ 
				$this->setError ("Could not open xsl file in \"$xml\""); 
				$this->setErrorCode("4"); 
				return false; 
			} 	
		}	
	} 	
    
	function setXsl($uri) {
		$doc = new docReader ($uri);
		
		if ( $doc->readDoc() == true ) {
			$this->xsl	= $doc->getString();
			return true;
		} 
        else {
			$this->setError ("Could not open xsl file in \"$uri\""); 
			$this->setErrorCode("4"); 

			return false;
		}
	}
	
	function isXmlContent($xml)
	{
		if (strcmp(substr($xml,0,5), "<?xml") == 0)
		{
			return true;
		}
		else
		{
			return false;
		}
	}

	function setReplacements ($findReplaceArray) { 
		$this->replacements = $findReplaceArray;
	}
	
	function setXslBaseUri($uri){	
		if ($uri != ""){
			xslt_set_base($this->processor, $uri);
		}	
		return true;
	}
	
	/* transform method */
    function transform()
    {
		/* apply replacements on xml and xsl strings after process transformation */
		if ($this->replacements != ""){
				$this->xml = $this->processReplace($this->xml);
				$this->xsl = $this->processReplace($this->xsl);
		}	
//debug("transform xml",$this->xml);		
//debug("transform xsl",$this->xsl);		
		$args = array ( '/_xml' => $this->xml, '/_xsl' => $this->xsl );
        $result = xslt_process ($this->processor, 'arg:/_xml', 'arg:/_xsl', NULL, $args); 
//debug("transform res",$result);		

        if ($result) {
		    $this->setOutput ($result);
			return true;
		}
		else {
		    $this->setError (xslt_error($this->processor));
			$this->setErrorCode(xslt_errno($this->processor));
			return false;
		}
    }
    
	/* Error Handling */ 
	function setError ($string) { 
		$this->error = $string; 
	} 

	function getErrorMessage() {
		$errorMsg =  "<pre>\n" .
				"There was an error that occurred in the XSL transformation ...\n" .
				"\tError string: " . $this->error . "\n" .
				"\tError number: " . $this->errorcode . "\n" .
			"</pre>\n";
		return $errorMsg;
	} 
	
 	function getError() { 
		return $this->error; 
	} 

 	function setErrorCode($string) {
 		$this->errorcode = $string;
 	}  	

	function getErrorCode() {
 		return $this->errorcode; 	
	} 
	
	function processReplace($string){
		foreach ($this->replacements as $key => $value) { 
			$find[] = "/\[" . $key . "\]/";
			$replace[] = $value;
		}
		$changed = preg_replace($find, $replace, $string);
		return $changed;
	}
	
}

/* docReader -- read a file or URL as a string */ 
class docReader { 
	var $string;	// public string representation of file 
	var $type;		// private URI type: 'file','url' 
	var $bignum		= 500000; 

	/* public constructor */ 
	function docReader ($uri) {  
		$this->setUri ($uri); 
		$this->setType(); 
		return;
	} 
	
	function readDoc(){
		$fp = fopen ($this->getUri(),"r"); 

		if ($fp) { 
 			// get length 
			if ( $this->getType() == 'file' ) { 
				$length = filesize ($this->getUri()); 
				$acumulado = fread ($fp, $length);
			}  
            else { 				
				$acumulado = "";
				while (!feof($fp)){
					$acumulado .= fgets ($fp, 4096);
				}
 			} 

			$this->setString($acumulado);
			fclose($fp);			
			return true; 
		} 
        else { 
			return false; 
		} 
	}


	/* determine if a URI is a filename or URL */ 
	function isFile ($uri) { 	// returns boolean 
		if (strstr ($uri,'http://') == $uri) { 
			return false; 
		} 
        else { 
			return true; 
		} 
	} 

	/* set and get methods */ 
	function setUri ($string) { 
		$this->uri = $string; 
	} 

	function getUri() { 
		return $this->uri; 
	} 

	function setString ($string) { 
		$this->string = $string; 
	} 

	function getString() { 
		return $this->string; 
	} 

	function setType() { 
		if ( $this->isFile ($this->uri) ) { 
			$this->type = 'file'; 
		} 
        else { 
			$this->type = 'url'; 
		}	 
	} 

	function getType() { 
		return $this->type; 
	} 
} 

?>