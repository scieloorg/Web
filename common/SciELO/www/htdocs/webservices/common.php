<?PHP
//=============================================================================================
function getElementValue ($xml, $element, $attributes = '')
{
        $elementPeace = "";
        if ($attributes == '') {
                $start_string = "<" . $element . ">";
        } else {
                $start_string = "<" . $element . " " . $attributes . ">";
        }
        $end_string = "</" . $element . ">";
        if (strpos($xml, $start_string) > 0){
                $elementPeace = substr($xml, strpos($xml, $start_string) + strlen($start_string), strpos($xml, $end_string) - strpos($xml, $start_string) - strlen($start_string));
        }
        return $elementPeace;
}

//=============================================================================================
function getIndicators($indicator)
{
global $applServer,$databasePath ;
$result="";
        switch ($indicator){
                case "journalTotal":
                        $serviceUrl = "http://" . $applServer . "/cgi-bin/wxis.exe/bvs-mod/wxis-modules/?IsisScript=list.xis&database=".$databasePath ."title/title&count=1";
                        $XML = readData($serviceUrl,true);
                        $result=getElementValue(getElementValue(str_replace("<hr>","<hr />",$XML) , "Isis_Total"),"occ");
                        break;
                case "articleTotal":
                        $serviceUrl = "http://" . $applServer . "/cgi-bin/wxis.exe/bvs-mod/wxis-modules/?IsisScript=search.xis&database=".$databasePath ."artigo/artigo&search=tp=o&count=1";
                        $XML = readData($serviceUrl,true);
                        $result=getElementValue(getElementValue(str_replace("<hr>","<hr />",$XML) , "Isis_Total"),"occ");
                        break;
                case "issueTotal":
                        $serviceUrl = "http://" . $applServer . "/cgi-bin/wxis.exe/bvs-mod/wxis-modules/?IsisScript=search.xis&database=".$databasePath ."artigo/artigo&search=tp=i&count=1";
                        $XML = readData($serviceUrl,true);
                        $result=getElementValue(getElementValue(str_replace("<hr>","<hr />",$XML) , "Isis_Total"),"occ");
                        break;
                case "citationTotal":
                        $serviceUrl = "http://" . $applServer . "/cgi-bin/wxis.exe/bvs-mod/wxis-modules/?IsisScript=search.xis&database=".$databasePath ."artigo/artigo&search=tp=c&count=1";
                        $XML = readData($serviceUrl,true);
                        $result=getElementValue(getElementValue(str_replace("<hr>","<hr />",$XML) , "Isis_Total"),"occ");
                        break;
        }
        return $result;
}

//=============================================================================================
function process($serviceUrl, $redirectHtml = "")
{
	global $output, $serviceRoot;
	
	if ($output == "html"){
		if ($redirectHtml == ""){
			print "Service not available";
		}else{		
			header("Location: " . $redirectHtml);
		}	
	}else{
		$xml = readData($serviceUrl, true);
	
		if ($output == "xml"){
			header("Content-type: text/xml");
	    	return envelopeXml($xml, $serviceRoot);
		}else{
			return $xml;
		}	
	}	

}

//============================================================================================
function envelopeXml($str, $root)
{
	global $version;

	$envelope = "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n";
	$envelope.= "<" . $root . " version=\"". $version . "\">\n"; 
	$envelope.= $str;
	$envelope.= "</" . $root . ">\n";
	
	return $envelope;
}

//============================================================================================
function readData($readFrom, $removeHeader)
{
	$str = "";
	$query = strstr($readFrom, "?");
		
	if ( strlen($query) > 250 ){	
		$str = PostIt($readFrom);
	}else{		
		$readUrl = encodeValues($readFrom);
		$fp = fopen($readUrl,"r");
		if ($fp)
		{
			while (!feof ($fp)) {
			    $buffer= fgets($fp, 8096);
				$str.= $buffer;
			}
			fclose ($fp);
		}			
	}	
	$str = trim($str);
    if ( $removeHeader )
    {
    // remove xml processing instruction 
        if ( strncasecmp($str, "<?xml", 5) == 0 )
        {
                $pos = strpos($str, "?>");
                if ( $pos > 0 )
                {
                        $str = substr_replace($str,"",0,$pos + 2);
                }
        }
	}
	return $str;
}


//=============================================================================================
function PostIt($url) { 

	// Strip URL  
	$url_parts = parse_url($url);
	$host = $url_parts["host"];
	$port = ($url_parts["port"]) ? $url_parts["port"] : 80;
	$path = $url_parts["path"];
	$query = $url_parts["query"];
	$timeout = 10;
	$contentLength = strlen($query);
	
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
    
	//return strstr($result,"<");
    return trim( substr( $result,strpos($result,"\n\r")+1 ) ); 
  } 

//================================================================================================
function encodeValues( $docURL )
{

	if (ereg("\?", $docURL)) {
		$splited1[0] = substr($docURL, 0, strpos($docURL,"?"));
		$splited1[1] = substr($docURL, strpos($docURL,"?")+1);
	}else{
		return $docURL;
	}	
	
	$splited2 = split( "&", $splited1[1] );

	if ( count($splited2) < 2 )
	{
		return $docURL;
	}
	$docURL = $splited1[0] . "?";
	$fisrt = true;
	foreach ($splited2 as $value)
	{
		if ( $first )
		{
			$first = false;
		}
		else
		{
			$docURL .= "&";
		}
		$splited3 = split("=",$value);

		$docURL .= $splited3[0];
		/*
		if ( count($splited3) > 1 ){
			$docURL .= "=" . urlencode($splited3[1]);
		}
		*/
		
		if ( count($splited3) > 1 ){		
			for ($i = 1; $i < count($splited3); $i++){
				$docURL .= "=" . urlencode($splited3[$i]);
			}
		}	
		
	}
	return $docURL;
}
?>
