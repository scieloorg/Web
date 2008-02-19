<?php 

	require_once(dirname(__FILE__)."/Service.php");
	require_once(dirname(__FILE__)."/ArticleServicesResult.php");

	class ArticleService extends Service {
		function ArticleService($serverDomain, $dataDomain=''){
			if (!$dataDomain){
				$dataDomain = $serverDomain;
			}
			if (!$serverDomain){
				echo "Desenvolvedor: Missing serverDomain parameter in ArticleService Constructor";
			}
			if (!$dataDomain){
				echo "Desenvolvedor: Missing dataDomain parameter in ArticleService Constructor";
			}
			$this->Service('article_metadata');
			if (strpos(' '.$serverDomain, 'http://')==0) {
				$serverDomain = 'http://'.$serverDomain;
			}
			$this->domain = $serverDomain;
			$this->dataDomain = $dataDomain;
			$this->setCall($serverDomain.'/cgi-bin/wxis.exe/');
			$this->setParam('IsisScript', 'ScieloXML/sci_artmetadata.xis');
			$this->setParam('def', 'scielo.def.php');
		}
		function setParams($pid){
			$this->setParam('pid', $pid);
		}
		function getArticle(){
			if ($this->getParam('pid')){
				Service::callService(Service::buildCall());
				
				$result = new ArticleServicesResult(Service::getResultInXML());
				$article = $result->getArticle();
				$article->setPID($this->getParam('pid'));
				$article->setURL($this->dataDomain);
			} else {
				die("Missing call the method setParams of ArticleService");
			}
			return $article;
		}
		
	}
?>