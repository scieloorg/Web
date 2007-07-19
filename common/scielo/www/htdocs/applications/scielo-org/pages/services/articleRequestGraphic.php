<?php 
ini_set('display_errors', '1');
error_reporting(1);

	require_once(dirname(__FILE__)."/../../classes/services/AccessServiceBar.php");
	$accessService = new AccessService();
	$accessService->setParams($_REQUEST['pid']);
	$startYear = $_REQUEST['startYear'];
	$lastYear = $_REQUEST['lastYear'];
	
	if($startYear !="" && $lastYear!="")
	{
		$accessService->buildGraphicByYear($accessService->getStats(), $startYear, $lastYear);
	}
	else
	{
		$accessService->buildGraphicByYear($accessService->getStats(),date("Y"), date("Y"));
	}



?>
