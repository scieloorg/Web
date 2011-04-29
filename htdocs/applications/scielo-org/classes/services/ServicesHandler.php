<?php
	ini_set("display_errors","1");
	error_reporting(E_ALL ^ E_NOTICE);
	class ServicesHandler {
	var $xml, $ini, $serviceURL, $aditionalPath, $params, $serviceDomain;

		function ServicesHandler(){
			$ini = parse_ini_file(dirname(__FILE__)."/../../scielo.def.php",true);
			$this->setServiceDomain($ini['trigrama_server']['server']);
		}

		function getServiceDomain(){
			return $this->serviceDomain;
		}

		function setServiceDomain($value){
			$this->serviceDomain = $value;
		}

		function getAditionalPath(){
			return $this->aditionalPath;
		}

		function setAditionalPath($value){
			$this->aditionalPath = $value;
		}

		function getParams(){
			return $this->params;
		}

		function addParam($name,$content){
			if ($this->params != ""){
				$this->params .= '&'.urlencode($name).'='.urlencode($content);
			}else{
				$this->params .= '?'.urlencode($name).'='.urlencode($content);
			}
		}

		function setServiceURL(){
			$this->serviceURL = $this->getServiceDomain().$this->getAditionalPath().$this->getParams();
		}
	
		function getServiceURL(){
			return $this->serviceURL;
		}
		
		function setXML(){
			$this->setServiceUrl();
			$xml = file_get_contents($this->getServiceURL());
			$this->xml = $xml;
		}

		function getXML(){
			return $this->xml;
		}
	}
?>
