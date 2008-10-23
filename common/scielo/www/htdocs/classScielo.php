<?php
include("classScieloBase.php");
require_once("classes/XML_XSL/XML_XSL.inc.php"); // 200603
require_once("applications/scielo-org/classes/wpBlogDAO.php");//200801
class Scielo extends ScieloBase
{
	var	$XML_XSL; // 200603

	function Scielo ($host)
	{
		$this->XML_XSL = new XSL_XML();
		$this->ScieloBase ($host);
		$this->_special_xsl = '';
	}

	function loadPreviousUrlWhichContainsOldPid(){
		$this->_request->getRequestValue("pid", $pid);
		if (strpos($pid,'(')>0){
			$this->_request->getRequestValue("script", $script);
			switch ($script){
				case "sci_arttext": $oldscript = "fbtext"; break;
				case "sci_serial": $oldscript = "fbsite"; break;
				case "sci_abstract": $oldscript = "fbabs"; break;
			}
			header('Location: /cgi-bin/fbpe/'.$oldscript.'?pid='.$pid);
		}
	}
	function GenerateIsisScriptUrl()
	{

		$this->_request->getRequestValue ("lng", $lng);
		$this->_request->getRequestValue ("nrm", $nrm);

    	$url  = "http://";
		$url .= $this->_def->getKeyValue("SERVER_SCIELO");
		$url .= $this->_def->getKeyValue("PATH_WXIS_SCIELO");
		$url .= $this->_def->getKeyValue("PATH_DATA");
		$url .= "?IsisScript=";
		$url .= $this->_def->getKeyValue("PATH_SCRIPTS");
		$url .= "$this->_script.xis";
		$url .= "&def=$this->_deffile";
		if ( !$lng || ($lng=='') ) $url .= "&lng=" . $this->_def->getKeyValue("STANDARD_LANG");
        if ( !$nrm || ($nrm=='') ) $url .= "&nrm=iso";
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

		/*
		*Resgatando o valor de siglum
		*/

		$str1 = strpos($xmlFromIsisScript,"<SIGLUM>");
		$str2 = strpos($xmlFromIsisScript,"</SIGLUM>");
		$strResultSiglum = substr($xmlFromIsisScript,$str1+8,($str2-$str1)-8);
		
		/*
		 * Validando o site do scimago
		 */
		
		if( $_REQUEST['script']=='sci_serial'){
			$issn = $_REQUEST['pid'];
			$issn = str_replace("-","",$issn);

			$url = "http://www.scimagojr.com/journalsearch.php?q=".$issn."&amp;tip=iss&amp;exact=yes";

			$handle = fopen($url,'r');

		}
		
		$this->_request->getRequestValue("pid", $pid);
		$this->_request->getRequestValue("t", $textLang);
		$this->_request->getRequestValue("file", $xmlFile);

		/*
		*Resgatando o count do comment e verificando o comment
		*/

		$show_comments = $this->_def->getKeyValue("show_comments");
		
		if($show_comments != 0){
			$xml_comments = file_get_contents("xml/allow_comment.xml");
			$issn_comments = substr($_REQUEST["pid"],1,9);
			$flag=0;
			if (strpos($xml_comments,$issn_comments)){
				$flag = 1;
			}

			if($flag == 1){			
				if($this->_script == 'sci_arttext' || $this->_script == 'sci_abstract'){
					
					$BlogDAO = new wpBlogDAO();
					$commentCount = $BlogDAO->getCountCommentByPid($pid,$strResultSiglum);
					$BlogDAO->fechaConexao();
				}
			}
		}

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
				//Exibe ou nï¿½o a opï¿½ï¿½o de Login
				"show_login" => "show_login",				
				//Exibe a servico de tradução windows live translations
				"show_article_wltranslation" => "show_article_wltranslation",				
				//Exibe ou nï¿½o a opï¿½ï¿½o de Envio de Artigo por email
				"show_send_by_email" => "show_send_by_email",
				//Exibe ou nï¿½o a opï¿½ï¿½o de Citados Em Scielo
				"show_cited_scielo" => "show_cited_scielo",
				//Exibe ou nï¿½o a opï¿½ï¿½o de Citados em Google
				"show_cited_google" => "show_cited_google",
				//Exibe ou nï¿½o a opï¿½ï¿½o de Similares em Scielo
				"show_similar_in_scielo" => "show_similar_in_scielo",
				//Exibe ou nï¿½o a opï¿½ï¿½o de Similares em Google
				"show_similar_in_google" => "show_similar_in_google",
				//Informa data de corte para processamento do Google Schoolar
				"google_last_process" => "google_last_process",
				//Exibe ou nï¿½o a opï¿½ï¿½o de Comments em Scielo
				"services_comments" => "show_comments",
				//Serviï¿½o do DATASUS
				"show_datasus" => "show_datasus",
				"MIMETEX" => "mimetex",
				"SCRIPT_TOP_TEN" => "SCRIPT_TOP_TEN",
				"SCRIPT_ARTICLES_PER_MONTH" => "SCRIPT_ARTICLES_PER_MONTH",
				//Habilita ou nï¿½o o log dos servicos
				"services_log" => "ENABLE_SERVICES_LOG",
				"show_scimago" => "show_scimago",
                "show_semantic_hl" => "show_semantic_hl",
				"show_fapesp_projects" => "show_fapesp_projects"
			);
				//die($commentCount);

			foreach ($elements as $k => $v) {
				$xmlScieloOrg .= "<$k>" . $this->_def->getKeyValue($v) . "</$k>";
			}
			$xmlScieloOrg .=  $this->userInfo();
			if($handle == false){
				$xmlScieloOrg.= "<scimago_status>offline</scimago_status>";
			}else{
				$xmlScieloOrg.= "<scimago_status>online</scimago_status>";
				
			}
			$xmlScieloOrg.="<commentCount>".$commentCount."</commentCount>";
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
		$result = "<USERINFO id=\"".$userID."\" status=\"".$userStatus."\">".utf8_encode($name)."</USERINFO>";
		return($result);
 	}

	// fixed 20041004 - gravaï¿½ï¿½o de html a cada requisiï¿½ï¿½o
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
