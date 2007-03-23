<?php
require_once("../classDefFile.php");
require_once("../bvs-lib/common/scripts/php/xslt.php");
require_once('../bvs-lib/common/classes/php/nusoap.php');
require_once('common.php');

// Backward compatible array creation
$_REQUEST = (isset($_REQUEST) ? $_REQUEST : array_merge($HTTP_GET_VARS, $HTTP_POST_VARS, $HTTP_COOKIE_VARS));

$transformer = new XSLTransformer();

$defFile = new DefFile("../scielo.def");

$version = "0.9";
$serviceRoot = "SciELOWebService";
$HTTP_RAW_POST_DATA = isset($HTTP_RAW_POST_DATA) ? $HTTP_RAW_POST_DATA : '';

$applServer = $defFile->getKeyValue("SERVER_SCIELO");
$country = $defFile->getKeyValue("COUNTRY");

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
		'rpc',									// style
		'encoded',								// use
		'Search on SciELO article database'		// documentation
	);

	$server->register('new_titles',				// method name
		array('count' => 'xsd:string'),			// input parameters
		array('return' => 'xsd:anyType'),		// output parameters
		'urn:SciELOService',					// namespace
		'urn:SciELOService#new_titles',				// soapaction
		'rpc',									// style
		'encoded',								// use
		'Return new titles from title database'		// documentation
	);

	$server->register('new_issues',					// method name
		array('count' => 'xsd:string'),			// input parameters
		array('return' => 'xsd:anyType'),		// output parameters
		'urn:SciELOService',					// namespace
		'urn:SciELOService#new_titles',				// soapaction
		'rpc',									// style
		'encoded',								// use
		'Return new titles from title database'		// documentation
	);

	$server->register('get_titles',					// method name
		array('lang' => 'xsd:string','letter' => 'xsd<% If  %>:string'),	// input parameters
		array('return' => 'xsd:anyType'),		// output parameters
		'urn:SciELOService',					// namespace
		'urn:SciELOService#new_titles',				// soapaction
		'rpc',									// style
		'encoded',								// use
		'Return new titles from title database'		// documentation
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
                 $response = get_titles($_REQUEST["letter"]);
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
	global $country, $applServer, $output, $transformer;
	
	$count= ($count != "" ? $count : "5");
	
	$serviceUrl = "http://" . $applServer . "/cgi-bin/wxis.exe/webservices/wxis/?IsisScript=listNewTitles.xis&database=/home/scielo/www/bases/title/title&gizmo=GIZMO_XML&count=" . $count;
	$XML = process($serviceUrl);
	$XML = str_replace('<?xml version="1.0" encoding="ISO-8859-1"?>','',$XML);
	$serviceXML  = '<?xml version="1.0" encoding="ISO-8859-1"?>';
	$serviceXML .= '<serviceXML>';
	$serviceXML .= '<vars>';
	$serviceXML .= '<applServer>'.$applServer.'</applServer>';
	$serviceXML .= '<country>'.$country.'</country>';		
	$serviceXML .= '</vars>';
	$serviceXML .= $XML;
	$serviceXML .= '</serviceXML>';
	$transformer->setXML($serviceXML);
	$transformer->SetXSL("http://". $applServer ."/webservices/xsl/scieloNewTitle2rss.xsl");
	$transformer->transform();

	$response = $transformer->getOutput();

	return $response;
}

function new_issues($count)
{
	global $country, $applServer, $output, $transformer;
	
	$count= ($count != "" ? $count : "5");
	$serviceUrl = "http://" . $applServer . "/cgi-bin/wxis.exe/webservices/wxis/?IsisScript=listNewIssues.xis&database=/home/scielo/www/bases/issue/issue&gizmo=GIZMO_XML&count=" . $count;
	$XML = process($serviceUrl);
	$XML = str_replace('<?xml version="1.0" encoding="ISO-8859-1"?>','',$XML);
	$serviceXML  = '<?xml version="1.0" encoding="ISO-8859-1"?>';
	$serviceXML .= '<serviceXML>';
	$serviceXML .= '<vars>';
	$serviceXML .= '<applServer>'.$applServer.'</applServer>';
	$serviceXML .= '<country>'.$country.'</country>';		
	$serviceXML .= '</vars>';
	$serviceXML .= $XML;
	$serviceXML .= '</serviceXML>';
	$transformer->setXML($serviceXML);
	$transformer->SetXSL("http://". $applServer ."/webservices/xsl/scieloIssues2rss.xsl");
	$transformer->transform();

	$response = $transformer->getOutput();

	return $response;
}

function get_titles($letter)
{
	global $country, $applServer, $output, $transformer;
	$serviceUrl = "http://" . $applServer . "/cgi-bin/wxis.exe/webservices/wxis/?IsisScript=list.xis&database=/home/scielo/www/bases/title/title&gizmo=GIZMO_XML";
	$XML = process($serviceUrl);
	$XML = str_replace('<?xml version="1.0" encoding="ISO-8859-1"?>','',$XML);
	$serviceXML  = '<?xml version="1.0" encoding="ISO-8859-1"?>';
	$serviceXML .= '<serviceXML>';
	$serviceXML .= '<vars>';
	$serviceXML .= '<applServer>'.$applServer.'</applServer>';
	$serviceXML .= '<country>'.$country.'</country>';	
	$serviceXML .= '<letter>'.$letter.'</letter>';
	$serviceXML .= '</vars>';
	$serviceXML .= $XML;
	$serviceXML .= '</serviceXML>';
	$transformer->setXML($serviceXML);
	$transformer->SetXSL("http://". $applServer ."/webservices/xsl/scieloTitle2rss.xsl");
	$transformer->transform();
	$response = $transformer->getOutput();

	return $response;
}

?>
