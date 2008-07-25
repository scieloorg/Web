<?php
require_once('nusoap/nusoap.php');

if(!isset($_REQUEST['service'])){
	die("missing parameter <i>service</i>");
}


$service = $_REQUEST['service'];

$clientesoap = new soapclient('http://'.$_SERVER["HTTP_HOST"].'/webservices/indexBVS.php');

switch($service){
	case "search":
		if(!isset($_REQUEST['expression'])){
			die("missing parameter <i>expression</i>");
		}
		if(!isset($_REQUEST['from'])){
			die("missing parameter <i>from</i>");
		}
		if(!isset($_REQUEST['count'])){
			die("missing parameter <i>count</i>");
		}
		$param = array('expression' => $_REQUEST['expression'],'from' => $_REQUEST['from'],'count' => $_REQUEST['count']);
		$resultado = $clientesoap->call('search',$param);
		break;
	case "advancedSearch":
		if(!isset($_REQUEST['index'])){
			die("missing parameter <i>index</i>");
		}
		if(!isset($_REQUEST['expression'])){
			die("missing parameter <i>expression</i>");
		}
		if(!isset($_REQUEST['from'])){
			die("missing parameter <i>from</i>");
		}
		if(!isset($_REQUEST['count'])){
			die("missing parameter <i>count</i>");
		}
		$param = array('index' => $_REQUEST['index'],'expression' => $_REQUEST['expression'],'from' => $_REQUEST['from'],'count' => $_REQUEST['count']);
		$resultado = $clientesoap->call('advancedSearch',$param);
		break;
	case "listRecords":
		if(!isset($_REQUEST['from'])){
			die("missing parameter <i>from</i>");
		}
		if(!isset($_REQUEST['count'])){
			die("missing parameter <i>count</i>");
		}
		$param = array('from' => $_REQUEST['from'],'count' => $_REQUEST['count']);
		$resultado = $clientesoap->call('listRecords',$param); // Alterar o nome do serviço. 
		break;
	case "lastRecords":		
		if(!isset($_REQUEST['count'])){
			die("missing parameter <i>count</i>");
		}
		$param = array('count' => $_REQUEST['count']);
		$clientesoap->response_timeout = 60;
		$resultado = $clientesoap->call('lastRecords',$param);
		break;
}


if($_REQUEST['return'] == 'soap'){
	echo '<h2>Request</h2><pre>' . htmlspecialchars($clientesoap->request, ENT_QUOTES) . '</pre>';
	echo '<h2>Response</h2><pre>' . htmlspecialchars($clientesoap->response, ENT_QUOTES) . '</pre>';
	echo '<h2>Debug</h2><pre>' . htmlspecialchars($clientesoap->debug_str, ENT_QUOTES) . '</pre>';
}else{
	header('Content-type: application/xml; charset="ISO-8859-1"',true);
	echo $resultado;
}
?>