<?php
	$redirect = "./scielo.php?script=sci_alphabetic&lng=en&nrm=iso";
	if ($_REQUEST['lang'])
		$redirect = "./scielo.php?script=sci_alphabetic&lng=".$_REQUEST['lang']."&nrm=iso"; 
	
	header("Location: " . $redirect);
?>
