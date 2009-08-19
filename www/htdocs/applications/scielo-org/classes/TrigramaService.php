<?php
	require_once(dirname(__FILE__)."/Service.php");
	require_once(dirname(__FILE__)."/TrigramaServiceResult.php");
	require_once(dirname(__FILE__)."/../XML_XSL/XML_XSL.inc.php");
	require_once(dirname(__FILE__)."/../XML_XSL/xslt.inc.php");
	
	class TrigramaService extends Service {
		function TrigramaService(){
			$f = dirname(__FILE__);
			$this->ini = parse_ini_file($f."/../../scielo.def.php",true);

			$this->Service('profile_article');
			$this->setParam('port', '1718');
			$this->setParam('cipar', 'similar/serw.cip');
			$this->setParam('wtrig2', 'on');
			$this->setParam('c', '');

			$this->setParam('maxrel', '30');
			$this->setParam('minsim', '0.30');
		}
		function setParams($text){
			$this->setParam('text', urlencode($text));
			$this->setParam('show', 'id');
		}
		function getArticles(){
			$array = $this->ini['collections'];
			foreach ($array as $name=>$collection){
				$this->setCall($this->ini['trigrama_server'][$name].'/cgi-bin/serx');
				$this->setParam('c', $this->ini['trigrama_parameter'][$name]);
				Service::callService(Service::buildCall());
				$xml[] = Service::getResultInXML();
			}
			$XML_XSL = new XSL_XML();
			$result = new TrigramaServiceResult($XML_XSL->concatXML($xml));
			$articles = $result->getArticles();

			return $articles;
		}
	}
?>
