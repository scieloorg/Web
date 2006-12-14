<?php
class XSLTransformerSocket {
	var $xsl, $xml, $host, $port, $FINISH, $END_OF_MESS_SYMBOL, $socket, $output;
	/* Constructor  */	 
	function XSLTransformerSocket($host,$port) { 
		$this->host = $host;
		$this->port = $port;
		$this->END_OF_MESS_SYMBOL = "?<==>?";
		$this->FINISH = "?<++>?";

		if($port != NULL){
			$this->socket = @fsockopen($host,$port, $errno, $errstr, 2);
		}else{
			$this->socket = false;
		}

		if ($this->socket)
		{
			putenv("ENV_SOCKET=true");
			$this->transf = "<!--transformed by socket JAVA-->";
		}
		else
		{
			putenv("ENV_SOCKET=false");
			$this->transf = "<!--transformed by PHP-->";	
		}
	} 

 	/* Destructor */ 
	function destroy() { 
       if ($this->socket) {
       fclose($this->socket);
       $this->socket = NULL;
	   }
	}

	function transform($xsl, $xml){
	  if (!$this->socket)
	  {
	   	die("Erro de socket: $errstr numero: $errno<br />\n");
	  }
			$aspas = array(chr(147),chr(148));
			$menos = array(chr(150));

			$xml = str_replace($aspas,"&quot;",$xml);
			$xml = str_replace($menos,"-",$xml);
			$xml = str_replace("\n","",$xml);
			$xml = str_replace(chr(132),"",$xml);
			$xml = str_replace(chr(131),"",$xml);

			$bar1 = strpos($xsl, "/");
			$bar2 = strpos($xsl, "\"");

			if((!$bar1) && (!$bar2))
			{
				$xsl = dirname(__FILE__)."\\xsl\\".strtolower($xsl).".xsl";
			}

			$data = "source=".urlencode($xml)."&style=".urlencode($xsl);

			fwrite($this->socket, "POST /ParserServletURL/ParserServletURL HTTP/1.0\r\n") or die("1");
			fwrite($this->socket, "Host: ".$_SERVER['SERVER_NAME']."\r\n") or die("2");
			fwrite($this->socket, "Content-type: application/x-www-form-urlencoded\r\n") or die("3");
			fwrite($this->socket, "Content-length: " . strlen($data) . "\r\n") or die("4");
			fwrite($this->socket, "Accept: */*\r\n") or die("5");
			fwrite($this->socket, "\r\n") or die("6");
			fwrite($this->socket, "$data\r\n") or die("7");
			fwrite($this->socket, "\r\n") or die("8");

			$message = $this->recebeResultado().$this->transf;
		return $message;
	}


    function recebeResultado() {
       if (!$this->socket) {
           die("recebeResultado/comunicacao encerrada");
       }

		$body = "";
		do {
			$data = fread($this->socket, 1024);
			if (strlen($data) == 0) {
				break;
			}
			$body .= $data;
		} while(true);

		@fclose($this->socket);

		return strstr($body,"<");
	}
}
?>