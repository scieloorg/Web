<?php 

	require_once(dirname(__FILE__)."/../XML_XSL/XML_XSL.inc.php"); // 200603
	require_once(dirname(__FILE__)."/ServiceResult.php");
	
	$XML_XSL = new XSL_XML();

	class Service {
		function Service($name){
			$this->_serviceName = $name;
		}
		function setParam($name, $value){
			$this->_param[$name] = $value;
		}	
		function getParam($name){
			return $this->_param[$name];
		}	
		function setCall($call){
			$this->_call = $call;
		}
		function getCall(){
			return $this->_call;
		}
		function setResultInXML($call){
			$this->_callResult = $call;
		}
		function getResultInXML(){
			return $this->_callResult;
		}
		function callService($url){
			$fp = fopen ($url,"r");
			print '<!--'.$url.'-->';
			if ($fp) { 
				$xml = "";
				do {
					$data = fread($fp, 1024);
					if (strlen($data) == 0) {
						break;
					}
					$xml .= $data;
				} while(true);
				fclose ($fp);
			}
			if ($this->_serviceName){
				//$xml = $XML_XSL->insertElement($xml, "service", 'id="'.$this->_serviceName.'"');
			}
			$this->setResultInXML($xml);
		}
		function buildCall(){
			$call = $this->getCall().'?';
			foreach ($this->_param as $k=>$param){
				$call.= $k.'='.$param.'&';
			}
			return $call;
		}
	}
	
?>
