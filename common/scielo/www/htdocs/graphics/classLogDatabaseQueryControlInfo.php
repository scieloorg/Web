<?php
include ("classLogDatabaseQuery.php");

class LogDatabaseQueryControlInfo extends LogDatabaseQuery
{
	// ------------------------------------------------------------------------------------------
	// ------------------------------   Private Data Members   ----------------------------------
	// ------------------------------------------------------------------------------------------

    var $_script = "",
        $_lng = "",
        $_nrm = "iso";

	// ------------------------------------------------------------------------------------------
	// --------------------------------     Constructor     -------------------------------------
	// ------------------------------------------------------------------------------------------

    function LogDatabaseQueryArticleMonthYear ($deffile)
    {
        LogDatabaseQuery::LogDatabaseQuery ($deffile);
    }

	// ------------------------------------------------------------------------------------------
	// ----------------------------------   Private Methods   -----------------------------------
	// ------------------------------------------------------------------------------------------
        
    function _getControlInfoXML ()
    {
        if (!$this->_lng) $this->_lng = $this->_defFile->getVar("STANDARD_LANG");
        
        $response  = " <CONTROLINFO>\n";
        $response .= "  <LANGUAGE>$this->_lng</LANGUAGE>\n";
        $response .= "  <STANDARD>$this->_nrm</STANDARD>\n";
        $response .= "  <PAGE_NAME>$this->_script</PAGE_NAME>\n";
        $response .= "  <APP_NAME>" . $this->_defFile->getVar("APP_NAME") . "</APP_NAME>\n";
        $response .= "  <ENABLE_STAT_LINK>" . $this->_defFile->getVar("ENABLE_STATISTICS_LINK") . "</ENABLE_STAT_LINK>\n";
        $response .= "  <ENABLE_CIT_REP_LINK>" . $this->_defFile->getVar("ENABLE_CITATION_REPORTS_LINK") . "</ENABLE_CIT_REP_LINK>\n";
        $response .= "  <SCIELO_INFO>\n";
        $response .= "   <SERVER>" . $this->_defFile->getVar("SERVER_SCIELO") . "</SERVER>\n";
        $response .= "   <PATH_WXIS>" . $this->_defFile->getVar("PATH_WXIS_SCIELO") . "</PATH_WXIS>\n";
        $response .= "   <PATH_CGI-BIN>" . $this->_defFile->getVar("PATH_CGI-BIN") . "</PATH_CGI-BIN>\n";
        $response .= "   <PATH_DATA>" . $this->_defFile->getVar("PATH_DATA") . "</PATH_DATA>\n";
        $response .= "   <PATH_SCRIPTS>" . $this->_defFile->getVar("PATH_SCRIPTS") . "</PATH_SCRIPTS>\n";
        $response .= "   <PATH_SERIAL_HTML>" . $this->_defFile->getVar("PATH_SERIAL_HTML") . "</PATH_SERIAL_HTML>\n";
        $response .= "   <PATH_XSL>" . $this->_defFile->getVar("PATH_XSL") . "</PATH_XSL>\n";
        $response .= "   <PATH_GENIMG>" . $this->_defFile->getVar("PATH_GENIMG") . "</PATH_GENIMG>\n";
        $response .= "   <PATH_SERIMG>" . $this->_defFile->getVar("PATH_SERIMG") . "</PATH_SERIMG>\n";
        $response .= "   <PATH_DATA_IAH>" . $this->_defFile->getVar("PATH_DATA_IAH_SCIELO") . "</PATH_DATA_IAH>\n";
        $response .= "   <PATH_CGI_IAH>" . $this->_defFile->getVar("PATH_CGI_BIN_IAH_SCIELO") . "</PATH_CGI_IAH>\n";
        $response .= "  </SCIELO_INFO>\n";
        $response .= " </CONTROLINFO>\n";

        return $response;
    }
   
    function _createCopyrightInfoXML ()
    {
        $year = date("Y");
        $owner = $this->_defFile->getVar("SHORT_NAME");
        $contact = $this->_defFile->getVar("E_MAIL");
        
	    $response  = " <COPYRIGHT YEAR=\"$year\">\n";
  		$response .= "  <OWNER>$owner</OWNER>\n";
  		$response .= "  <CONTACT>$contact</CONTACT>\n";
 	    $response .= " </COPYRIGHT>\n";
        
        return $response;
    }   
	    
	// ------------------------------------------------------------------------------------------
	// --------------------   Public Acessor Methods (Get/Set Properties) -----------------------
	// ------------------------------------------------------------------------------------------   
     
    function SetScriptName ($script)
    {
        if ($script)
        {
            $this->_script = $script; 
        }
    }

    function GetScriptName ()
    {
        return $this->_script;
    }
    
    function SetInterfaceLanguage ($lng)
    {
        if ($lng)
        {
            $this->_lng = $lng; 
        }
    }

    function GetInterfaceLanguage ()
    {
        return $this->_lng;
    }

    function SetStandard ($nrm)
    {
        if ($nrm)
        {
            $this->_nrm = $nrm; 
        }
    }

    function GetStandard ()
    {
        return $this->_nrm;
    }    
}    
?>