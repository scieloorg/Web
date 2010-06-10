<?php
	include ("classScieloLogOfi.php");

    // Create new Scielo object
	$host = $HTTP_HOST;    
	$scielo = new ScieloLog ($host);
	$script = $_REQUEST["script"];
	$dti = $_REQUEST["dti"];
	$dtf = $_REQUEST["dtf"];
	$access = $_REQUEST["access"];
	$cpage = $_REQUEST["cpage"];
	$nlines = $_REQUEST["nlines"];
	$pid = $_REQUEST["pid"];
	$lng = $_REQUEST["lng"];
	$nrm = $_REQUEST["nrm"];
	$order = $_REQUEST["order"];
	$tpages = $_REQUEST["$tpages"];
	$maccess = $_REQUEST["maccess"];
    $scielo->SetPreferedMethod ("POST");
    
    // Generate wxis url and set xml url
 	$xml = $scielo->GenerateXmlUrl($script,$dti,$dtf,$access,$cpage,$nlines,$pid,$lng,$nrm,$order,$tpages,$maccess);

	$scielo->SetXMLUrl ($xml);

    // Generate xsl url and set xsl url
	$xsl = $scielo->GenerateXslUrl();	
	$scielo->SetXSLUrl ($xsl);
	$scielo->ShowPage($script,$dti,$dtf,$access,$cpage,$nlines,$pid,$lng,$nrm,$order,$tpages,$maccess);


?>

