<?php

function check_parameters(){
	global $checked, $xml, $xsl, $xslSave, $xmlSave, $page, $lang;
	
	if ( isset($_GET['xml']) && !ereg("^[a-z][a-z\/]+.xml$", $_GET['xml']) )
		die("invalid parameter");
	else
		$checked['xml'] = $xml;	
	
	if ( !ereg("^[a-z][a-zA-Z\/\_\-]+.xsl$", $xsl) )
		die("invalid parameter");
	else
		$checked['xsl'] = $xsl;

	if ( isset($xmlSave) && !ereg(".xml$", $xmlSave) )
		die("invalid parameter");
	else
		$checked['xmlSave'] = $xmlSave;

	if ( isset($xslSave) && !ereg(".xsl$", $xslSave) )
		die("invalid parameter");
	else
		$checked['xslSave'] = $xslSave;
		
	if ( isset($page) && !ereg("^[a-zA-Z\_\-]+$", $page) )
		die("invalid parameter");
	else
		$checked['page'] = $page;

	if ( !ereg("^(pt)|(es)|(en)$",$lang) )
		die("invalid lang parameter");
	else 
		$checked['lang'] = $lang;

}

function cgiValue ( $key, $value )
{
	return $key . "=" . $value . "<br/>";
}

function debugCGI ( $httpVars )
{
	$returnVars = "";
	reset($httpVars);
	while ( list($key,$value) = each($httpVars) )
	{
		if ( gettype($value) == "array" ) {
			foreach ($value as $item) {
				$returnVars .= cgiValue($key,$item);
			}
		} else {
			$returnVars .= cgiValue($key,$value);
		}
	}
	print($returnVars);
}

function debug ( $debug )
{
	global $xmlContent;
	
	$debug = strtoupper($debug);
	if ( $debug == "VERSION" ) { echo "1.6"; }
	if ( $debug == "PHPINFO" ) { phpinfo(); }
	if ( $debug == "CGI" ) { debugCGI($_GET); debugCGI($_POST); }
	if ( $debug == "XML" ) { echo $xmlContent; }
	
	die();
	
}

function xmlKeyValue ( $key, $value )
{
	$value = str_replace("&amp;","&",stripslashes($value));
	$value = str_replace("&","&amp;",$value);
	return "         <" . $key . ">" . $value . "</" . $key . ">\n";
}

function xmlHttpVars ( $mainElement, $httpVars )
{
	$xmlVars = "";

	if ( count($httpVars) == 0 ) {
		return $xmlVars;
	}

	$xmlVars = "      <" . $mainElement . ">\n";

	reset($httpVars);
	while ( list($key,$value) = each($httpVars) )
	{
		if ( gettype($value) == "array" ) {
			foreach ($value as $item) {
				$xmlVars .= xmlKeyValue($key,$item);
			}
		} else {
			$xmlVars .= xmlKeyValue($key,$value);
		}
	}

	$xmlVars .= "      </" . $mainElement . ">\n";

	return $xmlVars;
}

function xmlHttpInfo ( $mainElement ){
	global $VARS;
	
	$xmlCgi = "   <" . $mainElement . ">\n";
	$xmlCgi .= xmlHttpVars("server",$_SERVER);
	$xmlCgi .= xmlHttpVars("cgi",$_GET);
	$xmlCgi .= xmlHttpVars("cgi",$_POST);
	if ( isset($_SESSION) ){
		$xmlCgi .= xmlHttpVars("session",$_SESSION);
	}	
	$xmlCgi .= xmlHttpVars("VARS",$VARS);
	$xmlCgi .= "   </" . $mainElement . ">\n";
	
	return $xmlCgi;
}

function xmlDefineInfo ( $mainElement )
{
	global $def;

	$xml = "   <" . $mainElement . ">\n";
	foreach ($def as $param => $value){
		$param = str_replace(' ','_',$param);
		$xml .= "   <" . $param . ">" . $value . "</" . $param . ">\n";
	}
	$xml .= "   </" . $mainElement . ">\n";
	
	return $xml;
}


function normalizeDocURL ( $docURL )
{
	global $def;
	
	$parsedURL = parse_url($docURL);

	if ( empty($parsedURL['scheme']) )
	{
		if ( substr($parsedURL['path'],0,1) != "/" )
		{
			$docURL = $def["DATABASE_PATH"] . "/" . $docURL;
		}
	}

	$docURL = str_replace("|","&",$docURL);
	return $docURL;
}

function normalizePath( $docPath, $ROOT = "DATABASE_PATH" )
{
	global $def;
	
	if ( substr($docPath,0,1) != "/" ){
		$docPath = $def[$ROOT] . $docPath;
	}
	
	return $docPath;
}


function getXmlDoc ( $docURL, $removeHeader )
{
	global $def, $xmlBuffer;
	$docContent = "";

	//$docURL = normalizeDocURL($docURL);
	$docURL = normalizePath($docURL);

	$fp = fopen ($docURL, "r");
	$docContent = "";
	if ($fp)
	{
		while (!feof ($fp)) {
		    $buffer= fgets($fp, 8096);
			$docContent.= $buffer;
		}
		fclose ($fp);
	}	

	if ( $removeHeader )
	{
		$docContent = xmlRemoveHeader($docContent);
	}

	return $docContent;
}


function xmlRemoveHeader($xml)
{
	/* remove xml processing instruction */
	$xml = trim($xml);
	if ( strncasecmp($xml, "<?xml", 5) == 0 )
	{
		$pos = strpos($xml, "?>");
		if ( $pos > 0 )
		{
			$xml = substr_replace($xml,"",0,$pos + 2);
		}
	}
	return $xml;
}


function BVSDocXml ( $rootElement, $xml )
{
	$content = "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n";
	$content .= "<" . $rootElement . ">\n";
	$content .= xmlHttpInfo("http-info");
	$content .= xmlDefineInfo("define");
	if ( isset($xml) )
	{
		//verifica se a variavel é um xml ou arquivo
		if ( strncasecmp($xml, "<?xml", 5) == 0 ){
			$content .= xmlRemoveHeader($xml);
		}else{
			$content .= getXmlDoc($xml,true);
		}	
	}
	$content .= "</" . $rootElement . ">\n";
	
	return $content;
}

function processTransformation ( $xml, $xsl )
{
	global $def;
	
	$result = "";
	$xslParams = array('xml-path' => $def['DATABASE_PATH'] . "xml/");

	$transform = new XSLTransformer();	
	if($def["LETTER_UNIT"] != "")
	{
		$transform->setXslBaseUri("file://" . $def["LETTER_UNIT"]."/".$def["SITE_PATH"]);
	}else{
		$transform->setXslBaseUri("file://" . $def["SITE_PATH"]);
	}

	if ($transform->setXml($xml) == false)
		die($transform->getErrorMessage());

	if ($transform->setXsl($xsl) == false)
		die($transform->getErrorMessage());

	$transform->setXslParameters($xslParams);
	
	if ($transform->transform() == false){
		print $transform->getErrorMessage();
	}else{
		$result = utf8_decode($transform->getOutput());
	}
	return $result;	
	
}

function putDoc ( $docURL, $docContent )
{
	$ret = false;
	$fp = fopen($docURL,"w"); 

	if ( $fp )
	{
		$ret = fwrite($fp,$docContent,strlen($docContent));
		fclose($fp);
	}

	return $ret;
}

function xmlWrite ( $xmlContent, $xsl, $xml )
{
	global $debug;
	$sucessWriteXml = "";
	
	$text = processTransformation($xmlContent,$xsl);
	$find = array("UTF-8","&amp;lt;","&amp;gt;","&amp;nbsp;");
	$replace = array("ISO-8859-1","&lt;","&gt;","&#160;");
	
	$text = str_replace($find, $replace ,$text);
	//$text = str_replace("UTF-8","ISO-8859-1",$text);

	if (trim($text) == ""){
		print("warning:transformation error generated empty content");	
	}else{
		if ( $debug == "XMLSAVE" ) { die($text); }

		//$xmlDoc = normalizeDocURL($xml);
		$xmlDoc = normalizePath($xml);
		
		if ( !putDoc($xmlDoc,$text) ){
			print("putDoc error: " . $xmlDoc . "<br/>\n");
		}else{
			$sucessWriteXml = $text;
		}	
	}
	return $sucessWriteXml;
}

function htmlWrite ( $xml )
{
	global $debug, $xmlSave;
	$sucess = false;
	
	$xsl = normalizePath("xsl/adm/xml-html.xsl", "SITE_PATH");
	$html= str_replace("xml","html", $xmlSave);
	
    //print "xsl=" . $xsl . " html=" . $html . "<br>";
	
	$text = processTransformation($xml,$xsl);
	$text = macroReplace($text);

	if (trim($text) == ""){
		print("warning:transformation error generated empty content");	
	}else{
		//$htmlFile = normalizeDocURL($html);
		$htmlFile = normalizePath($html);
		
		if ( !putDoc($htmlFile,$text) ){
			print("putDoc error: " . $htmlFile . "<br/>\n");
		}else{
			$sucess = true;
		}	
	}
	return $sucess;
}

function iniWrite ( $xml )
{
	global $debug, $xmlSave;
	$sucess = false;

	$xsl = "../xsl/adm/xml-ini.xsl";
	$ini = str_replace(array("xml/",".xml"),array("ini/",".ini"), $xmlSave);
	
    //print "\n xsl=" . $xsl . " ini=" . $ini . "<br>";
	
	$text = processTransformation($xml,$xsl);
	$text = trim($text);
	
	if( $text == "subpages not present in this component"){
		return $sucess;
	}else{
		if ($text == ""){
			print("warning:transformation error generated empty content");	
		}else{
			//$iniFile = normalizeDocURL($ini);
			$iniFile = normalizePath($ini);
			if ( !putDoc($iniFile,$text) ){
				print("putDoc error: " . $iniFile . "<br/>\n");
			}else{
				$sucess = true;
			}	
		}	
	}
	return $sucess;
}

function defineMetaIAHWrite ( )
{
	global $lang;
	$sucess = false;

	$xml = normalizePath("xml/" . $lang . "/bvs.xml");
	$xsl = normalizePath("xsl/metaiah/define-metaiah.xsl", "SITE_PATH");
	$define = normalizePath("xml/" . $lang . "/metaiah.xml");
	
    //print "\n xsl=" . $xsl . " ini=" . $ini . "<br>";
	
	$text = processTransformation($xml,$xsl);
	$text = str_replace("encoding=\"UTF-8\"","encoding=\"ISO-8859-1\"",$text);

	if ($text == ""){
		print("warning:transformation error generated empty content");	
	}else{
		if ( !putDoc($define,$text) ){
			print("putDoc error: " . $define . "<br/>\n");
		}else{
			$sucess = true;
		}
	}
	return $sucess;
}


function xmlCDATA ($str) {

	$cdataElement[] = "portal";
	$cdataElement[] = "description";

	foreach ($cdataElement as $element) {
		$find[] = "<" . $element . ">";
		$find[] = "</" . $element . ">";
		$replace[] = "<" . $element . "><![CDATA[";
		$replace[] = "]]></" . $element . ">";
	}

	$str = str_replace($find, $replace,$str);
	return $str;
}


function macroReplace($str){
	global $lang, $def;

	$find = array("(%SKIN_IMAGE_DIR%)","/&lt;\?/","/\?&gt;/");
	$replace = array("../image/public/skins/" . $def['SKIN_NAME']. "/" . $lang . "/","<?","?>");

	$changedStr = preg_replace ($find, $replace, $str);
	
	return $changedStr;
}
?>