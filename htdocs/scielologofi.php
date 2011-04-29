<?php
	include ("classScieloLogOfi.php");

    // Create new Scielo object
	$host = $HTTP_HOST;    
	$scielo = new ScieloLog ($host);
	
    $scielo->SetPreferedMethod ("POST");
    // Generate wxis url and set xml url
 	$xml = $scielo->GenerateXmlUrl($script,$dti,$dtf,$access,$cpage,$nlines,$pid,$lng,$nrm,$order,$tpages,$maccess);
	$scielo->SetXMLUrl ($xml);
	//die($xml);
    // Generate xsl url and set xsl url
	$xsl = $scielo->GenerateXslUrl();	
	$scielo->SetXSLUrl ($xsl);
	$scielo->ShowPage();
?>

