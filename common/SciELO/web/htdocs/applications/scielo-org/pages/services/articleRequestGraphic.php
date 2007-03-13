<?php 
ini_set('display_errors', '1');
error_reporting(1);

	require_once(dirname(__FILE__)."/../../classes/services/AccessServiceBar.php");
	$accessService = new AccessService();
	$accessService->setParams($_REQUEST['pid']);
	$accessService->buildGraphic($accessService->getStats());

?>
