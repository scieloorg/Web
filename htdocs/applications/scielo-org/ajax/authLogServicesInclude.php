<?php
/* 
 * Arquivo incluído em reflinks.php afim de gerar os logs de usuários autenticados no sistema
 * @author Gustavo Fonseca (gustavo.fonseca@bireme.org)
 * 
 */
	header('Content-Type: text/html');

	$ini = parse_ini_file(dirname(__FILE__)."/../../../scielo.def.php", true);

	// Classe com Dados dos Usuários do Scielo
	require_once(dirname(_FILE_)."/../../applications/scielo-org/classes/class.AuthScieloUserData.php");

	// Classes de LOG
	require_once(dirname(_FILE_)."/../../applications/scielo-org/classes/log/defineLog.php");
	require_once(dirname(_FILE_)."/../../applications/scielo-org/classes/log/class.Log.php");
	require_once(dirname(_FILE_)."/../../applications/scielo-org/classes/log/class.AuthUserDataLog.php");


session_start();

$urlAtual = 'http://'.$_SERVER['HTTP_HOST'].$_SERVER['REQUEST_URI'];
parse_str($urlAtual,$arrayURLElements);

$dadosUsuario = new AuthScieloUserData();


// Definindo Dados do Usuário
$dadosUsuario->setUserSession($_REQUEST['PHPSESSID']);
$dadosUsuario->setID($_REQUEST['userID']);
$dadosUsuario->setParentPID($_REQUEST['refpid']);
$dadosUsuario->setPID($arrayURLElements['pid']);
$dadosUsuario->setURL('http://'.$_SERVER['HTTP_HOST'].$_SERVER['REQUEST_URI']);

$servico = $ini['LOG']['AUTH_USERS_LOG_FILENAME'];

// Definindo dados a serem gravados
$userData = new AuthUserDataLog($servico, $dadosUsuario);

$userData->setFileName("_".$data."_logServices.txt");

// Gravamos o arquivo com o log de acesso
$userData->writeLog();

?>