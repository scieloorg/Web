<?php
class XSLTransformerJava {
	var $xsl, $xml, $host, $port, $FINISH, $END_OF_MESS_SYMBOL, $socket, $output, $defFile;

	/* Constructor  */	 
	function XSLTransformerJava($host,$port) { 
		//$this->host = $host;
		//$this->port = $port;
		$this->END_OF_MESS_SYMBOL = "?<==>?";		
		$this->FINISH = "?<++>?";
		if ($port){
			$this->socket = @fsockopen($host,$port, $errno, $errstr,10);
		}		
	} 

	function checkSocketOpen(){
		$r = false;
		if ($this->socket) {
			$r = true;
		}
		return $r;
	}
 	/* Destructor */ 

	function destroy() { 
       if ($this->socket) {
       fwrite($this->socket, FINISH."\n");
       fclose($this->socket);
       $this->socket = NULL;
	   }
	}
	function prepareXML($xml){
			$aspas = array(chr(147),chr(148));
			$menos = array(chr(150));
			/* 
				o transformador via socket usa xml com encoding iso,
				assim, se o xml vier em utf, necessário executar o utf8_decode
			*/
			if (strpos(strtolower($xml),'utf-')>0) {
				$xml = xml_utf8_decode($xml);
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
		return $xml;
	}
	function transform($xsl, $xml){
		if ($this->socket)
		{
			$xml = $this->prepareXML($xml);
			if (fwrite($this->socket, "utf-8:".$xsl.":".$xml."\n")){
				if (fwrite($this->socket, $this->END_OF_MESS_SYMBOL."\n")){
					$message = $this->recebeResultado();
				} else {
					$message = 'ERROR_2';
				}
			} else {
				$message = 'ERROR_1';
			}

		} else {
			$message = 'NO_SOCKET';
		}
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
