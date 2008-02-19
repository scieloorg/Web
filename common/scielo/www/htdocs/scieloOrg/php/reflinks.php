<?php
	ini_set("display_errors","1");
	error_reporting(E_ALL ^E_NOTICE);
	$lang = isset($_REQUEST['lng'])?($_REQUEST['lng']):"en";
	$_REQUEST['lang'] = $lang;
	$pid = isset($_REQUEST['pid'])?($_REQUEST['pid']):"";
	$text = isset($_REQUEST['text'])?($_REQUEST['text']):"";
	$refPid = isset($_REQUEST['refpid'])?($_REQUEST['refpid']):"";

	require_once(dirname(__FILE__)."/../../applications/scielo-org/users/functions.php");
	require_once(dirname(__FILE__)."/../../applications/scielo-org/users/langs.php");
	require_once(dirname(__FILE__)."/../../classDefFile.php");
	require_once(dirname(__FILE__)."/../../applications/scielo-org/classes/services/ArticleServices.php");

	$defFile = parse_ini_file(dirname(__FILE__)."/../../scielo.def.php");
	$applServer = $defFile["SERVER_SCIELO"];
	$databasePath = $defFile["PATH_DATABASE"];
	$pathHtdocs = $defFile["PATH_HTDOCS"];

	//Adicionado para flag de log comentado por Jamil Atta Junior (jamil.atta@bireme.org)
	$flagLog = $defFile['ENABLE_SERVICES_LOG'];

	// XML que tem o Título completo do artigo
	$xml1 = "http://" . $applServer . "/cgi-bin/wxis.exe/?IsisScript=ScieloXML/sci_references.xis&database=artigo&gizmo=GIZMO_XML_REF&search=rp=" . $pid . "$";

	// XML que tem as informações se determinado artigo tem referência no Medline, Lilacs, etc.
	$xml2 = "http://" . $applServer . "/cgi-bin/wxis.exe/?IsisScript=ScieloXML/sci_reflinks.xis&def=scielo.def.php&lng=en&pid=" . $refPid . "";

	$xml1 = file_get_contents($xml1);
	$xml2 = file_get_contents($xml2);

	// XML da primeira transformação para conseguirmos o titulo completo
	//Adicionado teg <service_log> 23/10/2007
	$xml = '<?xml version="1.0" encoding="ISO-8859-1"?>';
	$xml .='<root>';
	$xml .='<vars><refId>'.number_format(substr($refPid, 23, 27),0,"","").'</refId><applserver>'. $applServer .'</applserver></vars>';
	$xml .= str_replace('<?xml version="1.0" encoding="ISO-8859-1"?>','',$xml1);
	$xml .='</root>';

	if($_REQUEST['debug1'] == 'on')
	{
		die($xml);
	}
	$xsl = $pathHtdocs."/xsl/getReferencebyId.xsl";
	$transformer = new XSLTransformer();
	if (getenv("ENV_SOCKET")!="true"){  //socket
		$xsl = file_get_contents($xsl);
			//die("socket = false");
	} else {
		$xsl = 'GETREFERENCEBYID';
	}
	//die("socket = true");
	$transformer->setXslBaseUri(dirname(__FILE__));
	$transformer->setXML($xml);
	$transformer->setXSL($xsl);
	$transformer->transform();
	$output = $transformer->getOutput();
	// Pegamos o título completo da referência do artigo
	$fullTitle = $output;

	if(getenv("ENV_SOCKET")!="true"){
		//PHP
		$fullTitle = utf8_decode($fullTitle);
	}

	// XML Final que contem os dados que precisamos do XML1 e XML2
	$xmlFinal = '<?xml version="1.0" encoding="ISO-8859-1"?>';
	$xmlFinal .= substr($xml2, strpos($xml2, "<root>"), strpos($xml2, "<ref_TITLE>") - strpos($xml2, "<root>")).'<vars><htdocs>'.$pathHtdocs.'</htdocs><service_log>'.$flagLog.'</service_log></vars>';
	$xmlFinal .= " <ref_TITLE><![CDATA[".$fullTitle."]]></ref_TITLE>";
	$xmlFinal .= substr($xml2, strpos($xml2, "<TITLE>"));

	if($_REQUEST['debug2'] == 'on')
	{
		die($xmlFinal);
	}

	// Transformação Final, página de links de referencia
	$transformerFinal = new XSLTransformer();
	$xslFinal = $pathHtdocs."xsl/sci_reflinks.xsl";
	if (getenv("ENV_SOCKET")!="true"){  //socket
		$xslFinal = file_get_contents($xslFinal);
		//die("socket = false");
	} else {
		$xslFinal = 'SCI_REFLINKS';
	}
	//die("socket = true");
	$transformerFinal->setXslBaseUri($pathHtdocs."xsl");
	$transformerFinal->setXML($xmlFinal);
	$transformerFinal->setXSL($xslFinal);
	$transformerFinal->transform();
	$output = $transformerFinal->getOutput();

	if(getenv("ENV_SOCKET")!="true"){
		//PHP
		$output = utf8_decode($output);
	}

	if($transformerFinal->getError())
	{
		echo $transformerFinal->getError();
	}

	$output = str_replace('&amp;','&',$output);
	$output = str_replace('&lt;','<',$output);
	$output = str_replace('&gt;','>',$output);
	$output = str_replace('&quot;','"',$output);
	$output = str_replace('<p>',' ',$output);
	$output = str_replace('</p>',' ',$output);

	echo html_entity_decode($output);
	//echo ($output);
?>
