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
    function GenerateXmlUrl($script,$dti,$dtf,$access,$cpage,$nlines,$pid,$lng,$nrm,$order,$tpages,$maccess)
	{
  

	$server=$this->_def->getKeyValue("SERVER_SCIELO");
	$lang=$this->_def->getKeyValue("STANDARD_LANG");
	$app=$this->_def->getKeyValue("APP_NAME");
	$server=$this->_def->getKeyValue("SERVER_SCIELO");
	$path_wxis=$this->_def->getKeyValue("PATH_WXIS_SCIELO");
	$path_cgi=$this->_def->getKeyValue("PATH_CGI_BIN_IAH_SCIELO");
	$path_data=$this->_def->getKeyValue("PATH_DATA");
	$path_script=$this->_def->getKeyValue("PATH_SCRIPTS");
	$path_serial_html=$this->_def->getKeyValue("PATH_SERIAL_HTML");
	$path_xsl=$this->_def->getKeyValue("PATH_XSL");
	$path_genimg=$this->_def->getKeyValue("PATH_GENIMG");
	$path_serimg=$this->_def->getKeyValue("PATH_SERIMG");
	$path_data_iah=$this->_def->getKeyValue("PATH_DATA_IAH_SCIELO");
	$path_cgi_iah=$this->_def->getKeyValue("PATH_CGI_BIN_IAH_SCIELO");
	$serverlog=$this->_def->getKeyValue("SERVER_LOG");
	$scriptlog=$this->_def->getKeyValue("SCRIPT_LOG_NAME");
	$script_log_run=$this->_def->getKeyValue("SCRIPT_LOG_RUN");
	$contact=$this->_def->getKeyValue("E_MAIL");
	$owner=$this->_def->getKeyValue("SHORT_NAME");
	
	$control="<CONTROLINFO>\n";
	$control.="<LANGUAGE>$lang</LANGUAGE>\n";
	$control.="<STANDARD>iso</STANDARD>\n";
	$control.="<PAGE_NAME>$script</PAGE_NAME>\n";
	$control.="<PAGE_PID>$pid</PAGE_PID>\n";
	$control.="<APP_NAME>$app</APP_NAME>\n";
	$control.="<ENABLE_STAT_LINK>1</ENABLE_STAT_LINK>\n";
	$control.="<ENABLE_CIT_REP_LINK>1</ENABLE_CIT_REP_LINK>\n";
 	$control.="<SCIELO_INFO>\n";
	$control.="<SERVER>$server</SERVER>\n";
	$control.="<PATH_WXIS>$path_wxis</PATH_WXIS>\n";
	$control.="<PATH_CGI-BIN>$path_cgi</PATH_CGI-BIN>\n";
	$control.="<PATH_DATA>/</PATH_DATA>";
	$control.="<PATH_DATA>$path_data</PATH_DATA>\n";
	$control.="<PATH_SCRIPTS>$path_script/</PATH_SCRIPTS>\n";
	$control.="<PATH_SERIAL_HTML>$path_serial_html</PATH_SERIAL_HTML>\n";
	$control.="<PATH_XSL>$path_xsl</PATH_XSL>\n";
	$control.="<PATH_GENIMG>$path_genimg</PATH_GENIMG>\n";
	$control.="<PATH_SERIMG>$path_serimg</PATH_SERIMG>\n";
	$control.="<PATH_DATA_IAH>$path_data_iah</PATH_DATA_IAH>\n";
	$control.="<PATH_CGI_IAH>$path_cgi_iah</PATH_CGI_IAH>\n";
	$control.="<SERVER_LOG>$serverlog</SERVER_LOG>\n";
	$control.="<SCRIPT_LOG_NAME>$scriptlog</SCRIPT_LOG_NAME>\n";
	$control.="<SCRIPT_LOG_RUN>$script_log_run</SCRIPT_LOG_RUN>\n";
	$control.="</SCIELO_INFO>\n";
	$control.="</CONTROLINFO>\n";
	$control.="<COPYRIGHT YEAR=\"2004\">\n";
    $control.="<OWNER>$owner</OWNER>\n";
    $control.="<CONTACT>$contact</CONTACT>\n";
	$control.="</COPYRIGHT>\n";
	
	$xml="";
	$xml.="<?xml version=\"1.0\" encoding=\"iso-8859-1\"?>\n";
	if ($script=='sci_journalstat') {
	   $xml.="<JOURNALSTAT>\n"; 
	} elseif ($script=='sci_statiss') {
		$xml.="<STATISTICS>\n"; 
	} elseif ($script=='sci_statart') {
		$xml.="<STATISTICS>\n"; 
	} 
	
	$table = "";
    $filesize=90000;
	if (strpos($script_log_run,'?')>0) {
		$execute = $script_log_run."&script=";
	} else {
		$execute = $script_log_run."/?script=";
	}
	$url_xml="http://".$serverlog."/".$execute.$script."&pid=".$pid."&lng=".$lng."&nrm=".$nrm."&order=".$order."&dtf=".$dtf."&dti=".$dti."&access=".$access."&cpage=".$cpage."&nlines=".$nlines;
//$url_xml="http://".$serverlog."/".$script_log_run."/?script=".$script."&pid=".$pid."&lng=".$lng."&nrm=".$nrm."&order=".$order."&dtf=".$dtf."&dti=".$dti."&access=".$access."&cpage=".$cpage."&nlines=".$nlines;
	$fp2=fopen($url_xml, "r");
		while(!feof($fp2)) {
	   		$table.=fread ($fp2, $filesize);
		}
	fclose ($fp2); 
	
	$xml.=$control;
	$xml.=$table;
	
	if ($script=='sci_journalstat') {
	   $xml.="</JOURNALSTAT>\n"; 
	} elseif ($script=='sci_statiss') {
		$xml.="</STATISTICS>\n"; 
	} elseif ($script=='sci_statart') {
		$xml.="</STATISTICS>\n"; 
	} 
	
	//echo ("<textarea cols=\"60\" rows=\"30\" name=\"area\">$xml</textarea>");
	//die($xml);
	return trim($xml);
	
	}	
	
	function ShowPage ($script,$dti,$dtf,$access,$cpage,$nlines,$pid,$lng,$nrm,$order,$tpages,$maccess)
	{

		$logCachePath =$this->_def->getKeyValue("PATH_LOG_CACHE");

		$html="";
	    $filesize=90000;
		if ($logCachePath) {
			$pag_cache=$logCachePath.$script.$pid.$lng.$nrm.$order.$dtf.$dti.$access.$cpage.$nlines.".html";
		}

	   	$this->_CheckAlternateDisplay ();
		$html=$this->_Transform ();

		$out=fopen($pag_cache, "w");
		fwrite($out, $html);
		echo '<!--' .$pag_cache.'--> ';
        echo $html;
	}
}
?>
