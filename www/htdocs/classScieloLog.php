<?php
include("classScielo.php");

	// ------------------------------------------------------------------------------------------
	// --------------------------------   Defined Constants   -----------------------------------
	// ------------------------------------------------------------------------------------------

define ("NO_ORDER", 0);
define ("ORDER_TITLE", 1);
define ("ORDER_HOMEPG", 2);
define ("ORDER_ISSUETOC", 3);
define ("ORDER_ARTICLES", 4);
define ("ORDER_OTHER", 5);

	// ------------------------------------------------------------------------------------------
	// ----------------------------   ScieloLog class definition   ------------------------------
	// ------------------------------------------------------------------------------------------
    
class ScieloLog extends Scielo
{
	// ------------------------------------------------------------------------------------------
	// ------------------------------   Private Data Members   ----------------------------------
	// ------------------------------------------------------------------------------------------
    var $_order = NO_ORDER;       // Statistic order
        
	// ------------------------------------------------------------------------------------------
	// --------------------------------     Constructor     -------------------------------------
	// ------------------------------------------------------------------------------------------

    function ScieloLog ($host)
	{
		Scielo::Scielo ($host);
	}

	// ------------------------------------------------------------------------------------------
	// ----------------------------------   Private Methods   -----------------------------------
	// ------------------------------------------------------------------------------------------

	/***************************************************************************************
	    Private Method _GenerateSqlScriptUrl()	
	   
        Generate the mysql php script url
        	
		Parameters:
			NONE
	   
		Return Value: 
			url
	
		Last Change: 
			28/06/2001 (Roberto)
	***************************************************************************************/
    function _GenerateSqlScriptUrl()
    {
        $url  = "http://";
        $url .= $this->_def->getKeyValue("SERVER_SCIELO");
		$url .= $this->_def->getKeyValue("PATH_DATA");
		$url .= $this->_script . ".php";
        $url .= "?" . $this->_request->getQueryString();
        
// echo $url; exit;
        return $url;
    }
    
	/***************************************************************************************
	    Private Method _CallSqlQueryScript()	
	   
        Call the php script that queries the mysql database.
        	
		Parameters:
			NONE
	   
		Return Value: 
			Formatted response table from php script
	
		Last Change: 
			28/06/2001 (Roberto)
	***************************************************************************************/
    function _CallSqlQueryScript()
    {
        $buffer = "";
        $uri = $this->_GenerateSqlScriptUrl();

   		if($doc = new docReader($uri)) {
            $buffer = $doc->getString();
		} else {
			$this->setError("Could not open $uri");
            exit();
		}

        return $buffer;
    }
	
	// ------------------------------------------------------------------------------------------
	// ---------------------------------   Public Methods   -------------------------------------
	// ------------------------------------------------------------------------------------------

	/***************************************************************************************
	    Public Method GenerateXmlUrl()	
	   
        Overloads GenerateXmlUrl() method from base class Scielo
        	
		Parameters:
			NONE
	   
		Return Value: 
			xml url
	
		Last Change: 
			28/06/2001 (Roberto)
	***************************************************************************************/
    function GenerateXmlUrl()
	{
        $table = $this->_CallSqlQueryScript();
        
		$xml = Scielo::GenerateXmlUrl();
        $xml .= "&table=$table";        
        
		return $xml;
	}	
}

?>