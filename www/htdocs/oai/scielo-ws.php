<?php
	include_once ( "classScielo_XML.php" );
	define ( "DEFNAME", "scielo.def.php" );

	/******************************* SERVICES DEFINITION ***********************************/

	function getTitles ( $lang = "en", $debug = false  )
	{
		global $scielo_xml, $server;

		$parameters = array ( "lng" => $lang );

		$result = $scielo_xml->getXML ( "sci_alphabetic", $parameters, $debug );

		if ( $error = $scielo_xml->getError () )
		{
//			return new soap_fault ( "Scielo_WS_Server", "", $error );
			return new soap_fault ( "Scielo_WS_Server", $error );
		}

		return $result;
	}

	function getIssues ( $pid, $lang = "en", $debug = false )
	{
		global $scielo_xml, $server;

		if ( $pid == "" )
		{
//    		return new soap_fault ( 'Scielo_WS_Server','','Client must supply a valid PID.' );
    		return new soap_fault ( 'Scielo_WS_Server', 'Client must supply a valid PID.' );
	    }

		$parameters = array ( "pid" => $pid, "lng" => $lang );

		$result = $scielo_xml->getXML ( "sci_issues", $parameters, $debug );

		if ( $error = $scielo_xml->getError () )
		{
//			return new soap_fault ( "Scielo_WS_Server", "", $error );
			return new soap_fault ( "Scielo_WS_Server", $error );
		}

		return $result;
	}

	function getArticlesIssue ( $pid, $lang = "en", $debug = false )
	{
		global $scielo_xml, $server;

		if ( $pid == "" )
		{
//    		return new soap_fault ( 'Scielo_WS_Server','','Client must supply a valid PID.' );
    		return new soap_fault ( 'Scielo_WS_Server','Client must supply a valid PID.' );
	    }

		$parameters = array ( "pid" => $pid, "lng" => $lang );

		$result = $scielo_xml->getXML ( "sci_issuetoc", $parameters, $debug );
		if ( $error = $scielo_xml->getError () )
		{
//			return new soap_fault ( "Scielo_WS_Server", "", $error );
			return new soap_fault ( "Scielo_WS_Server", $error );
		}

		return $result;
	}

	function getAbstractArticle ( $pid, $lang = "en", $tlng = "en", $ws_oai = false, $debug = false  )
	{
		global $scielo_xml, $server;
		if ( $pid == "" )
		{
//    		return new soap_fault ( 'Scielo_WS_Server','','Client must supply a valid PID.' );
    		return new soap_fault ( 'Scielo_WS_Server','Client must supply a valid PID.' );
	    }

		$parameters = array ( "pid" => $pid, "lng" => $lang, "tlng" => $tlng );
        
        if ( $ws_oai )
        {
            $parameters[ "ws" ] = "true";
        }

		$result = $scielo_xml->getXML ( "sci_abstract", $parameters, $debug );

		if ( $error = $scielo_xml->getError () )
		{
//			return new soap_fault ( "Scielo_WS_Server", "", $error );
			return new soap_fault ( "Scielo_WS_Server", $error );
		}

		return $result;
	}
	
	function getAbstractArticleAgris ( $pid, $lang = "en", $tlng = "en", $ws_oai = false, $debug = false  )
	{
		global $scielo_xml, $server;
		if ( $pid == "" )
		{
//    		return new soap_fault ( 'Scielo_WS_Server','','Client must supply a valid PID.' );
    		return new soap_fault ( 'Scielo_WS_Server','Client must supply a valid PID.' );
	    }

		//$parameters = array ( "pid" => $pid, "lng" => $lang, "tlng" => $tlng ,"database" => "artigo","search=IV" => '$');
        $parameters = array ( "database" => "artigo","search=IV" => $pid.'$');
        
        if ( $ws_oai )
        {
            $parameters[ "ws" ] = "true";
        }

		$result = $scielo_xml->getXML ( "sci_xmloutput", $parameters, $debug );

		if ( $error = $scielo_xml->getError () )
		{
//			return new soap_fault ( "Scielo_WS_Server", "", $error );
			return new soap_fault ( "Scielo_WS_Server", $error );
		}

		return $result;
	}

	function getArticle ( $pid, $lang = "en", $tlng = "en", $debug = false )
	{
		global $scielo_xml, $server;

		if ( $pid == "" )
		{
//    		return new soap_fault ( 'Scielo_WS_Server','','Client must supply a valid PID.' );
    		return new soap_fault ( 'Scielo_WS_Server','Client must supply a valid PID.' );
	    }

		$parameters = array ( "pid" => $pid, "lng" => $lang, "tlng" => $tlng );

		$result = $scielo_xml->getXML ( "sci_arttext", $parameters, $debug );

		if ( $error = $scielo_xml->getError () )
		{
//			return new soap_fault ( "Scielo_WS_Server", "", $error );
			return new soap_fault ( "Scielo_WS_Server", $error );
		}

		return $result;
	}
    
    /* A função abaixo serve para limitar o tamanho das subexpressões da expressão de busca em 
      30 caracteres, caso a subexpressão apareça entre aspas. Isto contorna um bug no wxis 4.01r1
      que deve ser usado com o scielo.
    */
    function limitSearchSubexprLength ( $search )
    {
        if ( preg_match_all ( '/"([^"]+)"/i', $search, $matches, PREG_SET_ORDER ) )
        {
            for ( $i = 0; $i < count ( $matches ); $i++ )
            {            
                if ( strlen ( $matches[ $i ][ 1 ] ) > 30 )
                {
                    $trunc = '"' . substr ( $matches[ $i ][ 1 ], 0, 30 ) . '"';

                    $search = str_replace ( '"' . $matches[ $i ][ 1 ] . '"', $trunc, $search );
                }
            }
        }
        
        return $search;
    }

	function getArticlesAuthor ( $search, $lang = "en", $debug = false )
	{
		global $scielo_xml, $server;

		if ( $search == "" )
		{
//    		return new soap_fault ( 'Scielo_WS_Server','','Client must supply a valid search expression.' );
    		return new soap_fault ( 'Scielo_WS_Server','Client must supply a valid search expression.' );
	    }

		$search = stripslashes ( str_replace ( " ", "+", $search ) );
        
        $search = limitSearchSubexprLength ( $search );

		$parameters = array ( "search" => $search, "lng" => $lang );

		$result = $scielo_xml->getXML ( "sci_search", $parameters, $debug );

		if ( $error = $scielo_xml->getError () )
		{
//			return new soap_fault ( "Scielo_WS_Server", "", $error );
			return new soap_fault ( "Scielo_WS_Server", $error );
		}

		return $result;
	}

    function listRecords ( $set = "", $from = "", $until = "", $control = "", $lang = "en", $nrm = "iso", $count = 30, $debug = false )
    {
		global $scielo_xml, $server;
    
        $parameters = array();
        
        if ( !empty ( $set ) ) $parameters[ "set" ] = $set;
        if ( !empty ( $from ) ) $parameters[ "from" ] = $from;
        if ( !empty ( $until ) ) $parameters[ "until" ] = $until;
        if ( !empty ( $control ) ) $parameters[ "resume" ] = $control;
        $parameters[ "lng" ] = $lang;
        $parameters[ "nrm" ] = $nrm;
        $parameters[ "count" ] = $count;
		$result = $scielo_xml->getXML ( "sci_listrecords", $parameters, $debug );
		if ( $error = $scielo_xml->getError () )
		{
//			return new soap_fault ( "Scielo_WS_Server", "", $error );
			return new soap_fault ( "Scielo_WS_Server", $error );
		}

		return $result;
    }
	
	function listRecordsAgris ( $set = "", $from = "", $until = "", $control = "", $lang = "en", $nrm = "iso", $count = 30, $debug = false )
    {
		global $scielo_xml, $server;
    
        $parameters = array();
        
        if ( !empty ( $set ) ) $parameters[ "set" ] = $set;
        if ( !empty ( $from ) ) $parameters[ "from" ] = $from;
        if ( !empty ( $until ) ) $parameters[ "until" ] = $until;
        if ( !empty ( $control ) ) $parameters[ "resume" ] = $control;
        $parameters[ "lng" ] = $lang;
        $parameters[ "nrm" ] = $nrm;
        $parameters[ "count" ] = $count;
		$result = $scielo_xml->getXML ( "sci_listrecords_agris", $parameters, $debug );
		if ( $error = $scielo_xml->getError () )
		{
//			return new soap_fault ( "Scielo_WS_Server", "", $error );
			return new soap_fault ( "Scielo_WS_Server", $error );
		}

		return $result;
    }
	/*function listRecordsAgris ( $set = "", $from = "", $until = "", $control = "", $lang = "en", $nrm = "iso", $count = 30, $debug = false )
    {
		global $scielo_xml, $server;
    
        $parameters = array();
        
        //if ( !empty ( $set ) ) $parameters[ "set" ] = $set;
        if ( !empty ( $from ) ) $parameters[ "from" ] = $from;
        if ( !empty ( $until ) ) $parameters[ "until" ] = $until;
        if ( !empty ( $control ) ) $parameters[ "resume" ] = $control;
        ///$parameters[ "lng" ] = $lang;
        //$parameters[ "nrm" ] = $nrm;
        $parameters[ "count" ] = $count;
		$parameters[ "database" ] = 'artigo';
		$parameters[ "search" ] = 'HR=S'.$set.'$'; 
		
		
		
		$result = $scielo_xml->getXML ( "sci_listrecords_agris", $parameters, $debug );

		if ( $error = $scielo_xml->getError () )
		{
//			return new soap_fault ( "Scielo_WS_Server", "", $error );
			return new soap_fault ( "Scielo_WS_Server", $error );
		}

		return $result;
    }*/
	/*********************************** MAIN CODE *****************************************/

	if ( isset ( $_SERVER ) && !isset ( $DOCUMENT_ROOT ) )
	{
		$DOCUMENT_ROOT = $_SERVER[ "DOCUMENT_ROOT" ];
	}
    
    $DOCUMENT_ROOT = trim ( $DOCUMENT_ROOT );
    
    $dirChar = ( strpos ( $DOCUMENT_ROOT, "\\" ) === false ) ? "/" : "\\";

    if ( substr ( $DOCUMENT_ROOT, -1 ) == $dirChar )
    {
	    $deffile = $DOCUMENT_ROOT . DEFNAME;
    }
    else
    {
	    $deffile = $DOCUMENT_ROOT . $dirChar . DEFNAME;
    }

	$scielo_xml = new Scielo_XML ( $deffile );

?>