<?php
require_once("../classDefFile.php");
//require_once("../bvs-lib/common/scripts/php/xslt.php");
require_once('nusoap/nusoap.php');
require_once("../class.XSLTransformer.php");
require_once('common.php');

// Backward compatible array creation
$_REQUEST = (isset($_REQUEST) ? $_REQUEST : array_merge($HTTP_GET_VARS, $HTTP_POST_VARS, $HTTP_COOKIE_VARS));

$transformer = new XSLTransformer();

$defFile = new DefFile("../scielo.def");

$version = "1.0";
$serviceRoot = "SciELOWebService";
$HTTP_RAW_POST_DATA = isset($HTTP_RAW_POST_DATA) ? $HTTP_RAW_POST_DATA : '';

$applServer = $defFile->getKeyValue("SERVER_SCIELO");
$regionalScielo = $defFile->getKeyValue("SCIELO_REGIONAL_DOMAIN");
$collection = $defFile->getKeyValue("SHORT_NAME");
$country = $defFile->getKeyValue("COUNTRY");

$databasePath = $defFile->getKeyValue("PATH_DATABASE");

//$output = 'xml';


$output = $_REQUEST["output"];

if ($output == ""){
	if ($_REQUEST['service'] != "" && $HTTP_RAW_POST_DATA == "") {
		$output = "xml";
	}else{
		$output = "soap";
	}
}

if ($output == "soap") {
	// Create the server instance
	$server = new soap_server();
	// Initialize WSDL support
	$server->configureWSDL('SciELOService', 'urn:SciELOService');
	// Register the method to expose
	$server->register('search',					// method name
		array('expression' => 'xsd:string', 'from' => 'xsd:string', 'count' => 'xsd:string' ,'lang' => 'xsd:string'),	// input parameters
		array('return' => 'xsd:anyType'),		// output parameters
		'urn:SciELOService',					// namespace
		'urn:SciELOService#search',				// soapaction
		'SOAP-ENC:Array',						// style
		'encoded',								// use
		'Search on SciELO article database'		// documentation
	);

	$server->register('new_titles',				// method name
		array('count' => 'xsd:string'),			// input parameters
		array('return' => 'xsd:anyType'),		// output parameters
		'urn:SciELOService',					// namespace
		'urn:SciELOService#new_titles',			// soapaction
		'SOAP-ENC:Array',						// style
		'encoded',								// use
		'Return new titles from title database'		// documentation
	);

	$server->register('new_issues',					// method name
		array('count' => 'xsd:string'),			// input parameters
		array('return' => 'xsd:anyType'),		// output parameters
		'urn:SciELOService',					// namespace
		'urn:SciELOService#new_titles',				// soapaction
		'SOAP-ENC:Array',									// style
		'encoded',								// use
		'Return new titles from title database'		// documentation
	);

	$server->register('get_titles',					// method name
		array('return' => 'xsd:anyType'),		// output parameters
		'urn:SciELOService',					// namespace
		'urn:SciELOService#get_titles',				// soapaction
		'SOAP-ENC:Array',									// style
		'encoded',								// use
		'Return titles from title database [de acordo com o tipo e parametro]'		// documentation
	);

	// Use the request to (try to) invoke the service
	$server->service($HTTP_RAW_POST_DATA);
}else{

	switch ($_REQUEST["service"]){
           case "search":
                 $response = search($_REQUEST["expression"], $_REQUEST["from"], $_REQUEST["count"],$_REQUEST["lang"]);
                 break;
           case "new_titles":
                 $response = new_titles($_REQUEST["count"]);
				 break;
           case "new_issues":
                 $response = new_issues($_REQUEST["count"]);
				 break;
           case "get_titles":
                 $response = get_titles($_REQUEST["type"], $_REQUEST["param"]);
				 break;
	}
	print($response);

}

// Define the method as a PHP function
function search($expression, $from, $count, $lang)
{
	global $applServer, $output;

	$from = ($from  != "" ? $from  : "1");
	$count= ($count != "" ? $count : "10");

	if ($lang == "es"){
		$iahLang = "e";
	}else{
		if ($lang == "en"){
			$iahLang = "i";
		}else{
			$iahLang = "p";
		}
	}

	$serviceUrl   = "http://" . $applServer . "/cgi-bin/wxis.exe/iah/?IsisScript=iah/iah.xis&base=article^dlibrary&exprSearch=" . $expression . "&lang=" . $iahLang . "&nextAction=xml&isisFrom=" . $from . "&count=" . $count . "&fmt=citation";
	$redirectHtml = "http://" . $applServer . "/cgi-bin/wxis.exe/iah/?IsisScript=iah/iah.xis&base=article^dlibrary&exprSearch=" . $expression . "&lang=" . $iahLang . "&nextAction=lnk&isisFrom=" . $from . "&count=" . $count;
	$response = process($serviceUrl, $redirectHtml);
	return $response;
}

function new_titles($count)
{
	global $country, $applServer, $output, $transformer, $serviceRoot, $databasePath ;
	$count= ($count != "" ? $count : "50");
	$serviceUrl = "http://" . $applServer . "/cgi-bin/wxis.exe/webservices/wxis/?IsisScript=listNewTitles.xis&database=".$databasePath ."title/title&gizmo=GIZMO_XML&count=" . $count;
	$XML = readData($serviceUrl,true);
	$serviceXML .= '<collection name="'.$country.'" uri="http://'.$applServer.'">';
	$serviceXML .= $XML;
	$serviceXML .= '</collection>';
        if ($output == "xml"){
                header("Content-type: text/xml");
	        return envelopeXml($serviceXML, $serviceRoot);
        }else{
                return $serviceXML;
        }
	return $serviceXML;
}

function new_issues($count)
{
	global $country, $applServer, $output, $transformer, $serviceRoot,$databasePath ;

	$count= ($count != "" ? $count : "50");
	$serviceUrl = "http://" . $applServer . "/cgi-bin/wxis.exe/webservices/wxis/?IsisScript=listNewIssues.xis&database=".$databasePath."issue/issue&gizmo=GIZMO_XML&count=" . $count;
	$XML = readData($serviceUrl,true);
	$serviceXML .= '<collection name="'.$country.'" uri="http://'.$applServer.'">';
	$serviceXML .= $XML;
        $serviceXML .= '</collection>';
	if ($output == "xml"){
                header("Content-type: text/xml");
                return envelopeXml($serviceXML, $serviceRoot);
        }else{
                return $serviceXML;
        }
        return $serviceXML;
}
//traz os titulos por tipo selecionado e por parametro
function get_titles($type, $param)
{
global $country, $applServer, $output, $transformer, $serviceRoot, $databasePath ;
$xslName = '';
	$serviceUrl = "http://" . $applServer . "/cgi-bin/wxis.exe/webservices/wxis/?IsisScript=list.xis&database=".$databasePath."title/title&gizmo=GIZMO_XML";
	$XML = readData($serviceUrl,true);
//	die($serviceUrl);
    $serviceXML .= '<collection name="'.$country.'" uri="http://'.$applServer.'">';
	$serviceXML .= '<indicators>';
	$serviceXML .= '<journalTotal>'.getIndicators("journalTotal").'</journalTotal>';
        $serviceXML .= '<articleTotal>'.getIndicators("articleTotal").'</articleTotal>';
        $serviceXML .= '<issueTotal>'.getIndicators("issueTotal").'</issueTotal>';
        $serviceXML .= '<citationTotal>'.getIndicators("citationTotal").'</citationTotal>';
	$serviceXML .= '</indicators>';
	$serviceXML .= $XML;
	$serviceXML .= '</collection>';
        if ($output == "xml"){
                header("Content-type: text/xml");
                return envelopeXml($serviceXML, $serviceRoot);
        }else{
                return $serviceXML;
        }
	return $serviceXML;
}
?>
