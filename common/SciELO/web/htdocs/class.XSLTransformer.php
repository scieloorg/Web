<?php
    $version = split ("\.", phpversion());
    
    if ( $version[0] > 4 || ($version[0] == 4 && $version[1] >= 1) ) {
        include_once("class.XSLTransformer41.php");
    }
    else {
        include_once("class.XSLTransformer40.php");
    }
?>