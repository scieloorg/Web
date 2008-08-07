<?php
/* SciELO.ORG - Retorna os últimos registros em formato HTML
 * @author Gustavo Fonseca(gustavo.fonseca@bireme.org)
 * @version 0.1
 */

/* Inclui scripts externos */
require_once('lib/nusoap/nusoap.php');
require_once('functions.inc.php');
$widgetConf = parse_ini_file(dirname(__FILE__)."/conf/conf.php");

/* Instancia cliente SOAP */
$clientesoap = new soapclient($widgetConf['server']);

/* Verifica parâmetros recebidos */
if(!isset($_REQUEST['count'])){	
	$count = 5;
}else{
	$count = $_REQUEST['count'];
}

if(!isset($_REQUEST['collection'])){	
	$collection = 'org';
}else{
	$collection = $_REQUEST['collection'];
}

/* Inicializa array contendo os parâmetros necessários ao serviço */
$param = array('count' => $count,'collection' => $collection);

/* Consome o serviço */
$xml = $clientesoap->call('lastRecords',$param);

/* Parâmetro de DEBUG */
if($_REQUEST['return'] == 'soap'){
	echo '<h2>Request</h2><pre>' . htmlspecialchars($clientesoap->request, ENT_QUOTES) . '</pre>';
	echo '<h2>Response</h2><pre>' . htmlspecialchars($clientesoap->response, ENT_QUOTES) . '</pre>';
	echo '<h2>Debug</h2><pre>' . htmlspecialchars($clientesoap->debug_str, ENT_QUOTES) . '</pre>';
}else{
	if(!validateXML($xml)){
		die('Erro! Tente novamente mais tarde.');
	}

	/* Transformação XSLT */
	if(!$transformer = xslt_create()){
		die('error opening sablotron');
	}else{
		$xsl = file_get_contents(dirname(_FILE_) . '/xsl/wg_listRecords.xsl');
				
		$arguments = array(
			 '/_xml' => $xml,
			 '/_xsl' => $xsl
		);
		$procResult = xslt_process($transformer,'arg:/_xml', 'arg:/_xsl', NULL, $arguments);

		/* Imprime resultado */		
		echo $procResult;	
	}
}
?>