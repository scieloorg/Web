<?php
/**
 * Registra acesso aos servicos de artigos
 * @author Gustavo Fonseca(gustavo.fonseca@bireme.org)
 * @date 20081107
 */
$defFile = parse_ini_file(dirname(__FILE__)."/../../../scielo.def.php", true);

//header('Content-Type: text/html');

$pid = utf8_decode($_GET['pid']);
$lang = utf8_decode($_GET['lang']);
$serviceName = utf8_decode($_GET['serviceName']);

/* Converting service names to identification codes */
switch($serviceName){
	case 'artigo_em_formato_xml': $page = 'serv_serxmlf'; break;
	case 'referencias_do_artigo': $page = 'serv_seraref'; break;
	case 'referencias_artigo_links': $page = 'serv_serarfl'; break;
	case 'indicadores_de_saude': $page = 'serv_serhind'; break;
	case 'curriculum_scienTI': $page = 'serv_sercsci'; break;
	case 'como_citar_este_artigo': $page = 'serv_serhcit'; break;
	case 'access': $page = 'serv_sersacs'; break;
	case 'cited_SciELO': $page = 'serv_sercits'; break;
	case 'related': $page = 'serv_sersims'; break;
	case 'traducao_automatica': $page = 'serv_seratra'; break;
	case 'send_mail': $page = 'serv_sersema'; break;
	default: $page = false; break;
}

if($page){
	$imgUrl = 'http://';
	$imgUrl .= $defFile['LOG']['SERVER_LOG'];
	$imgUrl .= '/' . $defFile['LOG']['SCRIPT_LOG_NAME'];
	$imgUrl .= '?app=' . $defFile['SITE_INFO']['APP_NAME'];
	$imgUrl .= '&page=' . $page;
	$imgUrl .= '&pid=' . $pid;
	$imgUrl .= '&lang=' . $lang;

	$strReturn = file_get_contents($imgUrl); /* Load URI to register the access */
	
	if($strReturn){
		print("access accounting OK"); /* Return value OK */	
	}else{
		print("access accounting Error"); /* Return value Error */
	}
}else{
	print("service name not defined"); /* Return value if $serviceName is not defined */
}
?>