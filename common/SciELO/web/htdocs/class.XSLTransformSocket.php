<?php
class XSLTransformerSocket {
	var $xsl, $xml, $host, $port, $FINISH, $END_OF_MESS_SYMBOL, $socket, $output;
	/* Constructor  */	 
	function XSLTransformerSocket($host,$port) { 
		$this->host = $host;
		$this->port = $port;
		$this->END_OF_MESS_SYMBOL = "?<==>?";		
		$this->FINISH = "?<++>?";
		$this->socket = @fsockopen($host,$port, $errno, $errstr, 2);
		if ($this->socket)
		{
			putenv("ENV_SOCKET=true");
			$this->output .= "<!--transformed by socket JAVA-->";
		}
		else
		{
			putenv("ENV_SOCKET=false");
			$this->output .= "<!--transformed by PHP SOCK = false-->";	
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
	  $xml = str_replace('<?xml version="1.0" encoding="ISO-8859-1"?>','',$xml);
          $xml = str_replace('<?xml version="1.0" encoding="iso-8859-1"?>','',$xml);
          $xml = '<?xml version="1.0" encoding="ISO-8859-1"?>'.$xml;
	  fwrite($this->socket, "ISO-8859-1:".$xsl.":".$xml."\n");
	  fwrite($this->socket, $this->END_OF_MESS_SYMBOL."\n");
	  $message = $this->recebeResultado();
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
