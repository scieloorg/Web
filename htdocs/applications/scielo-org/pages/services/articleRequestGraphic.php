<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xml:lang="en" lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head>
<META Http-Equiv="Cache-Control" Content="no-cache">
<META Http-Equiv="Pragma" Content="no-cache">
<META Http-Equiv="Expires" Content="0">
</head>
<body>
<?php
require_once(dirname(__FILE__)."/../../../../security.php");

ini_set("display_errors", "0");
	ini_set("log_errors", "1");
error_reporting(1);
        $DirNameLocalGraphPage=dirname(__FILE__).'/';
	$scielomaindef = parse_ini_file($DirNameLocalGraphPage."/../../../../scielo.def.php", true);
	require_once(dirname(__FILE__)."/../../classes/services/AccessServiceBar.php");
	$pid = scielo_validate_article_pid(isset($_GET['pid']) ? $_GET['pid'] : '');
	if ($pid === false) {
		http_response_code(400);
		exit('Invalid request');
	}
	$accessService = new AccessService();
	$accessService->setParam('pid', $pid);
	$accessService->setParam('app', $scielomaindef["SITE_INFO"]['APP_NAME']);
	$startYear = isset($_GET['startYear']) && preg_match('/^(?:19|20)[0-9]{2}$/D', $_GET['startYear'])
		? (int) $_GET['startYear']
		: null;
	$lastYear = isset($_GET['lastYear']) && preg_match('/^(?:19|20)[0-9]{2}$/D', $_GET['lastYear'])
		? (int) $_GET['lastYear']
		: null;
	if ($startYear !== null && $lastYear !== null && $startYear > $lastYear) {
		$tmpYear = $startYear;
		$startYear = $lastYear;
		$lastYear = $tmpYear;
	}
	if($startYear !="" && $lastYear!="")
	{
		$mensagem = $accessService->buildGraphicByYearFlash($accessService->getStats(), $startYear, $lastYear);
	}
	else
	{
		$mensagem = $accessService->buildGraphicByYearFlash($accessService->getStats(),date("Y"), date("Y"));
	}



?>
</body>
</html>
