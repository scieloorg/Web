<?php
    $version = split ("\.", phpversion());
    
    if ( $version[0] > 4 || ($version[0] == 4 && $version[1] >= 1) ) {
        include_once(dirname(__FILE__)."/class.XSLTransformer41.php");
    }
    else {
        include_once(dirname(__FILE__)."/class.XSLTransformer40.php");
    }
?>