<?php

include("classScieloBase.php");
require_once("classes/XML_XSL/XML_XSL.inc.php"); // 200603
class Scielo extends ScieloBase
{
	var	$XML_XSL; // 200603


	function Scielo ($host)
	{
		$this->XML_XSL = new XSL_XML();
		$this->ScieloBase ($host);
	}

	function GenerateXmlUrl()
	{

    	$url  = "http://";
		$url .= $this->_def->getKeyValue("SERVER_SCIELO");
		$url .= $this->_def->getKeyValue("PATH_WXIS_SCIELO");
		$url .= $this->_def->getKeyValue("PATH_DATA");
		$url .= "?IsisScript=";
		$url .= $this->_def->getKeyValue("PATH_SCRIPTS");
		$url .= "$this->_script.xis";
		$url .= "&def=$this->_deffile";
        if ( !$this->_request->getRequestValue ("lng", $lng) ) $url .= "&lng=" . $this->_def->getKeyValue("STANDARD_LANG");
        if ( !$this->_request->getRequestValue ("nrm", $nrm) ) $url .= "&nrm=iso";
        if ( $this->_script == $this->_homepg && 
             !empty ( $this->_param ) && 
             !$this->_request->getQueryString () )
        {
            $url .= $this->_param;
        }
		$url .= "&sln=" . strtolower ( $this->_def->getKeyValue("STANDARD_LANG") );

		$this->_request->getRequestValue("pid", $pid);
		$this->_request->getRequestValue("t", $textLang);
		$this->_request->getRequestValue("file", $xmlFile);

		// 200603
		if ($this->_script == 'sci_arttext' || $this->_script == 'sci_abstract' ){
			$server = $this->_def->getKeyValue("SERVER_SCIELO");

			$services = $this->_def->getSection("FULLTEXT_SERVICES");
			foreach ($services as $id=>$service){
				$service = str_replace('PARAM_PID', $pid, $service);
				$service = str_replace('PARAM_SERVER', $serverOriginal, $service);
				$service = str_replace('CURRENT_URL', urlencode($currentURL), $service);
				//$services_xml[count($services_xml)] = $this->callService($service, $id);
				$services_xml[count($services_xml)] = $this->getURLService($service, $id);
			}
			if (count($services_xml)>0){
				$xmlList[] = $this->XML_XSL->concatXML($services_xml, "fulltext-service-list");
			}
		}
		// 200603
		$url .= "&" . $this->_request->getQueryString ();

		$xmlList[] = wxis_exe($url); // 200603
//adicionando o dominio do Site Regional...

	if (strpos($url,'debug=')==false && strpos($url, 'script=sci_verify')==false){

		$xmlScieloOrg = "<SCIELO_REGIONAL_DOMAIN>" . $this->_def->getKeyValue("SCIELO_REGIONAL_DOMAIN") . "</SCIELO_REGIONAL_DOMAIN>";

//exibir ou não a toolbox ?
		$xmlScieloOrg .= "<toolbox>".$this->_def->getKeyValue("show_toolbox")."</toolbox>";

//exibir o link Requests ?
		$xmlScieloOrg .= "<requests>".$this->_def->getKeyValue("show_requests")."</requests>";

//path para o script de login
		$xmlScieloOrg .= "<loginURL>".$this->_def->getKeyValue("login_url")."</loginURL>";

//path para o script de logout
		$xmlScieloOrg .= "<logoutURL>".$this->_def->getKeyValue("logout_url")."</logoutURL>";

		$xmlScieloOrg .=  $this->userInfo();
		
		$xmlScieloOrg = "<varScieloOrg>".$xmlScieloOrg."</varScieloOrg>";

		if (count($xmlList)>1){
			$xml = $this->XML_XSL->concatXML($xmlList, "root");
		} else {
			$xml = $xmlList[0];
		}

		$xml = str_replace("<CONTROLINFO>","<CONTROLINFO>".$xmlScieloOrg,$xml);
	}
		return $xml;
	}

	function GenerateXslUrl()
	{
		$xsl = $this->_def->getKeyValue("PATH_XSL");
		$xsl = $xsl . "$this->_script.xsl";

		return $xsl;
	}

	function callService($url, $serviceName){
		$fp = fopen ($url,"r"); 

		if ($fp) { 
			$acumulado = "";
			while (!feof($fp)){
				$acumulado .= fgets($fp, 4096);
			}
			fclose($fp);
		}
		$acumulado = $this->XML_XSL->insertElement($acumulado, "fulltext-service", 'id="'.$serviceName.'"');

		return $acumulado;
	}
	
	function getURLService($url, $serviceName){
		$acumulado = '<url><![CDATA['.$url.']]></url>';
		$acumulado = $this->XML_XSL->insertElement($acumulado, "fulltext-service", 'id="'.$serviceName.'"');
		return $acumulado;
	}

	function userInfo()
	{
		if(isset($_COOKIE['userID']) && (intval($_COOKIE['userID']) > 0))
		{
			$userStatus = "login";
			$name = trim($_COOKIE['firstName']." ".$_COOKIE['lastName']);
			$userID = $_COOKIE['userID'];
		}
		else
		{
			$userStatus = "logout";
            $name = null;
			$userID = null;
		}
		$result = "<USERINFO id=\"".$userID."\" status=\"".$userStatus."\">".$name."</USERINFO>";
		return($result);
 	}
	
	// fixed 20041004 - gravação de html a cada requisição	
	function GetPageFile()
	{

		$test = $this->_request->getRequestValue("debug", $debug);
		if (!$debug){
			$test = $this->_request->getRequestValue("script", $script);
			$doit = (($script=='sci_issuetoc') || ($script=='xsci_issues') || ($script=='sci_arttext') );
			if ($doit){
		$root = $this->_def->getKeyValue("PATH_CACHE");
				
				$test = $this->_request->getRequestValue("pid", $pid);
				$dir = strtoupper($pid);
				if ($test) {
					$len = strlen($dir);
					switch ($len){
						case 9:
							//$dir = '';
							//$file = $dir;
							break;
						case 17:
							$file = '';
							$dir = substr($dir,0,9).'/'.substr($dir,9,8);
							break;
						case 23:
							$dir = substr($dir, 1);
							$file = substr($dir,17);
							$dir = substr($dir,0,9).'/'.substr($dir,9,8);
							break;
						default:
							$dir = '';
							$failure = true;
							break;
					}
				}
				$test = $this->_request->getRequestValue("lng", $lng);
				$test = $this->_request->getRequestValue("tlng", $tlng);
		
		
				if (!$failure){
					if ($dir){
						$filePath .= $dir.'/';
					}		
					if ($lng){
						$filePath .= $lng.'/';
					} else {
						$filePath .= 'nl/';
					}
					if (($script=='sci_arttext')|| ($script=='sci_abstract') || ($script=='sci_pdf')){
						if (!$tlng) $tlng = $lng;
						$filePath .= $tlng.'/';
					}
		
					if ($filePath){
						$filename = $root. $filePath. $script . $file. '.html';
					}
				}
			}
		}
		return $filename;
	}
}

?>