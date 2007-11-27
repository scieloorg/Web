<?php
	header('Content-Type: text/html');

	$ini = parse_ini_file(dirname(__FILE__)."/../../../scielo.def", true);

	// Classe com Dados dos Usuários do Scielo
	require_once("../classes/ScieloUserData.php");

	// Classes de LOG
	require_once("../classes/log/defineLog.php");
	require_once("../classes/log/class.Log.php");
	require_once("../classes/log/class.UserDataLog.php");


	$servico = utf8_decode($_POST['servico']);
	$navegador = utf8_decode($_POST['browser']);
	$idioma = utf8_decode($_POST['idioma']);
	$resolucao = utf8_decode($_POST['resolucao']);
	$so = utf8_decode($_POST['SO']);
	$suporte = utf8_decode($_POST['suporte']);
	$url = utf8_decode($_POST['url']);
	$titulo = utf8_decode($_POST['titulo']);
	$data = date("d-m-Y");

	$dadosUsuario = new ScieloUserData();

	// Definindo Dados do Usuário
	$dadosUsuario->setBrowser($navegador);
	$dadosUsuario->setLanguage($idioma);
	$dadosUsuario->setOS($so);
	$dadosUsuario->setResolution($resolucao);
	$dadosUsuario->setSupport($suporte);
	$dadosUsuario->setTitle($titulo);
	$dadosUsuario->setURL($url);

	// Definindo dados a serem gravados
	$userData = new UserDataLog($servico, $dadosUsuario);
	$userData->setFileName("_".$data."_logServices.txt");

	// Gravamos o arquivo com o log de acesso
	$userData->writeLog();
?>
