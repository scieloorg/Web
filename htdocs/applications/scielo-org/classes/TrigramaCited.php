<?
require_once(dirname(__FILE__)."/ServicesHandler.php");
	
class TrigramaCited extends ServicesHandler {

	function TrigramaCited() {
		$this->ServicesHandler();
		$this->setAditionalPath('/cgi-bin/mxlind/cgi=@cited');
	}
}
/*
http://trigramas.bireme.br/cgi-bin/mx/cgi=@1?xml=&maxrel=30&minsim=0.30&show=scielo1&text=sida&collection=SciELO.br.TiKwAb&
http://trigramas.bireme.br/cgi-bin/mxlind/cgi=@related?pid=S0009-67252002000100002
http://trigramas.bireme.br/cgi-bin/mxlind/cgi=@cited?pid=S0716-97602002000100011
*/
?>