<?php
	ini_set("display_errors","1");
	error_reporting(E_ALL ^E_NOTICE);
	$lang = isset($_REQUEST['lang'])?($_REQUEST['lang']):"";
	$pid = isset($_REQUEST['pid'])?($_REQUEST['pid']):"";
	$text = isset($_REQUEST['text'])?($_REQUEST['text']):"";
	$refPid = isset($_REQUEST['refpid'])?($_REQUEST['refpid']):"";

	require_once(dirname(__FILE__)."/../../applications/scielo-org/users/functions.php");
	require_once(dirname(__FILE__)."/../../applications/scielo-org/users/langs.php");	
	require_once(dirname(__FILE__)."/../../classDefFile.php");
	require_once(dirname(__FILE__)."/../../applications/scielo-org/classes/services/ArticleServices.php");

	$defFile = parse_ini_file(dirname(__FILE__)."/../../scielo.def");
	$applServer = $defFile["SERVER_SCIELO"];
	$databasePath = $defFile["PATH_DATABASE"];

	// XML que tem o Título completo do artigo
	$xml1 = "http://" . $applServer . "/cgi-bin/wxis.exe/?IsisScript=ScieloXML/sci_references.xis&database=artigo&gizmo=GIZMO_XML_REF&search=rp=" . $pid . "$";

	// XML que tem as informações se determinado artigo tem referência no Medline, Lilacs, etc.
	$xml2 = "http://" . $applServer . "/cgi-bin/wxis.exe/?IsisScript=ScieloXML/sci_reflinks.xis&def=scielo.def&lng=en&pid=" . $refPid . "";

	$xml1 = file_get_contents($xml1);
	$xml2 = file_get_contents($xml2);

	// XML da primeira transformação para conseguirmos o titulo completo
	$xml = '<?xml version="1.0" encoding="ISO-8859-1"?>';
	$xml .='<root>';
	$xml .='<vars><refId>'.number_format(substr($refPid, 23, 27),0,"","").'</refId><applserver>'. $applServer .'</applserver></vars>';
	$xml .= str_replace('<?xml version="1.0" encoding="ISO-8859-1"?>','',$xml1);
	$xml .='</root>';

	if($_REQUEST['debug'] == 'on')
	{
		die($xml);
	}
	$xsl = dirname(__FILE__)."/../xsl/getReferencebyId.xsl";
	$transformer = new XSLTransformer();
	$transformer->setXslBaseUri(dirname(__FILE__));
	$transformer->setXML($xml);
	$transformer->setXSL($xsl);
	$transformer->transform();
	$output = $transformer->getOutput();
	// Pegamos o título completo da referência do artigo
	$fullTitle = $output;
	
	// XML Final que contem os dados que precisamos do XML1 e XML2
	$xmlFinal = '<?xml version="1.0" encoding="ISO-8859-1"?>';
	$xmlFinal .= substr($xml2, strpos($xml2, "<root>"), strpos($xml2, "<ref_TITLE>") - strpos($xml2, "<root>"));
	$xmlFinal .= " <ref_TITLE><![CDATA[".$fullTitle."]]></ref_TITLE>";
	$xmlFinal .= substr($xml2, strpos($xml2, "</TITLE>") + strlen("</TITLE>"));

	// Transformação Final, página de links de referencia
	$transformerFinal = new XSLTransformer();
	$xslFinal = "/home/scielo/www/htdocs/xsl/sci_reflinks.xsl";
	$transformerFinal->setXslBaseUri("/home/scielo/www/htdocs/xsl");
	$transformerFinal->setXML($xmlFinal);
	$transformerFinal->setXSL($xslFinal);
	$transformerFinal->transform();
	$output = $transformerFinal->getOutput();

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
	 
	echo html_entity_decode(utf8_decode($output));

?>
