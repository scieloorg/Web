<?php

include("classScieloBase.php");

class Scielo extends ScieloBase
{
	function Scielo ($host)
	{
		$this->ScieloBase ($host);
	}

	function GenerateXmlUrl()
	{
    	$xml  = "http://";
		$xml .= $this->_def->getKeyValue("SERVER_SCIELO");
		$xml .= $this->_def->getKeyValue("PATH_WXIS_SCIELO");
		$xml .= $this->_def->getKeyValue("PATH_DATA");
		$xml .= "?IsisScript=";
		$xml .= $this->_def->getKeyValue("PATH_SCRIPTS");
		$xml .= "$this->_script.xis";
		$xml .= "&def=$this->_deffile";
        if ( !$this->_request->getRequestValue ("lng", $lng) ) $xml .= "&lng=" . $this->_def->getKeyValue("STANDARD_LANG");
        if ( !$this->_request->getRequestValue ("nrm", $nrm) ) $xml .= "&nrm=iso";
        if ( $this->_script == $this->_homepg && 
             !empty ( $this->_param ) && 
             !$this->_request->getQueryString () )
        {
            $xml .= $this->_param;
        }
		$xml .= "&sln=" . strtolower ( $this->_def->getKeyValue("STANDARD_LANG") );
        $xml .= "&" . $this->_request->getQueryString ();

		return $xml;
	}

	function GenerateXslUrl()
	{
		$xsl = $this->_def->getKeyValue("PATH_XSL");
		$xsl = $xsl . "$this->_script.xsl";

		return $xsl;
	}
}

?>