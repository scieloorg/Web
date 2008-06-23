<?
	$lang = isset($_REQUEST['lang'])?($_REQUEST['lang']):"";
	$pid = isset($_REQUEST['pid'])?($_REQUEST['pid']):"";
	$text = isset($_REQUEST['text'])?($_REQUEST['text']):"";

	require_once(dirname(__FILE__)."/../../classDefFile.php");
	if(!class_exists("XSLTransformer"))
	{
		require_once(dirname(__FILE__)."/../../class.XSLTransformer.php");
	}
	$transformer = new XSLTransformer();
	$defFile = new DefFile(dirname(__FILE__)."/../../scielo.def.php");


	//Adicionado para flag de log comentado por Jamil Atta Junior (jamil.atta@bireme.org)
	$flagLog = $defFile->getKeyValue('ENABLE_SERVICES_LOG');


	$related_Service = $defFile->getKeyValue($serviceName);
	$related_Service = str_replace("PARAM_PID",$pid,$related_Service);
	$related_Service = str_replace("PARAM_TEXT",$text,$related_Service);

	$xmlh = "";
	$xmlh = file_get_contents(str_replace(' ','%20',utf8_decode(urldecode($related_Service))));
	$xmlh = str_replace("&lt;","<",$xmlh);
	$xmlh = str_replace("&gt;",">",$xmlh);
	$xmlh = str_replace("&amp;","&",$xmlh);
	$xmlh = str_replace("&quot;","\"",$xmlh);
	for($chr = 0; $chr < 32 ;$chr++)
	{
		$xmlh = str_replace(chr($chr),"",$xmlh);
	}

	$xmlh = str_replace(chr(146),"",$xmlh);
	$xml = '<?xml version="1.0" encoding="ISO-8859-1" ?>'."\n";
	$xml .= '<root>';
	$xml .= '<CONTROLINFO>';
	$xml .=         '<SCIELO_INFO>';

	if($defFile->getKeyValue('ACTIVATE_LOG') == '1')
	{
		$xml .=                 '<SERVER_LOG>'.$defFile->getKeyValue('SERVER_LOG').'</SERVER_LOG>';
		$xml .=                 '<SCRIPT_LOG_NAME>'.$defFile->getKeyValue('SCRIPT_LOG_NAME').'</SCRIPT_LOG_NAME>';
	}

	if($defFile->getKeyValue('ACTIVATE_GOOGLE') == '1')
	{
		$xml .=                 '<GOOGLE_CODE>'.$defFile->getKeyValue('GOOGLE_CODE').'</GOOGLE_CODE>';
	}

	$xml .=         '</SCIELO_INFO>';
	$xml .=         '<APP_NAME>'.$defFile->getKeyValue('APP_NAME').'</APP_NAME>';
	$xml .=         '<PAGE_NAME>'.$serviceName.'</PAGE_NAME>';
	$xml .=         '<PAGE_PID>'.$pid.'</PAGE_PID>';
	$xml .=         '<LANGUAGE>'.$lang.'</LANGUAGE>';
	$xml .= '</CONTROLINFO>';
	$xml .= '<vars>';
	$xml .= '<lang>'.$lang.'</lang>';
	$xml .= '</vars>';
	$xml .= '<service_log>'.$flagLog.'</service_log>';
	$xml .= str_replace('<?xml version="1.0" encoding="ISO-8859-1" ?>','',$xmlh);
	$xml .= '</root>';
	$xsl = $defFile->getKeyValue("PATH_XSL").$xslName.".xsl";
	if(isset($_REQUEST['debug']))
	{
		echo '<textarea cols="80" rows="10">';
		echo $xml;
		echo '</textarea>';
		echo '<textarea cols="80" rows="10">';
		echo file_get_contents($xsl);
		echo '</textarea>';
	}
	$transformer->setXslBaseUri($defFile->getKeyValue("PATH_XSL"));
	//$transformer->setXml(utf8_encode($xml));
	$transformer->setXml($xml);


	$transformer->setXslFile($xsl);
	$transformer->transform();

	$result = $transformer->getOutput();

	if($transformer->getError()){
		echo $transformer->getError();
	}
	echo $result;

?>