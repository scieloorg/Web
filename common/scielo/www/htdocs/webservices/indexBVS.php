<?php
require_once('nusoap/nusoap.php');
$defFile = parse_ini_file('../scielo.def.php');
$applServer = $defFile['SERVER_SCIELO'];

$s = new soap_server;
$s->register('search');
$s->register('advancedSearch');
$s->register('listRecords');

// $s->register('status');

$s->register('lastRecords');

//$s->register('lastUpdate');

// inicializa o suporte a WSDL
$s->configureWSDL('search.server','urn:search.server');
$s->wsdl->schemaTargetNamespace = 'urn.search.server';

// registra os metodos
$s->register('search',	//nome do servico
array('expression' => 'xsd:string','from' => 'xsd:string','count' => 'xsd:string'),	//parametro de entrada
array('return' => 'xsd:string'),	//parametro de saida
'urn:search.server',	//namespace
'urn:search.server#search',	//soap action
'rpc',	//style
'encoded',	//use
'Retorna XML');	//descricao	

$s->register('advancedSearch',	//nome do servico
array('index' => 'xsd:string','expression' => 'xsd:string','from' => 'xsd:string','count' => 'xsd:string'),	//parametro de entrada
array('return' => 'xsd:string'),	//parametro de saida
'urn:search.server',	//namespace
'urn:search.server#advancedSearch',	//soap action
'rpc',	//style
'encoded',	//use
'Retorna XML');	//descricao	

$s->register('listRecords',	//nome do servico
array('from' => 'xsd:string','count' => 'xsd:string'),	//parametro de entrada
array('return' => 'xsd:string'),	//parametro de saida
'urn:search.server',	//namespace
'urn:search.server#list',	//soap action
'rpc',	//style
'encoded',	//use
'Retorna XML');	//descricao	
/*
$s->register('status',	//nome do servico
array('index' => 'xsd:string','expression' => 'xsd:string','from' => 'xsd:string','count' => 'xsd:string'),	//parametro de entrada
array('return' => 'xsd:string'),	//parametro de saida
'urn:search.server',	//namespace
'urn:search.server#status',	//soap action
'rpc',	//style
'encoded',	//use
'Retorna XML');	//descricao	
*/
$s->register('lastRecords',	//nome do servico
array('count' => 'xsd:string'),	//parametro de entrada
array('return' => 'xsd:string'),	//parametro de saida
'urn:search.server',	//namespace
'urn:search.server#lastRecords',	//soap action
'rpc',	//style
'encoded',	//use
'Retorna XML');	//descricao	
/*
$s->register('lastUpdate',	//nome do servico
array('index' => 'xsd:string','expression' => 'xsd:string','from' => 'xsd:string','count' => 'xsd:string'),	//parametro de entrada
array('return' => 'xsd:string'),	//parametro de saida
'urn:search.server',	//namespace
'urn:search.server#lastUpdate',	//soap action
'rpc',	//style
'encoded',	//use
'Retorna XML');	//descricao	
*/
//metodos 
function search($expression, $from, $count){
	global $applServer;

	$from = ($from  != "" ? $from  : "1");
	$count= ($count != "" ? $count : "10");
	
	//" . $applServer . "
	$serviceUrl = "http://teste.scielo.br/cgi-bin/wxis.exe/?IsisScript=ScieloXML/fi_bvs_search.xis&database=search&search=".$expression."&from=".$from."&count=".$count;
	$response = file_get_contents($serviceUrl);
	
	return $response;
}

function advancedSearch($index, $expression, $from, $count){
	global $applServer;

	$from = ($from  != "" ? $from  : "1");
	$count= ($count != "" ? $count : "10");
	
	$expression = str_replace(" "," and ".$index,$expression);
	
	//" . $applServer . "
	$serviceUrl = "http://teste.scielo.br/cgi-bin/wxis.exe/?IsisScript=ScieloXML/fi_bvs_search.xis&database=searchp&search=".$index.$expression."&from=".$from."&count=".$count;
	$response = file_get_contents($serviceUrl);
	
	return $response;
}

function listRecords($from, $count){
	global $applServer;

	$from = ($from  != "" ? $from  : "1");
	$count= ($count != "" ? $count : "10");
	
	//" . $applServer . "
	$serviceUrl = "http://teste.scielo.br/cgi-bin/wxis.exe/?IsisScript=ScieloXML/fi_bvs_search.xis&database=search&search=$&from=".$from."&count=".$count;
	$response = file_get_contents($serviceUrl);
	
	return $response;
}

function lastRecords($count){
	global $applServer;
	
	$count= ($count != "" ? $count : "10");
	
	//" . $applServer . "
	$serviceUrl = "http://teste.scielo.br/cgi-bin/wxis.exe/?IsisScript=ScieloXML/fi_bvs_search.xis&database=search&search=$&count=".$count."&reverse=on";

	$response = file_get_contents($serviceUrl);
	
	return $response;
}

$s->service($HTTP_RAW_POST_DATA);
exit();
?>