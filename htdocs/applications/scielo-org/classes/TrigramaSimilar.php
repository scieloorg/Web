<?
ini_set("display_errors","1");
error_reporting(E_ALL ^ E_NOTICE);
require_once(dirname(__FILE__)."/ServicesHandler.php");
require_once(dirname(__FILE__)."/../XML_XSL/XML_XSL.inc.php");
require_once(dirname(__FILE__)."/../Article.php");
	
class TrigramaSimilar extends ServicesHandler {

	function TrigramaSimilar() {
		$this->ServicesHandler();
		$this->setAditionalPath('/cgi-bin/mx/cgi=@1');
		$this->addParam('xml','');
		$this->addParam('maxrel','30');
		$this->addParam('minsim','0.30');
		$this->addParam('show','scielo1');
	}

	function getXML()
	{
		$xml = $this->xml;
		$from = array('&quot;', '&lt;', '&gt;');
		$to = array('"', '<', '>');
		$xml = str_replace($from, $to, $xml);
		return $xml;
	}

	function getArticles() {
		$xml = $this->getXML();
		$XML_XSL = new XSL_XML();
		$content = $XML_XSL->xml_xsl($xml,dirname(__FILE__)."/../../xsl/similarToArray.xsl");
		$content = str_replace('<?xml version="1.0" encoding="ISO-8859-1"?>','',$content);
		$articles = split('\|SIMILAR_SPLIT\|',$content);
		$article = new Article();
		for ($i=0 ; $i < count($articles)-1 ; $i++){
			$articles[$i] = split('\|ITEM_SPLIT\|',$articles[$i]);
			if (trim($articles[$i][0]) != ''){
				$article->setPID(trim($articles[$i][0]));
				$article->setPublicationDate(trim($articles[$i][1]));
				$article->setRelevance(trim($articles[$i][2]));
				$article->setURL(trim($articles[$i][3]));
				$article->setTitle(trim($articles[$i][4]));
				$article->setSerial(trim($articles[$i][5]));
				$article->setVolume(trim($articles[$i][6]));
				$article->setNumber(trim($articles[$i][7]));
				$article->setYear(trim($articles[$i][8]));
				$article->setSuppl(trim($articles[$i][9]));
				$article->setAuthorXML(str_replace("\n","",trim($articles[$i][10])));
				$article->setKeywordXML(trim($articles[$i][11]));
				$arrArticles[$i] = $article;
			}
		}
//	die(print_r($arrArticles));
		return $arrArticles;
	}

}
/*
http://trigramas.bireme.br/cgi-bin/mx/cgi=@1?xml=&maxrel=30&minsim=0.30&show=scielo1&text=sida&collection=SciELO.br.TiKwAb&
http://trigramas.bireme.br/cgi-bin/mxlind/cgi=@related?pid=S0009-67252002000100002
http://trigramas.bireme.br/cgi-bin/mxlind/cgi=@cited?pid=S0716-97602002000100011
*/
?>