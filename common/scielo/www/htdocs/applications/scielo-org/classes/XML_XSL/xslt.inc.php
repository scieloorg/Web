<?php
	$DirName=dirname(__FILE__).'/';
    $phpversion = split ("\.", phpversion());
	if ( $phpversion[0] > 4 || ($phpversion[0] == 4 && $phpversion[1] >= 1) ) { 
		include_once($DirName . "xslt-4.1.php");    
	} else {        
		include_once($DirName . "xslt-4.0.php");    
	}
?>
