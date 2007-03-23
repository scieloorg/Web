<?php


//==============================================================================
function getDoc ( $docURL, $timeout = 10 ){
	$docContent = "[open failure]";

	$fp = fopen ($docURL, "r");
	
	if ($fp)
	{
		$docContent = "";
		while (!feof ($fp)) {
		    $buffer= fgets($fp, 8096);
			$docContent.= $buffer;
		}
		fclose ($fp);
	}	
	
	return $docContent;
}

//==============================================================================
function getDeCSTree($tree_id = ''){
	$decsWs  = "http://decs.ws.bvsalud.org/";	
	$request = "<decsws_request>" .
			   "	<service>getTree</service>" .
			   "	<parameters>" . 
			   "		<tree_id>" . $tree_id . "</tree_id>" . 
	   		   "	</parameters>" .
			   "</decsws_request>";
	$wsUrl = $decsWs . "main.php?decsws_parameters=" . $request;
	$response = postIt($wsUrl);
	
	return trim($response);
}


//==============================================================================
function postIt($url) { 
	// Strip URL  
	$url_parts = parse_url($url);
	$host = $url_parts["host"];
	$port = ($url_parts["port"]) ? $url_parts["port"] : 80;
	$path = $url_parts["path"];
	$query = $url_parts["query"];
	$timeout = 10;
	$contentLength = strlen($url_parts["query"]);
	
	// Generate the request header 
    $ReqHeader =  
      "POST $path HTTP/1.0\n". 
      "Host: $host\n". 
      "User-Agent: PostIt\n". 
      "Content-Type: application/x-www-form-urlencoded\n". 
      "Content-Length: $contentLength\n\n". 
      "$query\n"; 

	// Open the connection to the host 
	$fp = fsockopen($host, $port, $errno, $errstr, $timeout);
	
	fputs( $fp, $ReqHeader ); 
	if ($fp) {
		while (!feof($fp)){
			$result .= fgets($fp, 4096);
		}		
	}		
    
    return strstr($result,"<"); 
  } 
  
//================================================================================================
function getElementValue ($xml, $element, $attributes = '') 
{
    if ($attributes == '') {
	     $start_string = "<" . $element . ">";
	} else {
    	 $start_string = "<" . $element . " " . $attributes . ">";
	}
	$end_string = "</" . $element . ">";

    return substr($xml, strpos($xml, $start_string) + strlen($start_string), strpos($xml, $end_string) - strpos($xml, $start_string) - strlen($start_string));
}  
	
?>
