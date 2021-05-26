<?php
    include_once ("classDefFile.php");
    include_once ("class.XSLTransformerOAI.php");
    //include_once ("classScielo.php");
    include_once ("version-4.1-like-4.0.php");
	include_once ("scielo-ws.php");
	define ( "DEFNAME", "scielo.def.php" );
    define ( "DEFAULT_CACHE_EXPIRES", 180 );
	$defFile = parse_ini_file(dirname(__FILE__)."/../scielo.def.php");
    $metadataPrefixList = array ( "oai_dc" => array( "ns" => "http://www.openarchives.org/OAI/2.0/oai_dc/",
                                                     "schema" => "http://www.openarchives.org/OAI/2.0/oai_dc.xsd"),
								  "oai_dc_agris" => array("ns" => "http://www.purl.org/agmes/agrisap/schema/",
								  							"schema" => "http://www.purl.org/agmes/agrisap/schema/agris.xsd"),
                                  "oai_dc_openaire" => array( "ns" => "http://www.openarchives.org/OAI/2.0/oai_dc/",
                                                     "schema" => "http://www.openarchives.org/OAI/2.0/oai_dc.xsd"),
                                  "oai_dc_scielo" => array( "ns" => "http://www.openarchives.org/OAI/2.0/oai_dc/",
                                                            "schema" => "http://www.openarchives.org/OAI/2.0/oai_dc.xsd")
                                  );
/*
	$repositoryName = "SciELO Online Library Collection";
	$earliestDatestamp = "1996-01-01";
*/      
    $debug_str = "";
$identifier = cleanParameter($identifier);
	/******************************************* Functions *********************************************/
    
    function debugstring ( $str )
    {
        global $debug, $debug_str;
        
        if ( $debug )
        {
            $debug_str .= $str;
        }
    }
   
    function printdebug ()
    {
        global $debug, $debug_str;
        
        if ( $debug )
        {
            echo $debug_str;
            exit;
        }
    }

    function cleanParameter ($param)
    {
       $stopChars = array('"','<','>','&');
       $allowedChars = array('&quot;','&lt;','&gt;','&amp;');

       return str_replace($stopChars,$allowedChars,$param);

    }   

	/************************************** parseResumptionToken *************************************/
    
    function parseResumptionToken ( $resumptionToken )
    {
        global $metadataPrefix, $control, $set, $from, $until;
      
        $hregex = "/^HR__S([0-9X]{4}-[0-9X]{4})[0-9]{13}:([0-9X]{4}-[0-9X]{4}|openaire|scielo)?:((19|20)\d\d-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01]))?:((19|20)\d\d-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01]))?:(oai_dc)(_agris|_openaire|_scielo)?$/";
        $dregex = "/DTH__((19|20)\d\d(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[01]))__([0-9X]{4}-[0-9X]{4})([0-9]{9}|[0-9]{13}):([0-9X]{4}-[0-9X]{4}|openaire|scielo)?:((19|20)\d\d-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01]))?:((19|20)\d\d-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01]))?:(oai_dc)(_agris|_openaire|_scielo)?$/";

        if (substr($resumptionToken, 0, 1) == 'H'){
            $result_hregex = preg_match($hregex , $resumptionToken );
            if ( !$result_hregex ) return false;
        }
	if (substr($resumptionToken, 0, 1) == "D"){
            $result_dregex = preg_match($dregex , $resumptionToken );
            if ( !$result_dregex ) return false;
        }
        $params = split ( ":", $resumptionToken );
        $control = $params[ 0 ];
        $set = $params[ 1 ];
        $from = $params[ 2 ];
        $until = $params[ 3 ];
        $metadataPrefix = $params[ 4 ];

        if ( !$control ) return false;

        if ( $from && !isDatestamp ( $from ) ) return false;

        if ( $until && !isDatestamp ( $until ) ) return false;

        if ( $set && !is_Set ( $set ) ) return false;
    
        return true;
    }

	/********************************************** is_Set ************************************************/

    function is_Set ( $set )
    {
        return eregi ( "^([0-9a-z]{4}-[0-9a-z]{4}|openaire|scielo)$", $set );
    }

	/******************************************* isDatestamp **********************************************/
        
    function isDatestamp ( $date )
    {

        if (! preg_match("/[0-9]{4}-[0-9]{2}-[0-9]{2}$/",$date)){
            return false;
        }
        return true;
    }

	/******************************************* isValidPrefix *******************************************/

	function isValidPrefix ( $metadataPrefix )	
	{
		global $metadataPrefixList;

		reset ( $metadataPrefixList );

	    while ( list ( $key, )  = each ( $metadataPrefixList ) )
	    {
		    if ( $key == $metadataPrefix ) return true;
	    }

		return false;
	}

	/**************************************** createOAIErrorpacket ****************************************/
    
    function createOAIErrorpacket ( $request_uri, $verb, $errorcode, $error = "" )
    {
     	$payload = "<error code=\"$errorcode\">$error</error>\n";
       	$packet = generateOAI_packet ( $request_uri, $verb, $payload );
        return $packet;
    }
    
	/**************************************** generateOAI_packet ****************************************/

    /**
     * Converts HTML entities codes to their HTML representation
     * 
     * This function search in the $string for HTML entity codes
     * then tries to convert into their HTML representation 
     * if they aren't in blacklist conversion ($cannot_convert).
     * 
     * @param string $string Represents the OAI results from XLST.
     * 
     * @return string String with html entities codes converted.
     */
    function convert_html_entities($string) {
        $quantity = substr_count($string, "&");
        $start_search_pos = 0;
        $cannot_convert = array("&amp;", "&gt;", "&lt;");

        while($quantity-- > 0) {
            
            $entity_start_pos = strpos($string, "&", $start_search_pos);
            $entity_end_pos = strpos($string, ";", $entity_start_pos) + 1;
            $entity = substr($string, $entity_start_pos, $entity_end_pos - $entity_start_pos);

            if (!strrpos($entity, " ")) {
                // texto pode ser uma entidade, pois nao contem espaco
                if (!in_array($entity, $cannot_convert)) {
                    // entidade que nao esta' na lista $cannot_convert
                    $html_entity = html_entity_decode($entity, ENT_QUOTES, "UTF-8");
                    if ($entity != $html_entity && (ctype_print($html_entity) || preg_match("//u", $html_entity))) {
                        // conseguiu converter
                        $string = str_replace($entity, $html_entity, $string);
                    }
                }
            }

            $start_search_pos = $entity_end_pos;
        }

        return $string;        
    }

    function generateOAI_packet ( $request_uri, $verb, $payload )
    {
        global $identifier, $metadataPrefix, $from, $until, $set, $resumptionToken;
        
        $envelop  = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
        $envelop .= "<OAI-PMH xmlns=\"http://www.openarchives.org/OAI/2.0/\"\n";
        $envelop .= "         xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n";
        $envelop .= "         xsi:schemaLocation=\"http://www.openarchives.org/OAI/2.0/\n";
        $envelop .= "          http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd\">\n";

//        $responseDate = date ( "Y-m-d\TH:i:sO" );
//        $responseDate = substr ( $responseDate, 0, -2 ) . ":" . substr ( $responseDate, -2 );
        $responseDate = gmdate ( "Y-m-d\TH:i:s\Z" );
        
        $envelop .= " <responseDate>" . $responseDate . "</responseDate>\n";
        $envelop .= " <request verb=\"" . $verb . "\"";

        if ( $metadataPrefix && !$resumptionToken )
        {
        	$envelop .= " metadataPrefix=\"" . $metadataPrefix . "\"";
        }

        if ( $identifier && !$resumptionToken  )
        {
        	$envelop .= " identifier=\"" . $identifier . "\"";
        }

        if ( $from  && !$resumptionToken )
        {
        	$envelop .= " from=\"" . $from . "\"";
        }

        if ( $until  && !$resumptionToken )
        {
        	$envelop .= " until=\"" . $until . "\"";
        }

        if ( $set  && !$resumptionToken )
        {
        	$envelop .= " set=\"" . $set . "\"";
        }
                
        if ( $resumptionToken )
        {
        	$envelop .= " resumptionToken=\"" . $resumptionToken . "\"";
        }

        $envelop .= ">" . $request_uri . "</request>\n";

        $envelop .= $payload;

        $envelop .= "</OAI-PMH>\n";

        return $envelop;
    }

	/**************************************** generatePayload ****************************************/
    function generatePayload ( $ws_client_url, $service, $service_name, $parameters, $xsl )
    {
        global $debug, $defFile;
			//die($service_name." - ".$service);
			switch ( $service_name )
			{
			case "Identify": 
				{				
				$response = listRecords( $set = $parameters["set"], $from = $parameters["from"], $until = $parameters["until"], $control = $parameters["control"], $lang = "en", $nrm = "iso", $count = 30, $debug = false );
				break;
				}
			case "ListMetadataFormats":
				{
				$response = getAbstractArticle( $set = $parameters["pid"], $from = $parameters["from"], $until = $parameters["until"], $control = $parameters["control"], $lang = "en", $nrm = "iso", $count = 30, $debug = false );
				break;
				}
			case "ListIdentifiers":
				{
				$response = listRecords( $set = $parameters["set"], $from = $parameters["from"], $until = $parameters["until"], $control = $parameters["control"], $lang = "en", $nrm = "iso", $count = 30, $debug = false, $metadataprx = $parameters["metadataprefix"] );
				break;
				}
			case "ListSets":
				{
				$response = getTitles($lang = "en", $debug = false );
				break;
				}				
			case "ListRecords":
				{
				$response = listRecords( $set = $parameters["set"], $from = $parameters["from"], $until = $parameters["until"], $control = $parameters["control"], $lang = "en", $nrm = "iso", $count = 30, $debug = false, $metadataprx = $parameters["metadataprefix"] );
				break;
				}
			case "ListRecordsAgris":
				{
				$response = ListRecordsAgris( $set = $parameters["set"], $from = $parameters["from"], $until = $parameters["until"], $control = $parameters["control"], $lang = "en", $nrm = "iso", $count = 100, $debug = false, $metadataprx = $parameters["metadataprefix"] );
				break;
				}
			case "GetRecord":
				{
				$response = getAbstractArticle( $pid = $parameters["pid"],$lang = "en", $ws = $parameters["ws_oai"], $debug = false );
				break;
				}
            case "GetRecordScielo":
                {
                $response = getRecord( $pid = $parameters["pid"], $ws = $parameters["ws_oai"], $debug = false );
                break;
                }
			case "GetRecordAgris":
				{
				$response = getAbstractArticleAgris( $pid = $parameters["pid"],$lang = "en", $ws = $parameters["ws_oai"], $debug = false );
				break;
				}
			}
        
        #workaround for fatal error in DOMDocument::loadXML() when XML have & character 
        $response = preg_replace('/ & /', ' &amp; ', $response);

        if ( !$debug )
        {
            $transform = new XSLTransformerOAI();
            $transform->setXslBaseUri($defFile["PATH_OAI"]);
            $transform->setXslFile ( $defFile["PATH_OAI"].$xsl );
            $transform->setXml ( $response );
            $transform->transform();
            if ( $transform->getError() )
    	    {
                echo "XSL Transformation error\n";
    	        echo $transform->getError();
	            exit ();
    	    }
	        $result = $transform->getOutput();
        }
        
		
	    return convert_html_entities($result);
    }

	/**************************************** verbo GetRecord **************************************/

    function getRecord_OAI ( $request_uri, $ws_client_url, $xslPath, $identifier, $metadataPrefix )
    {
        global $debug;
    	if ( !isset ( $identifier ) || empty ( $identifier ) )
    	{
    		$result = "<error code=\"badArgument\">Missing or empty identifier</error>\n";
    	}
    	else if ( !isset ( $metadataPrefix ) || empty ( $metadataPrefix ) )
    	{

    		$result = "<error code=\"badArgument\">Missing or empty metadataPrefix</error>\n";
    	}
    	else if ( !isValidPrefix ( $metadataPrefix ) )
    	{
    		$result = "<error code=\"cannotDisseminateFormat\"/>\n";
    	}
    	else
    	{
	        $parameters = array ( "pid" => str_replace ( "oai:scielo:", "", $identifier ),
                                  "lang" => "en", 
                                  "tlng" => "en", 
                                  "ws_oai" => true );
                                  
        	if ( $debug ) $parameters[ "debug" ] = true;

			 if($metadataPrefix == 'oai_dc_agris'){
			 	$xsl = 'GetRecord_agris.xsl';
			 	$result = generatePayload ( $ws_client_url, "getAbstractArticleAgris", "GetRecordAgris", $parameters, $xsl );
            }
             else if($metadataPrefix == 'oai_dc_openaire'){
                $xsl = 'GetRecord_openaire.xsl';
                $result = generatePayload ( $ws_client_url, "getAbstractArticle", "GetRecord", $parameters, $xsl );
             } else if($metadataPrefix == 'oai_dc_scielo'){
                $xsl = 'GetRecord_scielo.xsl';
                $result = generatePayload ( $ws_client_url, "getRecord", "GetRecordScielo", $parameters, $xsl );
             } else {
			 	$xsl = 'GetRecord.xsl';
			 	$result = generatePayload ( $ws_client_url, "getAbstractArticle", "GetRecord", $parameters, $xsl );			
			 }

						 
	    	
	    }
	    $oai_packet = generateOAI_packet ( $request_uri, "GetRecord", $result );

	    return $oai_packet;
    }

	/**************************************** verbo Identify **************************************/

    function Identify_OAI ( $request_uri, $ws_client_url, $xslPath )
    {
    	global $repositoryName, $earliestDatestamp, $adminEmails;

    	$payload  = " <Identify>\n";
    	$payload .= "  <repositoryName>$repositoryName</repositoryName>\n";
    	$payload .= "  <baseURL>$request_uri</baseURL>\n";
    	$payload .= "  <protocolVersion>2.0</protocolVersion>\n";
    	for ( $i = 0; $i < sizeof ( $adminEmails ); $i++ )
    	{
    		$payload .= " <adminEmail>" . $adminEmails[ $i ] . "</adminEmail>\n";
    	}
        
        $parameters = array (
                "set" => "", 
                "from" => "19090401", 
                "until" => "", 
                "control" => "",
                "lang" => "en",
                "nrm" => "iso",
                "count" => 1
        );

        if ( $debug ) $parameters[ "debug" ] = true;
            
        $xsl = "Identify.xsl";
	   	$result = generatePayload ( $ws_client_url, "listRecords","Identify", $parameters, $xsl );
        
        $payload .= trim ( str_replace ( "datestamp", "earliestDatestamp", $result ) );
    	$payload .= "  <deletedRecord>no</deletedRecord>\n";
    	$payload .= "  <granularity>YYYY-MM-DD</granularity>\n";
    	$payload .= " </Identify>\n";

    	$oai_packet = generateOAI_packet ( $request_uri, "Identify", $payload );

//	    $oai_packet = str_replace ( "localhost", "200.6.42.159", $oai_packet);

    	return $oai_packet;
    }

	/************************************ verbo ListMetadataFormats **********************************/

    function ListMetadataFormats_OAI ( $request_uri, $ws_client_url, $xslPath, $identifier = "" )
    {
    	global $debug, $metadataPrefixList;

    	$payload = "";

    	if ( $identifier )
    	{
	        $parameters = array ( "pid" => str_replace ( "oai:scielo:", "", $identifier ),
                                  "lang" => "en", 
                                  "tlng" => "en", 
                                  "ws_oai" => true );
            if ( $debug ) $parameters[ "debug" ] = true;

        	//$xsl = $xslPath . "ListMetadataFormats.xsl";
		$xsl = "ListMetadataFormats.xsl";
    		$payload = generatePayload ( $ws_client_url, "getAbstractArticle","ListMetadataFormats", $parameters, $xsl );
		}

    	if ( trim ( $payload ) == "" )
    	{
			$payload  = " <ListMetadataFormats>\n";

	    	reset ( $metadataPrefixList );

	    	while ( list ( $metadataPrefix, $data ) = each ( $metadataPrefixList ) )
	    	{
	    		$payload .= "  <metadataFormat>\n";
	    		$payload .= "   <metadataPrefix>$metadataPrefix</metadataPrefix>\n";
	    		$payload .= "   <schema>" . $data[ "schema" ] . "</schema>\n";
	    		$payload .= "   <metadataNamespace>" . $data[ "ns" ] . "</metadataNamespace>\n";
	    		$payload .= "  </metadataFormat>\n";
	    	}

			$payload .= " </ListMetadataFormats>\n";
		}

    	$oai_packet = generateOAI_packet ( $request_uri, "ListMetadataFormats", $payload );

//	    $oai_packet = str_replace ( "localhost", "200.6.42.159", $oai_packet);

    	return $oai_packet;
    }

	/**************************************** verbo ListSets *****************************************/

    function ListSets_OAI ( $request_uri, $ws_client_url, $xslPath, $resumptionToken = "" )
    {
        global $debug;
        
        //$xsl = $xslPath . "ListSets.xsl";
		$xsl = "ListSets.xsl";
		$parameters = array ( "lang" => "en" );
        
        if ( $debug ) $parameters[ "debug" ] = true;

    	$result = generatePayload ( $ws_client_url, "getTitles", "ListSets", $parameters, $xsl );

	    $oai_packet = generateOAI_packet ( $request_uri, "ListSets", $result );

//	    $oai_packet = str_replace ( "localhost", "200.6.42.159", $oai_packet);

	    return $oai_packet;
    }

	/**************************************** ListIdOrRecords_OAI ****************************************/
    
    function ListIdOrRecords_OAI ( $verb, $request_uri, $ws_client_url, $xslPath, $metadataPrefix, $set = "", $from = "", $until = "", $control = "" )
    {
        global $debug;
        $eds = "19090401";
        $latest_datestamp = "20991230";

        if ( empty($metadataPrefix) )
            $metadataPrefix = "oai_dc"; 

        if ($from != '')
            $from = substr($from, 0, 4) . substr($from, 5, 2) . substr($from, 8, 2);

        if ($until != ''){
            $until = substr($until, 0, 4) . substr($until, 5, 2) . substr($until, 8, 2);
        }elseif ($from != ''){
            $until = $latest_datestamp;
        }

        if (($until < $from) and ($until < $eds)){
            $result = '<error code="badArgument">The request specified a date one year before the earliestDatestamp given in the Identify response</error>';
        }else if ( !isset ( $metadataPrefix ) || empty ( $metadataPrefix )){
    		$result = "<error code=\"badArgument\">Missing or empty metadataPrefix</error>\n";
    	}
    	else if ( !isValidPrefix ( $metadataPrefix ) )
    	{
       		$result = "<error code=\"cannotDisseminateFormat\"/>\n";
    	}
    	else
    	{
	        $parameters = array (
                "set" => $set, 
                "from" => $from, 
                "until" => $until, 
                "control" => $control,
                "lang" => "en",
                "nrm" => "iso",
                "count" => 40,
                "metadataprefix" => $metadataPrefix
            );

            if ( $debug ) $parameters[ "debug" ] = true;
            
	        //$xsl = $xslPath . "$verb.xsl";
			
			if($verb == 'ListRecords'){
				if($metadataPrefix == 'oai_dc_agris'){
				 	$xsl = 'ListRecords_agris.xsl';
				 	$result = generatePayload ( $ws_client_url, "listRecordsAgris", "ListRecordsAgris", $parameters, $xsl );
				}else if($metadataPrefix == 'oai_dc_openaire'){
                    $xsl = 'ListRecords_openaire.xsl';
                    $result = generatePayload ( $ws_client_url, "listRecords", "ListRecords", $parameters, $xsl );                
                }else{
					$xsl = "$verb.xsl";
					$result = generatePayload ( $ws_client_url, "listRecords", $verb, $parameters, $xsl ); 	
				 }
			}else{
				$xsl = "$verb.xsl";
				$result = generatePayload ( $ws_client_url, "listRecords", $verb, $parameters, $xsl ); 	
			}			
			
	    }

	    $oai_packet = generateOAI_packet ( $request_uri, $verb, $result );

//	    $oai_packet = str_replace ( "localhost", "200.6.42.159", $oai_packet);

	    return $oai_packet;    
    }

	/******************************************* Principal *******************************************/
    if ( isset ( $_SERVER ) && !isset ( $DOCUMENT_ROOT ) )
	{
		$DOCUMENT_ROOT = $_SERVER[ "DOCUMENT_ROOT" ];
	}
    
    $DOCUMENT_ROOT = trim ( $DOCUMENT_ROOT );
    
    $dirChar = ( strpos ( $DOCUMENT_ROOT, "\\" ) === false ) ? "/" : "\\";

    if ( substr ( $DOCUMENT_ROOT, -1 ) == $dirChar )
    {
	    $def = $DOCUMENT_ROOT . DEFNAME;
    }
    else
    {
	    $def = $DOCUMENT_ROOT . $dirChar . DEFNAME;
    }

    debugstring ( "\$def=$def\n" );    
    $deffile = new DefFile ( $def );

    $ws_client_url = "http://" . $deffile->getKeyValue("SERVER_SCIELO") . $deffile->getKeyValue("PATH_DATA") . "ws/scielo-ws.php";
    debugstring ( "\$ws_client_url=$ws_client_url\n" );    

    $self = "http://" . $deffile->getKeyValue("SERVER_SCIELO") . $deffile->getKeyValue("PATH_DATA") . "oai/scielo-oai.php";

	$xslPath = "http://" . $deffile->getKeyValue("SERVER_SCIELO") . $deffile->getKeyValue("PATH_DATA") . "oai/";
    debugstring ( "\$xslPath=$xslPath\n" );    
    
	$repositoryName = trim ( $deffile->getKeyValue("SITE_NAME") );
	$adminEmails = array ( trim ( $deffile->getKeyValue("E_MAIL") ) );
    switch ( $verb )
    {
    	case "Identify":
		$packet = Identify_OAI ( $self, $ws_client_url, $xslPath );
        break;

        case "ListMetadataFormats":
	    $packet = ListMetadataFormats_OAI ( $self, $ws_client_url, $xslPath, "" );
	break;
    	case "GetRecord":
        	$packet = getRecord_OAI ( $self, $ws_client_url, $xslPath,$identifier, $metadataPrefix );
        break;
        case "ListSets":
	     $packet = ListSets_OAI ( $self, $ws_client_url, $xslPath, $resumptionToken );
	break;          
        case "ListIdentifiers":
        case "ListRecords":

	       //$metadataPrefix2 = $metadataPrefix; // $metadataPrefix perde seu valor original apos o IF abaixo.
            if ( $resumptionToken && !parseResumptionToken ( $resumptionToken ) )
            {
                $packet = createOAIErrorpacket ( $self, $verb, "badResumptionToken" );
                break;
            }
            if ( $from && !isDatestamp( $from ) )
            {
                $packet = createOAIErrorpacket ( $self, $verb, "badArgument", "Invalid date format" );
                break;
            }

            if ( $until && !isDatestamp( $until ) )
            {
                $packet = createOAIErrorpacket ( $self, $verb, "badArgument", "Invalid date format" );
                break;
            }
            $packet = ListIdOrRecords_OAI ( $verb, $self, $ws_client_url, $xslPath, $metadataPrefix, $set, $from, $until, $control );
			break;

        default:
            $packet = createOAIErrorpacket ( $self, $verb, "badVerb", "Illegal OAI verb" );
        	break;
    }
    
    printdebug ();

    header ( "Content-Type: text/xml" );
    echo $packet;
?>
