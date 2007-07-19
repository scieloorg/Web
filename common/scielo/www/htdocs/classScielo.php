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
		$this->_special_xsl = '';
	}

	function GenerateIsisScriptUrl()
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
		$url .= "&" . $this->_request->getQueryString ();
		return $url;
	}
		
	function GenerateXmlUrl()
	{
    	$this->_IsisScriptUrl = $this->GenerateIsisScriptUrl();

		$xmlFromIsisScript = wxis_exe($this->_IsisScriptUrl); 


		$this->_request->getRequestValue("pid", $pid);
		$this->_request->getRequestValue("t", $textLang);
		$this->_request->getRequestValue("file", $xmlFile);

		
		if ($this->_script == 'sci_arttext' || $this->_script == 'sci_abstract' ){
			$server = $this->_def->getKeyValue("SERVER_SCIELO");
			$services = $this->_def->getSection("FULLTEXT_SERVICES");
			$services_xml = array();
			foreach ($services as $id=>$service){
				$service = str_replace('PARAM_PID', $pid, $service);
				$service = str_replace('PARAM_SERVER', $server, $service);
				$service = str_replace('CURRENT_URL', urlencode("http://".$_SERVER['SERVER_NAME'].$_SERVER['REQUEST_URI']), $service);
				//$services_xml[count($services_xml)] = $this->callService($service, $id);
				$services_xml[count($services_xml)] = $this->getURLService($service, $id);
			}
			if (count($services_xml)>0){
				$xmlList[] = $this->XML_XSL->concatXML($services_xml, "fulltext-service-list");
			}

			require_once("classes/XMLFromIsisScript.php"); 
			$xmlIsisScript = new XMLFromIsisScript($xmlFromIsisScript);
			$xmlFromIsisScript = $xmlIsisScript->getXml();
			$this->_special_xsl = $xmlIsisScript->getSpecialXSL();
		}

		$xmlList[] = $xmlFromIsisScript;

		
		$xmlScieloOrg = '';
		if (strpos($this->_IsisScriptUrl, 'script=sci_verify')==false){
			$elements = array(
				//adicionando o dominio do Site Regional...
				"SCIELO_REGIONAL_DOMAIN"=> "SCIELO_REGIONAL_DOMAIN",
				//exibir o toolbox ?
				"toolbox"=>"show_toolbox",
				//exibir o link Requests ?
				"requests" => "show_requests", 	
				//exibir as Referencias do Artigo
				"show_article_references" => "show_article_references", 
				//path para o script de login
				"loginURL" => "login_url",
				//path para o script de logout
				"logoutURL" => "logout_url",
				//Exibe ou não a opção de Login
				"show_login" => "show_login",
				//Exibe ou não a opção de Envio de Artigo por email
				"show_send_by_email" => "show_send_by_email",
				//Exibe ou não a opção de Citados Em Scielo
				"show_cited_scielo" => "show_cited_scielo",
				//Exibe ou não a opção de Citados em Google
				"show_cited_google" => "show_cited_google",

				//Exibe ou não a opção de Similares em Scielo
				"show_similar_in_scielo" => "show_similar_in_scielo",

				//Exibe ou não a opção de Similares em Google
				"show_similar_in_google" => "show_similar_in_google",

				//Informa data de corte para processamento do Google Schoolar
				"google_last_process" => "google_last_process"
			);


			foreach ($elements as $k => $v) {
				$xmlScieloOrg .= "<$k>" . $this->_def->getKeyValue($v) . "</$k>";				
			}
			$xmlScieloOrg .=  $this->userInfo();			
			$xmlScieloOrg = "<varScieloOrg>".$xmlScieloOrg."</varScieloOrg>";

		}
		if (count($xmlList)>1){
			$xml = $this->XML_XSL->concatXML($xmlList, "root");
		} else {
			$xml = $this->XML_XSL->insertProcessingInstruction($xmlList[0]);
		}

		$xml = str_replace("<CONTROLINFO>","<CONTROLINFO>".$xmlScieloOrg,$xml);

		return $xml;
	}

	function GenerateXslUrl()
	{
		$xsl = $this->_def->getKeyValue("PATH_XSL");
		$xsl = $xsl . $this->_script.$this->_special_xsl.".xsl";

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
