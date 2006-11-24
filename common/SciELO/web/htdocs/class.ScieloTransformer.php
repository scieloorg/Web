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
		if($doc = new ScieloDocReader($uri, $this->_method)) {
			$this->xml	= $doc->getString();
			return true; 
		} else { 
			$this->setError("Erro ao tentar abrir $xml"); 
			return false; 
		} 
    }
    
    function SetXsl($uri)
    {
		if($doc = new ScieloDocReader($uri, $this->_method)) {
			$this->xsl	= $doc->getString();
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
