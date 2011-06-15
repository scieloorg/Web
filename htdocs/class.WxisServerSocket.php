<?php
class WxisServerSocket {
	var $xsl, $xml, $host, $port, $socket, $output;
	/* Constructor  */	 

	function WxisServerSocket($host,$port) { 
	$this->host = $host;
		$this->port = $port;
		$this->socket = null;
		if ($this->socket)
		{
			echo("<!--Accessing Wxis by Socket-->");
		}
		else
		{
			echo("<!--Accessing Wxis by line-command-->");	
		}
	}

 	/* Destructor */ 
	function destroy() { 
       		if ($this->socket) {
       			fclose($this->socket);
       			$this->socket = NULL;
	   	}
	}

	function callWxis($parameters){
//echo "host: ".$this->host." port: ".$this->port. " parameter: ".$parameters;
         $this->socket = fsockopen($this->host,$this->port, $errno, $errstr);
//echo "olala";
	  if (!$this->socket)
	  {
	   	die("$errstr ($errno)<br />\n");
	  }
//echo "olala1";
	  fwrite($this->socket,$parameters."\n");
	  $message = $this->recebeResultado();
	  $this->destroy();
	  return $message;
	}


    function recebeResultado() {
//echo "recebe resultado";   
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
           $message .= $buffer;
       }
    return $message;
    }
} 
?>
