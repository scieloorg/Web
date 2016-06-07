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


	// XML que tem as informações se determinado artigo tem referência no Medline, Lilacs, etc.
	$req = "http://" . $applServer . "/cgi-bin/wxis.exe/?IsisScript=ScieloXML/sci_reflinks.xis&def=scielo.def.php&lng=".$lang."&pid=" . $refPid . "";
	$xml_reflinks = file_get_contents($req);

	if($_REQUEST['debug1'] == 'on')
	{
		echo '<!-- ' . $req . ' -->' . "\n";
		die($xml_reflinks);
	}

	if (! $_REQUEST['refid']){
		// XML que tem o Título completo do artigo
		$req = "http://" . $applServer . "/cgi-bin/wxis.exe/?IsisScript=ScieloXML/sci_references.xis&database=artigo&gizmo=GIZMO_XML_REF&search=rp=" . $pid . "$";
		$xml_references = file_get_contents($req);
		if($_REQUEST['debug2'] == 'on')
		{
			echo '<!-- ' . $req . ' -->' . "\n";
			die($xml_references);
		}

		// XML da primeira transformação para conseguirmos o titulo completo
		//Adicionado teg <service_log> 23/10/2007
		$xml_article_title = '<?xml version="1.0" encoding="ISO-8859-1"?>';
		$xml_article_title .='<root>';
		$xml_article_title .='<vars><refId>'.number_format(substr($refPid, 23)).'</refId><applserver>'. $applServer .'</applserver><lang>'.$lang.'</lang></vars>';
		$xml_article_title .= str_replace('<?xml version="1.0" encoding="ISO-8859-1"?>','',$xml_references);
		$xml_article_title .='</root>';
		if($_REQUEST['debug3'] == 'on')
		{
			die($xml_article_title);
		}
		$xsl = $pathHtdocs."/xsl/getReferencebyId.xsl";
		$transformer = new XSLTransformer();

		//die("socket = true");
		$transformer->setXslBaseUri(dirname(__FILE__));
		$transformer->setXml($xml_article_title);
		$transformer->setXslFile($xsl);
		$transformer->transform();
		$fullTitle = $transformer->getOutput();

		if (strpos($fullTitle, '<!--transformed by') > 0) {
			$fullTitle = substr($fullTitle, 0, strpos($fullTitle, '<!--transformed by'));
		}
		// Pegamos o título completo da referência do artigo

		if($transformer->transformedBy == "PHP"){
			//PHP
			$fullTitle = utf8_decode($fullTitle);
		}
		if($_REQUEST['debug4'] == 'on')
		{
			echo '<!-- fullTitle -->' . "\n";
			die($fullTitle);
		}
	}

	// XML Final que contem os dados que precisamos do XML1 e XML2
	$xmlFinal = '<?xml version="1.0" encoding="ISO-8859-1"?>';

	$pos_root = strpos($xml_reflinks, '<root>');
	$pos_reftitle = strpos($xml_reflinks, '<ref_TITLE>');

	$xmlFinal .= substr($xml_reflinks, $pos_root, $pos_reftitle - $pos_root);
	$xmlFinal .= '<vars><refid>'.$_REQUEST['refid'].'</refid>';
	$xmlFinal .= '<htdocs>'.$pathHtdocs.'</htdocs>';
	$xmlFinal .= '<service_log>'.$flagLog.'</service_log></vars>';
	$xmlFinal .= ' <ref_TITLE><![CDATA['.$fullTitle.']]></ref_TITLE>';
	$xmlFinal .= substr($xml_reflinks, strpos($xml_reflinks, '<TITLE>'));

	if($_REQUEST['debug5'] == 'on')
	{
		echo '<!-- xmlFinal -->' . "\n";
		die($xmlFinal);
	}

	// Transformação Final, página de links de referencia
	$transformerFinal = new XSLTransformer();
	$xslFinal = $pathHtdocs."xsl/sci_reflinks.xsl";
	
	//die("socket = true");
	$transformerFinal->setXslBaseUri($pathHtdocs."xsl");
	$transformerFinal->setXml($xmlFinal);
	$transformerFinal->setXslFile($xslFinal);
	$transformerFinal->transform();
	$output = $transformerFinal->getOutput();

	if($transformer->transformedBy == "PHP"){
		//PHP
		$output = utf8_decode($output);
	}
	if($_REQUEST['debug6'] == 'on')
	{
		echo '<!-- debug6 -->' . "\n";
		die($output);
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
	
/**
 * Inclusão do arquivo gerador de log de usuários autenticados somente se o serviço estiver habilitado no scielo.def, e existir o cookie userID
 */
if($defFile['ENABLE_AUTH_USERS_LOG'] == 1){	
	if(isset($_COOKIE['userID']) && $_COOKIE['userID']!= -2 ){
		require_once(dirname(__FILE__)."/../../applications/scielo-org/ajax/authLogServicesInclude.php");
	}
}	
?>
