<?php	    
   	include ("classScielo.php");

    // Create new Scielo object
	$host = $HTTP_HOST;    
    $scielo = new Scielo ($host);
	    
    // Generate wxis url and set xml url
 	$xml = $scielo->GenerateXmlUrl();
	$scielo->SetXMLUrl ($xml);

    // Generate xsl url and set xsl url
	$xsl = $scielo->GenerateXslUrl();	
	$scielo->SetXSLUrl ($xsl);
	
	$scielo->ShowPage();
?>

