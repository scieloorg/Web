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
include_once (dirname(__FILE__)."/class.XSLTransformSocket.php"); //socket
class XSLTransformer {
        var $xsl, $xml, $output, $error, $errorcode, $processor, $uri, $host, $port, $byJava;   //socket

	/* Constructor  */	 
	function XSLTransformer() {
	    $defFile = parse_ini_file(dirname(__FILE__)."/scielo.def.php",true);
	    $this->processor = xslt_create(); 
	    $this->host = $_SERVER["SERVER_ADDR"];
        $this->port = $defFile["SOCKET"]["SOCK_PORT"];
        $this->socket = new XSLTransformerSocket($this->host,$this->port);
	   /* retirado por Roberta 
	   if (!$this->socket){
        	die("socket creation error!");
		}
		*/
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

	/* output methods */
	function setOutput ($string) {
		$this->output = $string;
	}

	function getOutput() {
		return $this->xml_utf8_decode($this->output)."<!-- class.XSLTranformer41.php - 2 -->";
	}

	/* set methods */
	function setXml($xml) {
		if ($this->isXmlContent($xml))
		{
 			$this->xml = $xml;
			return true;
		}
		elseif ($doc = new docReader($xml)) 
		{
 			$this->xml = $doc->getString();
 			return true;
 		} 
		else 
		{
 			$this->setError("Could not open $xml");
 			return false;
 		}
 	}

	function setXslFile($xslFile) {
		$this->xslFile = $xslFile;
 	}

	function returnXslKey(){
		if ($this->xslFile){
			$pos_ini = strrpos($this->xslFile,"/")+1;
			$pos_ini = strrpos($this->xslFile,"/")+1;
			$pos_len = strrpos($this->xslFile,".")-$pos_ini;
			$r = strtoupper(substr($this->xslFile,$pos_ini,$pos_len));
		} else {
			if (strpos($this->xsl,".xsl")==0 && strpos(" ".$this->xsl,"/")==0){
				$r = $this->xsl;
			}
		}
		return $r;
	}

	function returnXslContent(){		
		if ($this->xslFile){
			$r = file_get_contents($this->xslFile);
		} else {
			if (strpos("x".$this->xsl," ")>0){
				$r = $this->xsl;
			}
		}
		return $r;
	}
	
	function getXsl($type) {
/*
var_dump($type);
var_dump($this->xsl);
var_dump($this->xslKey);
var_dump($this->xslFile);
var_dump($this->xslFileContent);
*/
		switch ($type){
			case "key":
				$r = $this->returnXslKey();
				break;
			case "filecontent":
				$r = $this->returnXslContent();							
				break;						
		}
		if (!$r){
			die('Anteriormente, para a transformação java, era feito $this->xsl = o apelido da XSL. Atualmente, dev usar o metodo $this->setXslFile passando o caminho completo do arquivo XSL. Essa mudança tem o objetivo de padronizar o ato de instanciar a XSL, servindo tanto para transformação java, quanto php. Pois caso o java não esteja operando, a transformação php pode ser usada.');
		}
/*
var_dump($r);
var_dump($this->xsl);
var_dump($this->xslKey);
var_dump($this->xslFile);
var_dump($this->xslFileContent);
*/
	return $r;
	}

	function setXsl($uri) {
		$this->xsl	= $uri;
		/*if ( $doc = new docReader ($uri) ) {
			$this->xsl	= $doc->getString();
			return true;
		} else {
			$this->setError ("Could not open $uri");
			return false;
		}*/
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
	
	function xml_utf8_decode($xml){
		$xml = utf8_decode($xml);
		$xml = str_replace('utf-8','iso-8859-1',$xml);
		$xml = str_replace('UTF-8','iso-8859-1',$xml);
		return $xml;
	}
	function xml_utf8_encode($xml){
		$xml = utf8_encode($xml);
		$xml = str_replace('iso-8859-1','utf-8',$xml);
		$xml = str_replace('ISO-8859-1','utf-8',$xml);
		return $xml;
	}
	/* transform method */
    function transform()
    {
		$this->xml = str_replace("&#","MY_ENT_",$this->xml);
		//$this->xml = xmlspecialchars  ($this->xml);

		$err = "";
		$result = "";
		$tryByPHP = false;
		$tryRedirect = false;
		if ($this->socket->checkSocketOpen()) {
			$result = $this->socket->transform($this->getXsl("key"), $this->xml);
			switch ($result){
				case "INVALID_XML":
					include_once (dirname(__FILE__)."/mail_msg.php");
					$url = "http://".$_SERVER['SERVER_NAME']."/php/xmlError.php?lang=".$_REQUEST['lng'];
					exit('<META http-equiv="refresh" content="0;URL='.$url.'">');
					break;
				case "NO_SOCKET":
					/* try again, redirecting or try by PHP */
					//$tryByPHP = true;
					$tryRedirect = true;
					break;
				default:
					$tryByPHP = false;
					$tryRedirect = false;
					$this->byJava ='true';
					$result = str_replace("MY_ENT_","&#",$result);

					$this->setOutput ($result."<!--transformed by JAVA ".date("h:m:s d-m-Y")."-->");
					break;
			}
        } else {
			/* try again, redirecting or try by PHP */			
			$tryByPHP = true;
			$this->transformedBy = "PHP";
			//$tryRedirect = true;
		}

		if ($tryByPHP){
        	$args = array ( '/_xml' => $this->xml, '/_xsl' =>  $this->getXsl("filecontent") );
			$result = xslt_process ($this->processor, 'arg:/_xml', 'arg:/_xsl', NULL, $args);
			if ($result) {
		        $this->byJava = 'false';
				$result = str_replace("MY_ENT_","&#",$result);
				$this->setOutput ($result."<!--transformed by PHP ".date("h:m:s d-m-Y")."-->");
							$this->transformedBy = "PHP";

	        } else {
        	    $err = "Error: " . xslt_error ($this->processor) . " Errorcode: " . xslt_errno ($this->processor);
	            $this->setError ($err);
				var_dump($err);
				var_dump($this->xsl);
				var_dump($this->xml);
        	}
        } elseif ($tryRedirect) {
			header('Location: http://'.$_SERVER["SERVER_NAME"].$_SERVER["REQUEST_URI"]);
		}		
    }
    
	
	/* Error Handling */ 
	function setError ($string) { 
		$this->error = $string; 
	} 

 	function getError() { 
		return $this->error; 
	} 
}

/* docReader -- read a file or URL as a string */ 
class docReader { 
	var $string;	// public string representation of file 
	var $type;		// private URI type: 'file','url' 
	var $bignum		= 3500000; 

	/* public constructor */ 
	function docReader ($uri) {  // returns integer 
		$this->setUri ($uri); 
		$this->setType(); 
		$fp = fopen ($this->getUri(),"r"); 

		if ($fp) { 
 			// get length 
			if ( $this->getType() == 'file' ) { 
				$length = filesize ($this->getUri()); 
			}  
            else { 
				$length = $this->bignum; 
 			} 
			$acumulado = "";
			while (!feof($fp)){
				$acumulado .= fread ($fp, $length);
			}
			$this->setString ($acumulado);

			/* $this->setString (fread ($fp, $length)); */
			fclose($fp);

			return 1; 
		} 
        else { 
			return 0; 
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

function xmlspecialchars($s){
//echo microtime ();
$s = utf8_decode($s);
	$s = str_replace("<", "NO_CHANGE_LT", $s);
	$s = str_replace(">", "NO_CHANGE_GT", $s);
	$s = str_replace('"', "NO_CHANGE_QUOTE", $s);
	$s = htmlentities($s);
	$s = entityname2number($s);
	$s = str_replace("NO_CHANGE_LT", "<", $s);
	$s = str_replace("NO_CHANGE_GT", ">", $s);
	$s = str_replace("NO_CHANGE_QUOTE", '"', $s);
//echo microtime ();
	return $s;
}
function entityname2number($s){
	//$t = parse_ini_file("/home/scielo/www/bases/gizmo/entname2number.ini", false);

	$f = file_get_contents("../bases/gizmo/entname2number.ini");

	$a = explode("\r\n",$f);
	foreach ($a as  $valor){
		$x = explode("=", $valor);
		$t1[] = $x[0];
		$t2[] = $x[1];
	}
	/*
	var_dump($t1);
	var_dump($t2);
	var_dump($s);
*/
	$s = str_replace($t1, $t2, $s);
//	var_dump($s);

	return $s;
}
?>
