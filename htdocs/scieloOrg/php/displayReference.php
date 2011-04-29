<?php
	require_once(dirname(__FILE__)."/../../applications/scielo-org/classes/services/ArticleReferenceService.php");
	require_once(dirname(__FILE__)."/../../class.XSLTransformer.php");
	$articleReferenceService = new ArticleReferenceService(); 

	$transformer = new XSLTransformer();
	$articleReferenceService->setXSLTransformer($transformer);
	echo $articleReferenceService->getReferenceByPid('http://'.$_SERVER["SERVER_NAME"],$pid,$lang,$tlang);
?>