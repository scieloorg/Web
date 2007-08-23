<?php
/*XSLTranformer -- Class to transform XML files using XSL with the Sablotron libraries.
Justin Grant (2000-07-30)
Thanks to Bill Humphries for the original examples on using the Sablotron module.
*/
/* test */
 /*  $transformer = new XSLTransformer();
  if ($transform->setXsl("http://www.someurl.com/document.xsl") &&
      $transform->setXml("http://www.someurl.com/document.xml")) {
 	$transformer->transform();
 	echo $transformer->getOutput();
  } else {
 	echo $transformer->getError();
  } 
*/
include_once (dirname(__FILE__)."/class.XSLTransformSocket.php"); //socket

class XSLTransformer{
	var $xsl, $xml, $output, $error, $errorcode, $processor, $uri, $host, $port; //socket

	/* Constructor  */
	function XSLTransformer() { 
                $defFile = new  DefFile("scielo.def");
                $this->processor = xslt_create();
                $this->host = $_SERVER["SERVER_ADDR"];
                $this->port = $defFile->getKeyValue("SOCK_PORT");
		$this->socket = new XSLTransformerSocket($this->host,$this->port);
		if (!$this->socket){
			die("socket creation error!");
		}
	}
	function setXslBaseUri($uri){	
		if ($uri != ""){
			xslt_set_base($this->processor, $uri);
		}	
		return true;
	}
  	/* Destructor */
 	function destroy() {
 		xslt_free($this->processor);
 	}

 	/* output methods */
	function setOutput($string) {
		$this->output = $string;
	}

	function getOutput() {
		return utf8_encode($this->output);
	}

	/* set methods */
	function setXml($uri) {
 		if($doc = new docReader($uri)) {
 			$this->xml = $doc->getString();
 			return true;
 		} else {
 			$this->setError("Could not open $xml");
 			return false;
 		}
 	}

	function setXsl($uri) {
		if($doc = new docReader($uri)) {
			$this->xsl = $doc->getString();
			return true;
		} else {
			$this->setError("Could not open $uri");
			return false;
		}
	}	

/*			
	function transform() {
         	xslt_process($this->xsl, $this->xml, $outcome);
 	        $this->setOutput($outcome);
	}
*/		

	/* transform method */	
        function transform() {
//              xslt_process($this->xsl, $this->xml, &$output, &$err);
//              $this->setOutput($output);
//              $this->setError($err);
                if (getenv("ENV_SOCKET")=="true"){ //socket
                        $result = $this->socket->transform($this->xsl, $this->xml);
                        $this->setOutput($result."<!--transformed by SOCKET Java-->");
                }else{
                        $args = array("/_stylesheet", $this->xsl, "/_xmlinput", $this->xml, "/_output", 0, 0);
                        if ($err = xslt_run ($this->processor, "arg:/_stylesheet", "arg:/_xmlinput", "arg:/_output", 0, $args))
                        {
                                $output = xslt_fetch_result ($this->processor, "arg:/_output");
                                $this->setOutput($output."<!--transformed by PHP-->");
                        }
                        else
                        {
                                $this->setError($err);
                        }
                }
        }

	/* Error Handling */
 	function setError($string) {
 		$this->error = $string;
 	}  	

	function getError() {
 		return $this->error; 	
	} 
}

/* docReader -- read a file or URL as a string */

 /* test */
 /* $docUri = new docReader('http://www.someurl.com/doc.html');
    echo $docUri->getString(); */

class docReader {
  	var $string; 	// public string representation of file
 	var $type; 	// private URI type: 'file','url'
 	var $bignum = 3500000;

  	/* public constructor */
 	function docReader($uri) {	// returns integer
		$this->setUri($uri); 		
		$this->setType();
  		$fp = fopen($this->getUri(),"r");

 		if($fp) {
			// get length
 			if ($this->getType() == 'file') {
 				$length = filesize($this->getUri());
 			}  else {
 				$length = $this->bignum;
  			}
			$acumulado = "";
			while (!feof($fp)){
				$acumulado .= fread ($fp, $length);
			}
			$this->setString ($acumulado);

/*  			$this->setString(fread($fp,$length)); */
			fclose($fp);
			return 1;
 		} else {
 			return 0;
 		}
 	}

 	/* determine if a URI is a filename or URL */
 	function isFile($uri) { 	// returns boolean
		if (strstr($uri,'http://') == $uri) {
 			return false;
 		} else {
 			return true;
 		}
 	}  	

	/* set and get methods */
  	function setUri($string) {
 		$this->uri = $string;
 	}

  	function getUri() {
 		return $this->uri;
 	}

  	function setString($string) {
 		$this->string = $string;
 	}

  	function getString() {
 		return $this->string;
 	}

 	function setType() {
 		if ($this->isFile($this->uri)) {
 			$this->type = 'file';
 		} else {
 			$this->type = 'url';
 		}
 	}

  	function getType() {
 		return $this->type;
 	}

}  

?>
