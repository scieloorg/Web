<?php
ini_set("display_errors","1");
error_reporting(E_ALL ^E_NOTICE ^E_WARNING);
include_once (dirname(__FILE__)."/classes/class_xml_check/class_xml_check.php"); //classe para verificacao de XML
include_once (dirname(__FILE__)."/class.XSLTransformer.php");

class XSLTransformerSocket {
	var $xsl, $xml, $host, $port, $FINISH, $END_OF_MESS_SYMBOL, $socket, $output, $defFile;

        function writeLog($content,$filename){
        	if (!$handle = fopen($filename, 'x+')) {
                        if (!$handle = fopen($filename, 'a+')) {
                        	exit;
                        }
                }else{
			chmod($filename, 0766);
		}
                if (fwrite($handle, $content) === FALSE) {
// 	               echo "Cannot write to file ($filename)";
                       exit;
                }
                fclose($handle);
        }

	/* Constructor  */	 
	function XSLTransformerSocket($host,$port) { 
		$this->defFile = parse_ini_file(dirname(__FILE__)."/scielo.def",true);
		$this->host = $host;
		$this->port = $port;
		$this->END_OF_MESS_SYMBOL = "?<==>?";		
		$this->FINISH = "?<++>?";
		$this->socket = @fsockopen($host,$port, $errno, $errstr);
		$this->socket_log_file = $this->defFile['SOCKET']['ACCESS_LOG_FILE'];
		$this->enable_socket_log = $this->defFile['SOCKET']['ENABLE_ACCESS_LOG'];
		for($i=0 ; $i<10 ; $i++){ //implementando tentativas para conectar ao java.
			if ($this->socket)
			{
				putenv("ENV_SOCKET=true");
				$this->output .= "<!--transformed by socket JAVA ".date('')."-->";
                              	if ($this->enable_socket_log){
					$this->writeLog($_SERVER["SERVER_ADDR"]." JAVA \n",$this->socket_log_file);
				}
				break;
			}
			else
			{
				$this->output .= "<!--transformed by PHP-->";	
				if ($this->enable_socket_log){
					$this->writeLog($_SERVER["SERVER_ADDR"]." PHP  \n",$this->socket_log_file);
					header('Location: http://'.$_SERVER["SERVER_NAME"].$_SERVER["REQUEST_URI"]);
				}
			}
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

		/* 
			o transformador via socket usa xml com encoding iso,
			assim, se o xml vier em utf, necessário executar o utf8_decode
		*/
		if (strpos(strtolower($xml),'utf-')>0) {
 			$xml = utf8_decode($xml);
			$utf = true;
 	    } 
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
		/*
			se o xml de entrada tem encoding iso, entao necessario executar utf8_decode
		*/
		if (!$utf) $message = utf8_decode($message);

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
