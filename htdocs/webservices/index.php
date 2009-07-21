<?php
ini_set("include_path",".");
ini_set("display_errors","1");
error_reporting(E_ALL ^ E_NOTICE ^ E_WARNING);

require_once("../classDefFile.php");
//require_once("../bvs-lib/common/scripts/php/xslt.php");
require_once('nusoap/nusoap.php');
require_once("../class.XSLTransformer.php");
require_once('common.php');


// Backward compatible array creation
$_REQUEST = (isset($_REQUEST) ? $_REQUEST : array_merge($HTTP_GET_VARS, $HTTP_POST_VARS, $HTTP_COOKIE_VARS));

$transformer = new XSLTransformer();

$defFile = new DefFile("../scielo.def.php");

$version = "1.0";
$serviceRoot = "SciELOWebService";
$HTTP_RAW_POST_DATA = isset($HTTP_RAW_POST_DATA) ? $HTTP_RAW_POST_DATA : '';

$applServer = $defFile->getKeyValue("SERVER_SCIELO");
$regionalScielo = $defFile->getKeyValue("SCIELO_REGIONAL_DOMAIN");
$collection = $defFile->getKeyValue("SHORT_NAME");
$country = $defFile->getKeyValue("COUNTRY");
$databasePath = $defFile->getKeyValue("PATH_DATABASE");

//$output = 'xml';
if ($_REQUEST["colname"]) {
	$colname = $_REQUEST["colname"];
} else {
	$colname = $country;
}

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
    $server->register('new_titles');
    $server->register('new_issues');
    $server->register('get_titles');
    $server->register('getDetachedTitles');
    $server->register('getDetachedNewTitles');
    
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

    $server->register('get_title_indicators',                                 // method name
            array('return' => 'xsd:anyType'),               // output parameters
            'urn:SciELOService',                                    // namespace
            'urn:SciELOService#get_titles',                         // soapaction
            'SOAP-ENC:Array',                                                                       // style
            'encoded',                                                              // use
            'Return titles from title database [de acordo com o tipo e parametro]'          // documentation
    );

    $server->register('getDetachedTitles',	//nome do servico
        array('issn' => 'xsd:string'),	//parametro de entrada
        array('return' => 'xsd:string'),	//parametro de saida
        'urn:search.server',	//namespace
        'urn:search.server#lastRecords',	//soap action
        'rpc',	//style
        'encoded',	//use
        'Retorna XML');	//descricao

    $server->register('getDetachedNewTitles',	//nome do servico
        array('issn' => 'xsd:string'),	//parametro de entrada
        array('return' => 'xsd:string'),	//parametro de saida
        'urn:search.server',	//namespace
        'urn:search.server#lastRecords',	//soap action
        'rpc',	//style
        'encoded',	//use
        'Retorna XML');	//descricao

	// Use the request to (try to) invoke the service
	$server->service($HTTP_RAW_POST_DATA);
}else{

	switch ($_REQUEST["service"]){
           case "search":
                 $response = search($_REQUEST["expression"], $_REQUEST["from"], $_REQUEST["count"],$_REQUEST["lang"]);
                 break;
           case "new_titles":
                 $response = new_titles($_REQUEST["count"], $_REQUEST["rep"]);
				 break;
           case "new_issues":
                 $response = new_issues($_REQUEST["count"]);
				 break;
           case "get_titles":
                 $response = get_titles($_REQUEST["type"], $_REQUEST["rep"]);
				 break;
           case "get_title_indicators":
                 $response = get_title_indicators($_REQUEST["type"], $_REQUEST["rep"],$_REQUEST["issn"]);
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

function new_titles($count, $rep)
{
	global $country, $applServer, $output, $transformer, $serviceRoot, $databasePath ;
	global $colname;
	$count= ($count != "" ? $count : "50");
	$serviceUrl = "http://" . $applServer . "/cgi-bin/wxis.exe/webservices/wxis/?IsisScript=listNewTitles.xis&database=".$databasePath ."title/title&gizmo=GIZMO_XML&count=" . $count;
	if ($rep){
		$serviceUrl .="&rep=".$rep;
		
	}
	$XML = readData($serviceUrl,true);
	$serviceXML .= '<collection name="'.$colname.'" uri="http://'.$applServer.'">';
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
	global $colname;

	$count= ($count != "" ? $count : "50");
	$serviceUrl = "http://" . $applServer . "/cgi-bin/wxis.exe/webservices/wxis/?IsisScript=listNewIssues.xis&database=".$databasePath."issue/issue&gizmo=GIZMO_XML&count=" . $count;
	$XML = readData($serviceUrl,true);
	$serviceXML .= '<collection name="'.$colname.'" uri="http://'.$applServer.'">';
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
function get_titles($type, $rep)
{
global $country, $applServer, $output, $transformer, $serviceRoot, $databasePath ;
global $colname;
$xslName = '';

	$serviceUrl = "http://" . $applServer . "/cgi-bin/wxis.exe/webservices/wxis/?IsisScript=list.xis&database=".$databasePath."title/title&gizmo=GIZMO_XML";
	if ($rep){
		$serviceUrl .= "&rep=".$rep;
	}
	$XML = readData($serviceUrl,true);
//	die($serviceUrl);
	if ($rep) {
		
	    $serviceXML .= '<collection name="'.$colname.'" uri="http://'.$applServer.'">';
		$serviceXML .= $XML;
		$serviceXML .= '</collection>';
	} else {
	    $serviceXML .= '<collection name="'.$colname.'" uri="http://'.$applServer.'">';
		$serviceXML .= '<indicators>';
		$serviceXML .= '<journalTotal>'.getIndicators("journalTotal").'</journalTotal>';
        $serviceXML .= '<articleTotal>'.getIndicators("articleTotal").'</articleTotal>';
        $serviceXML .= '<issueTotal>'.getIndicators("issueTotal").'</issueTotal>';
        $serviceXML .= '<citationTotal>'.getIndicators("citationTotal").'</citationTotal>';
		$serviceXML .= '</indicators>';
		$serviceXML .= $XML;
		$serviceXML .= '</collection>';
	}
        if ($output == "xml"){
                header("Content-type: text/xml");
                return envelopeXml($serviceXML, $serviceRoot);
        }else{
                return $serviceXML;
        }
	return $serviceXML;
}

function get_title_indicators($type, $rep, $issn)
{
global $country, $applServer, $output, $transformer, $serviceRoot, $databasePath;
global $colname;
$xslName = '';

	$serviceUrl = "http://" . $applServer . "/cgi-bin/wxis.exe/webservices/wxis/?IsisScript=search.xis&database=".$databasePath."/title/title&search=LOC=".$issn."$&gizmo=GIZMO_XML&count=1";
        if ($rep){
                $serviceUrl .= "&rep=".$rep;
        }
        $XML = readData($serviceUrl,true);

        $serviceXML .= '<collection name="'.$colname.'" uri="http://'.$applServer.'">';
        $serviceXML .= '<journalIndicators>';
        $serviceXML .= '<articleTotal>'.getIndicators("journalArticleTotal",$issn).'</articleTotal>';
	$serviceXML .= '<issueTotal>'.getIndicators("journalIssueTotal",$issn).'</issueTotal>';
	$serviceXML .= '<citationTotal>'.getIndicators("journalCitationTotal",$issn).'</citationTotal>';
        $serviceXML .= '</journalIndicators>';
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

/**
 * get all titles contained at the issn array
 * @param $issn array
 */
function getDetachedTitles($issn){
    global $country, $applServer, $output, $transformer, $serviceRoot, $databasePath ;
    global $colname;

    if(is_array($issn)){
        $issnTmp='';
        foreach($issn as $key => $value){
            if($key > 0){
                $issnTmp .= ' or ';
            }
            $issnTmp .= 'LOC='.$value;
        }
        $issnString = $issnTmp;
    }else{
        $issnString = 'LOC='.$issn;
    }

	$serviceUrl = "http://" . $applServer . "/cgi-bin/wxis.exe/webservices/wxis/?IsisScript=detached.xis&database=".$databasePath."title/title&gizmo=GIZMO_XML&search=".$issnString;
	$XML = readData($serviceUrl,true);    
    /* get the total num of journals */
    $journalTotal=getElementValue(getElementValue(str_replace("<hr>","<hr />",$XML) , "Isis_Total"),"occ");

    $serviceXML .= '<collection name="'.$colname.'" uri="http://'.$applServer.'">';
    $serviceXML .= '<indicators>';
    $serviceXML .= '<journalTotal>'.$journalTotal.'</journalTotal>';
    $serviceXML .= '<articleTotal>'.getIndicators("articleTotal",$issn).'</articleTotal>';
    $serviceXML .= '<issueTotal>'.getIndicators("issueTotal",$issn).'</issueTotal>';
    $serviceXML .= '<citationTotal>'.getIndicators("citationTotal",$issn).'</citationTotal>';
    $serviceXML .= '</indicators>';
    $serviceXML .= $XML;
    $serviceXML .= '</collection>';
	
	return $serviceXML;
}

function getDetachedNewTitles($issn){

    global $country, $applServer, $output, $transformer, $serviceRoot, $databasePath ;
	global $colname;

    if(is_array($issn)){
        $issnTmp='';
        foreach($issn as $key => $value){
            if($key > 0){
                $issnTmp .= ' or ';
            }
            $issnTmp .= 'LOC='.$value;
        }
        $issnString = $issnTmp;
    }else{
        $issnString = 'LOC='.$issn;
    }

	$count= ($count != "" ? $count : "50");
	$serviceUrl = "http://" . $applServer . "/cgi-bin/wxis.exe/webservices/wxis/?IsisScript=detached.xis&database=".$databasePath ."title/title&gizmo=GIZMO_XML&count=" . $count ."&search=".$issnString;
	if ($rep){
		$serviceUrl .="&rep=".$rep;
	}
    
	$XML = readData($serviceUrl,true);
	$serviceXML .= '<collection name="'.$colname.'" uri="http://'.$applServer.'">';
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

function getDetachedNewIssues(){}

?>
