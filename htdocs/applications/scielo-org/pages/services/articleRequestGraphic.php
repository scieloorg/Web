<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xml:lang="en" lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head>
<META Http-Equiv="Cache-Control" Content="no-cache">
<META Http-Equiv="Pragma" Content="no-cache">
<META Http-Equiv="Expires" Content="0">
</head>
<body>
<?php 
ini_set('display_errors', '1');
error_reporting(1);
        $DirNameLocalGraphPage=dirname(__FILE__).'/';
        $scielomaindef = parse_ini_file($DirNameLocalGraphPage."/../../../../scielo.def.php", true);
	require_once(dirname(__FILE__)."/../../classes/services/AccessServiceBar.php");
	$accessService = new AccessService();
        $accessService->setParam('pid',$_REQUEST['pid']);
        $accessService->setParam('app',$scielomaindef["SITE_INFO"][APP_NAME]);
	$startYear = $_REQUEST['startYear'];
	$lastYear = $_REQUEST['lastYear'];
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
