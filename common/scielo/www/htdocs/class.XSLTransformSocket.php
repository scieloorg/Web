<?php
include_once (dirname(__FILE__)."/classes/class_xml_check/class_xml_check.php"); //classe para verificacao de XML
include_once (dirname(__FILE__)."/applications/scielo-org/includes/phpmailer/class.phpmailer.php"); //classe para envio de email
include_once (dirname(__FILE__)."/class.XSLTransformer.php");

class XSLTransformerSocket {
	var $xsl, $xml, $host, $port, $FINISH, $END_OF_MESS_SYMBOL, $socket, $output, $defFile;
	/* Constructor  */	 
	function XSLTransformerSocket($host,$port) { 
		$this->defFile = parse_ini_file(dirname(__FILE__)."/scielo.def",true);
		$this->host = $host;
		$this->port = $port;
		$this->END_OF_MESS_SYMBOL = "?<==>?";		
		$this->FINISH = "?<++>?";
		$this->socket = @fsockopen($host,$port, $errno, $errstr);
		if ($this->socket)
		{
			putenv("ENV_SOCKET=true");
			$this->output .= "<!--transformed by socket JAVA ".date('')."-->";
		}
		else
		{
			$this->output .= "<!--transformed by PHP-->";	
		}
	} 

 	/* Destructor */ 
	function destroy() { 
       if ($this->socket) {
       fwrite($this->socket, FINISH."\n");
       fclose($this->socket);
       $this->socket = NULL;
	   }
	}

	function transform($xsl, $xml){
	  if (!$this->socket)
	  {
	   	die("$errstr ($errno)<br />\n");
	  }
		$aspas = array(chr(147),chr(148));
		$menos = array(chr(150));

		$xml = utf8_decode($xml);
		$xml = str_replace($aspas,"&quot;",$xml);
		$xml = str_replace($menos,"-",$xml);
		$xml = str_replace("\n","",$xml);
		$xml = str_replace(chr(132),"",$xml);
		$xml = str_replace(chr(131),"",$xml);
		$xml = str_replace(chr(134),"",$xml);
		$xml = str_replace(chr(145),"",$xml);
		$xml = str_replace(chr(146),"",$xml);
		//fwrite($this->socket, "ISO-8859-1:".$xsl.":".$xml."\n") or die("1")
	
		if($this->defFile['XML_ERROR']['ENABLED_XML_ERROR'] == '1'){
			$xmlCheck = new XML_check();
			$xml1 = $xml;
			if($xmlCheck->check_string($xml1)){ // verifica se o XML é bem formado
				fwrite($this->socket, "utf-8:".$xsl.":".$xml."\n") or die("1");
				fwrite($this->socket, $this->END_OF_MESS_SYMBOL."\n") or die("2");
				$message = ($this->recebeResultado() . "<!-- XML well formed verifier ON -->");
			}else{
				include_once (dirname(__FILE__)."/mail_msg.php");
				$url = "http://".$_SERVER['SERVER_NAME']."/php/xmlError.php?lang=".$_REQUEST['lng'];
				exit('<META http-equiv="refresh" content="0;URL='.$url.'">');
			}
		}else{
			fwrite($this->socket, "utf-8:".$xsl.":".$xml."\n") or die("1");
			fwrite($this->socket, $this->END_OF_MESS_SYMBOL."\n") or die("2");
			$message = ($this->recebeResultado() . "<!-- XML well formed verifier OFF -->");
		}

		//var_dump($xml);
		//var_dump($xsl);
		//var_dump($message);
		//$message =  utf8_decode($message);
		//die($message);

	 	return $message;
	}


    function recebeResultado() {

       if (!$this->socket) {
           die("recebeResultado/comunicacao encerrada");
       }
       $message = NULL;
       $buffer = NULL;

       while (!feof($this->socket)) {
           $buffer = fgets($this->socket,4096);
           if ($buffer == false) {
               echo "recebeResultado/erro de leitura";
           }
		   
		   if (strncmp($buffer,$this->END_OF_MESS_SYMBOL,6)==0) {
             break;
           }
		   
           $message .= $buffer;
       }

	   return $message;
	}
}
?>
