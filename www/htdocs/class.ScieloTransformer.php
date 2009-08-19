<?php
include("class.XSLTransformer.php");

class ScieloXMLTransformer extends XSLTransformer
{ 
    var $_method = "GET";
    
    function ScieloXMLTransformer()
    {
        XSLTransformer::XSLTransformer();
    }

    function SetPreferedMethod($method)
    {
        $this->_method = strtoupper($method);
    }
    
    function SetXml($uri)    
    {
		if ($this->isXmlContent($uri)) {
			$this->xml = $uri;
			return true;
		} elseif($doc = new ScieloDocReader($uri, $this->_method)) {
			$this->xml	= $doc->getString();
			return true; 
		} else { 
			$this->setError("Erro ao tentar abrir $xml"); 
			return false; 
		} 
    }
    
	 function SetXsl($uri)
    {
		if ($this->isXmlContent($uri)) {
			if (getenv("ENV_SOCKET")=="true"){  //socket
				// vai falhar a transformacao via java
				die("XSL deve ser uma chave no arquivo xslts.ini e não o conteúdo da XSL");
			}
			else
			{
				// serve apenas para transformação PHP
				$this->xslFileContent = $uri;
			}
			return true;
		} else {
			$this->setXslFile($uri);
			return true; 
		} 
    }
    
    function velhoSetXsl($uri)
    {
		if ($this->isXmlContent($uri)) {
			if (getenv("ENV_SOCKET")=="true"){  //socket
				$pos_ini = strrpos($uri,"/")+1;
				$pos_len = strrpos($uri,".")-$pos_ini;
				$this->xsl = strtoupper(substr($uri,$pos_ini,$pos_len));
			}
			else
			{
				$this->xsl = $uri;
			}
			return true;
		} elseif($doc = new ScieloDocReader($uri, $this->_method)) {
			if (getenv("ENV_SOCKET")=="true"){
				$pos_ini = strrpos($uri,"/")+1;
				$pos_ini = strrpos($uri,"/")+1;
				$pos_len = strrpos($uri,".")-$pos_ini;
				$this->xsl = strtoupper(substr($uri,$pos_ini,$pos_len));
			}
			else
			{
				$this->xsl = $doc->getString();
			}
			return true; 
		} else { 
			$this->setError("Erro ao tentar abrir $xsl"); 
			return false; 
		} 
    }
    
    function destroy()
    {
        XSLTransformer::destroy();
    }

    function isXmlContent(&$xml)
    {
//WXIS_LINE_COMMAND
$xml = trim(str_replace('Content-type:text/html', '', str_replace('Content-type:text/xml', '',$xml)));
        if (strcmp(substr(trim($xml),0,5), "<?xml") != 0)
        {
            return false;
        }

        return true;
    }

}

class ScieloDocReader extends docReader
{
    var $_method = "GET";
    
    function ScieloDocReader($uri,$method)
    {
   		$this->setUri($uri); 
        $this->setMethodType ($method);
        
		$this->setType(); 
        
        if ($this->getType() == 'file' or $this->getMethodType() == "GET")
        {
            docReader::docReader($uri);
        }
        else
        {
            // Read url using Post Method
            $result = $this->postMethod ($uri);
            $this->setString ($result);            
        }
    }
    
    function setMethodType ($method)
    {
        if ($method)
        {
           $this->_method = strtoupper($method);
        }
    }
    
    function getMethodType()
    {
        return $this->_method;
    }
    
    function postMethod ($uri)
    {
        $response = "";

        if ( $this->splitUrl ( $uri, $host, $port, $script, $request ) )
        {
    		// Build the header 
	    	$header = "POST " . $script . " HTTP/1.0\r\n"; 
		$header .= "Host: $host:$port\r\n";
		    $header .= "Content-type: application/x-www-form-urlencoded\r\n"; 
    		$header .= "Content-length: " . strlen($request) . "\r\n\r\n"; 
            
	    	// Open the connection 
    		if ( $fp = fsockopen($host, $port, &$err_num, &$err_msg, 30) ) 
	    	{ 
		    	// Send everything 
    			fputs($fp, $header . $request); 
	
                $is_body = false;
                
	    		// Get the response 
		    	while (!feof($fp))
			    { 				
				    $buffer = fgets($fp, 255); 
                    
                    // Discards the response header
                    if (!$is_body)
                    {
                        if ( ereg("^[[:space:]]*$", $buffer) ) $is_body = true;
                        continue;
                    }
                    
                    // Gets the response body
                    $response .= $buffer;
    			}	
	    	}            
	
		    fclose($fp);            
        }
                   
        return $response;
    }
    
    function splitUrl ($uri, &$host, &$port, &$cgi_script, &$request)
    {
        $result = ereg( "^http:\/\/([^\:\/]+)(\:[0-9]+)?(\/.+)\?(.+)$", $uri, $arr );

        if ($result)
        {
            $host = $arr[1];
            $port = $arr[2] ? substr($arr[2], 1) : 80;
            $cgi_script = $arr[3];
            $request = $arr[4];
        }
        
        return $result;
    }
}

?>
